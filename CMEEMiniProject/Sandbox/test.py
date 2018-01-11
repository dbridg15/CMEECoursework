import pandas as pd
import matplotlib.pyplot as plt
import scipy as sc

data= pd.read_csv("../Data/GrowthRespPhotoData_new.csv", low_memory = False)

sub = data[["OriginalID", "StandardisedTraitName",
           "StandardisedTraitValue", "StandardisedTraitUnit",
           "AmbientTemp", "AmbientTempUnit", "ConTemp", "ConTempUnit",
            "ResTemp", "ResTempUnit"]]


for i in data["OriginalID"].unique():

    tmp = sub[sub["OriginalID"] == i]
    filename = i + ".pdf"

    if tmp.shape[0] > 5:
        y = tmp["StandardisedTraitValue"]
        ytitle = (tmp["StandardisedTraitName"].iloc[0] + " (" +
                  tmp["StandardisedTraitUnit"].iloc[0] + ")")

        if tmp["AmbientTemp"].isnull().any() == False:
            x = tmp["AmbientTemp"]
            xtitle = "AmbientTemp (" + tmp["AmbientTempUnit"].iloc[0] + ")"
        elif tmp["ConTemp"].isnull().any() == False:
            x = tmp["ConTemp"]
            xtitle = "ConTemp (" + tmp["ConTempUnit"].iloc[0] + ")"
        elif tmp["ResTemp"].isnull().any() == False:
            x = tmp["ResTemp"]
            xtitle = "ResTemp (" + tmp["ResTempUnit"].iloc[0] + ")"

        plt.plot(x, y, 'ro')
        plt.xlabel(xtitle)
        plt.ylabel(ytitle)
        plt.title(i)
        # plt.show()
        # plt.savefig(filename)
