#!/usr/bin/env python3

"""Script demonstrating sys.argv"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import sys

print("This is the name of the script: ", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: ", str(sys.argv))
