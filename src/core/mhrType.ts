class MhrType {
  type: string;
  constructor(type: string, data: Object) {
    this.type = type;
    Object.keys(data).forEach((key) => this[key] = data[key]);
  }
  
  static int(): MhrType {
    return new MhrType('unit', { name: 'int' });
  }
  
  static temp(): MhrType {
    return new MhrType('temp', {});
  }
}

export default MhrType;
