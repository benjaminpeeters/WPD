# This sets up the package environment
.pkgenv <- new.env(parent = emptyenv())


#' Load the package data during development or after installation
#' @keywords internal
in_data_load <- function(force = FALSE) {
    # If data is already loaded and force is FALSE, return the loaded data
    if (!is.null(.pkgenv$DATA_Q) && !force) {
        return(.pkgenv$DATA_Q)
    }
    
    # Try development path first
    dev_path <- file.path("inst", "extdata", "DATA.RData")
    
    # If not found in development path, try installed package path
    if (!file.exists(dev_path)) {
        pkg_path <- system.file("extdata", "DATA.RData", 
                              package = "yourpackage")
        if (pkg_path == "") {
            stop("Data not found. Please ensure DATA.RData is in inst/extdata/")
        }
        data_path <- pkg_path
    } else {
        data_path <- dev_path
    }
    
    # Load data into package environment
    load(data_path, envir = .pkgenv)
    
    return(.pkgenv$DATA_Q)
}

