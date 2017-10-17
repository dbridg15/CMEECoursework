#! /usr/bin/env python3

"""Script takes a tuple of tuples containing birds latin, common and mass and
prints them out formatted and line by line
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

birds = (('Passerculus sandwichensis', 'Savannah sparrow', 18.7),
         ('Delichon urbica', 'House martin', 19),
         ('Junco phaeonotus', 'Yellow-eyed junco', 19.5),
         ('Junco hyemalis', 'Dark-eyed junco', 19.6),
         ('Tachycineata bicolor', 'Tree swallow', 20.2),
         )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line for each species
# Hints: use the "print" command! You can use list comprehensions!


for entry in birds:
    print("Latin Name: %s \nCommon Name: %s \nMass: %s \n"
          % (entry[0], entry[1], entry[2]))
