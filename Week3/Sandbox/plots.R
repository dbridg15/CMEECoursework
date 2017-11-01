rm(list = ls())


###############################################################################
# 9.1 Basic Plotting and Data Explotartion
###############################################################################

MyDF = read.csv('../Data/EcolArchives-E089-51-D1.csv')

dim(MyDF)
head(MyDF)


###############################################################################
# 9.1.3 Scatter Plot
###############################################################################

plot(MyDF$Predator.mass, MyDF$Prey.mass)

# log plot
plot(log(MyDF$Predator.mass),log(MyDF$Prey.mass))

# change marker
plot(log(MyDF$Predator.mass),log(MyDF$Prey.mass), pch = 20)

# and add some lables!
plot(log(MyDF$Predator.mass),log(MyDF$Prey.mass), pch = 20,
     xlab = "Predator Mass (kg)", ylab = "Prey Mass (kg)")


###############################################################################
# 9.1.4 Histograms
###############################################################################

hist(MyDF$Prey.mass)

hist(log(MyDF$Prey.mass),
     xlab = "Predator Mass (kg)", ylab = "Count")

# changing colours
hist(log(MyDF$Prey.mass), xlab = "Predator Mass (kg)", ylab = "Count",
     col = "lightblue", border = "pink")


###############################################################################
# 9.1.5 subplots
###############################################################################

par(mfcol = c(2, 1))  # this initialises the subplots
par(mfg = c(1, 1))  # this specifies which subplot to use first
hist(log(MyDF$Prey.mass), xlab = "Predator Mass (kg)", ylab = "Count",
     col = "lightblue", border = "pink",
     main = "Predator")
par(mfg = c(2, 1))  # second subplot
hist(log(MyDF$Prey.mass), xlab = "PreyPredator Mass (kg)", ylab = "Count",
     col = "lightblue", border = "pink",
     main = "Prey")


###############################################################################
# 9.1.6 overlaying plots
###############################################################################

hist(log(MyDF$Predator.mass),
     xlab = "Body Mass (kg)", ylab = "count",
     col = rgb(1, 0, 0, 0.5),
     main = "Predator-Prey size overlap")
hist(log(MyDF$Prey.mass), col = rgb(0, 0, 1, 0.5), add = T)
legend('topleft', c('Predators', 'Prey'),  # add legend
       fill = c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5)))


###############################################################################
# 9.1.7 boxplots
###############################################################################

boxplot(log(MyDF$Predator.mass))

# by location
boxplot(log(MyDF$Predator.mass) ~ MyDF$Location,
        xlab = "location", ylab = "Predator mass (kg)",
        main = "Predator Mass by location")

# by feeding interaction
boxplot(log(MyDF$Predator.mass) ~ MyDF$Type.of.feeding.interaction,
        xlab = "Feeding interaction", ylab = "Predator mass (kg)",
        main = "Predator Mass by type of feeding interaction")


###############################################################################
# 9.1.8 combining plots
###############################################################################

par(fig = c(0, 0.8, 0, 0.8))  # specify the figure size
plot(log(MyDF$Predator.mass),log(MyDF$Prey.mass), pch = 20,
     xlab = "Predator Mass (kg)", ylab = "Prey Mass (kg)")
par(fig = c(0, 0.8, 0.55, 1), new = T)
boxplot(log(MyDF$Predator.mass), horizontal = T, axes = F)
par(fig = c(0.65, 1, 0, 0.8), new = T)
boxplot(log(MyDF$Prey.mass), axes = F)
mtext("Fancy Predator-Prey scatterplot", side = 3, outer = T, line = -3)


###############################################################################
# 9.1.9 lattice plots
###############################################################################

require('lattice')

densityplot(~log(Predator.mass) | Type.of.feeding.interaction,
            data = MyDF)


###############################################################################
# 9.1.10 saving your graphics
###############################################################################

pdf("Pred_Prey_Overlay.pdf",  # open a blank pdf
    11.7, 8.3)  # these are page dimensions
hist(log(MyDF$Predator.mass),
     xlab = "Body Mass (kg)", ylab = "count",
     col = rgb(1, 0, 0, 0.5),
     main = "Predator-Prey size overlap")
