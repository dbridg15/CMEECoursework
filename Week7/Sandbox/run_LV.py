#!/usr/bin/env python3

"""Run and profile LV1.py and LV2.py
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import cProfile
import pstats
import io

prf = cProfile.Profile()

# LV1

prf.enable()
import LV1  # this opens LV1.py
prf.disable()
s = io.StringIO()
ps = pstats.Stats(prf, stream=s)
ps.print_stats(0).sort_stats('calls')  # order by calls
print("LV1.py:")
print(s.getvalue())

# LV2

prf.enable()
import LV2
prf.disable()
s = io.StringIO()
ps = pstats.Stats(prf, stream=s)
ps.print_stats(0).sort_stats('calls')  # order by calls
print("LV2.py:")
print(s.getvalue())
