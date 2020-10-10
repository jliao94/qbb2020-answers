#!/usr/bin/env python3
#Part 3
#converts aligned AA sequence into nucleotides, with "---" inserted for alignment gaps
import sys
from fasta_iterator_class import FASTAReader

AA_file = "/Users/cmdb/qbb2020-answers/assignment4/alignAA.fa"
DNA_file = "/Users/cmdb/qbb2020-answers/assignment4/query_and_blast.fa"
outputfile = "/Users/cmdb/qbb2020-answers/assignment4/conv_DNA_seqs.fa"

#AA_file = "/Users/cmdb/qbb2020-answers/assignment4/test_alignAA.fa"
#DNA_file = "/Users/cmdb/qbb2020-answers/assignment4/test_alignDNA.fa"

AA_file = FASTAReader(open(AA_file))
DNA_file = FASTAReader(open(DNA_file))

AA_seqs = []
DNA_seqs = []
#confirm sequences have the same length
AA_lengths = set() 
for seq_id, sequence in AA_file:
	AA_seqs.append((seq_id, sequence))
	AA_lengths.add(len(sequence))

print("length of aligned sequences")
print(AA_lengths)

for seq_id, sequence in DNA_file:
	DNA_seqs.append((seq_id, sequence))


#for every gap in the AA sequence, add a gap in the DNA sequence
converted_seq_lengths = set()
converted_sequences = []
DNA_headers = []
for i, j in zip(DNA_seqs, AA_seqs):

	#grab the DNA sequence
	DNA_seq = i[1] 
	AA_seq= j[1]

	DNA_header = i[0]
	DNA_headers.append(DNA_header)

	converted_sequence = ''
	start = 0
	end= 3
	for AA in AA_seq:
		if AA == "-":
			converted_sequence = converted_sequence + "---"
		else:
			converted_sequence = converted_sequence + DNA_seq[start:end]
			start +=3
			end +=3
	converted_seq_lengths.add(len(converted_sequence))
	converted_sequences.append(converted_sequence)

print("length of converted DNA sequences")
print(converted_seq_lengths)




with open(outputfile, 'w') as oFile:
	for i, j in zip(DNA_headers, converted_sequences):
		oFile.write(">" + i)
		oFile.write('\n')
		oFile.write(j)
		oFile.write('\n')


#Part 4 will be done in jupyter notebook for plotting

