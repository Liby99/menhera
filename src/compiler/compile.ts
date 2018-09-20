import * as llvm from "llvm-node";
import * as _ from 'underscore';
import MhrContext from 'core/mhrContext';
import MhrFunction from 'core/mhrFunction';
import {
  default as MhrNode,
  MhrIntNode,
  MhrBinOpNode,
  MhrLetNode,
  MhrVarNode,
  MhrClosureNode,
} from 'core/mhrNode';
import {
  default as MhrType,
  MhrUnitType,
  MhrClosureType,
} from 'core/mhrType';
import print from 'utility/print';

type FunctionContext = {
  env: { [name: string]: llvm.Value },
  envPtr: llvm.Value,
  envStructType: llvm.StructType,
  stdlib: { [name: string]: llvm.Function },
  llContext: llvm.LLVMContext,
  llModule: llvm.Module,
  llIrBuilder: llvm.IRBuilder,
  llFunc: llvm.Function,
};

function getType(type: MhrType, llContext: llvm.LLVMContext): llvm.Type | llvm.StructType {
  return type.match({
    'unit': ({ name }: MhrUnitType) => {
      switch (name) {
        case 'int': return llvm.Type.getInt32Ty(llContext);
        default: throw new Error(`Unknown type ${name}`);
      }
    },
    'closure': ({ ret, args }: MhrClosureType) => {
      const retType: llvm.Type = getType(ret, llContext);
      const i8PtrType: llvm.Type = llvm.Type.getInt8PtrTy(llContext);
      const argTypes: Array<llvm.Type> = args.map(arg => getType(arg, llContext));
      const funcType = llvm.FunctionType.get(retType, [i8PtrType].concat(argTypes), false);
      const closureStruct = llvm.StructType.get(llContext, [funcType, i8PtrType]);
      return closureStruct;
    }
  });
}

function getClosureType(closureType: MhrClosureType, llContext: llvm.LLVMContext): llvm.StructType {
  const { ret, args } = closureType;
  const retType: llvm.Type = getType(ret, llContext);
  const i8PtrType: llvm.Type = llvm.Type.getInt8PtrTy(llContext);
  const argTypes: Array<llvm.Type> = args.map(arg => getType(arg, llContext));
  const funcType = llvm.FunctionType.get(retType, [i8PtrType].concat(argTypes), false);
  const closureStruct = llvm.StructType.get(llContext, [funcType, i8PtrType]);
  return closureStruct;
}

function getFunctionType(func: MhrFunction, llContext: llvm.LLVMContext): llvm.FunctionType {
  const retType = getType(func.retType, llContext);
  const argTypes = func.args.map(arg => getType(arg.getType(), llContext));
  
  // Check if the function has parent env
  if (func.env) {
    const envPtrType: llvm.Type = llvm.Type.getInt8PtrTy(llContext);
    return llvm.FunctionType.get(retType, [envPtrType].concat(argTypes), false);
  } else {
    return llvm.FunctionType.get(retType, argTypes, false);
  }
}

function compileExpr(node: MhrNode, functionContext: FunctionContext): llvm.Value {
  const { env, envPtr, llIrBuilder, llModule, llContext, stdlib: { malloc } } = functionContext;
  return node.match({
    
    // int: return a constant int
    'int': ({ value }: MhrIntNode): llvm.Value => llvm.ConstantInt.get(llContext, value),
    
    // var: load the name from var
    'var': ({ name }: MhrVarNode): llvm.Value => {
      if (env[name]) {
        return llIrBuilder.createLoad(env[name]);
      } else {
        throw new Error(`Not Implemented: Unbound variable ${name}`);
      }
    },
    
    // binary operation: recursively compile the expr on each side, and build the operation
    'bin_op': (binOpNode: MhrBinOpNode): llvm.Value => {
      const { e1, e2 } = binOpNode;
      const v1 = compileExpr(e1, functionContext);
      const v2 = compileExpr(e2, functionContext);
      return binOpNode.matchOperator({
        '+': () => llIrBuilder.createAdd(v1, v2),
        '-': () => llIrBuilder.createSub(v1, v2),
        '*': () => llIrBuilder.createMul(v1, v2),
      });
    },
    
    // let: first store the result of binding to the env variable, then compile the expr
    'let': ({ variable, binding, expr }: MhrLetNode): llvm.Value => {
      llIrBuilder.createStore(compileExpr(binding, functionContext), env[variable.name]);
      return compileExpr(expr, functionContext);
    },
    
    // closure
    'closure': ({ func }: MhrClosureNode): llvm.Value => {
      
      // First get the func & env types
      const { closureType } = func;
      const { ret, args } = closureType;
      const retType: llvm.Type = getType(ret, llContext);
      const i8PtrType: llvm.Type = llvm.PointerType.get(llvm.Type.getInt8Ty(llContext), 0);
      const argTypes: Array<llvm.Type> = args.map(arg => getType(arg, llContext));
      const funcPtrType = llvm.PointerType.get(llvm.FunctionType.get(retType, [i8PtrType].concat(argTypes), false), 0);
      
      // Then generate the closure type & size
      const closureStruct = llvm.StructType.create(llContext, `${func.name}_closure`);
      closureStruct.setBody([funcPtrType, i8PtrType]);
      const closureSize = llModule.dataLayout.getTypeStoreSize(closureStruct);
      
      // Then generate the closure
      const closurePtr = llIrBuilder.createBitCast(llIrBuilder.createCall(malloc, [
        llvm.ConstantInt.get(llContext, closureSize)
      ]), llvm.PointerType.get(closureStruct, 0));
      
      // Store the function pointer to the closure
      const funcPtrLoc = llIrBuilder.createInBoundsGEP(closurePtr, [llvm.ConstantInt.get(llContext, 0), llvm.ConstantInt.get(llContext, 0)]);
      llIrBuilder.createStore(llModule.getFunction(func.name), funcPtrLoc);
      
      // Store the env pointer to the closure
      const envPtrLoc = llIrBuilder.createInBoundsGEP(closurePtr, [llvm.ConstantInt.get(llContext, 0), llvm.ConstantInt.get(llContext, 1)]);
      llIrBuilder.createStore(llIrBuilder.createBitCast(envPtr, i8PtrType), envPtrLoc);
      
      // return closurePtr;
      return llvm.ConstantInt.get(llContext, 0);
    },
    
    '_': () => {
      throw new Error('Not Implemented');
    }
  });
}

