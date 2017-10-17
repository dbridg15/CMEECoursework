#! /usr/bin/env python3

"""Script demonstrating loops in python
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# loops in python!!!
for i in range(5):
    print(i)


my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)


total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
    print(total)


# while loops...
z = 0
while z < 100:
    z = z + 1
    print(z)


b = True
while b:
    print('GERONIMO! Infinate loop! ctrl + c to stop!')
