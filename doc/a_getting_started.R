## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5,
  fig.align = 'center'
)

## ----installation, eval=FALSE-------------------------------------------------
# # install.packages("devtools")
# devtools::install_github("benjaminpeeters/WPD")

## ----load---------------------------------------------------------------------
library(WPD)

## ----basic-example------------------------------------------------------------
# Get GDP data for a specific country
data <- wp_data(
  ISO = "USA",
  formula = c("GDP_C", "CU_C/GDP_C*100"),
  variable = c("GDP", "Current Account"),
  years = c(2000, 2023)
)

# Preview the data
head(data)

## ----basic-plot---------------------------------------------------------------
# Create a basic time series plot
wp_plot_series(data, 
               y_axis = c("Billion USD", "% of GDP"),
               right_axis = "Current Account",
               title = "GDP and Current Account of the United States")

## ----fig.cap="", echo=FALSE---------------------------------------------------
knitr::include_graphics("figures/test-01-series-simple-01.png")

## ----available-data-----------------------------------------------------------
# View quarterly data
wp_info("Q")

## ----load-metadata------------------------------------------------------------
# Load metadata for quarterly and yearly data
data(METADATA_Q)
data(METADATA_Y)
# Load ISO3 Codes lists
data(ISO_DATA)

