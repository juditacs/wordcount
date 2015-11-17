var _ = require('lodash');

var data = {};

process.stdin.setEncoding('utf8');
process.stdin.on('readable', function() {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    _.forEach(_.words(chunk), function(word) {
      if (data[word]) {
        data[word].count++;
      } else {
        data[word] = {word: word, count: 1};
      }
    });
  }
});

process.stdin.on('end', function() {
  _.forEach(_.sortByOrder(data, ['count', 'word'], ['desc', 'asc']), function(item){
    process.stdout.write(item.word + '\t' + item.count + '\n');
  });
});
