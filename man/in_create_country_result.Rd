% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wp_data.r
\name{in_create_country_result}
\alias{in_create_country_result}
\title{Create Result Structure for Country Data}
\usage{
in_create_country_result(country_data, variable, date_cols, result)
}
\arguments{
\item{country_data}{data.frame; source data for one country}

\item{variable}{character; variable name}

\item{date_cols}{character; vector of date column names}

\item{result}{numeric; calculated values}
}
\value{
data.frame with standardized structure
}
\description{
Internal helper function that formats calculation results into the standard
data frame structure.

Used by: in_data_one_formula
Uses: None

Features:
\itemize{
\item Creates consistent output structure
\item Preserves column order
\item Maintains date formats
\item Sets appropriate column types
}
}
\keyword{internal}
