

get_iso_codes <- function() {
    data_q <- in_data_load()
    return(unique(data_q$ISO))
}


library(devtools)
load_all()  # Load the package functions

# Test getting ISO codes
iso_codes <- get_iso_codes()
print(iso_codes)


