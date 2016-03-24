#!/usr/bin/php
<?php
ini_set('memory_limit', '16384M');
$stdin = fopen('php://stdin', 'r');

$array = [];
while (false !== ($line = fgets($stdin))) {
    $words = preg_split('/\s+/', $line, -1, PREG_SPLIT_NO_EMPTY);

    foreach($words as $word) {
        if (isset($array[$word])) {
            $array[$word]++;
        } else {
            $array[$word] = 1;
        }
    }
}
fclose($stdin);
$array2 = [];

foreach($array as $key => $value) {
    if (isset($array2[$value])) {
        $array2[$value][] = $key;
    } else {
        $array2[$value] = [$key];
    }
}

krsort($array2);
ob_start();
foreach($array2 as $count => $wordsArray) {
    sort($wordsArray);
    foreach($wordsArray as $word) {
        echo "$word\t$count\n";
    }
}
