#! /usr/bin/env python3

"""Script demonstrating list comprehensions
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# Find taxa that are oak trees in a list of species
taxa = ['Quercus robur',
        'Fraxinus excelsior',
        'Pinus sylvestris',
        'Quercus cerris',
        'Quercus petrea',
        ]


def is_an_oak(name):
    """returns TRUE is the genus is quercus"""
    return name.lower().startswith('quercus ')


# Using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)


# Using list comprehensions
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)


# Get names in UPPER case using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)


oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)
