% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wp_data.r
\name{calculate_yoy_growth}
\alias{calculate_yoy_growth}
\title{Calculate Year-over-Year Growth Rates}
\usage{
calculate_yoy_growth(data)
}
\arguments{
\item{data}{data.frame; input data with Date and Value columns}
}
\value{
numeric vector of growth rates
}
\description{
Internal helper function that computes year-over-year growth rates for both
quarterly and annual data.

Used by: in_aggregate_time
Uses: None

Features:
\itemize{
\item Handles both quarterly and annual data automatically
\item Preserves quarter-to-quarter comparisons in quarterly data
\item Skips missing values in calculations
\item Handles zero base values gracefully
}
}
\keyword{internal}
