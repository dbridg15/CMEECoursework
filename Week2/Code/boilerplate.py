#! /usr/bin/python

""" PUT A DESCRIPTION HERE!!!!
    YOU CAN USE SEVERAL LINES"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import sys # module to interface our program with the operating system

# constants can go here


# functions can go here
def main(argv):
        print('This is a boilerplate') # NOTE: indented using two tabs
        return 0

if (__name__ == "__main__"): # makes sure the "main" function is called from
                             #command line
        status = main(sys.argv)
        sys.exit(status)

