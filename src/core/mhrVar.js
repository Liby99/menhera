class MhrVar {
  constructor(name) {
    this.name = name;
    this.realName = `var_${MhrVar.count++}`;
  }
}

MhrVar.count = 0;

module.exports = MhrVar;
