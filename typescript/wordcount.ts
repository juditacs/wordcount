///<reference path="typings/main.d.ts"/>


import * as readline from 'readline';

process.stdin.setEncoding('utf8');

let rl = readline.createInterface({ input: process.stdin, terminal: false });
let wordCounts:Array<number> = [];

const regExp = /[ \t\n\r]+/g;

rl.on('line', (line) => {
    var words = line.trim().split(regExp);

    for(var i = 0, len = words.length; i < len; i++) {
        var word = words[i];

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

    wordList.sort((x, y) => {
        if(wordCounts[x] < wordCounts[y])
            return 1;

        if(wordCounts[x] === wordCounts[y] && x > y)
            return 1;

        return -1;
    });

    for(var i = 0, len = wordList.length; i < len; i++) {
        var word = wordList[i];
        var count = wordCounts[word];

        process.stdout.write(word + '\t' + count + '\n');
    }

    process.exit(0);
});
