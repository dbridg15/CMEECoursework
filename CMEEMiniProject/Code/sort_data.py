import pandas as pd

data = pd.read_csv("../Data/GrowthRespPhotoData_new.csv", low_memory = False)


# get rid of 0s -ves and NAs from data (only +ves)
data2 = data.iloc[data.index[data["StandardisedTraitValue"] > 0]]


# get rid of ids with < 5 data points
data2 = data2.groupby("FinalID").filter(lambda x: len(x) > 5)

# set NewID based on OriginalID **do i even need to do this?**
#data2["NewID"] = data2.OriginalID.astype("category").cat.codes

# only columns i need
data2 = data2.loc[ : ,("FinalID",
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


# save the new df
data2.to_csv("test.csv")
