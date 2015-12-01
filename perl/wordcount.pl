#!/usr/bin/env perl

my %words;
while(<>) { $words{$_}++ for split }

print "$_\t$words{$_}\n"
    for sort {$words{$b}<=>$words{$a} or $a cmp $b} keys %words;
