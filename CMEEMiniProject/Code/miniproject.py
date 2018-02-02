#!/usr/bin/env python3

"""
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import pandas as pd
import numpy as np
from scipy import constants
from lmfit import minimize, Parameters, report_fit
from random import uniform

################################################################################
# constants
################################################################################

k = constants.value('Boltzmann constant in eV/K')
e = np.exp(1)

################################################################################
# schlfld_vals()
################################################################################

def schlfld_vals(id, df):
    """PUT IN DOCSTRING"""

    vals = {'id'    : id,
            'xVals' : np.asarray(df.UsedTemp[df.NewID == id]),
            'yVals' : np.asarray(df.STVlogged[df.NewID == id]),
            'B0'    : e**(df.B0[df.NewID == id].iloc[0]),
            'E'     : abs(df.E[df.NewID == id].iloc[0]),
            'El'    : abs(df.E[df.NewID == id].iloc[0]),
            'Eh'    : df.Eh[df.NewID == id].iloc[0],
            'Tl'    : df.Tl[df.NewID == id].iloc[0],
            'Th'    : df.Th[df.NewID == id].iloc[0]}

    return vals

################################################################################
# full_schlfld_residuals()
################################################################################

def full_schlfld_residuals(params, x, data):
    """PUT IN DOCSTRING!!!"""

    B0 = params['B0'].value
    E  = params['E'].value
    El = params['El'].value
    Eh = params['Eh'].value
    Tl = params['Tl'].value
    Th = params['Th'].value
    e  = params['e'].value
    k  = params['k'].value

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                   1+(e**((El/k)*((1/Tl)-(1/x))))+(e**((Eh/k)*((1/Th)-(1/x))))))

    return model - data

################################################################################
# full_schlfld_model()
################################################################################

def full_schlfld_model(id, df):
    """PUT IN DOCSTRING"""

    vals = schlfld_vals(id, df)

    xVals    = vals["xVals"]
    ldata    = vals["yVals"]

    res = {'id'     : vals["id"],
           'B0'     : vals["B0"],
           'E'      : vals["E"],
           'El'     : vals["El"],
           'Eh'     : vals["Eh"],
           'Tl'     : vals["Tl"],
           'Th'     : vals["Th"],
           'chisqr' : 1,  # will test on each try for improvment
           'aic'    : [np.NaN],
           'bic'    : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1

        if trycount > 10:
            res = pd.DataFrame(res)
            if res["chisqr"].values[0] == 1:
                print(id, "Full Schoolfield Failed to converge!")
            else:
                print(id, "Full Schoolfield Converged! lowest chisqr:", res["chisqr"].values[0])
            break

        try:
            params = Parameters()
            params.add('B0', value = uniform(vals["B0"]*.2, vals["B0"]*1.8), min = 0)
            params.add('E',  value = uniform(vals["E"]*.2, vals["E"]*1.8), min= 0)
            params.add('El', value = uniform(vals["El"]*.2, vals["El"]*1.8), min = 0)
            params.add('Eh', value = uniform(vals["Eh"]*.2, vals["Eh"]*1.8), min = 0)
            params.add('Tl', value = vals["Tl"], min = 260, max = 330)
            params.add('Th', value = vals["Th"], min = 260, max = 330)
            params.add('e',  value = e, vary = False)
            params.add('k',  value = k, vary = False)

            out = minimize(full_schlfld_residuals, params, args = (xVals, ldata))

            if out.chisqr < res["chisqr"]:
                res = {'id'     : [id],
                       'B0'     : [out.params["B0"].value],
                       'E'      : [out.params["E"].value],
                       'El'     : [out.params["El"].value],
                       'Eh'     : [out.params["Eh"].value],
                       'Tl'     : [out.params["Tl"].value],
                       'Th'     : [out.params["Th"].value],
                       'chisqr' : [out.chisqr],
                       'aic'    : [out.aic],
                       'bic'    : [out.bic]}
            continue

        except ValueError:
            continue

    return res

################################################################################
# noh_schlfld_residuals()
################################################################################

def noh_schlfld_residuals(params, x, data):
    """PUT IN DOCSTRING!!!"""

    B0 = params['B0'].value
    E  = params['E'].value
    El = params['El'].value
    Tl = params['Tl'].value
    e  = params['e'].value
    k  = params['k'].value

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                   1+(e**((El/k)*((1/Tl)-(1/x))))))

    return model - data

################################################################################
# noh_schlfld_model()
################################################################################

def noh_schlfld_model(id, df):
    """PUT IN DOCSTRING"""

    vals = schlfld_vals(id, df)

    xVals    = vals["xVals"]
    ldata    = vals["yVals"]

    res = {'id'     : vals["id"],
           'B0'     : vals["B0"],
           'E'      : vals["E"],
           'El'     : vals["El"],
           'Tl'     : vals["Tl"],
           'chisqr' : 1,  # will test on each try for improvment
           'aic'    : [np.NaN],
           'bic'    : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1

        if trycount > 10:
            res = pd.DataFrame(res)
            if res["chisqr"].values[0] == 1:
                print(id, "noh Schoolfield Failed to converge!")
            else:
                print(id, "noh Schoolfield Converged! lowest chisqr:", res["chisqr"].values[0])
            break

        try:
            params = Parameters()
            params.add('B0', value = uniform(vals["B0"]*.2, vals["B0"]*1.8), min = 0)
            params.add('E',  value = uniform(vals["E"]*.2, vals["E"]*1.8), min= 0)
            params.add('El', value = uniform(vals["El"]*.2, vals["El"]*1.8), min = 0)
            params.add('Tl', value = vals["Tl"], min = 260, max = 330)
            params.add('e',  value = e, vary = False)
            params.add('k',  value = k, vary = False)

            out = minimize(noh_schlfld_residuals, params, args = (xVals, ldata))

            if out.chisqr < res["chisqr"]:
                res = {'id'     : [id],
                       'B0'     : [out.params["B0"].value],
                       'E'      : [out.params["E"].value],
                       'El'     : [out.params["El"].value],
                       'Tl'     : [out.params["Tl"].value],
                       'chisqr' : [out.chisqr],
                       'aic'    : [out.aic],
                       'bic'    : [out.bic]}
            continue

        except ValueError:
            continue

    return res

################################################################################
# nol_schlfld_residuals()
################################################################################

def nol_schlfld_residuals(params, x, data):
    """PUT IN DOCSTRING!!!"""

    B0 = params['B0'].value
    E  = params['E'].value
    Eh = params['Eh'].value
    Th = params['Th'].value
    e  = params['e'].value
    k  = params['k'].value

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                   1+(e**((Eh/k)*((1/Th)-(1/x))))))

    return model - data

################################################################################
# nol_schlfld_model()
################################################################################

def nol_schlfld_model(id, df):
    """PUT IN DOCSTRING"""

    vals = schlfld_vals(id, df)

    xVals    = vals["xVals"]
    ldata    = vals["yVals"]

    res = {'id'     : vals["id"],
           'B0'     : vals["B0"],
           'E'      : vals["E"],
           'Eh'     : vals["Eh"],
           'Th'     : vals["Th"],
           'chisqr' : 1,  # will test on each try for improvment
           'aic'    : [np.NaN],
           'bic'    : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1

        if trycount > 10:
            res = pd.DataFrame(res)
            if res["chisqr"].values[0] == 1:
                print(id, "nol Schoolfield Failed to converge!")
            else:
                print(id, "nol Schoolfield Converged! lowest chisqr:", res["chisqr"].values[0])
            break

        try:
            params = Parameters()
            params.add('B0', value = uniform(vals["B0"]*.2, vals["B0"]*1.8), min = 0)
            params.add('E',  value = uniform(vals["E"]*.2, vals["E"]*1.8), min= 0)
            params.add('Eh', value = uniform(vals["Eh"]*.2, vals["Eh"]*1.8), min = 0)
            params.add('Th', value = vals["Th"], min = 260, max = 330)
            params.add('e',  value = e, vary = False)
            params.add('k',  value = k, vary = False)

            out = minimize(nol_schlfld_residuals, params, args = (xVals, ldata))

            if out.chisqr < res["chisqr"]:
                res = {'id'     : [id],
                       'B0'     : [out.params["B0"].value],
                       'E'      : [out.params["E"].value],
                       'Eh'     : [out.params["Eh"].value],
                       'Th'     : [out.params["Th"].value],
                       'chisqr' : [out.chisqr],
                       'aic'    : [out.aic],
                       'bic'    : [out.bic]}

            continue

        except ValueError:
            continue

    return res

################################################################################
# cubic_vals()
################################################################################

def cubic_vals(id, df):
    """PUT IN DOCSTRING"""

    vals = {'id'    : id,
            'xVals' : np.asarray(df.UsedTemp[df.NewID == id]),
            'yVals' : np.asarray(df.STVlogged[df.NewID == id]),
            'a'     : 0.,
            'b'     : 0.,
            'c'     : 0.,
            'd'     : 0.}

    return vals

################################################################################
# cubic_residuals()
################################################################################

def cubic_residuals(params, x, data):
    a = params['a'].value
    b = params['b'].value
    c = params['c'].value
    d = params['d'].value

    model = a + b*x + c*x**2 + d*x**3

    return model - data

################################################################################
# cubic_model()
################################################################################

def cubic_model(id, df):
    """PUT IN DOCSTRING"""

    vals = cubic_vals(id, df)

    xVals    = vals["xVals"]
    ldata    = vals["yVals"]

    res = {'id'     : vals["id"],
           'a'      : vals["a"],
           'b'      : vals["b"],
           'c'      : vals["c"],
           'd'      : vals["d"],
           'chisqr' : 1,  # will test on each try for improvment
           'aic'    : [np.NaN],
           'bic'    : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1

        if trycount > 10:
            res = pd.DataFrame(res)
            if res["chisqr"].values[0] == 1:
                print(id, "Cubic Failed to converge!")
            else:
                print(id, "Cubic Converged! lowest chisqr:", res["chisqr"].values[0])
            break

        try:
            params = Parameters()
            params.add('a', value = vals["a"])
            params.add('b', value = vals["b"])
            params.add('c', value = vals["c"])
            params.add('d', value = vals["d"])

            out = minimize(cubic_residuals, params, args = (xVals, ldata))

            if out.chisqr < res["chisqr"]:
                res = {'id'     : [id],
                       'a'      : [out.params["a"].value],
                       'd'      : [out.params["b"].value],
                       'c'      : [out.params["c"].value],
                       'd'      : [out.params["d"].value],
                       'chisqr' : [out.chisqr],
                       'aic'    : [out.aic],
                       'bic'    : [out.bic]}

            continue

        except ValueError:
            continue

    return res