export default function compile(context: MhrContext) {
  
  // Create context
  const llContext = new llvm.LLVMContext();
  const llModule = new llvm.Module('main', llContext);
  
  // Get malloc
  const i8PtrType = llvm.Type.getInt8PtrTy(llContext);
  const intType = llvm.Type.getInt32Ty(llContext);
  const mallocType = llvm.FunctionType.get(i8PtrType, [intType], false);
  const mallocFunc = llvm.Function.create(mallocType, llvm.LinkageTypes.ExternalLinkage, 'malloc', llModule);
  
  // Get funcs
  const stdlib = {
    'malloc': mallocFunc
  };
  
  // Pre-define all functions to get function signatures
  const mhrFunctions = context.getFunctions();
  mhrFunctions.forEach(func => {
    const llFuncType = getFunctionType(func, llContext);
    llvm.Function.create(llFuncType, llvm.LinkageTypes.InternalLinkage, func.name, llModule);
  });
  
  // Going into define all functions
  mhrFunctions.forEach(func => {
    
    // Generate function and entry block
    const llFunc = llModule.getFunction(func.name);
    const llBlock = llvm.BasicBlock.create(llContext, 'entry', llFunc);
    const llIrBuilder = new llvm.IRBuilder(llBlock);
    
    // Get local vars & env structure & env pointer
    const localVars = func.args.concat(func.vars);
    const localVarTypes = localVars.map(v => getType(v.getType(), llContext));
    const envStructType = llvm.StructType.create(llContext, `${func.name}_env`);
    
    // Set the env struct type
    if (func.env) {
      const envPtrType: llvm.Type = llvm.Type.getInt8PtrTy(llContext);
      envStructType.setBody([envPtrType].concat(localVarTypes));
    } else {
      envStructType.setBody(localVarTypes);
    }
    
    // Use malloc to get the env pointer
    const envPtr = llIrBuilder.createBitCast(llIrBuilder.createCall(mallocFunc, [
      llvm.ConstantInt.get(llContext, llModule.dataLayout.getTypeStoreSize(envStructType))
    ]), llvm.PointerType.get(envStructType, 0), 'curr_env');
    
    // Create the env by getting the element pointers from the allocated env
    const env = localVars.reduce((env, v, vi) => _.extend(env, { 
      [v.name]: llIrBuilder.createInBoundsGEP(envPtr, [llvm.ConstantInt.get(llContext, 0), llvm.ConstantInt.get(llContext, vi + 1)], v.name)
    }), {});
    
    // Store all the input variables into the env
    const llFuncArguments = llFunc.getArguments();
    func.args.forEach((arg, argIndex) => {
      llIrBuilder.createStore(llFuncArguments[argIndex + 1], env[arg.name]);
    });
    
    // Store env into the curr_env
    if (func.env) {
      llIrBuilder.createStore(llFuncArguments[0], llIrBuilder.createInBoundsGEP(envPtr, [llvm.ConstantInt.get(llContext, 0), llvm.ConstantInt.get(llContext, 0)]));
    }
    
    // Build the body
    const functionContext: FunctionContext = { env, llContext, llModule, llFunc, envPtr, envStructType, llIrBuilder, stdlib };
    llIrBuilder.createRet(compileExpr(func.body, functionContext));
  });
  
  console.log(llModule.print());
}
