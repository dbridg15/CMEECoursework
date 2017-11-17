#!/usr/bin/env python3

"""open and run TestR.R and print output and errors to seperate files
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# import
import subprocess

subprocess.Popen("/usr/lib/R/bin/Rscript --verbose TestR.R > \
                 ../Results/TestR.Rout 2> ../Results/TestR_errFile.Rout",
                 shell=True).wait()
