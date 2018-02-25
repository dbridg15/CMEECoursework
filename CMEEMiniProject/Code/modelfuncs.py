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

# TODO
    # Bind the E/El/Eh values to each other

################################################################################
# constants
################################################################################

k = constants.value('Boltzmann constant in eV/K')
e = np.exp(1)

np.random.seed(111)

################################################################################
# schlfld_vals()
################################################################################

def schlfld_vals(id, df):
    """PUT IN DOCSTRING"""

    vals = {'NewID' : id,
            'xVals' : np.asarray(df.UsedTempK[df.NewID == id]),
            'yVals' : np.asarray(df.OTVlogged[df.NewID == id]),
            'B0'    : df.B0[df.NewID == id].iloc[0],
            'E'     : abs(df.E[df.NewID == id].iloc[0]),
            'El'    : abs(df.El[df.NewID == id].iloc[0]),
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

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                   1+(e**((El/k)*((1/Tl)-(1/x))))+(e**((Eh/k)*((1/Th)-(1/x))))))

    return model - data

################################################################################
# full_schlfld_model()
################################################################################

def full_schlfld_model(id, df, tries = 10):
    """PUT IN DOCSTRING"""

    vals = schlfld_vals(id, df)

    xVals    = vals["xVals"]
    ldata    = vals["yVals"]

    res = {'NewID'  : vals["NewID"],
           'B0'     : vals["B0"],
           'E'      : vals["E"],
           'El'     : vals["El"],
           'Eh'     : vals["Eh"],
           'Tl'     : vals["Tl"],
           'Th'     : vals["Th"],
           'chisqr' : [np.NaN],  # will test on each try for improvment
           'aic'    : [np.NaN],
           'bic'    : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1

        if trycount > tries or res["aic"] != [np.NaN]:
           break

        try:
            if trycount == 1:
                params = Parameters()
                params.add('B0', value = vals["B0"], min = 0)
                params.add('E',  value = vals["E"], min= 0)
                params.add('El', value = vals["El"], min = 0)
                params.add('Eh', value = vals["Eh"], min = 0)
                params.add('Tl', value = vals["Tl"], min = 250, max = 400)
                params.add('Th', value = vals["Th"], min = 250, max = 400)
            else:
                params = Parameters()
                params.add('B0', value = np.random.uniform(0, vals["B0"]*2), min = 0)
                params.add('E',  value = np.random.uniform(0, vals["E"]*2), min= 0)
                params.add('El', value = np.random.uniform(0, vals["El"]*2), min = 0)
                params.add('Eh', value = np.random.uniform(0, vals["Eh"]*2), min = 0)
                params.add('Tl', value = vals["Tl"], min = 250, max = 400)
                params.add('Th', value = vals["Th"], min = 250, max = 400)

            out = minimize(full_schlfld_residuals, params, args = (xVals, ldata))

            if out.chisqr < res["aic"] or res["aic"] == [np.NaN]:
                res = {'NewID'  : [id],
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

    res = pd.DataFrame(res)
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

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                   1+(e**((El/k)*((1/Tl)-(1/x))))))

    return model - data

################################################################################
# noh_schlfld_model()
################################################################################

