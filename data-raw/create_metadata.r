
# Function to extract metadata
extract_metadata <- function(data) {
    if (!all(c("Symbol", "Indicator", "Origin") %in% colnames(data))) {
        stop("Data must contain 'Symbol', 'Indicator', and 'Origin' columns.")
    }
    
    # Get unique combinations and sort them
    metadata <- unique(data[, c("Origin", "Symbol", "Indicator", "Reference", "Frequency")])
    metadata <- metadata[order(metadata$Origin, metadata$Symbol), ]
    
    return(metadata)
}

# Load the original data
load("inst/extdata/DATA_Q.RData")  # This loads DATA_Q and DATA_Y
load("inst/extdata/DATA_Y.RData")  # This loads DATA_Q and DATA_Y

# Extract metadata for both frequencies
METADATA_Q <- extract_metadata(DATA_Q)
METADATA_Y <- extract_metadata(DATA_Y)


# Save metadata using usethis::use_data
usethis::use_data(METADATA_Q, METADATA_Y, overwrite = TRUE)

# Write the dataframe to a CSV file
write.csv(METADATA_Q, "inst/extdata/METADATA_Q.csv", row.names = FALSE)
write.csv(METADATA_Y, "inst/extdata/METADATA_Y.csv", row.names = FALSE)


# Optional: Print some information about the metadata
cat("Quarterly data:\n")
cat("Number of variables:", nrow(METADATA_Q), "\n")
cat("Origins:", paste(unique(METADATA_Q$Origin), collapse = ", "), "\n\n")

cat("Yearly data:\n")
cat("Number of variables:", nrow(METADATA_Y), "\n")
cat("Origins:", paste(unique(METADATA_Y$Origin), collapse = ", "), "\n")

# Clean up
# rm(DATA_Q, DATA_Y, METADATA_Q, METADATA_Y)
