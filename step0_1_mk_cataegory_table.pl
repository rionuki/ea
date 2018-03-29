#!/usr/bin/perl

use strict;
use warnings;

my @pathway_gene = ();
open(IN, "./pathway_gene.txt") or die "open error";
while(<IN>){
    chomp;
    my @line = split(/\t/, $_);
 
    $line[0] =~ s/^(\d+\s)//g;
    $line[0] =~ tr/ /_/;

    push @pathway_gene, "$line[0]\t$line[1]";

#    print "$line[0]\t$line[1]\n";

}

my %count = ();
open(IN1, "./pathway_gene_count_rev.txt") or die "open error";
while(<IN1>){
    chomp;
    my @line = split(/\t/, $_);
    $line[0] =~ s/\\//g;

    $line[0] =~ s/^(\d+\s)//g;
    $line[0] =~ tr/ /_/;

#    print "$line[0]\n";
    $count{"$line[0]"} = "$line[1]";
}

my %cat = ();
my $c = 0;
# input gene list to be tested
open(IN2, "$ARGV[0]") or die "open error";
while(<IN2>){
    chomp;
    ++$c;

    my $gene = $_;

    for(my $i = 0; $i < @pathway_gene; ++$i){
	if($pathway_gene[$i] =~ /\t$gene\b/){	
	    my @line = split(/\t/, $pathway_gene[$i]);
#	    print "$gene\t$line[0]\n";
	    ++$cat{"$line[0]"};
	}
    }

}

# number of genes in the human genome
my $total_gene = 20216;

foreach my $key (keys %cat){

#input gene set
    my $cat = $cat{$key};
    my $not_cat = $c - $cat;

#the other genes
    my $other_cat = $count{$key} - $cat;
    my $other_not_cat = 20216 - $c -$other_cat;

     $key =~ s/^(\d+\s)//g;
    $key =~ tr/ /_/;

#    print "$key\t$cat{$key}\t$count{$key}\t$c\n";

   print "$key\t$cat\t$not_cat\t$other_cat\t$other_not_cat\n";

}
