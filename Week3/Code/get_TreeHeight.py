#!/bin/usr/env python3

"""python script to calculates tree heights from the angle of elevation and the
distance fom the base using the trigonometric formula
height = distance * tan(radians)
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import math
import csv

# function to calculate height from angle and distance

def tree_height(degrees, distance):
    radians = degrees * math.pi /180
    height = distance * math.tan(radians)

    return height

with open("../Data/trees.csv",'r') as trees:

