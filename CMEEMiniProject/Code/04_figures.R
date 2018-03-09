#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# imports
source("plotfuncs.R")

###############################################################################
# Read in data
###############################################################################

GRDF    <- read.csv("../Results/sorted_data.csv")
flschDF <- read.csv("../Results/full_scholfield_model.csv")
nhschDF <- read.csv("../Results/noh_scholfield_model.csv")
nlschDF <- read.csv("../Results/nol_scholfield_model.csv")
cubicDF <- read.csv("../Results/cubic_model.csv")
arrhnDF <- read.csv("../Results/arrhenius_model.csv")

aicdf   <- data.frame("NewID" = cubicDF$NewID,
                      "cubic" = cubicDF$nlaic,
                      "flsch" = flschDF$nlaic,
                      "nhsch" = nhschDF$nlaic,
                      "nlsch" = nlschDF$nlaic,
                      "arrhn" = arrhnDF$nlaic)

###############################################################################
# General Stats
###############################################################################

# how many IDs after data was sorted
length(unique(GRDF$NewID))

# average number of points
mean(as.numeric(unlist(aggregate(cbind(count = NewID) ~ NewID, data = GRDF,
                                 FUN = function(x){NROW(x)})["count"])))

# How many didnt converge
length(unique(GRDF$NewID)) - sum(is.na(cubicDF$nlaic)  == FALSE)
length(unique(GRDF$NewID)) - sum(is.na(flschDF$nlaic)  == FALSE)
length(unique(GRDF$NewID)) - sum(is.na(nhschDF$nlaic)  == FALSE)
length(unique(GRDF$NewID)) - sum(is.na(nlschDF$nlaic)  == FALSE)
length(unique(GRDF$NewID)) - sum(is.na(arrhnDF$nlaic)  == FALSE)

# look at those which didn't converge
flschDF[is.na(flschDF$nlaic), ]
nhschDF[is.na(nhschDF$nlaic), ]
nlschDF[is.na(nlschDF$nlaic), ]


###############################################################################
# Table 1,
###############################################################################

mdls1 <- c("cubic", "flsch", "nhsch", "nlsch", "arrhn")  # all models
a <- compare(mdls1, "aicDF")

cubic_col <- c(sum(a$cubic_delta <= 2, na.rm = TRUE),
               sum(a$cubic_delta > 2 & a$cubic_delta <= 4, na.rm = TRUE),
               sum(a$cubic_delta > 4 & a$cubic_delta <= 7, na.rm = TRUE),
               sum(a$cubic_delta > 7 & a$cubic_delta <= 10, na.rm = TRUE),
               sum(a$cubic_delta > 10, na.rm = TRUE))

flsch_col <- c(sum(a$flsch_delta <= 2, na.rm = TRUE),
               sum(a$flsch_delta > 2 & a$flsch_delta <= 4, na.rm = TRUE),
               sum(a$flsch_delta > 4 & a$flsch_delta <= 7, na.rm = TRUE),
               sum(a$flsch_delta > 7 & a$flsch_delta <= 10, na.rm = TRUE),
               sum(a$flsch_delta > 10, na.rm = TRUE))

nhsch_col <- c(sum(a$nhsch_delta <= 2, na.rm = TRUE),
               sum(a$nhsch_delta > 2 & a$nhsch_delta <= 4, na.rm = TRUE),
               sum(a$nhsch_delta > 4 & a$nhsch_delta <= 7, na.rm = TRUE),
               sum(a$nhsch_delta > 7 & a$nhsch_delta <= 10, na.rm = TRUE),
               sum(a$nhsch_delta > 10, na.rm = TRUE))

nlsch_col <- c(sum(a$nlsch_delta <= 2, na.rm = TRUE),
               sum(a$nlsch_delta > 2 & a$nlsch_delta <= 4, na.rm = TRUE),
               sum(a$nlsch_delta > 4 & a$nlsch_delta <= 7, na.rm = TRUE),
               sum(a$nlsch_delta > 7 & a$nlsch_delta <= 10, na.rm = TRUE),
               sum(a$nlsch_delta > 10, na.rm = TRUE))

arrhn_col <- c(sum(a$arrhn_delta <= 2, na.rm = TRUE),
               sum(a$arrhn_delta > 2 & a$arrhn_delta <= 4, na.rm = TRUE),
               sum(a$arrhn_delta > 4 & a$arrhn_delta <= 7, na.rm = TRUE),
               sum(a$arrhn_delta > 7 & a$arrhn_delta <= 10, na.rm = TRUE),
               sum(a$arrhn_delta > 10, na.rm = TRUE))

tbl1 <- rbind(cubic_col, flsch_col, nhsch_col, nlsch_col, arrhn_col)
rownames(tbl1) <- c("Cubic", "Full Schoolfield", "No High Schoolfield",
                    "No Low Schoolfield", "EAAR")

print(tbl1)


###############################################################################
# Table 2,
###############################################################################

mdls2 <- c("flsch", "nhsch", "nlsch", "arrhn")  # all models
b <- compare(mdls2, "aicDF")

flsch_col <- c(sum(b$flsch_delta <= 2, na.rm = TRUE),
               sum(b$flsch_delta > 2 & a$flsch_delta <= 4, na.rm = TRUE),
               sum(b$flsch_delta > 4 & a$flsch_delta <= 7, na.rm = TRUE),
               sum(b$flsch_delta > 7 & a$flsch_delta <= 10, na.rm = TRUE),
               sum(b$flsch_delta > 10, na.rm = TRUE))

