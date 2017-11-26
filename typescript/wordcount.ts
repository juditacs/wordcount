///<reference path="typings/index.d.ts"/>

import * as readline from 'readline';
process.stdin.setEncoding('utf8');
const rl = readline.createInterface({ input: process.stdin, terminal: false });

const wordCounts: Map<string, number> = new Map();

const RegExp = /[ \t\n\r]+/g;
function notEmpty(word: string):boolean{
    return !!word;
}
rl.on('line', (line: string) => {
    const words = line.split(RegExp).filter(notEmpty);

    for (const word of words) {
        wordCounts.set(word, (wordCounts.get(word)||0) + 1);
    }

}).on('close', () => {
    const wordList = [...wordCounts.keys()];

    wordList.sort((x, y) => {
        const wordCountX = wordCounts.get(x);
        const wordCountY = wordCounts.get(y);
        if(wordCountX < wordCountY ||
          (wordCountX === wordCountY && x > y))
            return -1;

        return 1;
    });

    for (const word of wordList) {
        process.stdout.write(word + '\t' + wordCounts.get(word) + '\n');
    }

    process.exit(0);
});
