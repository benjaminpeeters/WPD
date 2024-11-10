
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



########################
# Transform column Reference into ASCII characters


# Function to convert non-ASCII characters to ASCII equivalents
clean_reference <- function(text) {
    # Convert to ASCII, replacing special characters
    text <- iconv(text, to = "ASCII//TRANSLIT")
    
    # Manual replacements for common special characters
    text <- gsub("\u2013", "-", text)  # em dash
    text <- gsub("\u2014", "-", text)  # en dash
    text <- gsub("\u2018", "'", text)  # smart single quotes
    text <- gsub("\u2019", "'", text)  # smart single quotes
    text <- gsub("\u201C", '"', text)  # smart double quotes
    text <- gsub("\u201D", '"', text)  # smart double quotes
    
    # Clean up any remaining non-ASCII characters
    text <- stringi::stri_trans_general(text, "Latin-ASCII")
    
    # Remove any remaining non-ASCII characters
    text <- iconv(text, "UTF-8", "ASCII", sub = "")
    
    return(text)
}

# Apply the transformation to the Reference column in both metadata dataframes
METADATA_Q$Reference <- clean_reference(METADATA_Q$Reference)
METADATA_Y$Reference <- clean_reference(METADATA_Y$Reference)

#######################

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
