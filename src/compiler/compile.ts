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

function getType(type: MhrType, llContext: llvm.LLVMContext): llvm.Type {
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

function getFunctionType(func: MhrFunction, llContext: llvm.LLVMContext): llvm.FunctionType {
  const retType = getType(func.retType, llContext);
  const argTypes = func.args.map(arg => getType(arg.getType(), llContext));
  return llvm.FunctionType.get(retType, argTypes, false);
}

function compileExpr(node: MhrNode, functionContext: FunctionContext): llvm.Value {
  const { env, llIrBuilder, llContext } = functionContext;
  return node.match({
    
    // If the expr is int, then return a constant int
    'int': ({ value }: MhrIntNode): llvm.Value => llvm.ConstantInt.get(llContext, value),
    
    // If the expr is var, then load the name from var
    'var': ({ name }: MhrVarNode): llvm.Value => {
      if (env[name]) {
        return llIrBuilder.createLoad(env[name]);
      } else {
        throw new Error('Not Implemented');
      }
    },
    
    // If the expr is binary operation, then recursively compile the expr on each side, and build the operation
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
    
    // If the expr is let, first store the result of binding to the env variable, then compile the expr
    'let': ({ variable, binding, expr }: MhrLetNode): llvm.Value => {
      llIrBuilder.createStore(compileExpr(binding, functionContext), env[variable.name]);
      return compileExpr(expr, functionContext);
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
  
  // Loop through all functions
  const mhrFunctions = context.getFunctions();
  mhrFunctions.forEach(func => {
    
    // Generate function and entry block
    const llFuncType = getFunctionType(func, llContext);
    const llFunc = llvm.Function.create(llFuncType, llvm.LinkageTypes.InternalLinkage, func.name, llModule);
    const llBlock = llvm.BasicBlock.create(llContext, 'entry', llFunc);
    const llIrBuilder = new llvm.IRBuilder(llBlock);
    
    // Get local vars & env structure & env pointer
    const localVarTypes = func.vars.map(v => getType(v.getType(), llContext));
    const envStructType = llvm.StructType.create(llContext, `${func.name}_env`);
    envStructType.setBody(localVarTypes);
    
    // Use malloc to get the env pointer
    const envPtr = llIrBuilder.createBitCast(llIrBuilder.createCall(mallocFunc, [
      llvm.ConstantInt.get(llContext, localVarTypes.reduce((sum, ty) => sum + ty.getPrimitiveSizeInBits(), 0) / 8)
    ]), llvm.PointerType.get(envStructType, 0));
    
    // Create the env by getting the element pointers from the allocated env
    const env = func.vars.reduce((env, v, vi) => _.extend(env, { 
      [v.name]: llIrBuilder.createInBoundsGEP(envPtr, [llvm.ConstantInt.get(llContext, 0), llvm.ConstantInt.get(llContext, vi)])
    }), {});
    
    // Build the body
    const functionContext: FunctionContext = { env, llContext, llModule, llFunc, envPtr, envStructType, llIrBuilder, stdlib };
    llIrBuilder.createRet(compileExpr(func.body, functionContext));
  });
  
  console.log(llModule.print());
}
