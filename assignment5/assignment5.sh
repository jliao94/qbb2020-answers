#!/bin/bash

#Part 1

conda install macs2 -y

#getting the mouse chr19 file
wget --timestamping 'ftp://hgdownload.cse.ucsc.edu/goldenPath/mm10/chromosomes/chr19.fa.gz' -O chr19.fa.gz
gunzip chr19.fa.gz
mkdir chr19_index

bowtie2-build chr19.fa chr19_index/chr19


for sample in CTCF_ER4 CTCF_G1E input_ER4 input_G1E
do
  bowtie2 -x chr19_index/chr19 -U ${sample}.fastq -S ${sample}.sam -p 6
  samtools view -bSo ${sample}.bam ${sample}.sam
  samtools sort ${sample}.bam -o ${sample}.sorted.bam
  samtools index ${sample}.sorted.bam
done

#call peaks
macs2 callpeak -t CTCF_ER4.bam -c input_ER4.bam --format=BAM --name=CTCF_ER4 --gsize=61420004
macs2 callpeak -t CTCF_G1E.bam -c input_G1E.bam --format=BAM --name=CTCF_G1E --gsize=61420004

#Differential binding
#identify locations wheere CTCF is lost/gained druing differentiation
#G1E is before differentiation, ER4 is after differentiation
bedtools intersect -a CTCF_G1E_peaks.narrowPeak -b CTCF_ER4_peaks.narrowPeak -v >CTCF_lost_in_dif.bed
bedtools intersect -a CTCF_ER4_peaks.narrowPeak -b CTCF_G1E_peaks.narrowPeak -v >CTCF_gained_in_dif.bed

#grab the functional region file 
wget https://raw.githubusercontent.com/bxlab/qbb2020/master/week5/Mus_musculus.GRCm38.94_features.bed

#Feature overlapping
#find intersection of functional regions with CTCF binding sites in ER4 and G1E
bedtools intersect -a Mus_musculus.GRCm38.94_features.bed -b CTCF_ER4_peaks.narrowPeak > ER4_func_regions.bed
bedtools intersect -a Mus_musculus.GRCm38.94_features.bed -b CTCF_G1E_peaks.narrowPeak > G1E_func_regions.bed


#Part 2

conda install meme -y

#download the meme motif database based on site provided in assignment write-up
tar -xvzf motif_databases.12.19.tgz

#run python script to grab the 100 most significant peaks 
python3 strongPeaks.py

#get fasta sequences from peaks file
bedtools getfasta -fo CTCF_ER4_100peaks.fa -fi chr19.fa -bed CTCF_ER4_100peaks.narrowPeak

#run meme-chip 
meme-chip -meme-maxw 20 -db /Users/cmdb/qbb2020-answers/assignment5/motif_databases/JASPAR/JASPAR_CORE_2016.meme CTCF_ER4_100peaks.fa

#the first motif is the strongest motif according to meme, matches known motifs in database according to tomtom
epstopdf /Users/cmdb/qbb2020-answers/assignment5/memechip_out/meme_out/logo1.eps /Users/cmdb/qbb2020-answers/assignment5/strongestLogo.pdf
