#!/usr/bin/env python3

"""Script demonstrating opening, reading, writing and closing csvfiles"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import csv

# Read a file containing:
# 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male (kg)'
with open('../Sandbox/testcsv.csv', 'r') as f:  # Using with open

    csvread = csv.reader(f)
    temp = []
    for row in csvread:
        temp.append(tuple(row))
        print(row)
        print("The species is", row[0])

# Write a file containing only species name and Body mass
with open('../Sandbox/testcsv.csv', 'r') as f:
    with open('../Sandbox/bodymass.csv', 'w') as g:

        csvread = csv.reader(f)
        csvwrite = csv.writer(g)
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0], row[4]])

# no need to cloes files as they close automaticly when exiting with open
