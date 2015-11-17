<?php
ini_set('memory_limit', '2048M');
$stdin = fopen('php://stdin', 'r');
//$stdin = fopen('de', 'r');



$array = array();
while (false !== ($line = fgets($stdin))) {
    $words = explode(" ", trim($line));

    foreach($words as $word){
        if (!array_key_exists($word,$array)){
            $array[$word] = 1;
            continue;
        }
        $array[$word]++;
    }

}

$array2 = array();

foreach($array as $key => $value){

    if (!array_key_exists($value,$array2)){
        $array2[$value] = array($key);
        continue;
    }
    $array2[$value][] = $key;
}

//ksort($array);
//arsort($array);

krsort($array2);
foreach($array2 as $count => $wordsArray){
    sort ($wordsArray);
    foreach($wordsArray as $word) {
        echo $word . "\t" . $count . "\n";
    }
}