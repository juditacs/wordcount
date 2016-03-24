#!/usr/bin/php
<?php
ini_set('memory_limit', '16384M');
$stdin = fopen('php://stdin', 'r');
//$stdin = fopen('test', 'r');


$array = array();
while (false !== ($line = fgets($stdin))) {
  $words = explode(' ', $line);
    foreach($words as $word){
        if(empty($word) &&  $word !== "0"){
            continue;
        }
        if (!array_key_exists($word,$array)){
            $array[$word] = 1;
            continue;
        }
        $array[$word]++;
    }


}
fclose($stdin);
$array2 = array();

foreach($array as $key => $value){

    if (!array_key_exists($value,$array2)){
        $array2[$value] = array($key);
        continue;
    }
    $array2[$value][] =(string) $key;
}


krsort($array2);
foreach($array2 as $count => $wordsArray){
    sort ($wordsArray);
    foreach($wordsArray as $word) {
        print "$word\t$count\n";
    }
}
