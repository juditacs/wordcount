<?php

function countWord($word,$array){

    if (!array_key_exists($word,$array)){
        $array[$word] = 1;
        return;
    }
    $array[$word]++;
}


$stdin = fopen('php://stdin', 'r');
//$stdin = fopen('de', 'r');



$array = array();
while (false !== ($line = fgets($stdin))) {
    $words = explode(" ", $line);

    foreach($words as $word){
        if (!array_key_exists($word,$array)){
            $array[$word] = 1;
            continue;
        }
        $array[$word]++;
    }

}
ksort($array);
arsort($array);
foreach($array as $key => $value){
    echo $key."\t".$value."\n";
}