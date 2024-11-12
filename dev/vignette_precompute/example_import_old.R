## ----setup, include=FALSE-----------------------------------------------------
library(WPD)
# Load precomputed data
source(system.file("data/basic_example.R", package = "WPD"))
source(system.file("data/advanced_example.R", package = "WPD"))


## ----eval=FALSE---------------------------------------------------------------
# basic_example <- wp_data(
#   ISO = "USA",
#   formula = "100*CU_C/GDP_C",
#   years = c(2000, 2002)
# )


## -----------------------------------------------------------------------------
head(basic_example)


## ----eval=FALSE---------------------------------------------------------------
# wp_plot_series(basic_example)


## ----eval=FALSE---------------------------------------------------------------
# advanced_example <- wp_data(
#   ISO = c("CHN", "JPN"),
#   formula = c("EXg_C/GDP_C"),
#   years = c(2010, 2012)
# )


## -----------------------------------------------------------------------------
head(advanced_example)


## ----eval=FALSE---------------------------------------------------------------
# wp_plot_bar(advanced_example)

