#!/bin/bash

gunzip methylation_fastq.tar.gz 

#look at different  portions of developing mouse embryos
SRR3083929 -> STEM-seq E5.5Epi Rep 1, epiblast
SRR3083926 -> STEM-seq E4.0ICM Rep 1, inner cell mass

mkdir fastqc_out

less -S /Users/cmdb/qbb2020-answers/assignment6/methylation_fastq/SRR3083926_1.chr6.fastq
less -S /Users/cmdb/qbb2020-answers/assignment6/methylation_fastq/SRR3083926_2.chr6.fastq

fastqc -o /Users/cmdb/qbb2020-answers/assignment6/fastqc_out /Users/cmdb/qbb2020-answers/assignment6/methylation_fastq/SRR3083926_1.chr6.fastq
fastqc -o /Users/cmdb/qbb2020-answers/assignment6/fastqc_out /Users/cmdb/qbb2020-answers/assignment6/methylation_fastq/SRR3083926_2.chr6.fastq

#In sequence content across the bases from the FastQC, there is a depletion of C nucleotides 
#representing conversion of unmethylated cytosines

mkdir chr6_reference
mv chr6.fa.gz ./chr6_reference

#index the genome
bismark_genome_preparation /Users/cmdb/qbb2020-answers/assignment6/chr6_reference

#indices can be found in /Users/cmdb/qbb2020-answers/assignment6/chr6_reference/Bisulfite_Genome

#aligning SRR3083929 -> STEM-seq E5.5Epi Rep 1
bismark /Users/cmdb/qbb2020-answers/assignment6/chr6_reference/ -1 /Users/cmdb/qbb2020-answers/assignment6/methylation_fastq/SRR3083929_1.chr6.fastq -2 /Users/cmdb/qbb2020-answers/assignment6/methylation_fastq/SRR3083929_2.chr6.fastq 

#aligning SRR3083926 -> STEM-seq E4.0ICM Rep 1
bismark /Users/cmdb/qbb2020-answers/assignment6/chr6_reference/ -1 /Users/cmdb/qbb2020-answers/assignment6/methylation_fastq/SRR3083926_1.chr6.fastq -2 /Users/cmdb/qbb2020-answers/assignment6/methylation_fastq/SRR3083926_2.chr6.fastq 

#sort the bismark aligned reads by genomic coordinates
samtools sort -o SRR3083926_1.chr6_bismark_bt2_pe_sorted.bam SRR3083926_1.chr6_bismark_bt2_pe.bam
samtools sort -o SRR3083929_1.chr6_bismark_bt2_pe_sorted.bam SRR3083929_1.chr6_bismark_bt2_pe.bam

#index the sorted bam files
samtools index SRR3083926_1.chr6_bismark_bt2_pe_sorted.bam
samtools index SRR3083929_1.chr6_bismark_bt2_pe_sorted.bam


#extract methylation data from the files
# -p flag for paired end files cannot use sorted bam files
bismark_methylation_extractor --bedgraph --comprehensive -p SRR3083929_1.chr6_bismark_bt2_pe.bam SRR3083926_1.chr6_bismark_bt2_pe.bam

#output of methylation calls will be in tab separated text files


