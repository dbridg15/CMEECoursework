#!/usr/bin/env python3

""" run fmr.R and say whether script ran successfully and the full_output
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
import subprocess

P = subprocess.Popen("Rscript --verbose fmr.R", shell=True,
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE)

try:
    P1, P2 = P.communicate()
except subprocess.TimeoutExpired:
    print("Script timed out!")

print("Script ran successfully!\n")
print(P1.decode())
