
function callThis(this: NotKnown) {
  this();
  this.method();
}
      