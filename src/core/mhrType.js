class MhrType {
  constructor(type, data) {
    this.type = type;
    Object.keys(data).forEach((key) => this[key] = data[key]);
  }
}

module.exports = MhrType;
