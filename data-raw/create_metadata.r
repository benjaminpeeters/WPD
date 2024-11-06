
# Function to extract metadata
extract_metadata <- function(data) {
    if (!all(c("Symbol", "Indicator", "Origin") %in% colnames(data))) {
        stop("Data must contain 'Symbol', 'Indicator', and 'Origin' columns.")
    }
    
    # Get unique combinations and sort them
    metadata <- unique(data[, c("Origin", "Symbol", "Indicator")])
    metadata <- metadata[order(metadata$Origin, metadata$Symbol), ]
    
    return(metadata)
}

# Load the original data
load("inst/extdata/DATA.RData")  # This loads DATA_Q and DATA_Y

# Extract metadata for both frequencies
METADATA_Q <- extract_metadata(DATA_Q)
METADATA_Y <- extract_metadata(DATA_Y)

# Add a frequency column to each metadata for potential future use
METADATA_Q$Frequency <- "Q"
METADATA_Y$Frequency <- "Y"

# Save metadata to data/ directory (for lazy loading)
dir.create("data", showWarnings = FALSE)
save(METADATA_Q, METADATA_Y, 
     file = "data/METADATA.RData", 
     compress = FALSE)  # No compression needed for small data

# Optional: Print some information about the metadata
cat("Quarterly data:\n")
cat("Number of variables:", nrow(METADATA_Q), "\n")
cat("Origins:", paste(unique(METADATA_Q$Origin), collapse = ", "), "\n\n")

cat("Yearly data:\n")
cat("Number of variables:", nrow(METADATA_Y), "\n")
cat("Origins:", paste(unique(METADATA_Y$Origin), collapse = ", "), "\n")

# Clean up
# rm(DATA_Q, DATA_Y, METADATA_Q, METADATA_Y)
