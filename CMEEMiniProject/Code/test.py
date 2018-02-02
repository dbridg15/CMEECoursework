from miniproject import *

GRDF = pd.read_csv("../Results/Sorted_data.csv")

cubicDF = pd.DataFrame(data = None, columns = ('id', 'a', 'b', 'c', 'd',
                                                 'chisqr', 'aic', 'bic'))

full_schDF = pd.DataFrame(data = None, columns = ('id', 'B0', 'E', 'Eh', 'El',
                                            'Tl', 'Th', 'chisqr', 'aic', 'bic'))

noh_schDF = pd.DataFrame(data = None, columns = ('id', 'B0', 'E', 'El', 'Tl',
                                                 'chisqr', 'aic', 'bic'))

nol_schDF = pd.DataFrame(data = None, columns = ('id', 'B0', 'E', 'Eh',
                                                 'Th', 'chisqr', 'aic', 'bic'))



for id in GRDF["NewID"].unique():

    cubicDF    = cubicDF.append(cubic_model(id, GRDF))
    full_schDF = full_schDF.append(full_schlfld_model(id, GRDF))
    noh_schDF  = noh_schDF.append(noh_schlfld_model(id,GRDF))
    nol_schDF  = nol_schDF.append(nol_schlfld_model(id,GRDF))

cubicDF.to_csv("../Results/cubic_model.csv")
full_schDF.to_csv("../Results/full_scholfield_model.csv")
noh_schDF.to_csv("../Results/noh_scholfield_model.csv")
nol_schDF.to_csv("../Results/nol_scholfield_model.csv")
