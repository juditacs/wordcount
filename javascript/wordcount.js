"use strict";
var TimSort = require('timsort');

process.stdin.setEncoding('utf8');
const regExp = /[ \t\n\r]+/;
var lastChunk = '';
var counts = new Map();
process.stdin.on('data', function (chunk) {
  var words = chunk.split(regExp);
  var count = words.length;
  if (lastChunk) {
    words[0] = lastChunk + words[0];
  }
  lastChunk = words[count - 1];
  count--;
  for (var i = 0; i < count; i++) {
    var word = words[i];
    if (word) {
      counts.set(word, (counts.get(word) || 0) + 1);
    }
  }
}).on('end', function () {
  if (lastChunk) {
    counts.set(lastChunk, (counts.get(lastChunk) || 0) + 1);
  }
  var res = [...counts.keys()];
  var comparer = (a, b)=> {
    var ca = counts.get(a);
    var cb = counts.get(b);
    return (ca < cb || (ca === cb && a > b) ? 1 : -1);
  };
  TimSort.sort(res, comparer);
  var c = res.length;

  let word = '';
  let count = '';
  let buff = '';
  const maxBuff = 1000;
  for (let i = 0; i < c; i++) {
    word = res[i];
    count = counts.get(word);

    buff += word + '\t' + count + '\n';
    if (i % maxBuff === 0) {
      process.stdout.write(buff);
      buff = '';
    }
  }
  process.stdout.write(buff);
  process.exit(0);
});