

# remove memory and load the package
source("dev/init_dev.r")



# Multiple countries with one indicator
in_print_debug("Test 1 - Multiple countries with one indicator", type = "wrapper")

formula <- c("100*CU_C/GDP_C")


data <- wp_data(ISO = c("CTR_LDR"),
                formula = formula,
                years = c(1965, 2030),
                adjust_seasonal = TRUE,
                window_seasadj = 11)

wp_plot_series(data = data,
               y_axis = "% of GDP",
               title = "Current Account of Center Leader Countries",
               subtitle = "Quarterly data, seasonally adjusted - Period: 1965-2024.",
               filename = "dev/img/test-01-series-simple-01")


# One country with multiple indicators
in_print_debug("Test 2 - One country with multiple indicators", type = "wrapper")

formula <- c("100*CU_C/GDP_C", 
             "100*(IMg_C+IMs_C)/GDP_C",
             "100*(EXg_C+EXs_C)/GDP_C")

variable <- c("Current Account",
              "Imports (Goods and services)",
              "Exports (Goods and services)")

data <- wp_data(ISO = c("CHN"),
                formula = formula,
                variable = variable,
                years = c(2005, 2024),
                adjust_seasonal = TRUE)

wp_plot_series(data = data,
               y_axis = "% of GDP",
               title = "Chinese Current Account",
               reference = FALSE,
               filename = "dev/img/test-01-series-simple-02")



