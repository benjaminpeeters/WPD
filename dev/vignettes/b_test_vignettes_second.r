# Load helper functions and paths
source("dev/vignettes/init.r")

#######################################
# Option

title <- "Introduction to WPD"
print <- TRUE

#######################################
# Create code, data, and plot

# Define example code as strings
basic_code <- '
basic_example <- wp_data(
  ISO = "USA",
  formula = "100*CU_C/GDP_C",
  years = c(2000, 2022)
)'

advanced_code <- '
advanced_example <- wp_data(
  ISO = c("CHN", "JPN", "USA", "DEU", "ZAF", "MEX"),
  formula = c("100*(EXg_C+EXs_C)/GDP_C"),
  variable = "Exports (% of GDP)",
  years = c(2010, 2022)
)'

# Execute the code and save the data
exec_save_code(basic_code, advanced_code)

# Generate plots
basic_plot <- '
wp_plot_series(basic_example, 
               filename = file.path(FIGURES_DIR, "basic_plot"), 
               print = print)
'

advanced_plot <- '
wp_plot_bar(advanced_example, 
            title = "Exports of Goods and Services", 
            subtitle = "Values are expressed in percent of GDP", 
            y_axis = "%",
            color = "Subregion", 
            filename = file.path(FIGURES_DIR, "advanced_plot"), 
            print = print,
            bg = "#CCCCCC")
'

exec_plot(basic_plot, advanced_plot)



#######################################
# Generate the vignette content

# Write YAML header
write_yaml_header(title, data_sources = c("basic_code", "advanced_code"))


# Write basic analysis section
write_md('
## Basic Analysis: Single Country Example

To analyze a country\'s economic indicators, start with a simple example. Here\'s how to calculate the US current account as a percentage of GDP:

```{r basic_example_code, eval=FALSE}
${basic_code}
```

This returns a data frame with the results:

```{r show_basic_results}
head(basic_code)
```

We can visualize this data using `wp_plot_series()`:

```{r basic_plot_code, eval=FALSE}
${basic_plot}
```

![Basic Time Series Plot](figures/basic_plot.png)

## Advanced Analysis: Multiple Countries

For comparative analysis, we can examine multiple countries. Let\'s look at export ratios for China and Japan:

```{r advanced_example_code, eval=FALSE}
${advanced_code}
```

Here\'s the resulting data:

```{r show_advanced_results}
head(advanced_code)
```

We can create a bar plot to compare these values:

```{r advanced_plot_code, eval=FALSE}
${advanced_plot}
```

![Advanced Bar Plot](figures/advanced_plot.png)')

