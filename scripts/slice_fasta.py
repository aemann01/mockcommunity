#!/usr/bin/python3

'''Read in fasta file and coordinates file (e.g., output of rnammer), pulls sequences and slices to given coordinates
'''

import pandas as pd
from Bio import SeqIO

coord = pd.read_csv("rnammer_16s.txt", sep="\t", header=None)
records = SeqIO.index("all_genomes.fa", "fasta")

for i in range(len(coord[0])):
    if coord[3][i] > coord[4][i]:
        x = coord[4][i]
        y = coord[3][i]
    else:
        x = coord[3][i]
        y = coord[4][i]
    print(">",records[coord[0][i]].id, sep="")
    print(records[coord[0][i]].seq[x:y])