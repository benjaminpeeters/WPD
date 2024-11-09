# This sets up the package environment
.pkgenv <- new.env(parent = emptyenv())






#' Load data for a specific frequency
#' @param frequency Character: "Q" or "Y"
#' @param verbose Logical: whether to print load message
#' @param force Logical: whether to force reload
#' @return The loaded data or NULL if not found
#' @note Data files are compressed using gzip compression. Expected load times:
#'       DATA_Q: ~0.3 seconds
#'       DATA_Y: ~0.9 seconds
#' @keywords internal
in_load_frequency_data <- function(frequency, verbose = TRUE, force = FALSE) {
    data_name <- paste0("DATA_", frequency)
    
    
    # Return cached data if available and not forcing reload
    if (!force && !is.null(.pkgenv[[data_name]])) {
        return(.pkgenv[[data_name]])
    }
    
    # Try development path first
    dev_path <- file.path("inst", "extdata", paste0(data_name, ".RData"))
    
    # If not found in development path, try installed package path
    if (!file.exists(dev_path)) {
        pkg_path <- system.file("extdata", paste0(data_name, ".RData"), 
                              package = "WPD")
        if (pkg_path == "") {
            stop("Data file ", data_name, ".RData not found")
        }
        data_path <- pkg_path
    } else {
        data_path <- dev_path
    }
    

    freq_name <- if (frequency == "Q") "quarterly" else "yearly"
    in_print_debug(paste0("Loading ", freq_name," data (first use)"), 
                   verbose = verbose, debug = FALSE, "info", "LOADING")

    # Load data into temporary environment
    temp_env <- new.env()
    load(data_path, envir = temp_env)
    
    # Store in package environment and return
    .pkgenv[[data_name]] <- get(data_name, envir = temp_env)
    invisible(.pkgenv[[data_name]])
}





#' Locate which dataset(s) contain the specified symbols
#' @param Symbol Character vector of symbols to locate, or NULL
#' @return Character vector containing "Q", "Y", both, or NULL
#' @keywords internal
in_locate_symbol <- function(Symbol = NULL) {
    if (is.null(Symbol)) return(c("Q", "Y"))
    
    # Check each symbol individually
    symbols_in_Q <- Symbol %in% METADATA_Q$Symbol
    symbols_in_Y <- Symbol %in% METADATA_Y$Symbol
    
    # Identify symbols not found in either dataset
    not_found <- !symbols_in_Q & !symbols_in_Y
    
    if (any(not_found)) {
        missing_symbols <- Symbol[not_found]
        message("The following symbols were not found in either dataset:\n",
                paste(missing_symbols, collapse = ", "))
        return(NULL)
    }
    
    # Determine which datasets to return
    frequencies <- character(0)
    if (any(symbols_in_Q)) frequencies <- c(frequencies, "Q")
    if (any(symbols_in_Y)) frequencies <- c(frequencies, "Y")
    
    return(frequencies)
}
