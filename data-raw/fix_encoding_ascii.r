# Function to convert special characters to ASCII escape sequences
fix_encoding_ascii <- function(data_list) {
    # Helper function to convert a single string to ASCII escape sequences
    escape_chars <- function(x) {
        if (is.character(x)) {
            # Convert common special characters to ASCII escape sequences
            x <- gsub("ç", "\\u00e7", x, fixed = TRUE)  # ç
            x <- gsub("é", "\\u00e9", x, fixed = TRUE)  # é
            x <- gsub("è", "\\u00e8", x, fixed = TRUE)  # è
            x <- gsub("ê", "\\u00ea", x, fixed = TRUE)  # ê
            x <- gsub("ë", "\\u00eb", x, fixed = TRUE)  # ë
            x <- gsub("à", "\\u00e0", x, fixed = TRUE)  # à
            x <- gsub("á", "\\u00e1", x, fixed = TRUE)  # á
            x <- gsub("â", "\\u00e2", x, fixed = TRUE)  # â
            x <- gsub("ã", "\\u00e3", x, fixed = TRUE)  # ã
            x <- gsub("ä", "\\u00e4", x, fixed = TRUE)  # ä
            x <- gsub("ñ", "\\u00f1", x, fixed = TRUE)  # ñ
            x <- gsub("ü", "\\u00fc", x, fixed = TRUE)  # ü
            x <- gsub("ú", "\\u00fa", x, fixed = TRUE)  # ú
            x <- gsub("ù", "\\u00f9", x, fixed = TRUE)  # ù
            x <- gsub("û", "\\u00fb", x, fixed = TRUE)  # û
            x <- gsub("ï", "\\u00ef", x, fixed = TRUE)  # ï
            x <- gsub("í", "\\u00ed", x, fixed = TRUE)  # í
            x <- gsub("ì", "\\u00ec", x, fixed = TRUE)  # ì
            x <- gsub("î", "\\u00ee", x, fixed = TRUE)  # î
            x <- gsub("ó", "\\u00f3", x, fixed = TRUE)  # ó
            x <- gsub("ò", "\\u00f2", x, fixed = TRUE)  # ò
            x <- gsub("ô", "\\u00f4", x, fixed = TRUE)  # ô
            x <- gsub("õ", "\\u00f5", x, fixed = TRUE)  # õ
            x <- gsub("ö", "\\u00f6", x, fixed = TRUE)  # ö
            
            # Capital letters
            x <- gsub("Ç", "\\u00c7", x, fixed = TRUE)  # Ç
            x <- gsub("É", "\\u00c9", x, fixed = TRUE)  # É
            x <- gsub("È", "\\u00c8", x, fixed = TRUE)  # È
            x <- gsub("Ê", "\\u00ca", x, fixed = TRUE)  # Ê
            x <- gsub("Ë", "\\u00cb", x, fixed = TRUE)  # Ë
            x <- gsub("À", "\\u00c0", x, fixed = TRUE)  # À
            x <- gsub("Á", "\\u00c1", x, fixed = TRUE)  # Á
            x <- gsub("Â", "\\u00c2", x, fixed = TRUE)  # Â
            x <- gsub("Ã", "\\u00c3", x, fixed = TRUE)  # Ã
            x <- gsub("Ä", "\\u00c4", x, fixed = TRUE)  # Ä
            x <- gsub("Ñ", "\\u00d1", x, fixed = TRUE)  # Ñ
            x <- gsub("Ü", "\\u00dc", x, fixed = TRUE)  # Ü
            x <- gsub("Ú", "\\u00da", x, fixed = TRUE)  # Ú
            x <- gsub("Ù", "\\u00d9", x, fixed = TRUE)  # Ù
            x <- gsub("Û", "\\u00db", x, fixed = TRUE)  # Û
            x <- gsub("Ï", "\\u00cf", x, fixed = TRUE)  # Ï
            x <- gsub("Í", "\\u00cd", x, fixed = TRUE)  # Í
            x <- gsub("Ì", "\\u00cc", x, fixed = TRUE)  # Ì
            x <- gsub("Î", "\\u00ce", x, fixed = TRUE)  # Î
            x <- gsub("Ó", "\\u00d3", x, fixed = TRUE)  # Ó
            x <- gsub("Ò", "\\u00d2", x, fixed = TRUE)  # Ò
            x <- gsub("Ô", "\\u00d4", x, fixed = TRUE)  # Ô
            x <- gsub("Õ", "\\u00d5", x, fixed = TRUE)  # Õ
            x <- gsub("Ö", "\\u00d6", x, fixed = TRUE)  # Ö
        }
        return(x)
    }
    
    # Helper function to recursively process nested lists
    fix_recursive <- function(x) {
        if (is.list(x)) {
            return(lapply(x, fix_recursive))
        } else if (is.character(x)) {
            return(escape_chars(x))
        } else {
            return(x)
        }
    }
    
    # Process the entire data structure
    fixed_data <- fix_recursive(data_list)
    
    return(fixed_data)
}



# convert2ascii <- function(char){
#     # First get the <U+XXXX> format
#     u_format <- iconv(char, "UTF-8", "ASCII", "Unicode")
#     # Convert to \uXXXX format
#     backslash_format <- gsub("<U\\+(....)>", "\\\\u\\1", u_format)
#     output <- backslash_format
#     return(output)
# }






