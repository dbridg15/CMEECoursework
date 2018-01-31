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
from lmfit import minimize, Parameters, report_fit

################################################################################
# read in as pandas dataframe
################################################################################

GRDF = pd.read_csv("../Results/Sorted_data.csv")

################################################################################
# constants
################################################################################

k = constants.value('Boltzmann constant in eV/K')
e = np.exp(1)

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

    print(id, 'of' , GRDF.NewID.unique().max())

    curveDF = GRDF[GRDF.NewID == id]
    curveDF = curveDF.reset_index(drop = True)

    xVals    = np.asarray(curveDF.UsedTemp)
    adjxVals = np.asarray(curveDF.adjTemp)
    data     = np.asarray(curveDF.StandardisedTraitValue)
    ldata    = np.asarray(curveDF.STVlogged)

    # y axis title is whatever trait unit...
    ytitle = (curveDF["StandardisedTraitName"].iloc[0] + " (" +
              curveDF["StandardisedTraitUnit"].iloc[0] + "))")

    E     = curveDF.E[0]
    Eh    = curveDF.Eh[0]
    Eint  = curveDF.Eint[0]
    Ehint = curveDF.Ehint[0]

    B0 = curveDF.B0[0]
    Th = curveDF.Th[0]
    Tl = curveDF.Tl[0]

    # plots!
    plt.figure(figsize = (20, 20))
    plt.subplot(211)
    plt.plot(xVals, data, 'ro')
    plt.ylabel(ytitle)
    plt.xlabel("Kelvin")
    plt.title(id)

    plt.subplot(212)
    plt.plot(adjxVals, ldata, 'bo')
    abline(slope = E, intercept = Eint, lcol = 'r--')
    abline(slope = Eh, intercept = Ehint, lcol = 'g--')
    plt.plot(((1/(k*283.15)), (1/(k*283.15))), (-10000, B0), 'b--')
    plt.plot(((1/(k*283.15)), -10000), (B0, B0), 'b--')
    plt.ylim(np.floor(min(ldata)), np.ceil(max(ldata)))
    plt.xlim(np.floor(min(adjxVals)), np.ceil(max(adjxVals)))
    stuff = "E: {} \n Eh: {} \n Th: {} \n Tl: {} \n B0: {}".format(E, Eh, Th,
                                                                   Tl, B0)
    plt.figtext(0.7, 0.9, fontsize = 16, s = stuff)
    plt.xlabel("1/kT")
    plt.ylabel("ln(B)")

    pp.savefig()
    plt.close()

pp.close()
