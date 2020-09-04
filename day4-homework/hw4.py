#!/usr/bin/env python3

import sys
from fasta_iterator_class import FASTAReader


################################################################  
    
#kmer counter code

# returns a nested dictionary
# first dictionary has the sequence header as the key containing a second dictionary
# second dictionary has the kmers as the key, then the locations of the kmers as a list
def track_kmer(sequences, k):
    #initialize dictionary to contain all the sequences that are present in the fasta
    total_seqs = {}
    
    #loop through individual sequences that exist in the fasta
    for seq_id, sequence in sequences:
        #initialize dictionary to store positions of each kmer
        kmers ={}
        for i in range(0, len(sequence) - k + 1):
            kmer = sequence[i:i + k]
            kmers.setdefault(kmer, [])
            kmers[kmer].append(i)
        total_seqs[seq_id] = kmers
    return total_seqs
    

    
######################################################################   
    

    
def main(target, query, k):
    
   #returns a tuple of the seq_id and the sequences
    target_seqs = FASTAReader(open(target))
    droyak_seqs = FASTAReader(open(query))

    #handle multiple target_seqs in its own dictionary
    #query_positions = track_kmer(droyak_seqs, k)
    target_positions = track_kmer(target_seqs, k)
    
    #grab a specific kmer in the query sequence
    for seq_id, sequence in droyak_seqs:
        for i in range(0, len(sequence)-k+1):
            query_kmer = sequence[i:i + k]
            
            #go through targets to find matching Kmers and their positions
            for target_ID in target_positions.keys():
                target_kmers = target_positions[target_ID]
                if query_kmer in target_kmers.keys():
                    for position in target_kmers[query_kmer]:
                        print(target_ID+'\t'+str(position)+'\t'+str(i)+'\t'+query_kmer)
                        
                        
    
         
    #print(target_positions)
#     for seq_id, sequence in droyak_seqs:
#     print(seq_id)
#     print(sequence)

    
    return
 
#######################################################################    
    
if __name__ == "__main__":
    target = sys.argv[1] #list of target sequences
    query = sys.argv[2]  #single query sequence, Droyak
    k = int(sys.argv[3])      #size of the kmers
    main(target, query, k)