nhsch_col <- c(sum(b$nhsch_delta <= 2, na.rm = TRUE),
               sum(b$nhsch_delta > 2 & a$nhsch_delta <= 4, na.rm = TRUE),
               sum(b$nhsch_delta > 4 & a$nhsch_delta <= 7, na.rm = TRUE),
               sum(b$nhsch_delta > 7 & a$nhsch_delta <= 10, na.rm = TRUE),
               sum(b$nhsch_delta > 10, na.rm = TRUE))

nlsch_col <- c(sum(b$nlsch_delta <= 2, na.rm = TRUE),
               sum(b$nlsch_delta > 2 & a$nlsch_delta <= 4, na.rm = TRUE),
               sum(b$nlsch_delta > 4 & a$nlsch_delta <= 7, na.rm = TRUE),
               sum(b$nlsch_delta > 7 & a$nlsch_delta <= 10, na.rm = TRUE),
               sum(b$nlsch_delta > 10, na.rm = TRUE))

arrhn_col <- c(sum(b$arrhn_delta <= 2, na.rm = TRUE),
               sum(b$arrhn_delta > 2 & a$arrhn_delta <= 4, na.rm = TRUE),
               sum(b$arrhn_delta > 4 & a$arrhn_delta <= 7, na.rm = TRUE),
               sum(b$arrhn_delta > 7 & a$arrhn_delta <= 10, na.rm = TRUE),
               sum(b$arrhn_delta > 10, na.rm = TRUE))

tbl2 <- rbind(flsch_col, nhsch_col, nlsch_col, arrhn_col)
rownames(tbl2) <- c("Full Schoolfield", "No High Schoolfield",
                    "No Low Schoolfield", "EAAR")

print(tbl2)

###############################################################################
# Figure 1.
###############################################################################


###############################################################################
# Figure 2.
###############################################################################

id <- 1623

pdf("../Results/figure2.pdf", width = 8, height = 4)
KT_plt(id, GRDF)
dev.off()

# what is this id? ############################################################

# OriginalTraitName
as.character(GRDF[GRDF$NewID == id, "OriginalTraitName"][1])

# Genus Species
paste(as.character(GRDF[GRDF$NewID == id, "ConGenus"][1]),
      as.character(GRDF[GRDF$NewID == id, "ConSpecies"][1]))

# Citation
as.character(GRDF[GRDF$NewID == id, "Citation"][1])

###############################################################################
# Figure 3.
###############################################################################

id <- 1832

pdf("../Results/figure3.pdf", width = 8, height = 4)
models_plt(id, GRDF, flschDF, nhschDF, nlschDF, cubicDF, arrhnDF)
dev.off()

# what is this id? ############################################################

# OriginalTraitName
as.character(GRDF[GRDF$NewID == id, "OriginalTraitName"][1])

# Genus Species
paste(as.character(GRDF[GRDF$NewID == id, "ConGenus"][1]),
      as.character(GRDF[GRDF$NewID == id, "ConSpecies"][1]))

# Citation
as.character(GRDF[GRDF$NewID == id, "Citation"][1])

colnames(cubicDF)[4] <- "nlRsqrd"

# plot table...
a <- rbind(cubicDF[cubicDF$NewID == id, c("nlRsqrd", "nlaic")],
           flschDF[flschDF$NewID == id, c("nlRsqrd", "nlaic")],
           nhschDF[nhschDF$NewID == id, c("nlRsqrd", "nlaic")],
           nlschDF[nlschDF$NewID == id, c("nlRsqrd", "nlaic")],
           arrhnDF[arrhnDF$NewID == id, c("nlRsqrd", "nlaic")])

a$Model <- c("Cubic", "Full Schoolfield", "No High Schoolfield", "No Low Schoolfield", "EAAR")


# means!

mean(cubicDF$nlRsqrd, na.rm = T)
mean(flschDF$nlRsqrd, na.rm = T)
mean(nhschDF$nlRsqrd, na.rm = T)
mean(nlschDF$nlRsqrd, na.rm = T)
mean(arrhnDF$nlRsqrd[arrhnDF$nlRsqrd > -100] , na.rm = T)

###############################################################################
# Figure 4.
###############################################################################

mdls1 <- c("cubic", "flsch", "nhsch", "nlsch", "arrhn")  # all models
mdls2 <- c("flsch", "nhsch", "nlsch", "arrhn")           # only mechanistic

plt1 <- compare(mdls1, "plt")
plt1 <- plt1 + ylab("Akaike Weight") + xlab("Model")
plt1 <- plt1 + scale_x_discrete(labels=c("Cubic",
                                         "Full\nSchoolfield",
                                         "No High\nSchoolfield",
                                         "No Low\nSchoolfield",
                                         "EAAR"))

plt2 <- compare(mdls2, "plt")
plt2 <- plt2 + ylab("Akaike Weight") + xlab("Model")
plt2 <- plt2 + scale_x_discrete(labels=c("Full\nSchoolfield",
                                         "No High\nSchoolfield",
                                         "No Low\nSchoolfield",
                                         "EAAR"))

pdf("../Results/figure4.pdf", width = 10, height = 5)
grid.arrange(plt1, plt2, nrow = 1)
dev.off()
