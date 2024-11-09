

# remove memory and load the package
source("dev/init_dev.r")

db <- wp_data(ISO = c("CTR"), formula = c("BP_C/1e9", "GDP_C/1e12", "POP/1e9"), years = c(1980,2010), verbose = TRUE, aggregate_period = "Mean")
print(head(db))

# wp_plot_series(data = db)
wp_plot_scatter(data = db)
