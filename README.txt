############################################################################################
#                                                                                          # 
#      These tools were developed for enrichment analysis of ancient haplotype blocks      #
#                                                                                          # 
#                                                   2018/03/29    Ritsuko Onuki            #     
#                                                                                          #
############################################################################################

step 0. 

1. Count number of genes in a focused pathway for input (genes in top 1% of blocks) and the other genes in the human genome. 
Also output number of genes not in a focused pathway for input and the other genes in the human genome.

command: step0_1_mk_category_table.pl input.txt > gene_list_0.01_rev.tab

2. Calculate jaccard index of input genes for a focused pathway. 

command: step1_2_comp_jac.pl > gene_list_0.01_rev_jac.tab

step 1. 

Extract ancient haplotype blocks randomly and calculate jaccard indexes between genes in pathways and extracted ancient haplotype blocks.
Set iteration time.

command: step1_suffle_001.pl 10000[iteration time]

step 2. 

Calculate p-value of jaccard index for input genes from distribution of jaccard index for genes in randomly selected from ancient haplotype blocks.
Number of elements are the number of interation time set in the step1.

Output pathways where input genes are enriched.  
