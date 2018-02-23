#!/usr/bin/env python3

"""
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy import constants
from scipy import stats
from scipy.optimize import leastsq

# TODO
    # B0 should be the not logged value!
    # change to OriginalTraitValue - done but check!
    # add docstrings!

################################################################################
# constants
################################################################################

k = constants.value('Boltzmann constant in eV/K')
e = np.exp(1)

################################################################################
# read in data
################################################################################

print("Reading in Data...\n")

GRDF = pd.read_csv("../Data/GrowthRespPhotoData_new.csv",
                   usecols = ["FinalID",
                              "OriginalTraitName",
                              "OriginalTraitDef",
                              "OriginalTraitValue",
                              "OriginalTraitUnit",
                              "AmbientTemp",
                              "AmbientTempUnit",
                              "ConTemp",
                              "ConTempUnit",
                              "ResTemp",
                              "ResTempUnit"],
                   low_memory = False)

################################################################################
# data wrangling
################################################################################

print("Wrangling Data...\n")

# create NewID based on FinalID
GRDF["NewID"] = GRDF.FinalID.astype("category").cat.codes

# get rid of 0s -ves and NAs from data (only +ves)
GRDF = GRDF.loc[GRDF.index[GRDF["OriginalTraitValue"] > 0]]

print("    Choosing which Temperature to use: ConTemp > ResTemp > AmbientTemp")

# return best temp to use: ConTemp > ResTemp > AmbientTemp
def best_temp(group):
    """docstring"""
    if group.ConTemp.isnull().any():
        if group.ResTemp.isnull().any():
            group["UsedTemp"]     = group.AmbientTemp
            group["UsedTempUnit"] = group.AmbientTempUnit
            group["UsedTempType"] = "AmbientTemp"
            return group
        else:
            group["UsedTemp"]     = group.ResTemp
            group["UsedTempUnit"] = group.ResTempUnit
            group["UsedTempType"] = "ResTemp"
            return group
    else:
        group["UsedTemp"]     = group.ConTemp
        group["UsedTempUnit"] = group.ConTempUnit
        group["UsedTempType"] = "ConTemp"
        return group

GRDF = GRDF.groupby("NewID").apply(best_temp)

# convert to kelvin
GRDF["UsedTempK"] = GRDF.UsedTemp + 273.15

# sort by ID then temperature
GRDF = GRDF.sort_values(['NewID', 'UsedTempK'])


# removes groups where all temp values are the same
def same_temp(group):
    """docstring"""
    if len(group.UsedTemp.unique()) == 1:
        return False
    else:
        return True

GRDF = GRDF.groupby("NewID").filter(same_temp)


# removes groups where all trait values are the same
def same_trait(group):
    """docstring"""
    if len(group.OriginalTraitValue.unique()) == 1:
        return False
    else:
        return True

GRDF = GRDF.groupby("NewID").filter(same_trait)

print("    Dealing with outliers...")

# function was used to remove outliers before switching back to
# OriginalTraitValue
# remove first point if its 3 times higher than second
# def outliers(group):
#     """docstring"""
#     try:
#         if group.reset_index().StandardisedTraitValue[0] >\
#            3*group.reset_index().StandardisedTraitValue[1]:
#             return group.reset_index()[1:]
#         else:
#             return group.reset_index()
#     except KeyError:
#         return group.reset_index()
#
# GRDF = GRDF.groupby("NewID").apply(outliers)

# only required columns
GRDF = GRDF.loc[ : ,("NewID",
                     "FinalID",
                     "OriginalTraitName",
                     "OriginalTraitDef",
                     "OriginalTraitValue",
                     "OriginalTraitUnit",
                     "UsedTemp",
                     "UsedTempType",
                     "UsedTempK")]

# remove groups with fewer than five rows
GRDF = GRDF.groupby("NewID").filter(lambda x: len(x) > 5)

# logged trait value
GRDF["OTVlogged"] = np.log(GRDF.OriginalTraitValue)

# 1/kT
GRDF["adjTemp"] = 1/(GRDF.UsedTempK*k)

# reset index and make NewID a column
GRDF.reset_index(level=0, inplace=True)

################################################################################
# calculate starting values
################################################################################

print("\nCalculating Starting Values...")

def strt_vals(group):
    """docstring"""
    split = group.reset_index().OTVlogged.idxmax()  # split
    x     = group.reset_index().adjTemp
    y     = group.reset_index().OTVlogged
    xVals = group.reset_index().UsedTempK

    if split + 1 == len(y) or split == 0\
                           or split == 1\
                           or x[:split].nunique() == 1\
                           or x[split:].nunique() == 1:

        lm1 = stats.linregress(x, y)
        lm2 = stats.linregress(x, y)
    else:
        try:
            lm1 = stats.linregress(x[:split], y[:split])
        except ValueError:
            lm1 = stats.linregress(x, y)
        try:
            lm2 = stats.linregress(x[split:], y[split:])
        except ValueError:
            lm2 = stats.linregress(x, y)

    vals = {"E"     : lm1[0],
            "El"    : lm1[0]/2,
            "Eh"    : lm2[0],
            "Eint"  : lm1[1],
            "Ehint" : lm2[1],
            "B0"    : np.exp(lm1[0]*(1/(k*283.15)) + lm1[1]),
            "Th"    : xVals[y.idxmax()],
            "Tl"    : min(xVals)}

    return pd.DataFrame(vals, index = [0])

startingVals = GRDF.groupby("NewID").apply(strt_vals)

# reset index of starting values and make NewID a column
startingVals.reset_index(level=0, inplace=True)

# merge GRDF and strt_vals
GRDF = pd.merge(GRDF, startingVals, on = "NewID")

# save to csv
GRDF.to_csv("../Results/sorted_data.csv", index = False)

print("\nDone!")
