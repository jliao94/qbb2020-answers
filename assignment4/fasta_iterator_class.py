#!/usr/bin/env python3

"""
Parse all FASTA records from stdin and print id and sequence
"""

import sys

class FASTAReader(object):

    def __init__(self, file):
        self.last_id = None
        self.file = file
        self.eof = False

    def __iter__(self):
        return self

    def __next__(self):
        if self.eof:
            raise StopIteration
        # check if this is the first sequence from the file
        if self.last_id is None:
            # First line
            line = self.file.readline()
            # Verify that this is a FASTA file
            assert line.startswith(">"), "Not a FASTA file"
            # Get the sequence ID
            seq_id = line[1:].rstrip("\r\n")
        else:
            # Get ID from previous round
            seq_id = self.last_id

        sequence = []
        while True:
            line = self.file.readline()
            # Check if we've reached the end of the file
            if line == "":
                self.eof = True
                break
            # Check if we've reached the next sequence
            elif not line.startswith(">"):
                sequence.append(line.strip())
            # We've reached the next sequence ID
            else:
                self.last_id = line[1:].rstrip("\r\n")
                break
        
        sequence = "".join(sequence)
        return seq_id, sequence

if __name__ == "__main__":
    reader = FASTAReader(sys.stdin)

    for seq_id, sequence in reader:
        print(seq_id, sequence)