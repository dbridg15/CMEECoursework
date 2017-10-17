#! /usr/bin/env python3

"""Script returns a dictionary of Order names with sets of species within them
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

taxa = [('Myotis lucifugus', 'Chiroptera'),
        ('Gerbillus henleyi', 'Rodentia',),
        ('Peromyscus crinitus', 'Rodentia'),
        ('Mus domesticus', 'Rodentia'),
        ('Cleithrionomys rutilus', 'Rodentia'),
        ('Microgale dobsoni', 'Afrosoricida'),
        ('Microgale talazaci', 'Afrosoricida'),
        ('Lyacon pictus', 'Carnivora'),
        ('Arctocephalus gazella', 'Carnivora'),
        ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic
# derived from  taxa so that it maps order names to sets of taxa.
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc.

# Write your script here:


taxa_dic = {}
for species in taxa:
    if species[1] not in taxa_dic:
        taxa_dic[species[1]] = set()
    taxa_dic[species[1]].add(species[0])
print(taxa_dic)
