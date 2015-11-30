"use strict";
var readline = require('readline');
var TimSort = require('timsort');

process.stdin.setEncoding('utf8');

let rl = readline.createInterface({ input: process.stdin, terminal: false });
let wordCounts = {};
const regExp = /[ \t\n\r]+/g;

rl.on('line', (line) => {
  let words = line.trim().split(regExp);

  for(let i = 0, len = words.length; i < len; i++) {
    let word = words[i];

    if (!word)
      return;

    if(wordCounts.hasOwnProperty(word)) {
      wordCounts[word]++;
    }
    else {
      wordCounts[word] = 1;
    }
  }
}).on('close', () => {
  let wordList = Object.keys(wordCounts);

  let compare = (x, y) => {
    if(wordCounts[x] < wordCounts[y])
      return 1;

    if(wordCounts[x] === wordCounts[y] && x > y)
      return 1;

    return -1;
  }

  TimSort.sort(wordList, compare);

  let word = '';
  let count = '';
  let buff = '';
  const maxBuff = 1000;
  for(let i = 0, len = wordList.length; i < len; i++) {
    word = wordList[i];
    count = wordCounts[word];

    buff += word + '\t' + count + '\n';
    if (i % maxBuff === 0) {
      process.stdout.write(buff);
      buff = '';
    }
  }
  process.stdout.write(buff);
  process.exit(0);
});
