# Load required libraries
library(knitr)
library(rmarkdown)
library(devtools)
devtools::load_all()

# Set up paths
VIGNETTE_PATH <- "vignettes"
DATA_DIR <- file.path(VIGNETTE_PATH, "data")
FIGURES_DIR <- file.path(VIGNETTE_PATH, "figures")

# WRITE RMARKDOWN FILE


write_md <- function(text, code = NULL) {
  if (!is.null(code)) {
    text <- sprintf(text, code)
  }
  cat(text, "\n\n", 
      file = file.path(VIGNETTE_PATH, filename),
      append = TRUE)
}



write_yaml_header <- function(title, data_sources = NULL) {
  # Start with the YAML header template
  yaml_text <- sprintf('---
title: "%s"
output: rmarkdown::html_vignette
vignette: >
  %%\\VignetteIndexEntry{%s}
  %%\\VignetteEngine{knitr::rmarkdown}
  %%\\VignetteEncoding{UTF-8}
---
', title, title)
  
  # Add the setup chunk
  setup_chunk <- '

# Write setup chunk
```{r setup, include=FALSE}
library(WPD)'
  
  # If data sources are provided, add them to the setup chunk
  if (!is.null(data_sources)) {
    data_sources_text <- paste0(
      '\n# Load precomputed data\n',
      paste0('source("data/', data_sources, '.R")', collapse = '\n')
    )
    setup_chunk <- paste0(setup_chunk, data_sources_text)
  }
  
  # Close the setup chunk
  setup_chunk <- paste0(setup_chunk, '\n```\n')
  
  # Combine YAML header and setup chunk
  full_text <- paste0(yaml_text, setup_chunk)
  
  # Write to file
  write_md(full_text)
}




# SAVE DATA

save_data_code <- function(data, filename) {
  dump_code <- paste(
    sprintf("%s <- structure(", filename),
    paste(deparse(data), collapse="\n"),
    ")",
    sep = "\n"
  )
  writeLines(dump_code, file.path(DATA_DIR, paste0(filename, ".R")))
}


exec_save_code <- function(...) {
  # Get all arguments
  args <- list(...)
  # Get the argument names from the call
  arg_names <- as.character(match.call(expand.dots = FALSE)$...)
  
  # Process each code string with its corresponding name
  for(i in seq_along(args)) {
    code_string <- args[[i]]
    arg_name <- arg_names[i]
    
    # Evaluate the code in the global environment
    eval(parse(text = code_string), envir = .GlobalEnv)
    
    # Get the resulting object from global environment
    example_data <- get(sub("^\\s*([[:alnum:]_]+)\\s*<-.*", "\\1", code_string), envir = .GlobalEnv)
    
    # Save the data using the original argument name
    save_data_code(example_data, arg_name)
  }
  
  # Return invisibly if needed for piping or assignment
  invisible(args)
}
