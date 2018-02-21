#!/usr/bin/env python3

"""
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
from modelfuncs import *
import pandas as pd
import sys

################################################################################
# read in the sorted dataframe
################################################################################

GRDF = pd.read_csv("../Results/sorted_data.csv")

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

arrhnDF = pd.DataFrame(data    = None,
                       columns = ('NewID', 'A0', 'Ea', 'deltaCp', 'deltaH',
                                  'chisqr', 'aic', 'bic'))

################################################################################
# progressBar function
################################################################################

def progressBar(value, endvalue, bar_length=40):

    percent = float(value) / endvalue
    arrow   = '#' * int(round(percent * bar_length))
    spaces  = ' ' * (bar_length - len(arrow))
    msg     = "\rID " + str(id).ljust(4)

    sys.stdout.write("\r {0} [{1}] {2}%".format(msg, arrow + spaces,
                                                int(round(percent * 100))))
    sys.stdout.flush()

################################################################################
# run model function for each id
################################################################################

print("\nStarting model fitting with NLLS")

iteration  = 0
iterations = len(GRDF.NewID.unique())

for id in GRDF["NewID"].unique():

    iteration += 1
    progressBar(iteration, iterations, 65)

    cubicDF = cubicDF.append(cubic_model(id, GRDF))
    flschDF = flschDF.append(full_schlfld_model(id, GRDF, 10))
    nhschDF = nhschDF.append(noh_schlfld_model(id,GRDF, 10))
    nlschDF = nlschDF.append(nol_schlfld_model(id,GRDF, 10))
    arrhnDF = arrhnDF.append(arrhenius_model(id,GRDF, 10))

################################################################################
# save results to csv
################################################################################

print("\n\nSaving Results as .csv files")

cubicDF.to_csv("../Results/cubic_model.csv")
flschDF.to_csv("../Results/full_scholfield_model.csv")
nhschDF.to_csv("../Results/noh_scholfield_model.csv")
nlschDF.to_csv("../Results/nol_scholfield_model.csv")
arrhnDF.to_csv("../Results/arrhenius_model.csv")

print("\nDone with Model Fitting!")
