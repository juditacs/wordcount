///<reference path="typings/main.d.ts"/>

import * as readline from 'readline';
process.stdin.setEncoding('utf8');
let rl = readline.createInterface({ input: process.stdin, terminal: false });

let wordCounts:Array<number> = [];
let i,words;

//removing functions
let functions  = Object.getOwnPropertyNames(Array.prototype);
for(i = functions.length - 1; i >= 0; i--){
    if(functions[i] == "length"){
        continue;
    }
    wordCounts[functions[i]] = null;
} 


const RegExp = /[ \t\n\r]+/g;
function notEmpty(word:string):boolean{
    return !!word;
}
rl.on('line', (line:string) => {
    words = line.split(RegExp).filter(notEmpty);

    for(i = words.length-1; i >=0 ; i--) {
        if (!words[i])
            return;

        if(words[i] != "length") { //array has length property, escape it :)
            if (wordCounts[words[i]]) {
                wordCounts[words[i]]++;
            } else {
                wordCounts[words[i]] = 1;
            }
        }else{
            if (wordCounts["$_pref_length"]) {
                wordCounts["$_pref_length"]++;
            } else {
                wordCounts["$_pref_length"] = 1;
            }
        }
    }

}).on('close', () => {
    for(i = functions.length - 1; i >= 0; i--){
        if(wordCounts[functions[i]] !== null){
            continue;
        }
        delete(wordCounts[functions[i]])
    }

    let wordList = Object.keys(wordCounts);

    wordList.sort((x, y) => {
        if(wordCounts[x] < wordCounts[y] ||
          (wordCounts[x] === wordCounts[y] && x > y))
            return -1;

        return 1;
    });

    for(i = wordList.length-1; i >=0 ; i--) {
       if(wordList[i] === "$_pref_length"){
           process.stdout.write('length\t' + wordCounts[wordList[i]] + '\n');
       }else{
           process.stdout.write(wordList[i] + '\t' + wordCounts[wordList[i]] + '\n');
       }
    }

    process.exit(0);
});
