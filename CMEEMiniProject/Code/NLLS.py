#!/usr/bin/env python3

"""
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
from modelfuncs import *
import pandas as pd

################################################################################
# read in the sorted dataframe
################################################################################

GRDF = pd.read_csv("../Results/Sorted_data.csv")

################################################################################
# set up dataframes for results
################################################################################

cubicDF = pd.DataFrame(data    = None,
                       columns = ('NewID', 'a', 'b', 'c', 'd', 'chisqr', 'aic',
                                  'bic'))

flschDF  = pd.DataFrame(data    = None,
                       columns = ('NewID', 'B0', 'E', 'Eh', 'El', 'Tl', 'Th',
                                  'chisqr', 'aic', 'bic'))

nhschDF = pd.DataFrame(data    = None,
                       columns = ('NewID', 'B0', 'E', 'El', 'Tl', 'chisqr',
                                  'aic', 'bic'))

nlschDF = pd.DataFrame(data    = None,
                       columns = ('NewID', 'B0', 'E', 'Eh', 'Th', 'chisqr',
                                  'aic', 'bic'))

################################################################################
# run model function for each id
################################################################################

for id in GRDF["NewID"].unique():

    cubicDF    = cubicDF.append(cubic_model(id, GRDF))
    flschDF = flschDF.append(full_schlfld_model(id, GRDF))
    nhschDF  = nhschDF.append(noh_schlfld_model(id,GRDF))
    nlschDF  = nlschDF.append(nol_schlfld_model(id,GRDF))

################################################################################
# save results to csv
################################################################################

cubicDF.to_csv("../Results/cubic_model.csv")
flschDF.to_csv("../Results/full_scholfield_model.csv")
nhschDF.to_csv("../Results/noh_scholfield_model.csv")
nlschDF.to_csv("../Results/nol_scholfield_model.csv")
