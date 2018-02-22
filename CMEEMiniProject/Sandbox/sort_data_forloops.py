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

# stop some annoying pandas warnings...
pd.options.mode.chained_assignment = None  # default='warn'

################################################################################
# constants
################################################################################

k = constants.value('Boltzmann constant in eV/K')
e = np.exp(1)

################################################################################
# Read in and sort data
################################################################################

# read in with only specific columns
GRDF = pd.read_csv("../Data/GrowthRespPhotoData_new.csv",
                   usecols = ["FinalID",
                              "StandardisedTraitName",
                              "StandardisedTraitDef",
                              "StandardisedTraitValue",
                              "StandardisedTraitUnit",
                              "AmbientTemp",
                              "AmbientTempUnit",
                              "ConTemp",
                              "ConTempUnit",
                              "ResTemp",
                              "ResTempUnit"],
                   low_memory = False)

# get rid of 0s -ves and NAs from data (only +ves)
GRDF = GRDF.iloc[GRDF.index[GRDF["StandardisedTraitValue"] > 0]]

# create NewID based on FinalID
GRDF["NewID"] = GRDF.FinalID.astype("category").cat.codes

# sort by NewID then ConTemp; AmbientTemp; ResTemp
# ***SHOULD ASK SAMRAAT ABOUT WHICH TEMP TO USE*
GRDF = GRDF.sort_values(['NewID', 'ConTemp', 'AmbientTemp', 'ResTemp'])

# reset index
GRDF = GRDF.reset_index(drop = True)

# go through each id and if the first value it > 3 times higher
# than the next then delete the row...
for id in GRDF.NewID.unique():
    tmp = GRDF[GRDF.NewID == id]
    tmp = tmp.reset_index(drop = True)
    try:
        if tmp.StandardisedTraitValue[0] > 3*tmp.StandardisedTraitValue[1]:
            GRDF = GRDF.drop(GRDF.index[GRDF.NewID == id][0])
    except KeyError:
        pass

# get rid of ids with < 5 data points
GRDF = GRDF.groupby("FinalID").filter(lambda x: len(x) > 5)

# which temperature measure to use? ConTemp > AmbientTemp > ResTemp
GRDF["UsedTemp"] = np.NaN
GRDF["TempType"] = np.NaN
GRDF["TempUnit"] = np.NaN

for id in GRDF.NewID.unique():
    if GRDF.ConTemp[GRDF.NewID == id].isnull().any() == False:
        GRDF.UsedTemp[GRDF.NewID == id] = GRDF.ConTemp[GRDF.NewID == id]
        GRDF.TempUnit[GRDF.NewID == id] = GRDF.ConTempUnit[GRDF.NewID == id]
        GRDF.TempType[GRDF.NewID == id] = "ConTemp"
    elif GRDF.ResTemp[GRDF.NewID == id].isnull().any() == False:
        GRDF.UsedTemp[GRDF.NewID == id] = GRDF.ResTemp[GRDF.NewID == id]
        GRDF.TempUnit[GRDF.NewID == id] = GRDF.ResTempUnit[GRDF.NewID == id]
        GRDF.TempType[GRDF.NewID == id] = "ResTemp"
    elif GRDF.AmbientTemp[GRDF.NewID == id].isnull().any() == False:
        GRDF.UsedTemp[GRDF.NewID == id] = GRDF.AmbientTemp[GRDF.NewID == id]
        GRDF.TempUnit[GRDF.NewID == id] = GRDF.AmbientTempUnit[GRDF.NewID == id]
        GRDF.TempType[GRDF.NewID == id] = "AmbientTemp"


# convert to kelvin
GRDF.UsedTempUnit = GRDF.TempUnit.str.lower()
TempK = GRDF.UsedTemp[GRDF.TempUnit != "kelvin"] + 273.15
GRDF.UsedTemp[GRDF.TempUnit != "kelvin"] = TempK

# only columns i need
GRDF = GRDF.loc[ : ,("NewID",
                     "FinalID",
                     "StandardisedTraitName",
                     "StandardisedTraitDef",
                     "StandardisedTraitValue",
                     "StandardisedTraitUnit",
                     "UsedTemp",
                     "TempType")]

# logged trait value
GRDF["STVlogged"] = np.log(GRDF.StandardisedTraitValue)

# 1/kT
GRDF["adjTemp"] = 1/(GRDF.UsedTemp*k)

# Sort by ID then temperature
GRDF = GRDF.sort_values(['NewID', 'UsedTemp'])

# get rid of ids where all trait values are at one temperature value
for id in GRDF.NewID.unique():
    if len(GRDF.UsedTemp[GRDF.NewID == id].unique()) == 1:
        GRDF = GRDF.drop(GRDF.index[GRDF.NewID == id])

# reset index
GRDF = GRDF.reset_index(drop = True)

################################################################################
# get starting values
################################################################################

GRDF["E"]     = np.NaN
GRDF["Eh"]    = np.NaN
GRDF["Eint"]  = np.NaN
GRDF["Ehint"] = np.NaN
GRDF["B0"]    = np.NaN
GRDF["Th"]    = np.NaN
GRDF["Tl"]    = np.NaN

for id in GRDF.NewID.unique():
    adjxVals = GRDF.adjTemp[GRDF.NewID == id].reset_index(drop = True)
    ldata    = GRDF.STVlogged[GRDF.NewID == id].reset_index(drop = True)

    split = np.argmax(ldata)  # split

    if split + 1 == len(ldata) or split == 0:
        lm1 = stats.linregress(x = adjxVals, y = ldata)
        lm2 = stats.linregress(x = adjxVals, y = ldata)
    else:
        try:
            lm1 = stats.linregress(x = adjxVals[:split], y = ldata[:split])
        except ValueError:
            lm1 = stats.linregress(x = adjxVals, y = ldata)
        try:
            lm2 = stats.linregress(x = adjxVals[split:], y = ldata[split:])
        except ValueError:
            lm2 = stats.linregress(x = adjxVals, y = ldata)

    GRDF.E[GRDF.NewID == id]  = lm1[0]  # slope of line right of Tpeak
    GRDF.Eh[GRDF.NewID == id] = lm2[0]  # slope of line left of Tpeak
    GRDF.Eint[GRDF.NewID == id]  = lm1[1]  # intercept of line right of Tpeak
    GRDF.Ehint[GRDF.NewID == id] = lm2[1]  # intercept of line left of Tpeak
    GRDF.B0[GRDF.NewID == id] = lm1[0]*(1/(k*283.15)) + lm1[1]  # ln(Bo) at 10C
    GRDF.Th[GRDF.NewID == id] = xVals[np.argmax(ldata)]  # Tpeak
    GRDF.Tl[GRDF.NewID == id] = min(xVals) # The lowest temp with STV
    # El I will bind so it must be lower than E in the NLLS

    GRDF.Eh[GRDF.Eh.isnull()] = GRDF.E[GRDF.Eh.isnull()]

# save as csv
GRDF.to_csv("../Results/Sorted_data.csv")
