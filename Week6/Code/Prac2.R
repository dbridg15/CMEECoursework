require(dplyr)
require(ggplot2)
require(reshape2)

g <- read.table("../Data/H938_chr15.geno", header = T)

head(g)
dim(g)

g <- mutate(g, nObs = nA1A1 + nA1A2 + nA2A2)

summary(g$nObs)

qplot(g$nObs, data = g)

# compute genotype frequencies

g <- mutate(g, p11 = nA1A1/nObs, p12 = nA1A2/nObs, p22 = nA2A2/nObs)

# compute allele frequencies from genotype frequencies

g <- mutate(g, p1 = p11 + 0.5*p12, p2 = p22 + 0.5*p12)

head(g)

qplot(p1, p2, data = g)

gTidy <- select(g, c(p1, p11, p12, p22)) %>%
        melt(id = 'p1', value.name = "Genotype.Proportion")

head(gTidy)
dim(gTidy)

ggplot(gTidy) + geom_point(aes(x = p1, y = Genotype.Proportion,
                               color = variable,
                               shape = variable)) +
    stat_function(fun = function(p) p^2, geom = "line", color = "red",
                  size = 2.5) +
    stat_function(fun = function(p) (1-p)^2, geom = "line", color = "blue",
                  size = 2.5) +
    stat_function(fun = function(p) 2*p*(1-p), geom = "line", colour = "green",
                  size = 2.5)


g <- mutate(g, X2 = (nA1A1 - nObs*p1^2)^2 /(nObs*p1^2) +
            (nA1A2 - nObs*2*p1*p2)^2 / (nObs*2*p1*p2) +
            (nA2A2 - nObs*p2^2)^2 / (nObs*p2^2))

g <- mutate(g, pval = 1-pchisq(X2,1))

sum(g$pval < 0.05, na.rm = T)

qplot(pval, data = g)

qplot(2*p1*(1-p1), p12, data = g) +
    geom_abline(intercept = 0, slope = 1, color = "red", size = 1.5)


###############################################################################

pDefHet <- mean((2*g$p1*(1-g$p1)-g$p12)/(2*g$p1*(1-g$p1)))
pDefHet

g <- mutate(g, F = (2*p1*(1-p1)-p12) / (2*p1*(1-p1)))

plot(g$F, xlab = "SNP number")


movingavg <- function(x, n=5){
    stats::filter(x, rep(1/n, n), sides = 2)
}

plot(movingavg(g$F), xlab = "SNP Number")


outlier <- which(movingavg(g$F) == max(movingavg(g$F), na.rm = T))

g[outlier,]


