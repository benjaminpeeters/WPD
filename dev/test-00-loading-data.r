
# remove memory and load the package
source("dev/init_dev.r")


formula <- c("100*BP_C/GDP_C",
             "FORT_500",
             "(EXg_R_2023-IMg_R_2023)/1e9",
             "BP_R_2023/(GDP_PPP_PC_MP*1e3)",
             "GDP_PPP_PC_MP/1e3")


data <- wp_data(ISO = c("USA", "CHN", "AZE"),
                formula = formula,
                years = c(1965, 2005))

print(data[data$ISO == "AZE" & data$Variable == formula[5], ])

