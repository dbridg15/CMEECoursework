#!/usr/bin/env python3

"""Script containing deliberte bug to demonstrate debugging
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

def createabug(x):
    """Function containing deliberate bug"""
    y = x**4
    z = 0.
    y = y/z
    return y

createabug(25)
