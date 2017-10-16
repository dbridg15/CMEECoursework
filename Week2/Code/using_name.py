#!/usr/bin/env python3

"""Simple Python script demonstrating if __name__ == '__main__'"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# Filename: using_name.py

if __name__ == '__main__':
    print('This program is being run by itself')
else:
    print('I am being imported from another module')
