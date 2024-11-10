

#' Convert Country Name to ISO3 Code
#' 
#' @description Converts country names to their corresponding ISO3 codes. The function
#' uses a hierarchical matching strategy: first trying exact match, then prefix and
#' partial matches if the input is long enough, while avoiding matches on common words.
#'
#' @param country_name Character vector containing the country names to convert.
#'   The function accepts various formats and spellings, including:
#'   \itemize{
#'     \item Official names (e.g., "United States of America")
#'     \item Common names (e.g., "United States", "USA")
#'     \item Historical names (e.g., "Burma" for Myanmar)
#'     \item Names with special characters (e.g., "Côte d'Ivoire")
#'     \item Names with abbreviations (e.g., "Rep." for Republic)
#'   }
#' @param verbose Logical, whether to print information about matching method used 
#'   when exact match fails (default: TRUE)
#' @param min_letter Integer, minimum number of letters required for prefix and 
#'   partial matching attempts (default: 3). Only used if exact match fails.
#'
#' @return Character vector of the same length as country_name containing ISO3 codes.
#'   Returns NA for entries where no match is found, with a warning message if verbose=TRUE.
#'
#' @details The function performs matching in the following order:
#'   1. Normalizes input name (converts to lowercase, removes special characters,
#'      standardizes spacing)
#'   2. Attempts exact match with normalized names
#'   3. If exact match fails and input length >= min_letter:
#'      - Tries prefix match (input matches start of country name)
#'      - Tries partial match (input is contained within country name)
#'      - Skips matching on common words like "United", "Republic", etc.
#'      - If verbose=TRUE, informs user about successful prefix/partial match
#'
#' @examples
#' # Single country
#' wp_ctry2iso("France")  # Returns "FRA"
#' 
#' # Multiple countries
#' wp_ctry2iso(c("France", "Germany", "Italy"))  # Returns c("FRA", "DEU", "ITA")
#' 
#' # Mixed cases with some partial matches
#' wp_ctry2iso(c("fra", "Deutsche", "Kingdom"))  
#' 
#' @family country code conversion functions
#' @seealso 
#'   \code{\link{wp_from_iso}} for converting ISO codes back to country names,
#'   \code{\link{wp_get_category}} for getting countries in specific categories
#'
#' @export
wp_ctry2iso <- function(country_name, verbose = TRUE, min_letter = 5) {
  
  # Define common words to exclude from partial/prefix matching
  stop_words <- c(
    "united", "republic", "democratic", "state", "states", "kingdom",
    "islamic", "federal", "federation", "new", "northern", "southern",
    "eastern", "western", "central", "people", "saint", "san", "union",
    "great", "grand", "independent", "congo", "korea", "germany"
  )
  
  # Helper function to normalize country names
  normalize_name <- function(name) {
    # Convert to lowercase
    name <- tolower(name)

    # Remove other special characters and standardize spacing
    name <- gsub("[._,\\-\\(\\)]", " ", name)       # Remove some special chars
    name <- gsub("\\s+", " ", name)           # Standardize spaces
    name <- trimws(name)                      # Remove leading/trailing whitespace

    # Handle special characters and diacritics
    name <- gsub("[\u00e8\u00e9\u00ea\u00eb]", "e", name)  # e variations
    name <- gsub("[\u00e0\u00e1\u00e2\u00e3\u00e4\u00e5]", "a", name)  # a variations
    name <- gsub("[\u00ec\u00ed\u00ee\u00ef]", "i", name)  # i variations
    name <- gsub("[\u00f2\u00f3\u00f4\u00f5\u00f6]", "o", name)  # o variations
    name <- gsub("[\u00f9\u00fa\u00fb\u00fc]", "u", name)  # u variations
    name <- gsub("[\u00fd\u00ff]", "y", name)  # y variations
    name <- gsub("\u00e6", "ae", name)  # ae ligature
    name <- gsub("\u0153", "oe", name)  # oe ligature
    name <- gsub("\u00f1", "n", name)   # n with tilde
    name <- gsub("\u00df", "ss", name)  # sharp s
    name <- gsub("\u00e7", "c", name)   # c cedilla

    # Replace common abbreviations
    name <- gsub("\\bdem\\.?\\b", "democratic", name)
    name <- gsub("\\brep\\.?\\b", "republic", name)
    name <- gsub("\\bst\\.?\\b", "saint", name)
    name <- gsub("\\bfed\\.?\\b", "federal", name)
    name <- gsub("\\bgovt\\.?\\b", "government", name)

    # Return normalized name
    return(name)
  }
  
  # Helper function to check if string contains only stop words
  is_only_stop_words <- function(str) {
    words <- strsplit(str, "\\s+")[[1]]
    all(words %in% stop_words)
  }
  
  # Main matching function for a single country name
  find_match <- function(one_country) {
    # Normalize the input country name
    normalized_input <- normalize_name(one_country)
    
    # Step 1: Try exact match first
    for (name in names(list_ctry2iso)) {
      if (normalize_name(name) == normalized_input) {
        return(list_ctry2iso[[name]])
      }
    }
    
    # Only proceed with prefix/partial matching if input is long enough
    # and input is not just stop words
    if (nchar(normalized_input) >= min_letter && !is_only_stop_words(normalized_input)) {
      # Step 2: Try prefix match
      for (name in names(list_ctry2iso)) {
        normalized_name <- normalize_name(name)
        if (grepl(paste0("^", normalized_input), normalized_name)) {
            in_print_debug(sprintf("Found prefix match: input '%s' matched with country '%s'", one_country, name),
                    verbose, FALSE, "info", "PREFIX")
            return(list_ctry2iso[[name]])
        }
      }
      
      # Step 3: Try partial match
      for (name in names(list_ctry2iso)) {
        normalized_name <- normalize_name(name)
        if (grepl(normalized_input, normalized_name)) {
            in_print_debug(sprintf("Found prefix match: input '%s' matched with country '%s'", one_country, name),
                    verbose, FALSE, "info", "PARTIAL")
            return(list_ctry2iso[[name]])
        }
      }
    }
    
    # If no match is found, return NA with warning
    in_print_debug(sprintf("ISO code for country name '%s' (%s) not found. NA value returned.", one_country, normalize_name(one_country)),
            verbose, FALSE, "warning")
    return(NA_character_)
  }
  
  # Apply the matching function to each country name in the input vector
  vapply(country_name, find_match, character(1))
}


