# data-raw/test_compression.R

library(microbenchmark)

# Load original data
load("inst/extdata/DATA_Q.RData")
load("inst/extdata/DATA_Y.RData")

#' Test compression and loading performance
#' @param data Name of the data object as string
#' @param name Name for the test
#' @param compression Compression method (NULL, "gzip", "bzip2", or "xz")
#' @return Named list with size and timing results
test_save_and_load <- function(data, name, compression) {
    file_path <- paste0("inst/extdata/test_", name, ".RData")
    
    # Save file with specified compression
    if (is.null(compression)) {
        save(list = data, file = file_path, compress = FALSE)
        compression_str <- "none"
    } else {
        save(list = data, file = file_path, 
             compress = compression, compression_level = 9)
        compression_str <- compression
    }
    
    # Get file size
    size_mb <- file.size(file_path) / 1024^2
    
    # Measure loading time (multiple times for reliability)
    # Clear memory first
    gc()
    
    # Create new environment for loading
    load_times <- microbenchmark(
        {
            e <- new.env()
            load(file_path, envir = e)
        },
        times = 10
    )
    
    # Calculate loading stats
    load_time_mean <- mean(load_times$time) / 1e9  # Convert nanoseconds to seconds
    load_time_sd <- sd(load_times$time) / 1e9
    
    # Create results string
    results <- sprintf(
        "%-20s | Size: %6.2f MB | Load time: %5.3f ± %5.3f seconds",
        paste0(name, " (", compression_str, ")"),
        size_mb,
        load_time_mean,
        load_time_sd
    )
    
    # Clean up
    file.remove(file_path)
    
    return(list(
        name = paste0(name, " (", compression_str, ")"),
        size_mb = size_mb,
        load_time_mean = load_time_mean,
        load_time_sd = load_time_sd
    ))
}

# Function to run all tests and create summary
run_compression_tests <- function(data_name) {
    cat(sprintf("\nTesting compression methods for %s:\n", data_name))
    cat(paste(rep("=", 65), collapse = ""), "\n")
    
    results <- list()
    
    # Test each compression method
    for (comp in list(NULL, "gzip", "bzip2", "xz")) {
        results[[length(results) + 1]] <- test_save_and_load(data_name, data_name, comp)
    }
    
    # Print results table
    cat("\nResults:\n")
    cat(paste(rep("-", 65), collapse = ""), "\n")
    cat("Method           |     Size     |         Load Time\n")
    cat(paste(rep("-", 65), collapse = ""), "\n")
    
    for (r in results) {
        cat(sprintf("%-15s | %6.2f MB    | %5.3f ± %5.3f seconds\n",
                   r$name, r$size_mb, r$load_time_mean, r$load_time_sd))
    }
    
    # Calculate and print efficiency metrics
    cat("\nEfficiency Metrics (relative to no compression):\n")
    cat(paste(rep("-", 65), collapse = ""), "\n")
    base_size <- results[[1]]$size_mb
    base_time <- results[[1]]$load_time_mean
    
    for (r in results[-1]) {
        size_reduction <- (base_size - r$size_mb) / base_size * 100
        time_overhead <- (r$load_time_mean - base_time) / base_time * 100
        
        cat(sprintf("%s:\n", r$name))
        cat(sprintf("  - Size reduction: %.1f%%\n", size_reduction))
        cat(sprintf("  - Time overhead: %.1f%%\n", time_overhead))
        cat(sprintf("  - Size/Time trade-off: %.2f MB saved per second overhead\n",
                   (base_size - r$size_mb) / (r$load_time_mean - base_time)))
    }
    
    return(results)
}

# Test individual datasets
q_results <- run_compression_tests("DATA_Q")
y_results <- run_compression_tests("DATA_Y")



# Clean up
rm(DATA_Q, DATA_Y)



# RESULTS 

# Testing compression methods for DATA_Q:
# ================================================================= 
#
# Results:
# ----------------------------------------------------------------- 
# Method           |     Size     |         Load Time
# ----------------------------------------------------------------- 
# DATA_Q (none)   |  90.64 MB    | 0.126 ± 0.021 seconds
# DATA_Q (gzip)   |  14.67 MB    | 0.281 ± 0.002 seconds
# DATA_Q (bzip2)  |  14.29 MB    | 2.124 ± 0.020 seconds
# DATA_Q (xz)     |  12.75 MB    | 1.049 ± 0.019 seconds
#
# Efficiency Metrics (relative to no compression):
# ----------------------------------------------------------------- 
# DATA_Q (gzip):
#   - Size reduction: 83.8%
#   - Time overhead: 123.0%
#   - Size/Time trade-off: 490.67 MB saved per second overhead
# DATA_Q (bzip2):
#   - Size reduction: 84.2%
#   - Time overhead: 1587.4%
#   - Size/Time trade-off: 38.22 MB saved per second overhead
# DATA_Q (xz):
#   - Size reduction: 85.9%
#   - Time overhead: 733.6%
#   - Size/Time trade-off: 84.37 MB saved per second overhead
#
# Testing compression methods for DATA_Y:
# ================================================================= 
#
# Results:
# ----------------------------------------------------------------- 
# Method           |     Size     |         Load Time
# ----------------------------------------------------------------- 
# DATA_Y (none)   | 241.95 MB    | 0.591 ± 0.221 seconds
# DATA_Y (gzip)   |  31.04 MB    | 0.940 ± 0.032 seconds
# DATA_Y (bzip2)  |  28.04 MB    | 4.850 ± 0.054 seconds
# DATA_Y (xz)     |  24.24 MB    | 2.589 ± 0.534 seconds
#
# Efficiency Metrics (relative to no compression):
# ----------------------------------------------------------------- 
# DATA_Y (gzip):
#   - Size reduction: 87.2%
#   - Time overhead: 59.0%
#   - Size/Time trade-off: 605.15 MB saved per second overhead
# DATA_Y (bzip2):
#   - Size reduction: 88.4%
#   - Time overhead: 720.5%
#   - Size/Time trade-off: 50.23 MB saved per second overhead
# DATA_Y (xz):
#   - Size reduction: 90.0%
#   - Time overhead: 338.0%
#   - Size/Time trade-off: 108.98 MB saved per second overhead








