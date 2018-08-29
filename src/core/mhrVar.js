class MhrVar {
  constructor(name, type) {
    this.name = name;
    this.type = type;
    this.realName = `var_${MhrVar.count++}`;
  }
  
  hasType() {
    return this.type !== undefined;
  }
  
  getType() {
    return this.type;
  }
}

MhrVar.count = 0;

module.exports = MhrVar;
