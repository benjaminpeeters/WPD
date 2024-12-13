% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wp_plot_common_components.r
\name{in_create_references_panel}
\alias{in_create_references_panel}
\title{Create References Citation Panel}
\usage{
in_create_references_panel(
  reference_col,
  dim,
  base_size = 16,
  verbose = TRUE,
  debug = TRUE
)
}
\description{
Internal function that creates a formatted panel for reference citations.
Handles text wrapping and layout of source citations.

Used by: in_plot_core
Uses: in_format_references

Features:
\itemize{
\item Automatic text wrapping
\item Width-aware formatting
\item Character count optimization
\item Consistent styling
}
}
\keyword{internal}
