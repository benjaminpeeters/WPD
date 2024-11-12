devtools::load_all()  # Load current development version

# Generate plots
p1 <- wp_plot_series(basic_example, filename = "vignettes/figures/basic_plot")

p2 <- wp_plot_bar(advanced_example, filename = "vignettes/figures/advanced_plot")
