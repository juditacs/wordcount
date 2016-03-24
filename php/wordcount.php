#!/usr/bin/php
<?php
ini_set('memory_limit', '16384M');
$stdin = fopen('php://stdin', 'r');
//$stdin = fopen('test', 'r');


$array = array();
while (false !== ($line = fgets($stdin))) {
    $words = preg_split('/\s+/', $line, -1, PREG_SPLIT_NO_EMPTY);
    foreach($words as $word){
        if (isset($array[$word])){
            $array[$word]++;
        } else {
            $array[$word] = 1;
        }
    }
}
fclose($stdin);
$array2 = array();
foreach($array as $key => $value){
    if (!isset($array2[$value])){
        $array2[$value] = array($key);
    } else {
        $array2[$value][] = $key;
    }
}
krsort($array2);
foreach($array2 as $count => $wordsArray){
    sort ($wordsArray);
    foreach($wordsArray as $word) {
        print "$word\t$count\n";
    }
}
