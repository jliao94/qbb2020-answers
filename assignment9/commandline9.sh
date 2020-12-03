#!/bin/bash

#Getting the data

#directory pathway for reference
#/Users/cmdb/qbb2020-answers/assignment9/

#extract Hi-C data
tar -xzf 3DGenomeData.tar.gz

#Loading in the data

#create a genomics partition file 
hifive fends -L /Users/cmdb/qbb2020-answers/assignment9/genome/mm9.len --binned 100000 /Users/cmdb/qbb2020-answers/assignment9/mm9.fends

#create file with counts of interaction reads
hifive hic-data -X data/WT_100kb/raw_\*.mat mm9.fends mm9.data

#create project file
hifive hic-project -f 25 -n 25 -j 100000 mm9.data mm9.project

#normalize the data and remove biases
hifive hic-normalize express -f 25 -w cis mm9.project

#Compartment analysis

#keep original gene intersection with compartment scores, overlap of genes with compartments must 
#have fraction of at least 0.5
bedtools intersect -a /Users/cmdb/qbb2020-answers/assignment9/data/WT_fpkm.bed -b /Users/cmdb/qbb2020-answers/assignment9/hic_comp.bed -f 0.5 -wa -wb > /Users/cmdb/qbb2020-answers/assignment9/intersection.bed

#filter the intersection bed file based on negative or positive compartment scores in the 9th column 
#of the intersection bed file
awk '{if($9~/\-/){print $0>"neg_compartment_genes"}else{print $0>"pos_compartment_genes"}}' /Users/cmdb/qbb2020-answers/assignment9/intersection.bed