#' Convert ISO Code to Country Information
#' 
#' @description Returns specified information about countries based on their ISO3 codes.
#' The function accepts a vector of ISO codes and returns corresponding information based
#' on the specified option.
#'
#' @param iso Character vector of ISO3 country codes
#' @param opt Character string specifying the type of information to return. Options:
#'   \itemize{
#'     \item "Name": Country names
#'     \item "ISO2": ISO2 country codes
#'     \item "Region": Major geographical regions (AFRICA, AMERICAS, ASIA, EUROPE, OCEANIA)
#'     \item "Subregion": Detailed geographical regions (e.g., NORTH_AFRICA, WEST_ASIA)
#'     \item "Center-Periphery": Economic category (CTR_LDR, CTR_FOL, SMP_LDR, SMP_FOL, PERI)
#'     \item "Oil": Hydrocarbon status (HYD_EXP, HYD_IMP, or NA)
#'     \item "NaturalRent": Natural resource status (NRS_REN or NA)
#'     \item "Category": All categories the country belongs to
#'   }
#' @param verbose Logical, whether to print informative messages about special cases 
#'   (default: TRUE)
#' 
#' @return A character vector of the same length as the input iso vector containing the requested information.
#'         For "Category" option, returns a character vector of categories for each ISO code.
#'         For "ISO2" option, returns ISO2 codes (e.g., "US" for "USA").
#'         Returns NA for countries not found in the specified category or for invalid ISO codes.
#' 
#' @examples
#' # Get country names
#' wp_from_iso(c("USA", "FRA", "DEU"), "Name")
#' 
#' # Get ISO2 codes
#' wp_from_iso(c("USA", "GBR", "FRA"), "ISO2")  # Returns c("US", "GB", "FR")
#' 
#' # Get regions
#' wp_from_iso(c("CHN", "BRA"), "Region")
#' 
#' # Get oil status
#' wp_from_iso(c("SAU", "USA", "RUS"), "Oil")  # Returns c("HYD_EXP", NA, "HYD_EXP")
#' 
#' # Get economic categories
#' wp_from_iso(c("USA", "CHN", "ETH"), "Center-Periphery")
#'
#' @family country code conversion functions
#' @family country classification functions
#' @seealso 
#'   \code{\link{wp_ctry2iso}} for converting country names to ISO codes,
#'   \code{\link{wp_get_category}} for getting all countries in specific categories
#'
#' @export
wp_from_iso <- function(iso, 
                       opt = "Name",  # Alternative options: "ISO2", "Region", "Subregion", "Center-Periphery", "Oil", "NaturalRent", "Category"
                       verbose = TRUE
                        ) {
    # Input validation
    if (!is.character(iso)) {
        stop("iso must be a character vector")
    }
    
    # Convert input ISO codes to uppercase for case-insensitive matching
    iso <- toupper(iso)

    # Helper function to check if a country is in a category
    in_check_category <- function(iso_code, category) {
        return(iso_code %in% list_category2iso[[category]])
    }
    
    # Helper function to get region/subregion
    in_get_region <- function(iso_code, detailed = FALSE) {
        # Define region categories
        regions <- c("AFRICA", "AMERICAS", "ASIA", "EUROPE", "OCEANIA")
        subregions <- c("NORTH_AFRICA", "EAST_AFRICA", "MIDDLE_AFRICA", "WEST_AFRICA", "SOUTH_AFRICA",
                       "NORTH_AMERICA", "CARIBBEAN", "CENTRAL_AMERICA", "SOUTH_AMERICA",
                       "EAST_ASIA", "SOUTHEAST_ASIA", "SOUTH_ASIA", "WEST_ASIA", "CENTRAL_ASIA",
                       "WESTERN_EUROPE", "EASTERN_EUROPE",
                       "AUSTRALIA_NZ", "OTHER_OCEANIA")
        
        categories_to_check <- if(detailed) subregions else regions
        
        for (cat in categories_to_check) {
            if (in_check_category(iso_code, cat)) {
                return(cat)
            }
        }
        return(NA_character_)
    }
    
    # Helper function to get center-periphery classification
    in_get_center_periphery <- function(iso_code) {
        if (in_check_category(iso_code, "CTR_LDR")) return("CTR_LDR")
        if (in_check_category(iso_code, "CTR_FOL")) return("CTR_FOL")
        if (in_check_category(iso_code, "SMP_WLD") || in_check_category(iso_code, "SMP_RLD")) return("SMP_LDR")
        if (in_check_category(iso_code, "SMP_FOL")) return("SMP_FOL")
        if (in_check_category(iso_code, "PERI")) return("PERI")
        return(NA_character_)
    }
    
    # Convert opt to make the function cas insensitive
    opt <- tolower(opt)

    # Process based on option
    if (opt == "name") {
        out <- in_get_ctry_name(iso, verbose = verbose)
    } else if (opt == "category") {
        out <- in_get_ctry_categories(iso)
    } else if (opt == "region") {
        out <- sapply(iso, in_get_region, detailed = FALSE, USE.NAMES = FALSE)
    } else if (opt == "subregion") {
        out <- sapply(iso, in_get_region, detailed = TRUE, USE.NAMES = FALSE)
    } else if (opt == "center-periphery") {
        out <- sapply(iso, in_get_center_periphery, USE.NAMES = FALSE)
    } else if (opt == "oil") {
        out <- sapply(iso, function(x) {
            if (in_check_category(x, "HYD_EXP")) return("HYD_EXP")
            if (in_check_category(x, "HYD_IMP")) return("HYD_IMP")
            return(NA_character_)
        }, USE.NAMES = FALSE)
    } else if (opt == "naturalrent") {
        out <- sapply(iso, function(x) {
            if (in_check_category(x, "NRS_REN")) return("NRS_REN")
            return(NA_character_)
        }, USE.NAMES = FALSE)
    } else if (opt == "iso2") {
        # Get ISO2 codes by looking up the reverse mapping in list_iso2_to_iso3
        out <- sapply(iso, function(x) {
            # Find the ISO2 code that maps to this ISO3 code
            iso2 <- names(list_iso2_to_iso3)[list_iso2_to_iso3 == x]
            if (length(iso2) == 0) return(NA_character_)
            return(iso2[1])  # Return the first match if multiple exist
        }, USE.NAMES = FALSE)
    } else {
        stop("Invalid opt value. Must be one of: 'Name', 'ISO2', 'Region', 'Subregion', 'Center-Periphery', 'Oil', 'NaturalRent', 'Category'")
    }
    
    if (opt != "Category") {
        names(out) <- iso
    }

    return(out)
}






