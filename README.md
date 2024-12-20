
# WPD: World Panel Data

[![R-CMD-check](https://github.com/benjaminpeeters/WPD/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/benjaminpeeters/WPD/actions)
[![Website](https://img.shields.io/badge/website-WPD-blue)](https://benjaminpeeters.github.io/WPD/)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#maturing)
[![License: AGPL
v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

## Overview

WPD (World Panel Data) is an R package that simplifies access to and
visualization of global economic and social panel data from major
international organizations and academic researchers. It aims to serve
as a bridge between publicly available datasets and researchers,
students, and the general public, making cross-country panel data easier
to work with.

The package includes a large database (approximately 50MB) of world
panel data that is loaded on demand through the ‘wp\_data’ function.
Features include customizable time series plots, cross-sectional
analysis tools, scatter plots with trend analysis, bar charts for
comparative analysis, built-in seasonal adjustment capabilities, and
support for both annual and quarterly frequencies. The package focuses
on macroeconomic indicators such as GDP, trade, prices, employment, and
financial and balance-of-payments data across multiple countries and
regions.

<!-- Place overview.png here: A visual showing the package's workflow from data sources to visualization -->

### Key Features

  - **Unified Data Access**: Load and manipulate data from multiple
    sources through a single interface
  - **Data Harmonization**: Standardized country names and ISO3 codes
    across all sources
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

<!-- Dynamic content: Documentation links -->

## Getting Started

Visit our [Documentation
Website](https://benjaminpeeters.github.io/WPD/index.html) for
comprehensive guides and tutorials. We recommend starting with:

1.  [R Basics: Getting Ready for
    WPD](https://benjaminpeeters.github.io/WPD/articles/a_introduction_to_r.html)
2.  [Introduction to
    WPD](https://benjaminpeeters.github.io/WPD/articles/b_example_import.html)
3.  [Loading data with
    `wp_data()`](https://benjaminpeeters.github.io/WPD/articles/b_loading_data_with_wp_data.html)
4.  [Introduction](https://benjaminpeeters.github.io/WPD/articles/b_test_vignettes_second.html)
5.  [Getting
    Started](https://benjaminpeeters.github.io/WPD/articles/c_getting_started.html)

Click here for [complete function
reference](https://benjaminpeeters.github.io/WPD/reference/index.html).

### Installation

``` r
# Install from GitHub
devtools::install_github("benjaminpeeters/WPD")
```

### Technical Requirements

  - R version ≥ 3.5.0
  - Disk space: \~100MB for installation
  - Runtime memory: 15-50MB (depending on data loaded)
  - Dependencies: ggplot2 (≥3.4.0, \<3.5.0), scales, patchwork, zoo,
    seasonal

### Basic Example

``` r
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

``` r
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

``` r
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

``` r
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

``` r
# Scatter plot with regression and grouping
wp_plot_scatter(data,
                color = "Region",
                interpolation = "Spline",
                r_squared = 3,  # Show full equation
                ISO = "Both")  # Show both points and labels
```

<!-- Place scatter.png here: Example scatter plot with regression line and country labels -->

<!-- Dynamic content: Citation -->

## Citation and Data Attribution

When using WPD, please cite both the package and the original data
sources:

``` r
# Generate citation dynamically
citation("WPD")
```

``` 

To cite package 'WPD' in publications use:

  Benjamin Peeters (2024). WPD: World Panel Data: A Macroeconomic Data Visualization and Analysis Toolkit. R package version 0.0.45.
  https://benjaminpeeters.github.io/WPD/

A BibTeX entry for LaTeX users is

  @Manual{,
    title = {WPD: World Panel Data: A Macroeconomic Data Visualization and Analysis Toolkit},
    author = {Benjamin Peeters},
    year = {2024},
    note = {R package version 0.0.45},
    url = {https://benjaminpeeters.github.io/WPD/},
  }
```

## Data Sources and References

### International Organizations

1.  **World Bank Development Indicators**  
    Comprehensive collection of development indicators.  
    <https://data.worldbank.org/indicator>

2.  **International Monetary Fund**
    
      - International Financial Statistics (IFS)  
        Global financial and economic indicators.
      - Balance of Payments Statistics  
        International transactions data.

3.  **Bank for International Settlements (BIS)**  
    Credit aggregates, property prices, and exchange rates.

4.  **OECD Main Economic Indicators**  
    Economic indicators for OECD members and partners.

### Research Databases

5.  **Jordà-Schularick-Taylor Macrohistory Database**
    
      - Jordà, Ò., Schularick, M., & Taylor, A. M. (2017).
        “Macrofinancial History and the New Business Cycle Facts.”
        *NBER Macroeconomics Annual*, 31(1), 213-263.
      - Jordà, Ò., et al. (2019). “The Rate of Return on Everything,
        1870–2015.” *The Quarterly Journal of Economics*, 134(3),
        1225-1298.
      - Jordà, Ò., et al. (2021). “Bank Capital Redux: Solvency,
        Liquidity, and Crisis.” *Review of Financial Studies*, 34(7),
        3062-3107.

6.  **KOF Globalisation Index**  
    Gygli, S., Haelg, F., Potrafke, N., & Sturm, J. E. (2019). “The KOF
    Globalisation Index – Revisited.” *Review of International
    Organizations*, 14(3), 543-574.

7.  **Emergency Events Database (EM-DAT)**  
    Centre for Research on the Epidemiology of Disasters (CRED). (2024).
    EM-DAT: The International Disaster Database.

8.  **Sovereign Default Database**  
    Beers, D., Ndukwe, C. I., & Charron, S. (2024). BoC–BoE Sovereign
    Default Database. Bank of Canada, Bank of England.

9.  **Capital Account Openness**  
    Quinn, D., & Toyoda, A. M. (2008). “Does Capital Account
    Liberalization Lead to Economic Growth?” *Review of Financial
    Studies*, 21(3), 1403-1449.

10. **Maddison Project Database**  
    Maddison Project Database 2023.

## Licensing

This package is available under a dual-licensing model:

1.  **AGPL-3.0 License** (Open Source)
      - Free for open-source projects, academic research, and personal
        use
      - Full terms in [LICENSE.md](LICENSE.md)
2.  **Commercial License**
      - For proprietary/commercial applications
      - Allows closed-source usage
      - Details in [LICENSE\_COMM.md](LICENSE_COMM.md)

For commercial licensing inquiries: - Email:
<benjaminpeeters@protonmail.com> - Subject: “Commercial License - R
Package WPD - \[Your Use Case\]”

## Development and Contributions

We welcome contributions\! Please read our [Contributing
Guide](CONTRIBUTING.md) for details on how to submit pull requests,
report issues, and contribute to documentation.

⚠️ **Important Note**: Currently, there are known issues with legend
rendering when using ggplot2 3.5.x. For optimal visualization, we
recommend using ggplot2 3.4.x. You can install the recommended version
using:

``` r
# Install specific ggplot2 version
remotes::install_version("ggplot2", version = "3.4.3")
```

### Future Developments

We are actively working on extending the package’s functionality. Here
are our planned features:

  - Expand database coverage:
      - Include World Inequality Database (WID)
      - Incorporate Aizenman’s research data
      - Add datasets from additional researchers
  - Enhance country identification flexibility:
      - Support ISO2 codes and full country names in `wp_data()`
      - Enable single-year queries in `wp_data()`
      - Add support for historical USSR ISO codes in `wp_get_category()`
  - Improve user experience:
      - Develop `wp_quick()` for streamlined data visualization (e.g.,
        balance of payments graphs)
      - Enhance `wp_info()` to display timespan and country coverage for
        each indicator
