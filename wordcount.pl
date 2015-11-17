#!/usr/bin/env perl

my %counter;

my $line = <STDIN>;
while($line ne "") {
    my @words = split(/\s+/, $line);
    for my $word (@words) {
        $counter{$word} ++;
    }
    $line = <STDIN>;
}

foreach my $word (sort { -$counter{$a} <=> -$counter{$b} or $a cmp $b } keys %counter) {
    printf "%s\t%s\n", $word, $counter{$word};
}