#' Get Countries Belonging to Specified Categories
#' 
#' @description Returns ISO3 codes for countries belonging to specified categories. 
#' Supports complex queries including category exclusions.
#'
#' @param input Character vector of category codes or ISO3 country codes. Can include
#'   exclusion patterns (e.g., "EUROPE-DEU" for European countries excluding Germany).
#' @param verbose Logical, whether to print reminder messages about specific countries 
#'   (default: TRUE)
#'
#' @return Character vector of ISO3 country codes belonging to the specified categories
#'
#' @details Categories include:
#'   \itemize{
#'     \item Economic: CTR_LDR, CTR_FOL, SMP_WLD, SMP_RLD, SMP_FOL, PERI
#'     \item Regional: AFRICA, AMERICAS, ASIA, EUROPE, OCEANIA
#'     \item Subregional: NORTH_AFRICA, WEST_ASIA, etc.
#'     \item Groups: BRICS, EU, ASEAN, etc.
#'     \item Resources: NRS_REN, HYD_EXP, HYD_IMP
#'   }
#'
#' @examples
#' # Get all center countries
#' center_countries <- wp_get_category("CTR")
#' 
#' # Get European countries excluding Germany
#' europe_except_germany <- wp_get_category("EUROPE-DEU")
#' 
#' # Get multiple categories
#' brics_and_eu <- wp_get_category(c("BRICS", "EU"))
#'
#' @family country classification functions
#' @seealso 
#'   \code{\link{wp_from_iso}} for getting specific information about countries,
#'   \code{\link{wp_ctry2iso}} for converting country names to ISO codes
#'
#' @export
wp_get_category <- function(input, verbose = TRUE) {
  # Input validation
  if (!is.character(input)) {
    stop("Input must be a character vector")
  }
  
  # Helper function to expand a single group
  expand_group <- function(group_name) {
    # Remove any whitespace
    group_name <- trimws(group_name)
    
    # Check if it's an exclusion pattern (contains "-")
    if (grepl("-", group_name)) {
      # Split the string into group and exclusions
      parts <- strsplit(gsub("\\s+", "", group_name), "-")[[1]]
      group <- parts[1]
      exclusions <- parts[-1]
      
      # Get the base group's ISO codes
      base_codes <- list_category2iso[[group]]
      if (!is.null(base_codes)) {
        return(setdiff(base_codes, exclusions))
      } else {
        return(character(0))
      }
    }
    
    # If not an exclusion pattern, check if it's a group name
    codes <- list_category2iso[[group_name]]
    if (!is.null(codes)) {
      return(codes)
    }
    
    # If not a group, then check if it's a direct ISO code
    if (nchar(group_name) == 3) {
      return(group_name)
    }
    
    # Return empty vector if group not found
    return(character(0))
  }
  
  # Print reminders for specific countries if verbose is TRUE
  if (verbose && any(input %in% c("CTR", "CTR_LDR", "CTR_FOL", "SMP", "SMP_LDR", "SMP_RLD", "SMP_FOL"))) {
    cat("Reminder: Notable exclusions from CTR/SMP categories:\n")
    cat("- South Korea (KOR)\n")
    cat("- Singapore (SGP)\n")
    cat("- Taiwan (TWN)\n")
    cat("Consider if these should be included in your analysis.\n\n")
  }
  
  # Process each input element and combine results
  result <- character(0)
  for (item in input) {
    result <- c(result, expand_group(item))
  }
  
  # Remove duplicates and return
  return(unique(result))
}