hist(log(MyDF$Prey.mass), col = rgb(0, 0, 1, 0.5), add = T)
legend('topleft', c('Predators', 'Prey'),  # add legend
       fill = c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5)))
dev.off()  # turn off graphics device


###############################################################################
# 9.3.1 basic plotting with ggplot
###############################################################################

require(ggplot2)

# scatter plots
qplot(Prey.mass, Predator.mass, data = MyDF)

# colour by feeding interaction
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      colour = Type.of.feeding.interaction)

# now with shape
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      shape = Type.of.feeding.interaction)

# colours can be a bit funny! (red isn't always red!
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      colour = "Red")

# except when you use I (for Identity)
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      colour = I("Red"))

# same for point size
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
     size = 3)
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      size = I(3))

# shapes have discrete values though
# qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
#      shape = 3)  # will give error!!!
# qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
#       shape = I(3))

# setting transparancy
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
    colour = Type.of.feeding.interaction, alpha = I(0.5))

# Smoothers and regression lines
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
     geom = c("point", "smooth"))

qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
     geom = c("point", "smooth")) + geom_smooth(method = "lm")

qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
     geom = c("point", "smooth"), colour = Type.of.feeding.interaction) +
        geom_smooth(method = "lm")

qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
     geom = c("point", "smooth"), colour = Type.of.feeding.interaction) +
        geom_smooth(method = "lm", fullrange = T)

qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF,
      geom = "jitter")

# Boxplots
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF,
      geom = "boxplot")

# histograms and density plots
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "histogram")

# fill by feeding method
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "histogram",
      fill = Type.of.feeding.interaction)

# defining binwidth
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "histogram",
      fill = Type.of.feeding.interaction, binwidth = 1)

# changed to density
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "density",
      fill = Type.of.feeding.interaction, alpha = I(0.5))

# changed to density colour instead of fill!
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "density",
      colour = Type.of.feeding.interaction, alpha = I(0.5))


###############################################################################
# Multi-faceted plots
###############################################################################

qplot(log(Prey.mass/Predator.mass),
      facets = Type.of.feeding.interaction ~.,
      data = MyDF, geom = 'density')

qplot(log(Prey.mass/Predator.mass),
      facets = .~ Type.of.feeding.interaction,
      data = MyDF, geom = 'density')

qplot(log(Prey.mass/Predator.mass),
      facets = .~ Type.of.feeding.interaction + Location,
      data = MyDF, geom = 'density')

qplot(log(Prey.mass/Predator.mass),
      facets = .~ Location + Type.of.feeding.interaction,
      data = MyDF, geom = 'density')

# Log plots

qplot(Prey.mass, Predator.mass, data = MyDF, log = 'xy')

# Adding labels

qplot(Prey.mass, Predator.mass, data = MyDF, log = 'xy',
      main = 'Relation between predator and prey mass',
      xlab = 'log(Prey masjhkjsdgkasfgsldjvhs) (g)',
      ylab = 'log(predator mass) (g)')

qplot(Prey.mass, Predator.mass, data = MyDF, log = 'xy',
      main = 'Relation between predator and prey mass',
      xlab = 'log(Prey mass) (g)',
      ylab = 'log(predator mass) (g)') + theme_classic()

# printing to pdf

pdf('MyFirst-ggplot2-Figure.pdf')
print(qplot(Prey.mass, Predator.mass, data = MyDF, log = 'xy',
            main = 'Relation between predator and prey mass',
            xlab = 'log(Prey mass) (g)',
            ylab = 'log(predator mass) (g)'))
dev.off()


###############################################################################
# 9.3.3  geom!
###############################################################################

qplot(Predator.lifestage, data = MyDF, geom = 'bar')


qplot(Predator.lifestage, log(Prey.mass),  data = MyDF, geom = 'boxplot')


qplot(log(Predator.mass),  data = MyDF, geom = 'density')


qplot(log(Predator.mass),  data = MyDF, geom = 'histogram')


qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = 'point')


qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = 'smooth')


