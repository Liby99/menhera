class MhrNode {
  constructor(node) {
    Object.keys(node).forEach((key) => this[key] = node[key]);
  }
  
  match(options) {
    const option = options[this.type] || options['_'];
    return option && option(this);
  }
}

module.exports = MhrNode;
