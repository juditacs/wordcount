var _ = require('lodash');
var Console = require('console').Console;

var data = {};

var log = new Console(process.stderr, process.stderr);

process.stdin.setEncoding('utf8');
process.stdin.on('readable', function() {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    _.forEach(chunk.split(/[\n\t\r\f ]+/g), function(word) {
      if (word == '') {return;}
      if (data[word]) {
        //console.log('Adding to ' + word + '.');
        data[word].count++;
      } else {
        //console.log('Inserting ' + word + '.');
        data[word] = {word: word, count: 1};
      }
    });
  }
});

process.stdin.on('end', function() {
  var sorted = _.sortByOrder(data, ['count', 'word'], ['desc', 'asc']);
  //console.log('Output has '+sorted.length+' items:');
  _.forEach(sorted, function(item){
    process.stdout.write(item.word + '\t' + item.count + '\n');
  });
});
