require(dplyr)
attach(iris)
dplyr::tbl_df(iris)  # like head() but nicer
dplyr::glimpse(iris)  # like str() but nicer
utils::View(iris)  # same as fix
dplyr::filter(iris, Sepal.Length > 7)
dplyr::slice(iris, 10:15)


