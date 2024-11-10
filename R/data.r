#' ISO Code Mapping Data
#'
#' Various lookup tables for converting between country names, ISO codes, and categories
#'
#' @format A list containing multiple lookup tables:
#' \describe{
#'   \item{list_ctry2iso}{List mapping country names to ISO3 codes}
#'   \item{list_categories}{Character vector of all valid category codes}
#'   \item{list_category2iso}{List mapping categories to ISO3 codes}
#'   \item{list_iso2ctry}{List mapping ISO3 codes to country names}
#'   \item{list_iso2ctry_old}{List mapping historical ISO3 codes to country names}
#'   \item{list_iso2ctry_others}{List mapping special ISO3-like codes}
#'   \item{list_iso_old2new}{List mapping old ISO codes to current ones}
#'   \item{list_iso2_to_iso3}{List mapping ISO2 codes to ISO3 codes}
#'   \item{category_labels}{List mapping category codes to display labels}
#' }
#'
#' @source Created from various official ISO standards and WPD classifications
#' @usage data(ISO_DATA)
"ISO_DATA"

#' Metadata for Quarterly Variables
#'
#' A dataset containing information about all available quarterly variables.
#'
#' @format A data frame with the following columns:
#' \describe{
#'   \item{Origin}{Short identifier for the data source}
#'   \item{Reference}{Detailed source of the data}
#'   \item{Symbol}{Variable identifier}
#'   \item{Indicator}{Description of the variable}
#'   \item{Frequency}{Always "Q" for this dataset}
#' }
#' @usage data(METADATA_Q)
"METADATA_Q"

#' Metadata for Yearly Variables
#'
#' A dataset containing information about all available yearly variables.
#'
#' @format A data frame with the following columns:
#' \describe{
#'   \item{Origin}{Short identifier for the data source}
#'   \item{Reference}{Detailed source of the data}
#'   \item{Symbol}{Variable identifier}
#'   \item{Indicator}{Description of the variable}
#'   \item{Frequency}{Always "Y" for this dataset}
#' }
#' @usage data(METADATA_Y)
"METADATA_Y"
