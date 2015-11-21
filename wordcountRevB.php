<?php
function cmp($pairA, $pairB)
{
    if ($pairA['count'] == $pairB['count']) {
        return ($pairA['word'] < $pairB['word']) ? -1 : 1;
    }
    return ($pairA['count'] > $pairB['count']) ? -1 : 1;
}


ini_set('memory_limit', '2048M');
//$stdin = fopen('php://stdin', 'r');
$stdin = fopen('de', 'r');


$array = array();
while (false !== ($line = fgets($stdin))) {
    $words = preg_split('/\s+/', $line);
    foreach($words as $word){
        if (!array_key_exists($word,$array)){
            $array[$word] = array("word" =>$word, "count" => 1);
            continue;
        }
        $array[$word]["count"]++;
    }

}
fclose($stdin);


usort($array, "cmp");

foreach($array as $pair){
    echo $pair['word'] . "\t" . $pair['count'] . "\n";
}