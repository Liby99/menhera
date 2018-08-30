import MhrType from './mhrType';

class MhrVar {
  
  static count: number;
  
  name: string;
  realName: string;
  type: MhrType;
  
  constructor(name, type) {
    this.name = name;
    this.type = type;
    this.realName = MhrVar.generateRealName();
  }
  
  hasType() {
    return this.type !== undefined;
  }
  
  getType() {
    return this.type;
  }
  
  static generateRealName(): string {
    return `var_${this.count++}`;
  }
}

MhrVar.count = 0;

export default MhrVar;
