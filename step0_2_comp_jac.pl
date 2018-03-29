#!/usr/bin/perl

use strict;
use warnings;

my %count = ();
open(IN, "./pathway_gene_count_rev.txt") or die "open error";
while(<IN>){
    chomp;
    my @line = split(/\t/, $_);
    $line[0] =~ s/\\//g;

    $line[0] =~ s/\d{5}\s//g;
    $line[0] =~ tr/ /_/;
#    print "$line[0]\t$line[1]\n";

    $count{"$line[0]"} = "$line[1]";
}


foreach my $key (keys %count){
#    print "$key\t$count{$key}\n";
}

#open(IN2, "./table_2.tab") or die "open error";
open(IN2, "./gene_list_0.01_rev.tab") or die "open error";

while(<IN2>){
    chomp;
    my @line2 = split(/\t/, $_);
    
    my $cat_all = $count{"$line2[0]"};
    my $union = $cat_all + $line2[2];

#   my $union = $cat_all + $line2[1] + $line2[2] - $line2[1];

    my $jac = 0;
    if($union != 0){
	$jac = $line2[1]/$union;
    }
    print "$line2[0]\t$line2[1]\t$union\t$jac\n";

}
