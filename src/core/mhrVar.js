class MhrVar {
  constructor(name, type) {
    this.name = name;
    this.type = type;
    this.realName = `var_${MhrVar.count++}`;
  }
}

MhrVar.count = 0;

module.exports = MhrVar;
