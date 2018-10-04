#!/usr/bin/env python3

"""
Author:      David Bridgwood
Description: script containg functions to perform non linear least squared model
             fitting on thermal performance curves"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import pandas as pd
import numpy as np
from scipy import constants
from lmfit import minimize, Parameters, report_fit

# TODO
    # change non-logged functions - Same results but less janky
    # add some reasonable bounds on parameters
    # if i really thought about it its probably possible to nest the Schoolfield
    # models so they only need one function

# *** Full Schoolfield functions are fully commented - the others are pretty
# similar ***

################################################################################
# constants
################################################################################

k = constants.value('Boltzmann constant in eV/K')
e = np.exp(1)

np.random.seed(111)  # set random seed for repeatability
# still get different results on different machines - might be lmfits fault...

################################################################################
# get_TSS()
################################################################################

def get_TSS(data):
    """gets the total sum of squares for given data"""
    return sum((data - np.mean(data))**2)

################################################################################
# schlfld_vals()
################################################################################

def schlfld_vals(id, df):
    """returns in a dictionary x, y and starting values for fitting schoolfield models"""

    vals = {'NewID' : id,
            'xVals' : np.asarray(df.UsedTempK[df.NewID == id]),
            'yVals' : np.asarray(df.OTVlogged[df.NewID == id]),  # logged values
            'B0'    : df.B0[df.NewID == id].iloc[0],
            'E'     : abs(df.E[df.NewID == id].iloc[0]),         # absolute values
            'El'    : abs(df.El[df.NewID == id].iloc[0]),
            'Eh'    : df.Eh[df.NewID == id].iloc[0],
            'Tl'    : df.Tl[df.NewID == id].iloc[0],
            'Th'    : df.Th[df.NewID == id].iloc[0]}

    return vals

################################################################################
# full_schlfld_residuals()
################################################################################

def full_schlfld_residuals(params, x, data):
    """returns residuals of data and model with given parameters for full_schlfld_model"""

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
# full_schlfld_nl_residuals()
################################################################################

def full_schlfld_nl_residuals(params, x, data):
    """returns non logged residuals of data and model with given parameters for full_schlfld_model"""

    B0 = params['B0'].value
    E  = params['E'].value
    El = params['El'].value
    Eh = params['Eh'].value
    Tl = params['Tl'].value
    Th = params['Th'].value

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                   1+(e**((El/k)*((1/Tl)-(1/x))))+(e**((Eh/k)*((1/Th)-(1/x))))))

    # this is equivilent to running through the non-logged model and
    # calculating residuals as model - nonlogged data (in this case the input
    # data is logged hence need for exp)
    return np.exp(model) - np.exp(data)


################################################################################
# full_schlfld_model()
################################################################################

def full_schlfld_model(id, df, min_tries = 5, max_tries = 25, method = 1):
    """performs non linear least square model fitting for given ids TPC on full_schlfld_model

    keyword arguments:
        id         -- specific curve id
        df         -- dataframe containg TPC data and starting values for all ids
        min_tries  -- minium number of tries before stopping for given id
        max_tries  -- maximum number of tries before giving up
        method     -- 1 - stops trying once model converges (after min_tries)
                      2 - continue trying to improve fit upto max_tries"""

    vals = schlfld_vals(id, df)  # get starting values and data from values function

    xVals    = vals["xVals"]     # temperatures
    yVals    = vals["yVals"]     # corresponding trait values

    # res will be output - set initial values as starting values
    res = {'NewID'   : vals["NewID"],
           'B0'      : vals["B0"],
           'E'       : vals["E"],
           'El'      : vals["El"],
           'Eh'      : vals["Eh"],
           'Tl'      : vals["Tl"],
           'Th'      : vals["Th"],
           'chisqr'  : [np.NaN],
           'RSS'     : [np.NaN],
           'TSS'     : [np.NaN],
           'Rsqrd'   : [np.NaN],
           'nlRSS'   : [np.NaN],
           'nlTSS'   : [np.NaN],
           'nlRsqrd' : [np.NaN],
           'nlaic'   : [np.NaN],
           'aic'     : [np.NaN],  # will test on each try for improvment
           'bic'     : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1  # increment trycount

        if method == 1:  # method 1 check if curve has converged or tries have run out
            if (res["aic"] != [np.NaN] and trycount > min_tries) or trycount > max_tries:
                break
        elif method == 2:  # method 2 just check if tries have run out
            if trycount > max_tries:
                break

        try:
            # on first try use calculated starting values
            if trycount == 1:
                params = Parameters()
                params.add('B0', value = vals["B0"], min = 0)
                params.add('E',  value = vals["E"],  min = 0)
                params.add('El', value = vals["El"], min = 0)
                params.add('Eh', value = vals["Eh"], min = 0)
                params.add('Tl', value = vals["Tl"], min = 250, max = 400)
                params.add('Th', value = vals["Th"], min = 250, max = 400)

            # on following tries starting values are randomised between 0 and 2*
            # starting value - appart from temperatures...
            else:
                params = Parameters()
                params.add('B0', value = np.random.uniform(0, vals["B0"]*2), min = 0)
                params.add('E',  value = np.random.uniform(0, vals["E"]*2),  min = 0)
                params.add('El', value = np.random.uniform(0, vals["El"]*2), min = 0)
                params.add('Eh', value = np.random.uniform(0, vals["Eh"]*2), min = 0)
                params.add('Tl', value = vals["Tl"], min = 250, max = 400)
                params.add('Th', value = vals["Th"], min = 250, max = 400)

            # try minimize function to minimize residuals (logged data, logged
            # models)
            out = minimize(full_schlfld_residuals, params, args = (xVals, yVals))

            # calculate Rsquared from logged residuals
            RSS      = sum(full_schlfld_residuals(out.params, xVals, yVals)**2)
            TSS      = get_TSS(yVals)
            Rsquared = 1 - (RSS/TSS)

            # calculate Rsquared and AIC from nonlogged residuals - this
            # definatley works i dont care what Ewan says...
            nl_RSS   = sum(full_schlfld_nl_residuals(out.params, xVals, yVals)**2)
            nl_TSS   = get_TSS(np.exp(yVals))
            nl_Rsqrd = 1 - (nl_RSS/nl_TSS)
            nl_aic   = len(xVals)*np.log(nl_RSS/len(xVals)) + 2*6

            # if aic from this try is lower than previous lowest overwrite res
            # (only relevant for method == 2)
            if out.aic < res["aic"] or res["aic"] == [np.NaN]:
                res = {'NewID'   : [id],
                       'B0'      : [out.params["B0"].value],
                       'E'       : [out.params["E"].value],
                       'El'      : [out.params["El"].value],
                       'Eh'      : [out.params["Eh"].value],
                       'Tl'      : [out.params["Tl"].value],
                       'Th'      : [out.params["Th"].value],
                       'chisqr'  : [out.chisqr],
                       'RSS'     : RSS,
                       'TSS'     : TSS,
                       'Rsqrd'   : Rsquared,
                       'nlRSS'   : nl_RSS,
                       'nlTSS'   : nl_TSS,
                       'nlRsqrd' : nl_Rsqrd,
                       'nlaic'   : nl_aic,
                       'aic'     : [out.aic],
                       'bic'     : [out.bic]}
            continue

        # if it didnt converge go to next try
        except ValueError:
            continue

    # convert res to dataframe (so it can be appended) and output
    res = pd.DataFrame(res)
    return res

################################################################################
# noh_schlfld_residuals()
################################################################################

def noh_schlfld_residuals(params, x, data):
    """returns residuals of data and model with given parameters for schlfld_model without high parameters"""

    B0 = params['B0'].value
    E  = params['E'].value
    El = params['El'].value
    Tl = params['Tl'].value

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                   1+(e**((El/k)*((1/Tl)-(1/x))))))

    return model - data

################################################################################
# noh_schlfld_nl_residuals()
################################################################################

def noh_schlfld_nl_residuals(params, x, data):
    """returns residuals of data and model with given parameters for schlfld_model without high parameters"""

    B0 = params['B0'].value
    E  = params['E'].value
    El = params['El'].value
    Tl = params['Tl'].value

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                   1+(e**((El/k)*((1/Tl)-(1/x))))))

    return np.exp(model) - np.exp(data)

################################################################################
# noh_schlfld_model()
################################################################################

def noh_schlfld_model(id, df, min_tries = 5, max_tries = 25, method = 1):
    """performs non linear least square model fitting for given ids TPC on schlfld_model without high parameters

    keyword arguments:
        id     -- specific curve id
        df     -- dataframe containg TPC data and starting values for all ids
        min_tries  -- minium number of tries before stopping for given id
        max_tries  -- maximum number of tries before giving up
        method     -- 1 - stops trying once model converges (after min_tries)
                      2 - continue trying to improve fit upto max_tries"""

    vals = schlfld_vals(id, df)  # get starting values and data from values function

    xVals    = vals["xVals"]     # temperatures
    yVals    = vals["yVals"]     # corresponding trait values

    # res will be output - set initial values as starting values
    res = {'NewID'   : vals["NewID"],
           'B0'      : vals["B0"],
           'E'       : vals["E"],
           'El'      : vals["El"],
           'Tl'      : vals["Tl"],
           'chisqr'  : [np.NaN],
           'RSS'     : [np.NaN],
           'TSS'     : [np.NaN],
           'Rsqrd'   : [np.NaN],
           'nlRSS'   : [np.NaN],
           'nlTSS'   : [np.NaN],
           'nlRsqrd' : [np.NaN],
           'nlaic'   : [np.NaN],
           'aic'     : [np.NaN],  # will test on each try for improvment
           'bic'     : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1  # increment trycount

        if method == 1:  # method 1 check if curve has converged or tries have run out
            if (res["aic"] != [np.NaN] and trycount > min_tries) or trycount > max_tries:
                break
        elif method == 2:  # method 2 just check if tries have run out
            if trycount > max_tries:
                break

        try:
            # on first try use starting values
            if trycount == 1:
                params = Parameters()
                params.add('B0', value = vals["B0"], min = 0)
                params.add('E',  value = vals["E"],  min= 0)
                params.add('El', value = vals["El"], min = 0)
                params.add('Tl', value = vals["Tl"], min = 250, max = 400)

            # on following tries starting values are randomised
            else:
                params = Parameters()
                params.add('B0', value = np.random.uniform(0, vals["B0"]*2), min = 0)
                params.add('E',  value = np.random.uniform(0, vals["E"]*2), min= 0)
                params.add('El', value = np.random.uniform(0, vals["El"]*2), min = 0)
                params.add('Tl', value = vals["Tl"], min = 250, max = 400)

            # try minimize function to minimize residuals
            out = minimize(noh_schlfld_residuals, params, args = (xVals, yVals))

            RSS      = sum(noh_schlfld_residuals(out.params, xVals, yVals)**2)
            TSS      = get_TSS(yVals),
            Rsquared = 1 - (RSS/TSS)

            nl_RSS   = sum(noh_schlfld_nl_residuals(out.params, xVals, yVals)**2)
            nl_TSS   = get_TSS(np.exp(yVals))
            nl_Rsqrd = 1 - (nl_RSS/nl_TSS)
            nl_aic   = len(xVals)*np.log(nl_RSS/len(xVals)) + 2*4

            # if aic from this try is lower than previous lowest overwrite res
            # (only relevant for method == 2)
            if out.aic < res["aic"] or res["aic"] == [np.NaN]:
                res = {'NewID'   : [id],
                       'B0'      : [out.params["B0"].value],
                       'E'       : [out.params["E"].value],
                       'El'      : [out.params["El"].value],
                       'Tl'      : [out.params["Tl"].value],
                       'chisqr'  : [out.chisqr],
                       'RSS'     : RSS,
                       'TSS'     : TSS,
                       'Rsqrd'   : Rsquared,
                       'nlRSS'   : nl_RSS,
                       'nlTSS'   : nl_TSS,
                       'nlRsqrd' : nl_Rsqrd,
                       'nlaic'   : nl_aic,
                       'aic'     : [out.aic],
                       'bic'     : [out.bic]}
            continue

        # if it didnt converge go to next try/break if tries have run out
        except ValueError:
            continue

    # convert res to dataframe and output
    res = pd.DataFrame(res)
    return res

################################################################################
# nol_schlfld_residuals()
################################################################################

def nol_schlfld_residuals(params, x, data):
    """returns residuals of data and model with given parameters for schlfld_model without low parameters"""

    B0 = params['B0'].value
    E  = params['E'].value
    Eh = params['Eh'].value
    Th = params['Th'].value

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(1+(e**((Eh/k)*((1/Th)-(1/x))))))

    return model - data

################################################################################
# nol_schlfld_nl_residuals()
################################################################################

def nol_schlfld_nl_residuals(params, x, data):
    """returns residuals of data and model with given parameters for schlfld_model without low parameters"""

    B0 = params['B0'].value
    E  = params['E'].value
    Eh = params['Eh'].value
    Th = params['Th'].value

    model = np.log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(1+(e**((Eh/k)*((1/Th)-(1/x))))))

    return np.exp(model) - np.exp(data)

################################################################################
# nol_schlfld_model()
################################################################################

def nol_schlfld_model(id, df, min_tries = 5, max_tries = 25, method = 1):
    """performs non linear least square model fitting for given ids TPC on schlfld_model without low parameters

    keyword arguments:
        id     -- specific curve id
        df     -- dataframe containg TPC data and starting values for all ids
        min_tries  -- minium number of tries before stopping for given id
        max_tries  -- maximum number of tries before giving up
        method     -- 1 - stops trying once model converges (after min_tries)
                      2 - continue trying to improve fit upto max_tries"""

    vals = schlfld_vals(id, df)  # get starting values and data from values function

    xVals    = vals["xVals"]     # temperatures
    yVals    = vals["yVals"]     # corresponding trait values

    # res will be output - set initial values as starting values
    res = {'NewID'   : vals["NewID"],
           'B0'      : vals["B0"],
           'E'       : vals["E"],
           'Eh'      : vals["Eh"],
           'Th'      : vals["Th"],
           'RSS'     : [np.NaN],
           'TSS'     : [np.NaN],
           'Rsqrd'   : [np.NaN],
           'chisqr'  : [np.NaN],
           'nlRSS'   : [np.NaN],
           'nlTSS'   : [np.NaN],
           'nlRsqrd' : [np.NaN],
           'nlaic'   : [np.NaN],
           'aic'     : [np.NaN],  # will test on each try for improvment
           'bic'     : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1  # increment trycount

        if method == 1:  # method 1 check if curve has converged or tries have run out
            if (res["aic"] != [np.NaN] and trycount > min_tries) or trycount > max_tries:
                break
        elif method == 2:  # method 2 just check if tries have run out
            if trycount > max_tries:
                break

        try:
            # on first try use starting values
            if trycount == 1:
                params = Parameters()
                params.add('B0', value = vals["B0"], min = 0)
                params.add('E',  value = vals["E"], min= 0)
                params.add('Eh', value = vals["Eh"], min = 0)
                params.add('Th', value = vals["Th"], min = 250, max = 400)

            # on following tries starting values are randomised
            else:
                params = Parameters()
                params.add('B0', value = np.random.uniform(0, vals["B0"]*2), min = 0)
                params.add('E',  value = np.random.uniform(0, vals["E"]*2), min= 0)
                params.add('Eh', value = np.random.uniform(0, vals["Eh"]*2), min = 0)
                params.add('Th', value = vals["Th"], min = 250, max = 400)

            # try minimize function to minimize residuals
            out = minimize(nol_schlfld_residuals, params, args = (xVals, yVals))

            RSS      = sum(nol_schlfld_residuals(out.params, xVals, yVals)**2)
            TSS      = get_TSS(yVals),
            Rsquared = 1 - (RSS/TSS)

            nl_RSS   = sum(nol_schlfld_nl_residuals(out.params, xVals, yVals)**2)
            nl_TSS   = get_TSS(np.exp(yVals))
            nl_Rsqrd = 1 - (nl_RSS/nl_TSS)
            nl_aic   = len(xVals)*np.log(nl_RSS/len(xVals)) + 2*4

            # if aic from this try is lower than previous lowest overwrite res
            # (only relevant for method == 2)
            if out.aic < res["aic"] or res["aic"]  == [np.NaN]:
                res = {'NewID'   : [id],
                       'B0'      : [out.params["B0"].value],
                       'E'       : [out.params["E"].value],
                       'Eh'      : [out.params["Eh"].value],
                       'Th'      : [out.params["Th"].value],
                       'chisqr'  : [out.chisqr],
                       'RSS'     : RSS,
                       'TSS'     : TSS,
                       'Rsqrd'   : Rsquared,
                       'nlRSS'   : nl_RSS,
                       'nlTSS'   : nl_TSS,
                       'nlRsqrd' : nl_Rsqrd,
                       'nlaic'   : nl_aic,
                       'aic'     : [out.aic],
                       'bic'     : [out.bic]}

            continue

        # if it didnt converge go to next try/break if tries have run out
        except ValueError:
            continue

    # convert res to dataframe and output
    res = pd.DataFrame(res)
    return res

################################################################################
# cubic_vals()
################################################################################

def cubic_vals(id, df):
    """returns in a dictionary x, y and starting values for fitting cubic model"""

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
    """returns residuals of data and model with given parameters for cubic model"""

    a = params['a'].value
    b = params['b'].value
    c = params['c'].value
    d = params['d'].value

    model = a + b*x + c*x**2 + d*x**3

    return model - data

################################################################################
# cubic_model()
################################################################################

# does not have tries as all curves converge on model
def cubic_model(id, df):
    """performs non linear least square model fitting for given ids TPC on cubic model

    keyword arguments:
        id     -- specific curve id
        df     -- dataframe containg TPC data and starting values for all ids"""

    vals = cubic_vals(id, df)  # get starting values and data from values function

    xVals    = vals["xVals"]   # temperatures
    yVals    = vals["yVals"]   # corresponding trait values

    res = {'NewID'  : vals["NewID"],
           'a'      : vals["a"],
           'b'      : vals["b"],
           'c'      : vals["c"],
           'd'      : vals["d"],
           'chisqr' : [np.NaN],
           'RSS'    : [np.NaN],
           'TSS'    : [np.NaN],
           'Rsqrd'  : [np.NaN],
           'nlaic'  : [np.NaN],  # will test on each try for improvment
           'bic'    : [np.NaN]}

    # add parameters
    params = Parameters()
    params.add('a', value = vals["a"])
    params.add('b', value = vals["b"])
    params.add('c', value = vals["c"])
    params.add('d', value = vals["d"])

    # minimize
    out = minimize(cubic_residuals, params, args = (xVals, yVals))

    RSS      = sum(cubic_residuals(out.params, xVals, yVals)**2)
    TSS      = get_TSS(yVals),
    Rsquared = 1 - (RSS/TSS)

    # save output in res convert to dataframe and return
    res = {'NewID'   : [id],
            'a'      : [out.params["a"].value],
            'b'      : [out.params["b"].value],
            'c'      : [out.params["c"].value],
            'd'      : [out.params["d"].value],
            'chisqr' : [out.chisqr],
            'RSS'    : RSS,
            'TSS'    : TSS,
            'Rsqrd'  : Rsquared,
            'nlaic'  : [out.aic],
            'bic'    : [out.bic]}

    res = pd.DataFrame(res)

    return res

################################################################################
# arrhenius_vals()
################################################################################

def arrhenius_vals(id, df):
    """returns in a dictionary x, y and starting values (NAs) for fitting enzyme assisted arrhenius model"""

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
    """returns residuals of data and model with given parameters for enzyme assisted arrhenius model"""

    A0      = params['A0'].value
    Ea      = params['Ea'].value
    deltaCp = params['deltaCp'].value
    deltaH  = params['deltaH'].value
    trefs   = params['trefs'].value

    model = np.log(A0) - ((Ea - deltaH*(1 - x/trefs) - deltaCp*(x - trefs - x*np.log(x/trefs)))/(x*k))

    return model - data

################################################################################
# arrhenius_nl_residuals()
################################################################################

def arrhenius_nl_residuals(params, x, data):
    """returns residuals of data and model with given parameters for enzyme assisted arrhenius model"""

    A0      = params['A0'].value
    Ea      = params['Ea'].value
    deltaCp = params['deltaCp'].value
    deltaH  = params['deltaH'].value
    trefs   = params['trefs'].value

    model = np.log(A0) - ((Ea - deltaH*(1 - x/trefs) - deltaCp*(x - trefs - x*np.log(x/trefs)))/(x*k))

    return np.exp(model) - np.exp(data)

################################################################################
# arrhenius_model()
################################################################################

def arrhenius_model(id, df, min_tries = 5, max_tries = 25, method = 1):
    """performs non linear least square model fitting for given ids TPC on enzyme assisted arrhenius model

    keyword arguments:
        id     -- specific curve id
        df     -- dataframe containg TPC data and starting values for all ids
        min_tries  -- minium number of tries before stopping for given id
        max_tries  -- maximum number of tries before giving up
        method     -- 1 - stops trying once model converges (after min_tries)
                      2 - continue trying to improve fit upto max_tries"""

    vals = arrhenius_vals(id, df)  # get starting values and data from values function

    xVals    = vals["xVals"]     # temperatures
    yVals    = vals["yVals"]     # corresponding trait values

    # res will be output - set initial values as starting values
    res = {'NewID'   : vals["NewID"],
           'A0'      : vals["A0"],
           'Ea'      : vals["Ea"],
           'deltaCp' : vals["deltaCp"],
           'deltaH'  : vals["deltaH"],
           'trefs'   : vals["trefs"],
           'chisqr'  : [np.NaN],
           'RSS'     : [np.NaN],
           'TSS'     : [np.NaN],
           'Rsqrd'   : [np.NaN],
           'nlRSS'   : [np.NaN],
           'nlTSS'   : [np.NaN],
           'nlRsqrd' : [np.NaN],
           'nlaic'   : [np.NaN],
           'aic'     : [np.NaN],  # will test on each try for improvment
           'bic'     : [np.NaN]}

    trycount = 0
    while True:

        trycount += 1  # increment trycount

        if method == 1:  # method 1 check if curve has converged or tries have run out
            if (res["aic"] != [np.NaN] and trycount > min_tries) or trycount > max_tries:
                break
        elif method == 2:  # method 2 just check if tries have run out
            if trycount > max_tries:
                break

        try:  # each try randomises starting values
            params = Parameters()
            params.add('A0', value = np.random.uniform(0, 10), min = 0)
            params.add('Ea', value = np.random.uniform(0, 10), min = 0)
            params.add('deltaCp',  value = np.random.uniform(-10, 10))
            params.add('deltaH', value = np.random.uniform(-10, 10))
            params.add('trefs', value = np.random.uniform(280, 350), min = 250, max = 400)

            # see if it converged
            out = minimize(arrhenius_residuals, params, args = (xVals, yVals))

            RSS      = sum(arrhenius_residuals(out.params, xVals, yVals)**2)
            TSS      = get_TSS(yVals),
            Rsquared = 1 - (RSS/TSS)

            nl_RSS   = sum(arrhenius_nl_residuals(out.params, xVals, yVals)**2)
            nl_TSS   = get_TSS(np.exp(yVals))
            nl_Rsqrd = 1 - (nl_RSS/nl_TSS)
            nl_aic   = len(xVals)*np.log(nl_RSS/len(xVals)) + 2*5

            # if aic from this try is lower than previous lowest overwrite res
            # (only relevant for method == 2)
            if out.aic < res["aic"] or res["aic"] == [np.NaN]:
                res = {'NewID'   : [id],
                       'A0'      : [out.params["A0"].value],
                       'Ea'      : [out.params["Ea"].value],
                       'deltaCp' : [out.params["deltaCp"].value],
                       'deltaH'  : [out.params["deltaH"].value],
                       'trefs'   : [out.params["trefs"].value],
                       'chisqr'  : [out.chisqr],
                       'RSS'     : RSS,
                       'TSS'     : TSS,
                       'Rsqrd'   : Rsquared,
                       'nlRSS'   : nl_RSS,
                       'nlTSS'   : nl_TSS,
                       'nlRsqrd' : nl_Rsqrd,
                       'nlaic'   : nl_aic,
                       'aic'     : [out.aic],
                       'bic'     : [out.bic]}
            continue

        # if it didnt converge go to next try/break if tries have run out
        except ValueError:
            continue

    # convert res to dataframe and return
    res = pd.DataFrame(res)
    return res
