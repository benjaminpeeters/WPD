
#' Display information about available data
#' @param frequency Character, either "Q", "Y", or NULL for both
#' @return Invisibly returns the metadata for the specified frequency/frequencies
#' @export
wp_info <- function(frequency = NULL) {
    # Validate frequency argument
    if (!is.null(frequency)) {
        frequency <- match.arg(frequency, c("Q", "Y"))
        metadata_list <- list(get(paste0("METADATA_", frequency)))
        names(metadata_list) <- frequency
    } else {
        metadata_list <- list(
            Q = METADATA_Q,
            Y = METADATA_Y
        )
    }
    
    # Function to print metadata for one frequency
    print_metadata <- function(metadata, freq) {
        in_print_debug(sprintf("############# %s Data (%d variables) #############\n", 
                        ifelse(freq == "Q", "Quarterly", "Yearly"),
                        nrow(metadata)),
                    verbose = TRUE, debug = TRUE, 
                    type = "empty")
        
        # Get unique Origins
        unique_origins <- unique(metadata$Origin)
        
        # Print the results grouped by Origin
        for (origin in rev(unique_origins)) {

            ref <- paste0(unique(metadata[metadata$Origin == origin,]$Reference), collapse=", ")

            in_print_debug(sprintf("Data from %s", ref),
                    verbose = TRUE, 
                    debug = FALSE,
                    type = "info",
                    text_type = origin)
            
            # Filter data for current Origin
            origin_data <- metadata[metadata$Origin == origin, ]
            
            # Print Symbol and Indicator for current Origin
            for (i in seq_len(nrow(origin_data))) {
                symbol <- origin_data$Symbol[i]
                indicator <- origin_data$Indicator[i]
                cat(sprintf("%-26s | %s\n", symbol, indicator))
            }
            
            cat("\n")
        }
    }
    
    # Print metadata for each frequency
    for (freq in names(metadata_list)) {
        print_metadata(metadata_list[[freq]], freq)
    }
    
    # Invisibly return the metadata
    invisible(metadata_list)
}
