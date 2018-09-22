export default class FileContext {

  file: string;
  lines: Array<string>;

  constructor(file) {
    this.file = file;
    this.lines = file.split('\n');
  }

  get(node) {
    const { startPosition, endPosition } = node;
    if (endPosition.row > startPosition.row) {
      throw new Error('Cannot get multiple line node');
    } else {
      const line = this.lines[startPosition.row];
      return line.substring(startPosition.column, endPosition.column);
    }
  }
}