def noh_schlfld_model(id, df, tries = 10):
    """PUT IN DOCSTRING"""

    vals = schlfld_vals(id, df)

    xVals    = vals["xVals"]
    ldata    = vals["yVals"]

    res = {'NewID'  : vals["NewID"],
           'B0'     : vals["B0"],
           'E'      : vals["E"],
           'El'     : vals["El"],
           'Tl'     : vals["Tl"],
           'chisqr' : [np.NaN],  # will test on each try for improvment
           'aic'    : [np.NaN],
           'bic'    : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1

        if trycount > tries or res["aic"] != [np.NaN]:
           break

        try:
            if trycount == 1:
                params = Parameters()
                params.add('B0', value = vals["B0"], min = 0)
                params.add('E',  value = vals["E"],  min= 0)
                params.add('El', value = vals["El"], min = 0)
                params.add('Tl', value = vals["Tl"], min = 250, max = 400)

            else:
                params = Parameters()
                params.add('B0', value = np.random.uniform(0, vals["B0"]*2), min = 0)
                params.add('E',  value = np.random.uniform(0, vals["E"]*2), min= 0)
                params.add('El', value = np.random.uniform(0, vals["El"]*2), min = 0)
                params.add('Tl', value = vals["Tl"], min = 250, max = 400)

            out = minimize(noh_schlfld_residuals, params, args = (xVals, ldata))

            if out.chisqr < res["aic"] or res["aic"] == [np.NaN]:
                res = {'NewID'  : [id],
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

    res = pd.DataFrame(res)
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

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(1+(e**((Eh/k)*((1/Th)-(1/x))))))

    return model - data

################################################################################
# nol_schlfld_model()
################################################################################

def nol_schlfld_model(id, df, tries = 10):
    """PUT IN DOCSTRING"""

    vals = schlfld_vals(id, df)

    xVals    = vals["xVals"]
    ldata    = vals["yVals"]

    res = {'NewID'  : vals["NewID"],
           'B0'     : vals["B0"],
           'E'      : vals["E"],
           'Eh'     : vals["Eh"],
           'Th'     : vals["Th"],
           'chisqr' : [np.NaN],  # will test on each try for improvment
           'aic'    : [np.NaN],
           'bic'    : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1

        if trycount > tries or res["aic"] != [np.NaN]:
           break

        try:
            if trycount == 1:
                params = Parameters()
                params.add('B0', value = vals["B0"], min = 0)
                params.add('E',  value = vals["E"], min= 0)
                params.add('Eh', value = vals["Eh"], min = 0)
                params.add('Th', value = vals["Th"], min = 250, max = 400)

            else:
                params = Parameters()
                params.add('B0', value = np.random.uniform(0, vals["B0"]*2), min = 0)
                params.add('E',  value = np.random.uniform(0, vals["E"]*2), min= 0)
                params.add('Eh', value = np.random.uniform(0, vals["Eh"]*2), min = 0)
                params.add('Th', value = vals["Th"], min = 250, max = 400)


            out = minimize(nol_schlfld_residuals, params, args = (xVals, ldata))

            if out.chisqr < res["aic"] or res["aic"]  == [np.NaN]:
                res = {'NewID'  : [id],
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

    res = pd.DataFrame(res)
    return res

################################################################################
# cubic_vals()
################################################################################

def cubic_vals(id, df):
    """PUT IN DOCSTRING"""

    vals = {'NewID' : id,
            'xVals' : np.asarray(df.UsedTemp[df.NewID == id]),
            'yVals' : np.asarray(df.OriginalTraitValue[df.NewID == id]),
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

    res = {'NewID'  : vals["NewID"],
           'a'      : vals["a"],
           'b'      : vals["b"],
           'c'      : vals["c"],
           'd'      : vals["d"],
           'chisqr' : [np.NaN],  # will test on each try for improvment
           'aic'    : [np.NaN],
           'bic'    : [np.NaN]}

    params = Parameters()
    params.add('a', value = vals["a"])
    params.add('b', value = vals["b"])
    params.add('c', value = vals["c"])
    params.add('d', value = vals["d"])

    out = minimize(cubic_residuals, params, args = (xVals, ldata))

    res = {'NewID'   : [id],
            'a'      : [out.params["a"].value],
            'b'      : [out.params["b"].value],
            'c'      : [out.params["c"].value],
            'd'      : [out.params["d"].value],
            'chisqr' : [out.chisqr],
            'aic'    : [out.aic],
            'bic'    : [out.bic]}

    res = pd.DataFrame(res)

    return res

################################################################################
# arrhenius_vals()
################################################################################

def arrhenius_vals(id, df):
    """PUT IN DOCSTRING"""

    vals = {'NewID'   : id,
            'xVals'   : np.asarray(df.UsedTempK[df.NewID == id]),
            'yVals'   : np.asarray(df.OTVlogged[df.NewID == id]),
            'A0'      : [np.NaN],
            'Ea'      : [np.NaN],
            'deltaCp' : [np.NaN],
            'deltaH'  : [np.NaN],
            'trefs'   : [np.NaN]}

    return vals

################################################################################
# arrhenius_residuals()
################################################################################

def arrhenius_residuals(params, x, data):

    A0      = params['A0'].value
    Ea      = params['Ea'].value
    deltaCp = params['deltaCp'].value
    deltaH  = params['deltaH'].value
    trefs   = params['trefs'].value

    model = np.log(A0) - ((Ea - deltaH*(1 - x/trefs) - deltaCp*(x - trefs - x*np.log(x/trefs)))/(x*k))

    return model - data

################################################################################
# arrhenius_model()
################################################################################

def arrhenius_model(id, df, tries):
    """PUT IN DOCSTRING"""

    vals = arrhenius_vals(id, df)

    xVals    = vals["xVals"]
    ldata    = vals["yVals"]

    res = {'NewID'   : vals["NewID"],
           'A0'      : vals["A0"],
           'Ea'      : vals["Ea"],
           'deltaCp' : vals["deltaCp"],
           'deltaH'  : vals["deltaH"],
           'trefs'   : vals["trefs"],
           'chisqr'  : [np.NaN],
           'aic'     : [np.NaN],  # will test on each try for improvment
           'bic'     : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1

        if trycount > tries:
           break

        try:
            params = Parameters()
            params.add('A0', value = np.random.uniform(0, 10), min = 0)
            params.add('Ea', value = np.random.uniform(0, 10), min = 0)
            params.add('deltaCp',  value = np.random.uniform(-10, 10))
            params.add('deltaH', value = np.random.uniform(-10, 10))
            params.add('trefs', value = np.random.uniform(280, 350), min = 250, max = 400)

            out = minimize(arrhenius_residuals, params, args = (xVals, ldata))

            if out.chisqr < res["aic"] or res["aic"] == [np.NaN]:
                res = {'NewID'   : [id],
                       'A0'      : [out.params["A0"].value],
                       'Ea'      : [out.params["Ea"].value],
                       'deltaCp' : [out.params["deltaCp"].value],
                       'deltaH'  : [out.params["deltaH"].value],
                       'trefs'   : [out.params["trefs"].value],
                       'chisqr'  : [out.chisqr],
                       'aic'     : [out.aic],
                       'bic'     : [out.bic]}
            continue

        except ValueError:
            continue

    res = pd.DataFrame(res)
    return res
