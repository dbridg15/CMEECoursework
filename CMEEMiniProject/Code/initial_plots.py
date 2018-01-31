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


################################################################################
# sort data
################################################################################

data = pd.read_csv("../Data/GrowthRespPhotoData_new.csv", low_memory = False)


# get rid of 0s -ves and NAs from data (only +ves)
data2 = data.iloc[data.index[data["StandardisedTraitValue"] > 0]]

# get rid of ids with < 5 data points
data2 = data2.groupby("FinalID").filter(lambda x: len(x) > 5)

# set NewID based on OriginalID **do i even need to do this?**
data2["NewID"] = data2.FinalID.astype("category").cat.codes

# only columns i need
data2 = data2.loc[ : ,("NewID",
                       "FinalID",
                       "OriginalTraitName",
                       "OriginalTraitDef",
                       "OriginalTraitValue",
                       "OriginalTraitUnit",
                       "StandardisedTraitName",
                       "StandardisedTraitDef",
                       "StandardisedTraitValue",
                       "StandardisedTraitUnit",
                       "AmbientTemp",
                       "AmbientTempUnit",
                       "ConTemp",
                       "ConTempUnit",
                       "ResTemp",
                       "ResTempUnit",
                       "Consumer")]


################################################################################
# plots
################################################################################

pp = PdfPages('../Results/initial_plots.pdf')

for i in data2["NewID"].unique():

    tmp = data2[data2["NewID"] == i]

    if tmp.shape[0] > 5:
        y = tmp["StandardisedTraitValue"]
        ytitle = (tmp["StandardisedTraitName"].iloc[0] + " (" +
                  tmp["StandardisedTraitUnit"].iloc[0] + ")")

        if tmp["ConTemp"].isnull().any() == False:
            x = tmp["ConTemp"]
            xtitle = "ConTemp (" + tmp["ConTempUnit"].iloc[0] + ")"
        elif tmp["AmbientTemp"].isnull().any() == False:
            x = tmp["AmbientTemp"]
            xtitle = "AmbientTemp (" + tmp["AmbientTempUnit"].iloc[0] + ")"
        elif tmp["ResTemp"].isnull().any() == False:
            x = tmp["ResTemp"]
            xtitle = "ResTemp (" + tmp["ResTempUnit"].iloc[0] + ")"

        plt.figure(figsize = (20, 20))
        plt.subplot(211)
        plt.plot(x, np.log(y), 'ro')
        plt.xlabel(xtitle)
        plt.ylabel(ytitle)
        plt.title(i)

        plt.subplot(212)
        plt.plot((1/((x+273.15)*constants.value('Boltzmann constant in eV/K'))),
                 (np.log(y)), 'bo')
        plt.xlabel("1/kT")
        plt.ylabel("ln(B)")

        #plt.show()
        pp.savefig()
        plt.close()
pp.close()
