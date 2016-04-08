#!/usr/bin/php
<?php

ini_set('memory_limit', '16384M');

$stdin = fopen('php://stdin', 'r');

$delimiters = " \n\t";
$countedWords = array();
while (false !== ($line = fgets($stdin))) {
    $token = strtok($line, $delimiters);
    while (false !== $token) {
        if (isset($countedWords[$token])) {
            ++$countedWords[$token];
        } else {
            $countedWords[$token] = 1;
        }

        $token = strtok($delimiters);
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
