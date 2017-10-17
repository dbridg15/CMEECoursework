#!/usr/bin/python3

"""Script takes data from TestOakData.csv and returns only species in the genus
Quercus to new file JustOaksData.csv
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import csv
import sys
import doctest


# Function returns TRUE if the genus of given species is Quercus
def is_an_oak(name):
    """ Returns True if name is starts with 'quercus '
        >>> is_an_oak('quercus')
        True

        >>> is_an_oak('Fagus sylvatica')
        False

        >>> is_an_oak('Quercuss')
        False
    """
    return name.lower() == 'quercus'  # Removed trailing space and made ==


print(is_an_oak.__doc__)


# Function tskes list of species from TestOaksData.csv and returns only sepcies
# in genus Quercus into JustOaksDavta.csv
def main(argv):
    """Main function, takes list of species from TestOaksData.csv, passes though
    is_an_oak and writes to file JustOaksData.csv"""
    # Open Data and output file
    f = open('../Data/TestOaksData.csv', 'r')
    g = open('../Data/JustOaksData.csv', 'w')
    taxa = csv.reader(f)  # Read csv file
    csvwrite = csv.writer(g)
#    oaks = set()  # is this even needed?
    for row in taxa:  # for all the species in taxa
        print(row)
        print("The genus is", row[0])
        if is_an_oak(row[0]):
            print(row[0])
            print('FOUND AN OAK!')
            print(" ")
            csvwrite.writerow([row[0], row[1]])

    return 0


if (__name__ == "__main__"):
    status = main(sys.argv)

doctest.testmod()
