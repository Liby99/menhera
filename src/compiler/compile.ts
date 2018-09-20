import * as llvm from "llvm-node";
import MhrContext from 'core/mhrContext';
import {
  default as MhrNode,
  MhrIntNode,
  MhrBinOpNode
} from 'core/mhrNode';
// import MhrType from 'core/mhrType';

function compileExpr(node: MhrNode, builder: llvm.IRBuilder, context: llvm.LLVMContext): llvm.Value {
  return node.match({
    'int': ({ value }: MhrIntNode): llvm.Value => {
      return llvm.ConstantInt.get(context, value);
    },
    'bin_op': ({ e1, op, e2 }: MhrBinOpNode): llvm.Value => {
      const v1 = compileExpr(e1, builder, context);
      const v2 = compileExpr(e2, builder, context);
      switch (op) {
        case '+': return builder.createAdd(v1, v2);
        case '-': return builder.createSub(v1, v2);
        default: throw new Error('Not Implemented');
      }
    },
    _: () => {
      throw new Error('Not Implemented');
    }
  });
}

export default function compile(context: MhrContext) {
  const llContext = new llvm.LLVMContext();
  const llModule = new llvm.Module('main', llContext);
  
  const llIntType = llvm.Type.getInt32Ty(llContext);
  
  const mhrFunctions = context.getFunctions();
  mhrFunctions.forEach(func => {
    const llFuncType = llvm.FunctionType.get(llIntType, [], false);
    const llFunc = llvm.Function.create(llFuncType, llvm.LinkageTypes.InternalLinkage, func.getName(), llModule);
    const llBlock = llvm.BasicBlock.create(llContext, 'entry', llFunc);
    const llIrBuilder = new llvm.IRBuilder(llBlock);
    llIrBuilder.createRet(compileExpr(func.body, llIrBuilder, llContext));
  });
  
  console.log(llModule.print());
  
  // const llcontext = new llvm.LLVMContext();
  // const llmodule = new llvm.Module("test", llcontext);
  //
  // const llintType = llvm.Type.getInt32Ty(llcontext);
  // // const llinitializer = llvm.ConstantInt.get(llcontext, 0);
  // // const llglobalVariable = new llvm.GlobalVariable(llmodule, llintType, true, llvm.LinkageTypes.InternalLinkage, llinitializer);
  //
  // const mainFuncType = llvm.FunctionType.get(llintType, [llintType], false);
  // const mainFunc = llvm.Function.create(mainFuncType, llvm.LinkageTypes.InternalLinkage, 'main', llmodule);
  //
  // const block = llvm.BasicBlock.create(llcontext, 'entry', mainFunc);
  //
  // const irbuilder = new llvm.IRBuilder(block);
  // const left = llvm.ConstantInt.get(llcontext, 3);
  // const right = llvm.ConstantInt.get(llcontext, 5);
  // const res = irbuilder.createAdd(left, right);
  // irbuilder.createRet(res);
  //
  // const ll = llmodule.print(); // prints IR
  // console.log(ll);
  // llvm.writeBitcodeToFile(llmodule, 'haha.ll'); // Writes file to disk
}
