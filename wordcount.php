<?php

//$stdin = fopen('php://stdin', 'r');
$stdin = fopen('php://stdin', 'r');

$array = array();
while ($word = fscanf($stdin, "%s")) {
    $word = $word[0];
    if (!array_key_exists($word,$array)){
        $array[$word] = 1;
        continue;
    }
    $array[$word]++;
}
ksort($array);
arsort($array);
foreach($array as $key => $value){
    echo $key."\t".$value."\n";
}