#################################################################################################################################
# Internal functions - helper for wp_from_iso


#' Convert ISO code to country name
#' 
#' Internal helper function that converts ISO3 codes to their corresponding country names
#' using a hierarchical lookup across multiple tables.
#'
#' @param iso_code Character vector of ISO3 country codes
#' @param verbose Logical, whether to print information about matches found in special or historical
#'   code lists (default: TRUE)
#'   
#' @return Character vector of country names. Returns NA for ISO codes not found in any lookup table.
#'   When verbose is TRUE, prints informative messages for:
#'   \itemize{
#'     \item Matches found in special/regional codes list
#'     \item Matches found in historical codes list
#'     \item ISO codes not found in any list
#'   }
#'
#' @details The function performs lookups in the following order:
#'   1. Current ISO codes (list_iso2country)
#'   2. Special and regional codes (list_iso2country_others)
#'   3. Historical codes (list_iso2country_old)
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' # Current ISO code
#' in_get_ctry_name("FRA")  # Returns "France"
#' 
#' # Special regional code
#' in_get_ctry_name("EMU")  # Returns "Euro Area" with note if verbose=TRUE
#' 
#' # Historical code
#' in_get_ctry_name("CSK")  # Returns "Czechoslovakia" with note if verbose=TRUE
#' 
#' # Multiple codes
#' in_get_ctry_name(c("USA", "EMU", "CSK"))  
#' # Returns c("United States", "Euro Area", "Czechoslovakia")
#' # with appropriate notes for EMU and CSK if verbose=TRUE
#' }
in_get_ctry_name <- function(iso_code, verbose = TRUE) {
  # Function to look up the country name for a single ISO code
  lookup_name <- function(code) {
    # First check in main current ISO list
    name <- list_iso2country[[code]]
    if (!is.null(name)) {
      return(name)
    }
    
    # If not found, check in others list
    name <- list_iso2country_others[[code]]
    if (!is.null(name)) {
        in_print_debug(sprintf("ISO code '%s' (%s) found in special/regional pseudo-ISO codes list", code, name), 
                    verbose, FALSE, "info", "Special")
        return(name)
    }
    
    # If still not found, check in historical list
    name <- list_iso2country_old[[code]]
    if (!is.null(name)) {
        in_print_debug(sprintf("ISO code '%s' (%s) found in historical ISO codes list", code, name), 
                    verbose, FALSE, "info", "Archive")
        return(name)
    }
    
    # If no match found in any list
    in_print_debug(sprintf("ISO not in any lists: %s", code),
                verbose, FALSE, "warning")
    return(NA)
  }
  
  # If input is a vector, apply the lookup function to each element
  if (length(iso_code) > 1) {
    return(sapply(iso_code, lookup_name))
  } else {
    return(lookup_name(iso_code))
  }
}



