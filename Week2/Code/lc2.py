#! /usr/bin/env python3

"""Using list comprehension containing if statements to create lists of
wet and dry months
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN', 111.4),
            ('FEB', 126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG', 140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV', 128.4),
            ('DEC', 142.2),
            )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

# list comprehension going through each month in rainfall and adding them to
# the list if they meet the requirments

wet_lc = set([month for month in rainfall if month[1] > 100])
print(wet_lc)

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm.

dry_lc = set([month for month in rainfall if month[1] < 50])
print(dry_lc)

# (3) Now do (1) and (2) using conventional loops (you can choose to do
# this before 1 and 2 !).

# loop going through each month in rainfall and adding them to
# the uist if they meet the requirments

wet_lp = set()
for month in rainfall:
    if month[1] > 100:
        wet_lp.add(month)
print(wet_lp)


dry_lp = set()
for month in rainfall:
    if month[1] < 50:
        dry_lp.add(month)
print(dry_lp)
