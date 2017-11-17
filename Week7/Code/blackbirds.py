#!/usr/bin/env python3

""" returns table of Kingdom, Phylum and Species from blackbirds.txt
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
import re
import prettytable

# Read the file
f = open('../Data/blackbirds.txt', 'r')
text = f.read()
f.close()

# remove \t\n (tabs and new lines) and put a space in:
text = text.replace('\t', ' ')
text = text.replace('\n', ' ')

# note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform
# to ASCII:
text = text.encode('ascii', 'ignore').decode()

# Now write a python script that captures the Kingdom,
# Phylum and Species name for each species and prints it out to screen neatly.

# print(text)

kingdom = re.findall(r'Kingdom (\w+)', text)
phylum = re.findall(r'Phylum (\w+)', text)
species = re.findall(r'Species (\w+\s\w+)', text)
# would be nice to get english names as well but its not in the same place for
# all species

# make table

x = prettytable.PrettyTable()

x.add_column('Kingdom', kingdom)
x.add_column('Phylum', phylum)
x.add_column('Species', species)

print(x)