qplot(log(Predator.mass), log(Prey.mass), data = MyDF,
      geom = 'smooth', method = 'lm')


###############################################################################
# 9.3.4  Advanced plotting!
###############################################################################


p  <- ggplot(MyDF, aes(x = log(Predator.mass),
                       y = log(Prey.mass),
            colour = Type.of.feeding.interaction))

p + geom_point()


p <- ggplot(MyDF, aes(x = log(Predator.mass),
                      y = log(Prey.mass),
                      colour = Type.of.feeding.interaction))

q <- p + geom_point(size = I(2), shape = I(10)) + theme_classic()

q

q + theme(legend.position = 'none')


###############################################################################
# 9.3.5 case study: plotting a matrix
###############################################################################

require(reshape2)

GenerateMatrix <- function(N){
    M <- matrix(runif(N * N), N, N)
    return(M)
}

M <- GenerateMatrix(10)

M[1:3, 1:3]

Melt <- melt(M)

Melt[1:4,]

ggplot(Melt,aes(Var1, Var2, fill = value)) + geom_tile()

p <- ggplot(Melt,aes(Var1, Var2, fill = value)) + geom_tile()
q <- p + geom_tile(colour = 'black')
q <- p + theme(legend.position = 'none')

q <- p + theme(legend.position = 'none',
               panel.background = element_blank(),
               axis.ticks = element_blank(),
               panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(),
               axis.text.x = element_blank(),
               axis.title.x = element_blank(),
               axis.text.y = element_blank(),
               axis.title.y = element_blank())

q + scale_fill_countinuous(low = 'yellow',
                           high = 'darkgreen')


q + scale_fill_gradientn(colours = grey.colors(10))

q + scale_fill_gradientn(colours = rainbow(10))


q + scale_fill_gradientn(colours =
                         c('red', 'white', 'blue'))


###############################################################################
# 9.3.6 case study: plotting two dataframes
###############################################################################


build_eclipse <- function(hradius, vradius){
    npoints = 250
    a  <- seq(0, 2 * pi, length = npoints + 1)
    x <- hradius * cos(a)
    y <- vradius * sin(a)
    return(data.frame(x = x, y = y))
}


N <- 250

M <- matrix(rnorm(N * N), N, N)

eigvals <- eigen(M)$values

eigDF <- data.frame('Real' = Re(eigvals),
                    'Imaginary' = Im(eigvals))

my_radius = sqrt(N)

ellDF <- build_eclipse(my_radius, my_radius)

names(ellDF) <- c('Real', 'Imaginary')


p <- ggplot(eigDF, aes(x = Real, y = Imaginary))

p <- p +
    geom_point(shape = I(3)) +
    theme(legend.position = 'none')
p
p <- p + geom_hline(aes(yintercept = 0))
p <- p + geom_vline(aes(xintercept = 0))


p <- p + geom_polygon(data = ellDF,
                      aes(x = Real,
                          y = Imaginary,
                          alpha = 1/20,
                          fill = 'red'))

pdf('Girko.pdf')
print(p)
dev.off()


###############################################################################
# Case Study 3: Annotating plots
###############################################################################

a <- read.table('../Data/Results.txt', header = T)

print(a[1:3,])
print(a[90:95,])

a$ymin <- rep(0, dim(a)[1])

p <- ggplot(a)
p <- p + geom_linerange(data = a, aes(x = x,
                                      ymin = ymin,
                                      ymax = y1,
                                      size = (0.5)
                                      ),
                        colour = '#E69F00',
                        alpha = 1/2, show.legend = FALSE)


p <- p + geom_linerange(data = a, aes(x = x,
                                      ymin = ymin,
                                      ymax = y2,
                                      size = (0.5),
                                      ),
                        colour = '#56B4E9',
                        alpha = 1/2, show.legend = F)

p <- p + geom_text(data = , aes(x = x, y = -500, label = Label))

p <- p + scale_x_continuous("My x axis",
                            breaks = seq(3, 5, by = 0.5)
                            ) +
         scale_y_continuous("My y axis") + theme_classic() +
         theme(legend.position = "none")



p


