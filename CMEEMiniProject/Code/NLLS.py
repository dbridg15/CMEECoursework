#!/usr/bin/env python3

"""
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
from modelfuncs import *
import sys

################################################################################
# read in the sorted dataframe
################################################################################

GRDF = pd.read_csv("../Results/sorted_data.csv")

################################################################################
# set up dataframes for results
################################################################################

cubicDF = pd.DataFrame(data = None)
flschDF = pd.DataFrame(data = None)
nhschDF = pd.DataFrame(data = None)
nlschDF = pd.DataFrame(data = None)
arrhnDF = pd.DataFrame(data = None)

################################################################################
# progressBar function
################################################################################

def progressBar(value, endvalue, bar_length = 65):
    """function which prints progress through model functions as a progressBar"""

    percent = float(value) / endvalue
    hashes  = '#' * int(round(percent * bar_length))
    spaces  = ' ' * (bar_length - len(hashes))
    msg     = "\rID " + str(id).ljust(4)

    sys.stdout.write("\r {0} [{1}] {2}%".format(msg, hashes + spaces,
                                                int(round(percent * 100))))
    sys.stdout.flush()

################################################################################
# run model function for each id
################################################################################

print("\nStarting model fitting with NLLS")

# number of iterations for progressBar is number of unique ids
iterations = len(GRDF.NewID.unique())

# cubic model-------------------------------------------------------------------

iteration  = 0
print("\nCubic Model...")

for id in GRDF["NewID"].unique():
    iteration += 1                                   # increment iterations
    progressBar(iteration, iterations, 65)           # print progressBar to console
    cubicDF = cubicDF.append(cubic_model(id, GRDF))  # append output of NLLS fitting

# calulate how many converged and print to console
failed    = cubicDF.aic.isnull().sum()
converged = iterations - failed
print("\n{0} of {1} curves converged.".format(converged, iterations))


# # full schoolfield model--------------------------------------------------------

iteration  = 0
print("\n\nFull Schoolfield Model...") # change the text!

for id in GRDF["NewID"].unique():
    iteration += 1
    progressBar(iteration, iterations, 65)
    # method 1 for speed
    flschDF = flschDF.append(full_schlfld_model(id, GRDF, tries = 25, method = 1))

failed    = flschDF.aic.isnull().sum()
converged = iterations - failed
print("\n{0} of {1} curves converged.".format(converged, iterations))


# no high schoolfield-----------------------------------------------------------

iteration  = 0
print("\n\nSchoolfield Model without high...") # change the text!

for id in GRDF["NewID"].unique():
    iteration += 1
    progressBar(iteration, iterations, 65)
    # method 1 for speed
    nhschDF = nhschDF.append(noh_schlfld_model(id,GRDF, tries = 25, method = 1))

failed    = nhschDF.aic.isnull().sum()
converged = iterations - failed
print("\n{0} of {1} curves converged.".format(converged, iterations))


# no low schoolfield------------------------------------------------------------

iteration  = 0
print("\n\nSchoolfield Model without low...") # change the text!

for id in GRDF["NewID"].unique():
    iteration += 1
    progressBar(iteration, iterations, 65)
    # method 1 for speed
    nlschDF = nlschDF.append(nol_schlfld_model(id,GRDF, tries = 25, method = 1))

failed    = nlschDF.aic.isnull().sum()
converged = iterations - failed
print("\n{0} of {1} curves converged.".format(converged, iterations))


# arrhenius model---------------------------------------------------------------

iteration  = 0
print("\n\nEnzyme assisted Arrhenius Model...")

for id in GRDF["NewID"].unique():
    iteration += 1
    progressBar(iteration, iterations, 65)
    # method 2 for slightly better curves
    arrhnDF = arrhnDF.append(arrhenius_model(id, GRDF, tries = 5, method = 2))

failed    = arrhnDF.aic.isnull().sum()
converged = iterations - failed
print("\n{0} of {1} curves converged.".format(converged, iterations))

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
