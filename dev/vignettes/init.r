
source("dev/init_dev.r")

# Load required libraries
# library(knitr)
# library(rmarkdown)

# Set up paths
VIGNETTE_PATH <- "vignettes"
DATA_DIR <- file.path(VIGNETTE_PATH, "data")
FIGURES_DIR <- file.path(VIGNETTE_PATH, "figures")



get_current_file <- function() {
  frame_files <- lapply(sys.frames(), function(x) x$ofile)
  frame_file <- Find(Negate(is.null), frame_files)
  if (!is.null(frame_file)) {
    # Normalize path and get just the filename without extension
    filename <- basename(frame_file)
    filename <- tools::file_path_sans_ext(filename)
    return(filename)
  } else {
    return(NULL)
  }
}


# Create vignette file
filename <- paste0(get_current_file(),".Rmd")
file.create(file.path(VIGNETTE_PATH, filename))


# WRITE RMARKDOWN FILE

write_md <- function(text) {
  cat(stringr::str_interp(text), "\n\n", 
      file = file.path(VIGNETTE_PATH, filename),
      append = TRUE)
}



write_yaml_header <- function(title, data_sources = NULL) {
  # Start with the YAML header template
  yaml_text <- sprintf('---
title: "%s"
author: "Benjamin Peeters"
date: "`r Sys.Date()`"
output: rmarkdown::html_vignette
vignette: >
  %%\\VignetteIndexEntry{%s}
  %%\\VignetteEngine{knitr::rmarkdown}
  %%\\VignetteEncoding{UTF-8}
---
', title, title)
  
  # Add the setup chunk
  setup_chunk <- '

```{r setup, include=FALSE}
# Write setup chunk
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


# EXECUTE PLOT

# Also remove the filename row by default
exec_plot <- function(..., keep_filename = FALSE, keep_print = FALSE) {
  # Get all arguments except parameters
  plot_codes <- list(...)
  # Get the argument names from the call
  plot_names <- as.character(match.call(expand.dots = FALSE)$...)
  
  for(i in seq_along(plot_codes)) {
    plot_code <- plot_codes[[i]]
    plot_name <- plot_names[i]
    
    # Execute the original code
    eval(parse(text = plot_code))
    
    if (!keep_filename || !keep_print) {
      # Get the indentation of the parameters
      lines <- strsplit(plot_code, "\n")[[1]]
      param_line <- grep("(filename|print)\\s*=", lines, value = TRUE)[1]
      indentation <- gsub("^(\\s*)(filename|print).*", "\\1", param_line)
      
      if (!keep_filename) {
        # Remove the entire filename line more precisely
        plot_code <- gsub("\\s*filename\\s*=\\s*file\\.path\\([^\\)]+\\)\\s*,?\\s*\n?", "\n", plot_code)
      }
      
      if (!keep_print) {
        # Remove the print parameter line
        plot_code <- gsub("\\s*print\\s*=\\s*[^,\\)]+\\s*,?\\s*\n?", "\n", plot_code)
      }
      
      # Clean up any potential double commas that might result
      plot_code <- gsub(",\\s*\\)", ")", plot_code)
      
      # Clean up any potential extra newlines while preserving indentation
      plot_code <- gsub("\n+", "\n", plot_code)
      
      # Fix indentation of remaining parameters
      plot_code <- gsub("\n(\\s*)(\\w+\\s*=)", paste0("\n", indentation, "\\2"), plot_code)
    }
    
    # Assign the modified code back to the global environment
    assign(plot_name, plot_code, envir = .GlobalEnv)
  }
  
  # Return invisibly if needed for piping or assignment
  invisible(plot_codes)
}





# vignettes/
# ├── a-new-to-r/
# │   └── your-first-r-script.Rmd
# ├── b-getting-started/
# │   ├── introduction.Rmd
# │   ├── installation-setup.Rmd
# │   ├── installation-setup.Rmd
# │   └── basic-workflow.Rmd
# ├── c-fundamentals/
# │   ├── loading-data-basics.Rmd
# │   ├── data-manipulation.Rmd
# │   └── first-visualization.Rmd
# ├── d-advanced/
# │   ├── advanced-data-loading.Rmd
# │   ├── customizing-plots.Rmd
# │   └── working-with-formulas.Rmd
# ├── e-special-features/
# │   ├── complex-visualizations.Rmd
# │   ├── custom-aggregations.Rmd
# │   └── optimization-techniques.Rmd
# └── z-contributing/
#     ├── development-guide.Rmd
#     └── adding-features.Rmd
#
