#!/usr/bin/env python3

"""
Author:      David Bridgwood
Description: reads in raw data for TPCs, filters out groups with too few points,
             selects best available temperature measure, converts to kelvin,
             calculates 1/kT. Calculates starting values for NLLS on schoolfield
             model"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import pandas as pd
import numpy as np
from scipy import constants
from scipy import stats
from datetime import datetime

startTime = datetime.now()

# TODO

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

print("Choosing which Temperature to use: ConTemp > ResTemp > AmbientTemp")

# return best temp to use: ConTemp > ResTemp > AmbientTemp
def best_temp(group):
    """fill usedtemp columns with best temperature measure: ConTemp > ResTemp > AmbientTemp"""
    if group.ConTemp.isnull().any():      # if ConTemp contains NAs then use ResTemp
        if group.ResTemp.isnull().any():  # if ResTemp contains NAs then use AmbientTemp
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

# apply best_temp function to each group (curve)
GRDF = GRDF.groupby("NewID").apply(best_temp)

# add column with temperature in kelvin
GRDF["UsedTempK"] = GRDF.UsedTemp + 273.15

# sort by ID then temperature
GRDF = GRDF.sort_values(['NewID', 'UsedTempK'])

# removes groups where all temp values are the same
def same_temp(group):
    """removes groups which contain all the same temperature values"""
    if len(group.UsedTemp.unique()) == 1:
        return False
    else:
        return True

GRDF = GRDF.groupby("NewID").filter(same_temp)

# removes groups where all trait values are the same
def same_trait(group):
    """removes groups which contain all the same trait values"""
    if len(group.OriginalTraitValue.unique()) == 1:
        return False
    else:
        return True

GRDF = GRDF.groupby("NewID").filter(same_trait)

# print("    Dealing with outliers...")
#
# function was used to remove outliers before switching back to
# OriginalTraitValue
# remove first point if its 3 times higher than second
# def outliers(group):
#     """remove first point of curve if it is > 3 times higher than the second"""
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

#  select only required columns
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

# add column with logged trait values
GRDF["OTVlogged"] = np.log(GRDF.OriginalTraitValue)

# calculate 1/kT
GRDF["adjTemp"] = 1/(GRDF.UsedTempK*k)

# reset index and make NewID a column
GRDF.reset_index(level=0, inplace=True)

################################################################################
# calculate starting values
################################################################################

print("\nCalculating Starting Values from data...")

def strt_vals(group):
    """returns starting values for NLLS of schoolfield model, calculated from data for each group as seperatre dataframe"""

    split = group.reset_index().OTVlogged.idxmax()  # find position of max trait value
    x     = group.reset_index().adjTemp
    y     = group.reset_index().OTVlogged
    xVals = group.reset_index().UsedTempK

       # if the max trait value is in the last two points
    if (split + 1 == len(y) or
        split == len(y) or
        # or first two points
        split == 0 or
        split == 1 or
        # or all points on that side of the split have the same temp
        x[:split].nunique() == 1 or
        x[split:].nunique() == 1):

        # then just put a line through all the points
        lm1 = stats.linregress(x, y)
        lm2 = stats.linregress(x, y)
    else:                             # otherwise
        try:                          # try and put a line through either side of the split
            lm1 = stats.linregress(x[:split], y[:split])
        except ValueError:
            lm1 = stats.linregress(x, y)
        try:
            lm2 = stats.linregress(x[split:], y[split:])
        except ValueError:
            lm2 = stats.linregress(x, y)

    vals = {"E"     : lm1[0],                                  # E is the slope of the right side
            "El"    : lm1[0]/2,                                # El is estimated as E/2
            "Eh"    : lm2[0],                                  # Eh is teh slope of the left side
            "Eint"  : lm1[1],                                  # Intercept of right line for illustrative plot
            "Ehint" : lm2[1],                                  # Intercept of left side for illustrative plot
            "B0"    : np.exp(lm1[0]*(1/(k*283.15)) + lm1[1]),  # B0 trait value to 10C from line through right side of 1/KT by trait
            "Th"    : xVals[y.idxmax()],                       # Th temperature with max trait value
            "Tl"    : min(xVals)}                              # Tl lowest temperature of curve

    return pd.DataFrame(vals, index = [0])

startingVals = GRDF.groupby("NewID").apply(strt_vals)

# reset index of starting values and make NewID a column
startingVals.reset_index(level=0, inplace=True)

# merge GRDF and strt_vals dataframes
GRDF = pd.merge(GRDF, startingVals, on = "NewID")

# save to csv
GRDF.to_csv("../Results/sorted_data.csv", index = False)

print("\nDone!")

print("Time taken: ", datetime.now() - startTime)
