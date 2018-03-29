#!/usr/bin/perl

use strict;
use warnings;

use List::Util;

my @blocks = ();
open(IN, "./haplotype_blocks_ccds.txt") or die "open error";
while(<IN>){
    chomp;
    push @blocks, $_;
}

my $it = $ARGV[0];

my %sample = ();
for(my $l = 0; $l < $it; ++$l){

    my @shuffled = List::Util::shuffle @blocks;

    my @genes = ();
    for(my $i = 0; $i < 310; ++$i){
#    print "$shuffled[$i]\n";
	my @line = split(/:/, $shuffled[$i]);
	my @line2 = split(/\s/, $line[1]);
	
	for(my $j = 0; $j < @line2; ++$j){
	    if($line2[$j] =~ /[a-zA-Z]/){
		push @genes, "$line2[$j]";
	    }
	}
	
	
    }
    
# remove duplicate
    my %count2 = ();
    @genes = grep( !$count2{$_}++, @genes );
    
    
    my @pathway_gene = ();
    open(IN2, "../pathway_gene.txt") or die "open error";
    while(<IN2>){
	chomp;

	my @line = split(/\t/, $_);

	$line[0] =~ s/(\d+\s)//g;
	$line[0] =~ tr/ /_/;

	push @pathway_gene, "$line[0]\t$line[1]";
    }
    
    my %count = ();
    open(IN3, "./pathway_gene_count.txt") or die "open error";
    while(<IN3>){
	chomp;
	my @line = split(/\t/, $_);
	$line[0] =~ s/\\//g;

	$line[0] =~ s/(\d+\s)//g;
	$line[0] =~ tr/ /_/;

#    print "$line[0]\n";
	$count{"$line[0]"} = "$line[1]";
    }
    
    my %cat = ();
    my $c = 0;
    for(my $k = 0; $k < @genes; ++$k){
	++$c;
	
	my $gene = $genes[$k];
	
	for(my $i = 0; $i < @pathway_gene; ++$i){
	    if($pathway_gene[$i] =~ /\t$gene\b/){
		my @line = split(/\t/, $pathway_gene[$i]);    
		++$cat{"$line[0]"};
	    }
	}
	
    }
    
    my $total_gene = 20216;
    
    foreach my $key (keys %cat){
#input gene set
	my $cat = $cat{$key};
	my $not_cat = $c - $cat;
	
#the other genes
	my $other_cat = $count{$key} - $cat;
	my $other_not_cat = 20216 - $c -$other_cat;

#    $key =~ s/(\d+\s)//g;
#    $key =~ tr/ /_/;
	
#    print "$key\t$cat\t$not_cat\t$other_cat\t$other_not_cat\n";
	
	if($count{$key} != 0){
	    my $prob = 0;

#jaccard coefficient
	    my $union = $cat + $not_cat + $other_cat;

	    $prob = $cat/$union;
	    
	    push(@{$sample{"$key"}}, $prob);
	    
#    print "$key\t$prob\n";
	}
    }
    
} 

my $sample_file = "sample" . "_$it" . "_jac_rev_001.txt";
my $num_id = 0;

open(OUT, ">./$sample_file") or die "open error";
foreach my $tmpkey (sort keys %sample){
    my $id = $tmpkey;
    $id =~ s/(\d+\s)//g;
    $id =~ tr/ /_/;

    print OUT "$id";
    my $l = 0;
    foreach my $key (@{$sample{$tmpkey}}){
	++$l;
    }
    if($it != $l){
	my $diff = $it - $l;
	for(my $m = 0; $m < $diff; ++$m){
	    push @{$sample{$tmpkey}}, "0";
	}
    }
    foreach my $key (@{$sample{$tmpkey}}){
	print OUT "\t$key";
    }
    print OUT "\n";
    ++$num_id;
}

# R start

#my $r_out = "sample_quantile" . "_$it.txt";
#my $r_script = "sample_quantile" . "_$it.R";

## make R script
#my $script = <<"EOF";
#list<-read.table("./$sample_file", stringsAsFactors=F, row.names=1)
#result<-NULL
#a<-$num_id
#b<-NULL
#for(i in 1:a) {
#    b<-quantile(list[i,], prob=0.95)
#    result<-rbind(result, b)
#}

#write.table(result, file="$r_out", col.name=F, row.names=T, quote=F)
#EOF

#open(my $out_script, '>', "./$r_script") or "die";
#print $out_script $script;
#close($out_script);

## perform R script
#system("R --vanilla --slave < ./$r_script");

## read output
#open(my $out, '<', $r_out) or die;
#my @result = <$out>;
#close($out);

#for(my $m = 0; $m < @result; ++$m){
##    print "$result[$m]";
#}
