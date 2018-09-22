import * as llvm from 'llvm-node';
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
  MhrApplicationNode,
} from 'core/mhrNode';
import {
  default as MhrType,
  MhrUnitType,
  MhrClosureType,
  MhrTempType,
} from 'core/mhrType';

type ExternFunction = {
  malloc: llvm.Function,
  printf: llvm.Function,
};

type FunctionContext = {
  env: { [name: string]: llvm.Value },
  envPtr: llvm.Value,
  envStructType: llvm.StructType,
  stdlib: ExternFunction,
  llContext: llvm.LLVMContext,
  llModule: llvm.Module,
  llIrBuilder: llvm.IRBuilder,
  llFunc: llvm.Function,
  mhrContext: MhrContext,
  mhrFunction: MhrFunction,
};

const ci = llvm.ConstantInt.get;

export default function compile(context: MhrContext) {

  // Create context
  const llContext = new llvm.LLVMContext();
  const llModule = new llvm.Module('main', llContext);

  function getType(type: MhrType): llvm.Type | llvm.StructType {
    return type.match({
      'unit': ({ name }: MhrUnitType) => {
        switch (name) {
          case 'int': return llvm.Type.getInt32Ty(llContext);
          default: throw new Error(`Unknown type ${name}`);
        }
      },
      'closure': ({ ret, args }: MhrClosureType) => {
        const retType: llvm.Type = getType(ret);
        const i8PtrType: llvm.Type = llvm.Type.getInt8PtrTy(llContext);
        const argTypes: Array<llvm.Type> = args.map(arg => getType(arg));
        const funcType = llvm.FunctionType.get(retType, [i8PtrType].concat(argTypes), false);
        const funcPtrType = llvm.PointerType.get(funcType, 0);
        const closureStruct = llvm.StructType.get(llContext, [funcPtrType, i8PtrType]);
        return llvm.PointerType.get(closureStruct, 0);
      },
      'temp': ({ id }: MhrTempType) => {
        throw new Error(`Not inferred temp type ${id}`);
      },
    });
  }

  function getFunctionType(func: MhrFunction, llContext: llvm.LLVMContext): llvm.FunctionType {
    const retType = getType(func.retType);
    const argTypes = func.args.map(arg => getType(arg.getType()));

    // Check if the function has parent env
    if (func.env) {
      const envPtrType: llvm.Type = llvm.Type.getInt8PtrTy(llContext);
      return llvm.FunctionType.get(retType, [envPtrType].concat(argTypes), false);
    } else {
      return llvm.FunctionType.get(retType, argTypes, false);
    }
  }

  function compileExpr(node: MhrNode, functionContext: FunctionContext): llvm.Value {
    const { env, envPtr, llIrBuilder, llModule, llContext, stdlib: { malloc }, mhrFunction, mhrContext } = functionContext;
    return node.match({

      // int: return a constant int
      'int': ({ value }: MhrIntNode): llvm.Value => ci(llContext, value),

      // var: load the name from var
      'var': ({ name }: MhrVarNode): llvm.Value => {
        if (env[name]) {
          return llIrBuilder.createLoad(env[name]);
        } else {

          const findParentVar = (mhrFunction: MhrFunction, envPtr: llvm.Value): llvm.Value => {
            const parentFunc = mhrContext.getFunction(mhrFunction.env);
            if (parentFunc) {

              // Get parent function, parent env pointer and try to find the variable
              const parentEnvPtr = llIrBuilder.createBitCast(
                llIrBuilder.createLoad(
                  llIrBuilder.createInBoundsGEP(envPtr, [ci(llContext, 0), ci(llContext, 0)])
                ),
                llvm.PointerType.get(parentFunc.llEnvStructType, 0)
              );
              const v = parentFunc.getLocalVar(name);
              if (v) {

                // There's the var inside parent env.
                const varIndex = parentFunc.env ? 1 : 0 + v.index;
                const varPtr = llIrBuilder.createInBoundsGEP(parentEnvPtr, [ci(llContext, 0), ci(llContext, varIndex)]);
                return llIrBuilder.createLoad(varPtr);
              } else {

                // There's no var inside parent env. Recurse to parent function
                return findParentVar(parentFunc, parentEnvPtr);
              }
            } else {

              // There's no parent function anymore. So we cannot find the variable
              throw new Error(`Unbound variable ${name}`);
            }
          }
          return findParentVar(mhrFunction, envPtr);
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
      'closure': ({ functionName }: MhrClosureNode): llvm.Value => {
        const func = mhrContext.getFunction(functionName);
        const { llClosureType: closureStruct } = func;
        const closureSize = llModule.dataLayout.getTypeStoreSize(closureStruct);

        // Then generate the closure
        const closurePtr = llIrBuilder.createBitCast(llIrBuilder.createCall(malloc, [
          ci(llContext, closureSize)
        ]), llvm.PointerType.get(closureStruct, 0));

        // Store the function pointer to the closure
        const funcPtrLoc = llIrBuilder.createInBoundsGEP(closurePtr, [ci(llContext, 0), ci(llContext, 0)]);
        llIrBuilder.createStore(llModule.getFunction(func.name), funcPtrLoc);

        // Store the env pointer to the closure
        const envPtrLoc = llIrBuilder.createInBoundsGEP(closurePtr, [ci(llContext, 0), ci(llContext, 1)]);
        llIrBuilder.createStore(llIrBuilder.createBitCast(envPtr, llvm.Type.getInt8PtrTy(llContext)), envPtrLoc);

        return closurePtr;
      },

      // Application
      'application': ({ callee, params }: MhrApplicationNode): llvm.Value => {

        const closure = compileExpr(callee, functionContext);
        const values = params.map(param => compileExpr(param, functionContext));

        const funcPtr = llIrBuilder.createInBoundsGEP(closure, [ci(llContext, 0), ci(llContext, 0)]);
        const func = llIrBuilder.createLoad(funcPtr);
        const envPtr = llIrBuilder.createInBoundsGEP(closure, [ci(llContext, 0), ci(llContext, 1)]);
        const env = llIrBuilder.createLoad(envPtr);

        return llIrBuilder.createCall(func, [env].concat(values));
      },

      '_': () => {
        throw new Error('Not Implemented');
      }
    });
  }

  function getMalloc(llContext: llvm.LLVMContext, llModule: llvm.Module): llvm.Function {
    const i8PtrType = llvm.Type.getInt8PtrTy(llContext);
    const intType = llvm.Type.getInt32Ty(llContext);
    const mallocType = llvm.FunctionType.get(i8PtrType, [intType], false);
    return llvm.Function.create(mallocType, llvm.LinkageTypes.ExternalLinkage, 'malloc', llModule);
  }

  function getPrintf(llContext: llvm.LLVMContext, llModule: llvm.Module): llvm.Function {
    const i32Type = llvm.Type.getInt32Ty(llContext);
    const i8PtrType = llvm.Type.getInt8PtrTy(llContext);
    const printfType = llvm.FunctionType.get(i32Type, [i8PtrType], true);
    return llvm.Function.create(printfType, llvm.LinkageTypes.ExternalLinkage, 'printf', llModule);
  }

  function getExternFunctions(llContext: llvm.LLVMContext, llModule: llvm.Module): ExternFunction {
    return {
      malloc: getMalloc(llContext, llModule),
      printf: getPrintf(llContext, llModule),
    };
  }

  // Get funcs
  const stdlib = getExternFunctions(llContext, llModule);
  const { malloc, printf } = stdlib

  // Pre-define all functions to get function signatures
  const mhrFunctions = context.getFunctions();
  mhrFunctions.forEach(func => {

    // First get function type
    const llFuncType = getFunctionType(func, llContext);
    func.llFunctionType = llFuncType;

    // Then create function
    const llFunc = llvm.Function.create(llFuncType, llvm.LinkageTypes.InternalLinkage, func.name, llModule);
    func.llFunction = llFunc;

    // Get local vars & env structure & env pointer
    const localVars = func.args.concat(func.vars);
    const localVarTypes = localVars.map(v => getType(v.getType()));
    const envStructType = llvm.StructType.create(llContext, `${func.name}_env`);
    if (func.env) {
      const envPtrType: llvm.Type = llvm.Type.getInt8PtrTy(llContext);
      envStructType.setBody([envPtrType].concat(localVarTypes));
    } else {
      envStructType.setBody(localVarTypes);
    }
    func.llEnvStructType = envStructType;

    if (func.env) {

      // Get the closure type
      const i8PtrType: llvm.Type = llvm.Type.getInt8PtrTy(llContext);
      const funcPtrType = llvm.PointerType.get(llFuncType, 0);
      const closureStructType = llvm.StructType.get(llContext, [funcPtrType, i8PtrType]);
      func.llClosureType = closureStructType;
    }
  });

  // Going into define all functions
  mhrFunctions.forEach(func => {
    const { llEnvStructType: envStructType, llFunction: llFunc } = func;

    // Generate function and entry block
    const llBlock = llvm.BasicBlock.create(llContext, 'entry', llFunc);
    const llIrBuilder = new llvm.IRBuilder(llBlock);

    // Use malloc to get the env pointer
    const size = llModule.dataLayout.getTypeStoreSize(envStructType);
    const envPtrType = llvm.PointerType.get(envStructType, 0);
    const envPtr = size > 0
      ? llIrBuilder.createBitCast(llIrBuilder.createCall(malloc, [ci(llContext, size)]), envPtrType, 'curr_env')
      : llvm.ConstantPointerNull.get(envPtrType);

    // Create the env by getting the element pointers from the allocated env
    const offset = func.env ? 1 : 0;
    const env = func.localVars.reduce((env, v, vi) => _.extend(env, {
      [v.name]: llIrBuilder.createInBoundsGEP(envPtr, [ci(llContext, 0), ci(llContext, vi + offset)], v.name)
    }), {});
    const llFuncArguments = llFunc.getArguments();

    // Store env into the curr_env
    if (func.env) {
      const parentEnvPtr = llIrBuilder.createInBoundsGEP(envPtr, [ci(llContext, 0), ci(llContext, 0)], 'parent_env');
      llIrBuilder.createStore(llFuncArguments[0], parentEnvPtr);
    }

    // Store all the input variables into the env
    func.args.forEach((arg, argIndex) => {
      llIrBuilder.createStore(llFuncArguments[argIndex + 1], env[arg.name]);
    });

    // Build the body
    const functionContext: FunctionContext = { env, llContext, llModule, llFunc, envPtr, envStructType, llIrBuilder, stdlib, mhrContext: context, mhrFunction: func };
    const result = compileExpr(func.body, functionContext);

    // Build main function print
    if (func.name === 'main') {
      const stringLiteral = llIrBuilder.createGlobalStringPtr('%d\n');
      llIrBuilder.createCall(printf, [stringLiteral, result]);
    }

    // Return the value
    llIrBuilder.createRet(result);
  });

  console.log(llModule.print());
}
