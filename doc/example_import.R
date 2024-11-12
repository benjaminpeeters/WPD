## ----vignette_setup, include=FALSE--------------------------------------------
library(WPD)
# Load precomputed data
source("data/basic_example.R")
source("data/advanced_example.R")

## ----basic_example_code, eval=FALSE-------------------------------------------
# basic_example <- wp_data(
#   ISO = "USA",
#   formula = "100*CU_C/GDP_C",
#   years = c(2000, 2002)
# )

## ----show_basic_results-------------------------------------------------------
head(basic_example)

## ----basic_plot_code, eval=FALSE----------------------------------------------
# wp_plot_series(basic_example)

## ----advanced_example_code, eval=FALSE----------------------------------------
# advanced_example <- wp_data(
#   ISO = c("CHN", "JPN"),
#   formula = c("EXg_C/GDP_C"),
#   years = c(2010, 2012)
# )

## ----show_advanced_results----------------------------------------------------
head(advanced_example)

## ----advanced_plot_code, eval=FALSE-------------------------------------------
# wp_plot_bar(advanced_example)

