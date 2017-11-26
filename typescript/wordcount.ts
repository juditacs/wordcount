///<reference path="typings/main.d.ts"/>

import * as readline from 'readline';
process.stdin.setEncoding('utf8');
let rl = readline.createInterface({ input: process.stdin, terminal: false });

let wordCounts: Map<string, number> = new Map();

const RegExp = /[ \t\n\r]+/g;
function notEmpty(word: string):boolean{
    return !!word;
}
rl.on('line', (line: string) => {
    let words = line.split(RegExp).filter(notEmpty);

    for (let word of words) {
        wordCounts.set(word, (wordCounts.get(word)||0) + 1);
    }

}).on('close', () => {
    let wordList = Object.keys(wordCounts);

    wordList.sort((x, y) => {
        let wordCountX =  wordCounts.get(x);
        let wordCountY =  wordCounts.get(y);
        if(wordCountX < wordCountY ||
          (wordCountX === wordCountY && x > y))
            return -1;

        return 1;
    });
    
    for (let word of wordList) {
        process.stdout.write(word + '\t' + wordCounts.get(word) + '\n');
    }

    process.exit(0);
});
