#!/usr/bin/env python3

"""
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import pandas as pd
import numpy as np
from scipy import constants

################################################################################
# read in data
################################################################################

cubicDF = pd.read_csv("../Results/cubic_model.csv")
flschDF = pd.read_csv("../Results/full_scholfield_model.csv")
nhschDF = pd.read_csv("../Results/noh_scholfield_model.csv")
nlschDF = pd.read_csv("../Results/nol_scholfield_model.csv")

################################################################################
#
################################################################################

aic = pd.DataFrame({"NewID" : cubicDF.NewID,
                    "cubic" : cubicDF.aic,
                    "flsch" : flschDF.aic,
                    "nhsch" : nhschDF.aic,
                    "nlsch" : nlschDF.aic})

################################################################################
#
################################################################################


