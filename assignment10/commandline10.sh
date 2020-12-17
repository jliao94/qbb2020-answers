#starting directory:
#/Users/cmdb/qbb2020-answers/assignment10/

#Step 1: Investigate the taxonomic profile of the reads
#extract the downloaded week13 data
tar -xvf week13_data.tar

#make directories for formatted kraken files and 
mkdir /Users/cmdb/qbb2020-answers/assignment10/week13_data/KRAKEN_formatted
mkdir /Users/cmdb/qbb2020-answers/assignment10/week13_data/krona_output
cd /Users/cmdb/qbb2020-answers/assignment10/week13_data/KRAKEN

#ran formatting code in attached jupyter notebook

mv *formatted ../KRAKEN_formatted/
cd /Users/cmdb/qbb2020-answers/assignment10/week13_data/KRAKEN_formatted

#after formatting files (done in jupyter notebook), run ktImportText on each file
ktImportText -q -o SRR492183.krona.html SRR492183.kraken_formatted 
ktImportText -q -o SRR492186.krona.html SRR492186.kraken_formatted
ktImportText -q -o SRR492188.krona.html SRR492188.kraken_formatted  
ktImportText -q -o SRR492189.krona.html SRR492189.kraken_formatted  
ktImportText -q -o SRR492190.krona.html SRR492190.kraken_formatted
ktImportText -q -o SRR492193.krona.html SRR492193.kraken_formatted
ktImportText -q -o SRR492194.krona.html SRR492194.kraken_formatted
ktImportText -q -o SRR492197.krona.html SRR492197.kraken_formatted

mv *krona* ../krona_output

#Step 2: Deconvolute the assembled scaffolds into individual genomes (binning)
#index the assembly file
cd /Users/cmdb/qbb2020-answers/assignment10/week13_data
mv assembly.fasta /Users/cmdb/qbb2020-answers/assignment10/week13_data/
cd /Users/cmdb/qbb2020-answers/assignment10/week13_data/READS
bwa index assembly.fasta

#align each of the fastq files
bwa mem -o SRR492183_aligned.sam assembly.fasta SRR492183_1.fastq SRR492183_2.fastq 
bwa mem -o SRR492186_aligned.sam assembly.fasta SRR492186_1.fastq SRR492186_2.fastq 
bwa mem -o SRR492188_aligned.sam assembly.fasta SRR492188_1.fastq SRR492188_2.fastq 
bwa mem -o SRR492189_aligned.sam assembly.fasta SRR492189_1.fastq SRR492189_2.fastq 
bwa mem -o SRR492190_aligned.sam assembly.fasta SRR492190_1.fastq SRR492190_2.fastq 
bwa mem -o SRR492193_aligned.sam assembly.fasta SRR492193_1.fastq SRR492193_2.fastq 
bwa mem -o SRR492194_aligned.sam assembly.fasta SRR492194_1.fastq SRR492194_2.fastq 
bwa mem -o SRR492197_aligned.sam assembly.fasta SRR492197_1.fastq SRR492197_2.fastq 

#convert aligned files to bam format
samtools view -b SRR492183_aligned.sam > SRR492183_aligned.bam
samtools view -b SRR492186_aligned.sam > SRR492186_aligned.bam
samtools view -b SRR492188_aligned.sam > SRR492188_aligned.bam
samtools view -b SRR492189_aligned.sam > SRR492189_aligned.bam
samtools view -b SRR492190_aligned.sam > SRR492190_aligned.bam
samtools view -b SRR492193_aligned.sam > SRR492193_aligned.bam
samtools view -b SRR492194_aligned.sam > SRR492194_aligned.bam
samtools view -b SRR492197_aligned.sam > SRR492197_aligned.bam

#sort the bams for metabat input
samtools sort SRR492183_aligned.bam -o SRR492183_aligned.sorted.bam
samtools sort SRR492186_aligned.bam -o SRR492186_aligned.sorted.bam
samtools sort SRR492188_aligned.bam -o SRR492188_aligned.sorted.bam
samtools sort SRR492189_aligned.bam -o SRR492189_aligned.sorted.bam
samtools sort SRR492190_aligned.bam -o SRR492190_aligned.sorted.bam
samtools sort SRR492193_aligned.bam -o SRR492193_aligned.sorted.bam
samtools sort SRR492194_aligned.bam -o SRR492194_aligned.sorted.bam
samtools sort SRR492197_aligned.bam -o SRR492197_aligned.sorted.bam


#run metabat2 on the sorted bam files 
#current directory: Users/cmdb/qbb2020-answers/assignment10/week13_data/READS
runMetaBat.sh assembly.fasta *.sorted.bam

#Step 3: Estimate the taxonomy of your putative genomes
cd Users/cmdb/qbb2020-answers/assignment10
tar -xvf bins.tar














