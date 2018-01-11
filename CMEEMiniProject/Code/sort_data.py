import pandas as pd

data = pd.read_csv("../Data/GrowthRespPhotoData_new.csv", low_memory = False)

# get rid of ids with < 5 data points
data2 = data.groupby("OriginalID").filter(lambda x: len(x) > 5)

# set NewID based on OriginalID **do i even need to do this?**
data2["NewID"] = data2.OriginalID.astype("category").cat.codes

# only columns i need
data3 = data2.loc[ : ,("OriginalID",
                       "NewID",
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
                       "ResTempUnit")]

# getting list of indexes for trait values less then 0. Not sure what to do with
# them though...
a = data2.index[data2["StandardisedTraitValue"] < 0].tolist()
data2.StandardisedTraitValue.loc[a]


# save the new df
data2.to_csv("test.csv")
