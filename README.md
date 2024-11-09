# WPD: World Panel Data

[![R-CMD-check](https://github.com/benjaminpeeters/WPD/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/benjaminpeeters/WPD/actions)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)


## Overview

WPD (World Panel Data) is an R package that simplifies access to and visualization of global panel data from major international organizations. It serves as a bridge between publicly available datasets and researchers, making it easier to work with cross-country panel data.

<!-- Place overview.png here: A visual showing the package's workflow from data sources to visualization -->

### Key Features

- **Unified Data Access**: Load and manipulate data from multiple sources through a single interface
- **Data Harmonization**: Standardized country names and ISO3 codes across all sources
- **Advanced Data Processing**: 
  - Frequency matching (quarterly to yearly or vice versa)
  - Multiple interpolation methods
  - Seasonal adjustments for quarterly data
  - Group aggregation with various methods
  - Automatic data validation and cleaning
- **Publication-Ready Visualizations**:
  - Time series plots with multiple customization options
  - Scatter plots with statistical annotations
  - Bar plots with flexible grouping
  - Support for multi-panel layouts
  - Export in various formats (PNG, PDF)



## Getting Started

Visit our [Documentation Website](https://benjaminpeeters.github.io/WPD/index.html) for comprehensive guides and tutorials. We recommend starting with:

1. [Introduction to Data Loading](https://benjaminpeeters.github.io/WPD/articles/1-introduction-wp_data.html)
2. [Basic Time Series Plotting](https://benjaminpeeters.github.io/WPD/articles/2.1-wp_plot_series_basics.html)
3. [Multi-Variable Plots](https://benjaminpeeters.github.io/WPD/articles/2.2-wp_plot_series_multi.html)
4. [Scatter Plot Features](https://benjaminpeeters.github.io/WPD/articles/4.1-wp_plot_scatter.html)


Click here for [complete function reference](https://benjaminpeeters.github.io/WPD/reference/index.html).


### Installation

```r
# Install from GitHub
devtools::install_github("benjaminpeeters/WPD")
```

### Technical Requirements

- R version ≥ 3.5.0
- Disk space: ~100MB for installation
- Runtime memory: 15-50MB (depending on data loaded)
- Dependencies: ggplot2 (≥3.4.0, <3.5.0), scales, patchwork, zoo, seasonal

### Basic Example

```r
library(WPD)

# Load data for G7 countries
data <- wp_data(
  ISO = "G7",
  formula = c("GDP_C", "CU_C/GDP_C*100"),
  variable = c("GDP", "Current Account"),
  years = c(2000, 2023)
)

# Create a time series plot
wp_plot_series(data, 
               y_axis = c("Billion USD", "% of GDP"),
               right_axis = "Current Account",
               title = "GDP and Current Account in G7 Countries")
```

<!-- Place example1.png here: Output of the above code showing GDP and Current Account for G7 -->

## Available Data

Browse available data using the `wp_info()` function:

```r
# View all available variables
wp_info()

# View only quarterly data
wp_info("Q")

# View only yearly data
wp_info("Y")
```

<!-- Place data_coverage.png here: Visual showing temporal and geographical coverage of different data sources -->

## Advanced Features

### Data Processing

```r
# Complex data manipulation example
data <- wp_data(
  ISO = c("EU", "BRICS"),  # Multiple country groups
  formula = "100*CU_C/GDP_C",  # Custom formula
  years = c(2000, 2023),
  adjust_seasonal = TRUE,  # Apply seasonal adjustment
  aggregate_iso = "Mean",  # Average across countries
  aggregate_period = "CAGR"  # Calculate compound growth
)
```

### Visualization Examples

#### Time Series Plots

```r
# Multi-panel time series with events
events <- data.frame(
  Event = c("Global Financial Crisis", "Covid-19 Pandemic"),
  Date = as.Date(c("2008-09-15", "2020-03-11"))
)

wp_plot_series(data,
               key_dates = events,
               area = TRUE,  # Create area plot
               reference = TRUE)  # Add data sources
```

<!-- Place timeseries.png here: Example of multi-panel time series with event markers -->

#### Scatter Plots

```r
# Scatter plot with regression and grouping
wp_plot_scatter(data,
                color = "Region",
                interpolation = "Spline",
                r_squared = 3,  # Show full equation
                ISO = "Both")  # Show both points and labels
```

<!-- Place scatter.png here: Example scatter plot with regression line and country labels -->




## Citation and Data Attribution

When using WPD, please cite both the package and the original data sources:

```r
# Get package citation
citation("WPD")
```

```
To cite WPD in publications use:

  Peeters, B. (2024). WPD: World Panel Data. R package version 0.0.9.
  https://github.com/benjaminpeeters/WPD

A BibTeX entry for LaTeX users is:

  @Manual{,
    title = {WPD: World Panel Data},
    author = {Benjamin Peeters},
    year = {2024},
    note = {R package version 0.0.9},
    url = {https://github.com/benjaminpeeters/WPD},
  }
```



## Data Sources and References

### International Organizations

1. **World Bank Development Indicators**  
   Comprehensive collection of development indicators.  
   https://data.worldbank.org/indicator

2. **International Monetary Fund**
   - International Financial Statistics (IFS)  
     Global financial and economic indicators.
   - Balance of Payments Statistics  
     International transactions data.

3. **Bank for International Settlements (BIS)**  
   Credit aggregates, property prices, and exchange rates.

4. **OECD Main Economic Indicators**  
   Economic indicators for OECD members and partners.

### Research Databases

5. **Jordà-Schularick-Taylor Macrohistory Database**
   - Jordà, Ò., Schularick, M., & Taylor, A. M. (2017). "Macrofinancial History and the New Business Cycle Facts." *NBER Macroeconomics Annual*, 31(1), 213-263.
   - Jordà, Ò., et al. (2019). "The Rate of Return on Everything, 1870–2015." *The Quarterly Journal of Economics*, 134(3), 1225-1298.
   - Jordà, Ò., et al. (2021). "Bank Capital Redux: Solvency, Liquidity, and Crisis." *Review of Financial Studies*, 34(7), 3062-3107.

6. **KOF Globalisation Index**  
   Gygli, S., Haelg, F., Potrafke, N., & Sturm, J. E. (2019). "The KOF Globalisation Index – Revisited." *Review of International Organizations*, 14(3), 543-574.

7. **Emergency Events Database (EM-DAT)**  
   Centre for Research on the Epidemiology of Disasters (CRED). (2024). EM-DAT: The International Disaster Database.

8. **Sovereign Default Database**  
   Beers, D., Ndukwe, C. I., & Charron, S. (2024). BoC–BoE Sovereign Default Database. Bank of Canada, Bank of England.

9. **Capital Account Openness**  
   Quinn, D., & Toyoda, A. M. (2008). "Does Capital Account Liberalization Lead to Economic Growth?" *Review of Financial Studies*, 21(3), 1403-1449.

10. **Maddison Project Database**  
    Maddison Project Database 2023.

## Licensing

This package is available under a dual-licensing model:

1. **AGPL-3.0 License** (Open Source)
   - Free for open-source projects, academic research, and personal use
   - Full terms in [LICENSE.md](LICENSE.md)

2. **Commercial License**
   - For proprietary/commercial applications
   - Allows closed-source usage
   - Details in [LICENSE_COMM.md](LICENSE_COMM.md)

For commercial licensing inquiries:
- Email: benjaminpeeters@protonmail.com
- Subject: "Commercial License - R Package WPD - [Your Use Case]"

## Development and Contributions

We welcome contributions! Please read our [Contributing Guide](CONTRIBUTING.md)  for details on how to submit pull requests, report issues, and contribute to documentation.

In the future I would like to:

- include additional database such as WID data, work by Aizenman, etc.
- make possible to use ISO2 and full names instead of only ISO3
- make possible to enter only one year
- make wp_get_category able to return previous URSS ISO codes
- create wp_quick which jointly use wp_data and wp_plot_* to produce useful graphs (for example, on balance of payments) 

