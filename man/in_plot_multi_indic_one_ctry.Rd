% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wp_plot_series.r
\name{in_plot_multi_indic_one_ctry}
\alias{in_plot_multi_indic_one_ctry}
\title{Create Multi-Line Plot for One Country}
\usage{
in_plot_multi_indic_one_ctry(
  data,
  y_axis = NULL,
  key_dates = NULL,
  base_size = 16
)
}
\description{
Internal function that creates a simple multi-line plot for multiple indicators
in a single country. Basic implementation for time series comparison.

Used by: wp_plot_series (via in_plot_core), in_plot_multi_by_ctry
Uses: in_scale_y, in_scale_x, in_theme_plot, in_add_date_markers

Features:
\itemize{
\item Multiple indicators as separate lines
\item Consistent color coding
\item Single y-axis scaling
\item Optional key date markers
}
}
\keyword{internal}
