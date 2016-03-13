#!/usr/bin/php
<?php
ini_set('memory_limit', '16384M');
$stdin = fopen('php://stdin', 'r');
//$stdin = fopen('test', 'r');


class WordCount {
    public $word;
    public $count;
    function __construct($word, $count) {
        $this->word = $word;
        $this->count = $count;
    }
}

$array = array();
while (false !== ($line = fgets($stdin))) {
  $words = preg_split('/\s+/', $line);
    foreach($words as $word){
        if(empty($word)){
            continue;
        }
        if (!array_key_exists($word,$array)){
            $newWord = new WordCount($word, 1);
            $array[$word] = $newWord;
            continue;
        }
        $array[$word]->count++;
    }


}
fclose($stdin);

uasort($array, function($a, $b) {
        if ($a->count == $b->count ) {
            return strcmp($a->word, $b->word);
        }
        return ($a->count < $b->count) ? 1 : -1;
});

foreach($array as $wordCount){
        print $wordCount->word . "\t" . $wordCount->count . "\n";
}
