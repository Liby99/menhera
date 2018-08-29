class MhrFunction {
  constructor(type, args, body, funcIndex) {
    this.funcIndex = funcIndex;
    this.funcName = MhrFunction.generateName(funcIndex);
    this.args = args;
    this.body = body;
  }
  
  static generateName(index) {
    return `function_${index}`;
  }
}

module.exports = MhrFunction;
