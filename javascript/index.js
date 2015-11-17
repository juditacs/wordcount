var _ = require('lodash');
var Console = require('console').Console;

var data = {};

var log = new Console(process.stderr, process.stderr);

log.time('Read');
process.stdin.setEncoding('utf8');
process.stdin.on('readable', function() {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    chunk = chunk.substring(0, chunk.length-1);
    _.forEach(chunk.split(' '), function(word) {
      if (data[word]) {
        data[word].count++;
      } else {
        data[word] = {word: word, count: 1};
      }
    });
  }
});

process.stdin.on('end', function() {
  log.timeEnd('Read');
  log.time('Sort');
  var sorted = _.sortByOrder(data, ['count', 'word'], ['desc', 'asc']);
  log.timeEnd('Sort');
  log.time('Write');
  _.forEach(sorted, function(item){
    process.stdout.write(item.word + '\t' + item.count + '\n');
  });
  log.timeEnd('Write');
});
