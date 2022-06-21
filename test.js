const RegExpFromString = require('regexp-from-string');

const regExp = RegExpFromString("/\[([A-Z]+\-[0-9]+)\]/i");
// `regExp` is the same as RegExp(/Rock/ig);
console.log(regExp);