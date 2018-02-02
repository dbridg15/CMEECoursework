#!/usr/bin/env python3

"""
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import pandas as pd
import numpy as np
from scipy import constants
from scipy import stats
from scipy.optimize import leastsq
from lmfit import minimize, Parameters, report_fit
from random import *

################################################################################
# read in as pandas dataframe
################################################################################

GRDF = pd.read_csv("../Results/Sorted_data.csv")

cubicDF = pd.DataFrame(data = None, columns = ('id', 'a', 'b', 'c', 'd',
                                                 'chisqr', 'aic', 'bic'))

schooDF = pd.DataFrame(data = None, columns = ('id', 'B0', 'E', 'Eh', 'El',
                                            'Tl', 'Th', 'chisqr', 'aic', 'bic'))

################################################################################
# constants
################################################################################

k = constants.value('Boltzmann constant in eV/K')
e = np.exp(1)

################################################################################
# run model save results and plot fitted curve
################################################################################

for id in GRDF["NewID"].unique():

    print(id, 'of', GRDF.NewID.unique().max())

    curveDF = GRDF[GRDF.NewID == id]
    curveDF = curveDF.reset_index(drop = True)

    xVals    = np.asarray(curveDF.UsedTemp)
    adjxVals = np.asarray(curveDF.adjTemp)
    data     = np.asarray(curveDF.StandardisedTraitValue)
    ldata    = np.asarray(curveDF.STVlogged)

    # cubic model ##############################################################

    # set parameters
    params = Parameters()
    params.add('a', value = 0.)
    params.add('b', value = 0.)
    params.add('c', value = 0.)
    params.add('d', value = 0.)

    # function of model - returns residuals
    def get_residual(params, x, data):
        a = params['a'].value
        b = params['b'].value
        c = params['c'].value
        d = params['d'].value
        model = a + b*x + c*x**2 + d*x**3
        return model - data

    # output of NLLS
    try:
        out1 = minimize(get_residual, params, args = (xVals, ldata))

        # save results best fitting parameters
        tmp1 = {'id'     : [id],
                'a'      : [out1.params["a"].value],
                'b'      : [out1.params["b"].value],
                'c'      : [out1.params["c"].value],
                'd'      : [out1.params["d"].value],
                'chisqr' : [out1.chisqr],
                'aic'    : [out1.aic],
                'bic'    : [out1.bic]}
        tmp1 = pd.DataFrame(tmp1)
    except ValueError:
        tmp1 = {'id'     : [id],
                'a'      : [na],
                'b'      : [na],
                'c'      : [na],
                'd'      : [na],
                'chisqr' : [na],
                'aic'    : [na],
                'bic'    : [na]}
        tmp1 = pd.DataFrame(tmp1)

    cubicDF = cubicDF.append(tmp1)


    # full schoolfield model ###################################################

    def schlfld_residual(sparams, x, data):
        B0 = sparams['B0'].value
        E  = sparams['E'].value
        El = sparams['El'].value
        Eh = sparams['Eh'].value
        Tl = sparams['Tl'].value
        Th = sparams['Th'].value
        e  = sparams['e'].value
        k  = sparams['k'].value

        model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                   1+(e**((El/k)*((1/Tl)-(1/x))))+(e**((Eh/k)*((1/Th)-(1/x))))))

        return model - data

    B0 = e**curveDF.B0[0]
    E  = abs(curveDF.E[0])
    El = abs(curveDF.E[0])
    Eh = curveDF.Eh[0]
    Tl = curveDF.Tl[0]
    Th = curveDF.Th[0]

    trycount = 0
    while True:

        trycount += 1
        print(id, 'Try:', trycount)
        if trycount > 10:
            tmp2 = {'id'     : [id],
                    'B0'     : e**curveDF.B0[0],
                    'E'      : abs(curveDF.E[0]),
                    'El'     : abs(curveDF.E[0]),
                    'Eh'     : curveDF.Eh[0],
                    'Tl'     : curveDF.Tl[0],
                    'Th'     : curveDF.Th[0],
                    'chisqr' : [np.NaN],
                    'aic'    : [np.NaN],
                    'bic'    : [np.NaN]}
            tmp2 = pd.DataFrame(tmp2)
            break

        try:
            sparams = Parameters()
            sparams.add('B0', value = uniform(B0*.2, B0*1.8), min = 0)
            sparams.add('E',  value = uniform(E*.2, E*1.8), min= 0)
            sparams.add('El', value = uniform(E*.2, E*1.8), min = 0)
            sparams.add('Eh', value = uniform(Eh*.2, Eh*1.8), min = 0)
            sparams.add('Tl', value = Tl, min = 260, max = 330)
            sparams.add('Th', value = Th, min = 260, max = 330)
            sparams.add('e',  value = e, vary = False)
            sparams.add('k',  value = k, vary = False)

            out2 = minimize(schlfld_residual, sparams, args = (xVals, ldata))

            tmp2 = {'id'     : [id],
                    'B0'     : [out2.params["B0"].value],
                    'E'      : [out2.params["E"].value],
                    'El'     : [out2.params["El"].value],
                    'Eh'     : [out2.params["Eh"].value],
                    'Tl'     : [out2.params["Eh"].value],
                    'Th'     : [out2.params["Eh"].value],
                    'chisqr' : [out2.chisqr],
                    'aic'    : [out2.aic],
                    'bic'    : [out2.bic]}
            tmp2 = pd.DataFrame(tmp2)

            break

        except ValueError:
            print('Did not converge.')
            continue

    schooDF = schooDF.append(tmp2)

    out1    = None
    out2    = None
    sparams = None
    params  = None
    tmp1    = None
    tmp2    = None

cubicDF.to_csv("../Results/cubic_model.csv")
schooDF.to_csv("../Results/Schholfield_model.csv")
