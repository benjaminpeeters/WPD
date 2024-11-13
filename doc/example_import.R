## ----setup, include=FALSE-----------------------------------------------------
library(WPD)
# Load precomputed data
source("data/basic_code.R")
source("data/advanced_code.R")

## ----basic_example_code, eval=FALSE-------------------------------------------
# 
# basic_example <- wp_data(
#   ISO = "USA",
#   formula = "100*CU_C/GDP_C",
#   years = c(2000, 2022)
# )

## ----show_basic_results-------------------------------------------------------
head(basic_code)

## ----basic_plot_code, eval=FALSE----------------------------------------------
# wp_plot_series(basic_example)

## ----advanced_example_code, eval=FALSE----------------------------------------
# 
# advanced_example <- wp_data(
#   ISO = c("CHN", "JPN", "USA", "DEU", "ZAF", "MEX"),
#   formula = c("100*(EXg_C+EXs_C)/GDP_C"),
#   variable = "Exports (% of GDP)",
#   years = c(2010, 2022)
# )

## ----show_advanced_results----------------------------------------------------
head(advanced_code)

## ----advanced_plot_code, eval=FALSE-------------------------------------------
# wp_plot_bar(advanced_example)

