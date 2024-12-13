% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wp_data.r
\name{in_match_Q2Y}
\alias{in_match_Q2Y}
\title{Convert Quarterly Data to Yearly Frequency}
\usage{
in_match_Q2Y(data, frequencies, symbols, verbose = TRUE, debug = FALSE)
}
\arguments{
\item{data}{data.frame; input dataset}

\item{frequencies}{character; frequencies for each symbol}

\item{symbols}{character; vector of symbols to process}

\item{verbose}{logical; print progress information}

\item{debug}{logical; print debug information}
}
\value{
data.frame with yearly frequency
}
\description{
Internal function that converts quarterly data to yearly frequency by averaging
quarterly values.

Used by: in_adjust_columns_to_frequency
Uses: in_process_yearly_data

Features:
\itemize{
\item Averages quarterly values
\item Handles missing quarters
\item Maintains series relationships
\item Updates frequency indicators
}
}
\keyword{internal}
