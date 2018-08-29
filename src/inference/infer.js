const assert = require('assert');
const MhrType = require('core/mhrType');
const InferenceContext = require('inference/inferenceContext');

function addTempType(node) {
  if (!node.hasType) {
    node.setType(inferenceContext.generateTemporaryType());
  }
}

const Inferer = {
  inference(mhrContext) {
    
    // Setup
    const inferenceContext = new InferenceContext();
    
    // Loop through all functions
    const functions = mhrContext.getFunctions();
    functions.forEach((f) => {
      
      // First add args and their type to context
      const args = f.getArgs();
      args.forEach(arg => {
        if (!arg.hasType()) {
          arg.setType(inferenceContext.generateTemporaryType());
        }
      });
      
      // Then setup ret type
      if (f.hasRetType()) {
        f.setRetType(inferenceContext.generateTemporaryType());
      }
      
      // Finally fill all nodes with temporary type if not
      const traverse = (node) => node.match({
        'int': () => node.setType(MhrType.int()),
        'bin_op': ({ e1, e2 }) => {
          addTempType(node);
          traverse(e1);
          traverse(e2);
        },
      });
    });
  },
};

module.exports = Inferer;
