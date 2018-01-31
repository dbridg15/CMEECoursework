require(ggplot2)

test <- read.csv("../Data/GrowthRespPhotoData_new.csv")

pdf("test.pdf")

for(id in levels(test$OriginalID)){
    tmp <- subset(test[,c("OriginalID", "StandardisedTraitName",
                  "StandardisedTraitValue", "StandardisedTraitUnit",
                  "AmbientTemp", "AmbientTempUnit", "ConTemp", "ConTempUnit")],
                  test$OriginalID == id)
    if(nrow(tmp) > 5){
        if(any(is.na(tmp$AmbientTemp)) == FALSE){
            print(
              ggplot(tmp, aes(AmbientTemp, StandardisedTraitValue)) +
                  geom_point() +
                  labs(x = paste0("AmbientTemp (", tmp$AmbientTempUnit[1],")"),
                       y = paste0(tmp$StandardisedTraitName[1], " (",
                                  tmp$StandardisedTraitUnit[1], ")"),
                       title = tmp$OriginalID[1])
            )
        } else if(any(is.na(tmp$ConTemp)) == FALSE){
            print(
              ggplot(tmp, aes(ConTemp, StandardisedTraitValue)) +
                  geom_point() +
                  labs(x = paste0("ConTemp (", tmp$ConTempUnit[1], ")"),
                       y = paste0(tmp$StandardisedTraitName[1], " (",
                                  tmp$StandardisedTraitUnit[1], ")"),
                       title = tmp$OriginalID[1])
                  )
        }
    }
}

dev.off()
