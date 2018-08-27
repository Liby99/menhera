class Context {
  constructor(file) {
    this.file = file;
    this.lines = file.split('\n');
  }
  
  get(node) {
    const { startPosition, endPosition } = node;
    if (endPosition.row > startPosition.row) {
      throw new Error('Not implemented');
    } else {
      const line = this.lines[startPosition.row];
      return line.substring(startPosition.column, endPosition.column);
    }
  }
}

module.exports = Context;