#' Get all categories that contain specific countries
#'
#' @param country_codes Character vector of ISO3 country codes
#'
#' @return Character vector of category names
#'
#' @keywords internal
in_get_ctry_categories <- function(country_codes) {
  if (!is.character(country_codes) || any(nchar(country_codes) != 3)) {
    stop("country_codes must be ISO3 codes")
  }
  
  result <- character(0)
  for (cat in list_categories) {
    category_countries <- wp_get_category(cat, verbose = FALSE)
    if (all(country_codes %in% category_countries)) {
      result <- c(result, cat)
    }
  }
  return(result)
}
in_get_ctry_categories <- function(country_codes) {
  if (!is.character(country_codes) || any(nchar(country_codes) != 3)) {
    stop("country_codes must be ISO3 codes")
  }
  
  result <- character(0)
  for (cat in list_categories) {
    category_countries <- wp_get_category(cat, verbose = FALSE)
    if (all(country_codes %in% category_countries)) {
      result <- c(result, cat)
    }
  }
  return(result)
}






#################################################################################################################################
# Internal functions - others




#' Get overlapping countries between two categories
#' 
#' @param category1 Character, first category name
#' @param category2 Character, second category name
#' @return Character vector of ISO3 codes present in both categories
#' @examples
#' eu_brics_overlap <- get_category_overlap("EU", "BRICS")
#' 
#' @keywords internal
#' @noRd
in_get_category_overlap <- function(category1, category2) {
  countries1 <- wp_get_category(category1, verbose = FALSE)
  countries2 <- wp_get_category(category2, verbose = FALSE)
  return(intersect(countries1, countries2))
}


#' Get countries that are in category1 but not in category2
#' 
#' @param category1 Character, first category name
#' @param category2 Character, second category name
#' @return Character vector of ISO3 codes present in category1 but not in category2
#' @examples
#' \dontrun{
#' # Find advanced economies (CTR) that are not in the European Union (EU)
#' ctr_not_eu <- in_get_category_difference("CTR", "EU")
#' # Returns: c("USA", "GBR", "JPN", "AUS", "CAN", "CHE", "ISL", "NOR", "NZL")
#' }
#' @keywords internal
#' @noRd
in_get_category_difference <- function(category1, category2) {
  countries1 <- wp_get_category(category1, verbose = FALSE)
  countries2 <- wp_get_category(category2, verbose = FALSE)
  return(setdiff(countries1, countries2))
}






