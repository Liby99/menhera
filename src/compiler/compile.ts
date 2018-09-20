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

function getType(type: MhrType, context: llvm.LLVMContext): llvm.Type {
  return type.match({
    'unit': ({ name }: MhrUnitType) => {
      switch (name) {
        case 'int': return llvm.Type.getInt32Ty(context);
        default: throw new Error(`Unknown type ${name}`);
      }
    },
    'closure': ({ ret, args }: MhrClosureType) => {
      const retType: llvm.Type = getType(ret, context);
      const i8PtrType: llvm.Type = llvm.Type.getInt8PtrTy(context);
      const argTypes: Array<llvm.Type> = args.map(arg => getType(arg, context));
      const funcType = llvm.FunctionType.get(retType, [i8PtrType].concat(argTypes), false);
      const closureStruct = llvm.StructType.get(context, [funcType, i8PtrType]);
      return closureStruct;
    }
  });
}

function getFunctionType(func: MhrFunction, context: llvm.LLVMContext): llvm.FunctionType {
  const retType = getType(func.retType, context);
  const argTypes = func.args.map(arg => getType(arg.getType(), context));
  return llvm.FunctionType.get(retType, argTypes, false);
}

function compileExpr(
  node: MhrNode, 
  env: { [name: string]: llvm.Value },
  builder: llvm.IRBuilder, 
  context: llvm.LLVMContext
): llvm.Value {
  return node.match({
    'int': ({ value }: MhrIntNode): llvm.Value => llvm.ConstantInt.get(context, value),
    'var': ({ name }: MhrVarNode): llvm.Value => builder.createLoad(env[name]),
    'bin_op': (binOpNode: MhrBinOpNode): llvm.Value => {
      const { e1, e2 } = binOpNode;
      const v1 = compileExpr(e1, env, builder, context);
      const v2 = compileExpr(e2, env, builder, context);
      return binOpNode.matchOperator({
        '+': () => builder.createAdd(v1, v2),
        '-': () => builder.createSub(v1, v2),
        '*': () => builder.createMul(v1, v2),
      });
    },
    'let': ({ variable, binding, expr }: MhrLetNode): llvm.Value => {
      builder.createStore(compileExpr(binding, env, builder, context), env[variable.name]);
      return compileExpr(expr, env, builder, context);
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
  
  // Loop through all functions
  const mhrFunctions = context.getFunctions();
  mhrFunctions.forEach(func => {
    
    // Generate function and entry block
    const llFuncType = getFunctionType(func, llContext);
    const llFunc = llvm.Function.create(llFuncType, llvm.LinkageTypes.InternalLinkage, func.getName(), llModule);
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
    
    // const { env } = func.vars.reduce(({ env, offset }, v, vi) => {
    //   return ({
    //     offset: offset + localVarTypes[vi].getPrimitiveSizeInBits(),
    //     env: _.extend(env, {
    //       // [v.name]: llIrBuilder.createAdd(envPtr, llvm.ConstantInt.get(llContext, offset / 8))
    //       [v.name]: llIrBuilder.createInBoundsGEP(envPtr, [llvm.ConstantInt.get(llContext, 0)])
    //     })
    //   });
    // }, { env: {}, offset: 0 });
    
    llIrBuilder.createRet(compileExpr(func.body, env, llIrBuilder, llContext));
  });
  
  console.log(llModule.print());
}
