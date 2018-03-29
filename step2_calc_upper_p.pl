#!/usr/bin/perl

use strict;
use warnings;

my %result = ();
open(IN, "./gene_list_0.01_rev_jac.tab") or die "open error";
while(<IN>){
    chomp;
    my @line = split(/\t/, $_);
    $result{"$line[0]"} = "$line[3]";
}

my %sample = ();
open(IN2, "./sample_10000_jac_rev_001.txt") or die "open error";
while(<IN2>){
    chomp;
    my @line2 = split(/\t/, $_);
    $sample{"$line2[0]"} = "$_";
}

my %upper = ();
foreach my $key (keys %result){
    my $prob = $result{$key};

    if(defined $sample{$key}){

	my @random = split(/\t/, $sample{$key});

	my $l = @random - 1;

	my $c = 0;
	for(my $i = 1; $i < @random; ++$i){
	    if($prob <= $random[$i]){
		++$c;
	    }
	}
	
	my $p = $c/$l;
	
#    print "$p\t$c\t$l\n";
	
	if($p < 0.05){
#	print "$key\t$p\n";
	    $upper{"$key"} = "$p";
	}
    }
}

foreach my $key (sort {$upper{$a} <=> $upper{$b}} keys %upper) {
    print "$key\t$upper{$key}\n";
}
