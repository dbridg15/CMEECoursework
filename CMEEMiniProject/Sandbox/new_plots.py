#!/usr/bin/env python3

"""
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import numpy as np
from scipy import constants
from scipy.optimize import leastsq
from scipy import stats


pd.options.mode.chained_assignment = None  # default='warn'

################################################################################
# sort data
################################################################################
k = constants.value('Boltzmann constant in eV/K')
e = np.exp(1)

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

# create NewID based on FianlID
GRDF["NewID"] = GRDF.FinalID.astype("category").cat.codes

# sort by NewID then ConTemp; AmbientTemp; ResTemp  *SHOULD ASK SAMRAAT ABOUT WHICH TEMP TO USE*
GRDF = GRDF.sort_values(['NewID', 'ConTemp', 'AmbientTemp', 'ResTemp'])

# reset index
GRDF = GRDF.reset_index(drop = True)

# go through each id and if the first value it > 5 times higher than the next then delete the row...
for id in GRDF.NewID.unique():
    tmp = GRDF[GRDF.NewID == id]
    tmp = tmp.reset_index(drop = True)

    try:
        if tmp.StandardisedTraitValue[0] > 5*tmp.StandardisedTraitValue[1]:
            GRDF = GRDF.drop(GRDF.index[GRDF.NewID == id][0])
    except KeyError:
        pass

# get rid of ids with < 5 data points
GRDF = GRDF.groupby("FinalID").filter(lambda x: len(x) > 5)

# convert to kelvin
GRDF.ConTempUnit     = GRDF.ConTempUnit.str.lower()
GRDF.AmbientTempUnit = GRDF.AmbientTempUnit.str.lower()
GRDF.ResTempUnit     = GRDF.ResTempUnit.str.lower()

GRDF.ConTemp[GRDF.ConTempUnit != "kelvin"]         = GRDF.ConTemp[GRDF.ConTempUnit != "kelvin"] + 273.15
GRDF.AmbientTemp[GRDF.AmbientTempUnit != "kelvin"] = GRDF.AmbientTemp[GRDF.AmbientTempUnit != "kelvin"] + 273.15
GRDF.ResTemp[GRDF.ResTempUnit != "kelvin"]         = GRDF.ResTemp[GRDF.ResTempUnit != "kelvin"] + 273.15

# only columns i need
GRDF = GRDF.loc[ : ,("NewID",
                     "FinalID",
                     "StandardisedTraitName",
                     "StandardisedTraitDef",
                     "StandardisedTraitValue",
                     "StandardisedTraitUnit",
                     "AmbientTemp",
                     "ConTemp",
                     "ResTemp")]

# logged trait value
GRDF["STVlogged"] = np.log(GRDF.StandardisedTraitValue)

# reset index
GRDF = GRDF.reset_index(drop = True)

################################################################################
# Functions
###############################################################################

def abline(slope, intercept, lcol):
    """Plot a line from slope and intercept"""
    axes = plt.gca()
    x_vals = np.array(axes.get_xlim())
    y_vals = intercept + slope * x_vals
    plt.plot(x_vals, y_vals, lcol)

################################################################################
# plots
################################################################################

pp = PdfPages('../Results/initial_plots.pdf')

for id in GRDF["NewID"].unique():

    curveDF = GRDF[GRDF["NewID"] == id]

    if curveDF["ConTemp"].isnull().any() == False:
        curveDF = curveDF.sort_values("ConTemp")
        xVals   = np.asarray(curveDF["ConTemp"])
    elif curveDF["AmbientTemp"].isnull().any() == False:
        curveDF = curveDF.sort_values("AmbientTemp")
        xVals   = np.asarray(curveDF["AmbientTemp"])
    elif curveDF["ResTemp"].isnull().any() == False:
        curveDF = curveDF.sort_values("ResTemp")
        xVals   = np.asarray(curveDF["ResTemp"])

    data    = np.asarray(curveDF["StandardisedTraitValue"])
    ldata   = np.asarray(curveDF["STVlogged"])

    # y axis title is whatever trait unit...
    ytitle = ("ln(" + curveDF["StandardisedTraitName"].iloc[0] + " (" +
            curveDF["StandardisedTraitUnit"].iloc[0] + "))")

    # Starting Values

    # E is the slope of the main bit of the curve when ln(B) is plotted against 1/kT (made positive?)
    # use all point past Tpeak (Th) Eh is the slope of the line before these points
    split = np.argmax(ldata)  # split
    try:
        lm1 = stats.linregress(x = (1/(xVals[:split]*k)), y = ldata[:split])  # E is slope
    except ValueError:
        lm1 = stats.linregress(x = (1/(xVals[split:]*k)), y = ldata[split:])  # Eh is slope

    try:
        lm2 = stats.linregress(x = (1/(xVals[split:]*k)), y = ldata[split:])  # Eh is slope
    except ValueError:
        lm1 = stats.linregress(x = (1/(xVals[:split]*k)), y = ldata[:split])  # E is slope

    E  = lm1[0]                          # slope of line for points to right of Tpeak
    Eh = lm2[0]                          # slope of line for points to left og Tpeak
    B0 = lm1[0]*(1/(k*283.15)) + lm1[1]  # y = mx +c to get ln(Bo) at 10 degrees
    Th = xVals[np.argmax(ldata)]         # Tpeak
    Tl = min(xVals)                      # The lowest temperture value for which there is a trait value
    # El I will bind so it must be lower than E in the NLLS

    # plots!
    plt.figure(figsize = (20, 20))
    plt.subplot(211)
    plt.plot(xVals, ldata, 'ro')
    plt.ylabel(ytitle)
    plt.xlabel("Kelvin")
    plt.title(id)

    plt.subplot(212)
    plt.plot((1/(xVals*k)), ldata, 'bo')
    abline(slope = lm1[0], intercept = lm1[1], lcol = 'r--')
    abline(slope = lm2[0], intercept = lm2[1], lcol = 'g--')
    plt.plot(((1/(k*283.15)), (1/(k*283.15))), (-10000, B0), 'b--')
    plt.plot(((1/(k*283.15)), -10000), (B0, B0), 'b--')
    plt.ylim(np.floor(min(ldata)), np.ceil(max(ldata)))
    plt.xlim(np.floor(min((1/(xVals*k)))), np.ceil(max((1/(xVals*k)))))
    stuff = "E: {} \n Eh: {} \n Th: {} \n Tl: {} \n B0: {}".format(E, Eh, Th, Tl, B0)
    plt.figtext(0.7, 0.4, fontsize = 16, s = stuff)
    plt.xlabel("1/kT")
    plt.ylabel("ln(B)")

    pp.savefig()
    plt.close()

pp.close()
