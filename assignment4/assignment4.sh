#!/bin/bash

#Part 1
#conda install emboss mafft

#count to make sure 1000 sequences were counted
#grep '>' seqdump.txt | wc -l

#rename blast output file
#mv seqdump.txt blast_output.fa

#add query sequence to the blast output
#cat week4_query.fa blast_output.fa > query_and_blast.fa


#Part 2
#transeq -sequence query_and_blast.fa -outseq aminoacids.fa

#mafft aminoacids.fa > alignAA.fa

#Part 3
#move FASTAREADER script from previous file
#cd ..
#cd day4-homework
#mv fasta_iterator_class.py ../assignment4

#converting back into nucleotides will be done with the python script conversion.py

