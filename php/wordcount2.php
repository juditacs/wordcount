#!/usr/bin/php
<?php

ini_set('memory_limit', '16384M');

$stdin = fopen('php://stdin', 'r');

$countedWords = array();
while (false !== ($line = fgets($stdin))) {
    $words = preg_split('/\s+/', $line, -1, PREG_SPLIT_NO_EMPTY);
    foreach ($words as $word) {
        if (!isset($countedWords[$word])) {
            $countedWords[$word] = 0;
        }

        ++$countedWords[$word];
    }
}

fclose($stdin);

$groupedByCountWords = array();
foreach ($countedWords as $word => $count) {
    $groupedByCountWords[$count][] = $word;
}

krsort($groupedByCountWords);

foreach ($groupedByCountWords as $count => $words) {
    sort($words, SORT_STRING);
    foreach ($words as $word) {
        printf("%s\t%s\n", $word, $count);
    }
}
