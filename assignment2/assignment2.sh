#!/bin/bash

#concatenate individual chromosome files into whole genome reference
cat chr*.fa > sacCer3.fa
rm chr*.fa

#Step 1
bwa index sacCer3.fa

#Step 2
for SAMPLE in 09 11 23 24 27 31 35 39 62 63
do
	echo A01_${SAMPLE}.fastq
	bwa mem -R "@RG\tID:A01${SAMPLE}\tSM:A01${SAMPLE}" sacCer3.fa A01_${SAMPLE}.fastq > A01_${SAMPLE}.sam
done

#Step 3
for SAMPLE in 09 11 23 24 27 31 35 39 62 63
do
	echo A01_${SAMPLE}.sam
	samtools sort -O bam -o A01_${SAMPLE}_sorted.bam A01_${SAMPLE}.sam	
done

#Step 4
freebayes -f sacCer3.fa --genotype-qualities -p 1 A01_09_sorted.bam A01_11_sorted.bam A01_23_sorted.bam A01_24_sorted.bam A01_27_sorted.bam A01_31_sorted.bam A01_35_sorted.bam A01_39_sorted.bam A01_62_sorted.bam A01_63_sorted.bam> A01_var.vcf

#Step 5
#from the vcf file 
#PHRED scale is -10 * log(1-p)
#-10 * log(1-0.99) is 20

vcffilter -f 'QUAL > 20'  A01_var.vcf > A01_var_filtered.vcf 
echo "finished filter"

#Step 6
#vcfallelicprimitives will convert variant calls to SNPs
vcfallelicprimitives -k -g A01_var_filtered.vcf > A01_var_decomp.vcf 
echo "finished decomposition"

#Step 7
snpeff download R64-1-1.86
snpeff ann R64-1-1.86 A01_var_decomp.vcf > A01_var_predictions.vcf 
echo "finished variant predictions"

#Step 8
#plots will be generated in Jupyter notebook titled "Quant_Lab_Assignment_2"

#generating file for first 1000 lines of finalzed VCF
head -n 1000 A01_var_predictions.vcf > var_predictions_1000L.vcf