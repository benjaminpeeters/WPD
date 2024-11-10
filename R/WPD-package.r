#' WPD: World Panel Data Visualization and Analysis Toolkit
#'
#' A comprehensive package for accessing, analyzing and visualizing global economic
#' and social indicators. The package provides tools for working with panel data,
#' with built-in visualization capabilities and data analysis functions.
#'
#' @section Main Functions:
#' \itemize{
#'   \item \code{\link{wp_data}}: Load and filter panel data
#'   \item \code{\link{wp_plot_series}}: Create time series plots
#'   \item \code{\link{wp_plot_bar}}: Create bar charts
#'   \item \code{\link{wp_plot_scatter}}: Create scatter plots
#'   \item \code{\link{wp_info}}: Get information about available data
#' }
#'
#' @section Country Code Utilities:
#' \itemize{
#'   \item \code{\link{wp_ctry2iso}}: Convert country names to ISO3 codes
#'   \item \code{\link{wp_from_iso}}: Convert ISO codes to country information
#'   \item \code{\link{wp_get_category}}: Get countries belonging to specific categories
#' }
#'
#' @section Data:
#' The package includes:
#' \itemize{
#'   \item Annual and quarterly macroeconomic indicators
#'   \item Cross-country panel data
#'   \item Built-in seasonal adjustment capabilities
#'   \item Efficient on-demand data loading
#' }
#'
#' @docType package
#' @name WPD
#' @keywords internal
#'
#' @references
#' Package website: \url{https://benjaminpeeters.github.io/WPD}
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace imports. Please do not edit manually.
## usethis namespace: start
## usethis namespace: end
NULL
