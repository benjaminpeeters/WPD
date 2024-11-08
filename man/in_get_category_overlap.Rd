% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wp_iso.r
\name{in_get_category_overlap}
\alias{in_get_category_overlap}
\title{Get overlapping countries between two categories}
\usage{
in_get_category_overlap(category1, category2)
}
\arguments{
\item{category1}{Character, first category name}

\item{category2}{Character, second category name}
}
\value{
Character vector of ISO3 codes present in both categories
}
\description{
Get overlapping countries between two categories
}
\examples{
eu_brics_overlap <- get_category_overlap("EU", "BRICS")

}
\keyword{internal}
