
devtools::load_all()  # Load current development version

# Function to save data as R code
save_data_code <- function(data, filename) {
  dump_code <- paste(
    sprintf("%s <- structure(", filename),
    paste(deparse(data), collapse="\n"),
    ")",
    sep="\n"
  )
  writeLines(dump_code, file.path("vignettes/data", paste0(filename, ".R")))
}


# Generate multiple examples
basic_example <- wp_data(
  ISO = "USA",
  formula = "100*CU_C/GDP_C",
  years = c(2000, 2002)
)
save_data_code(basic_example, "basic_example")

advanced_example <- wp_data(
  ISO = c("CHN", "JPN"),
  formula = c("EXg_C/GDP_C"),
  years = c(2010, 2012)
)
save_data_code(advanced_example, "advanced_example")
