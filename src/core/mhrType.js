class MhrType {
  constructor(type, data) {
    this.type = type;
    Object.keys(data).forEach((key) => this[key] = data[key]);
  }
  
  static int() {
    return new MhrType('unit', { name: 'int' });
  }
}

module.exports = MhrType;
