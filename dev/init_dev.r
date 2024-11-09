
# Step 1: Clear the environment
rm(list = ls(envir = .GlobalEnv), envir = .GlobalEnv)

# Step 2: Detach all non-essential packages
detach_all_packages <- function() {
  # List of base packages that should not be detached
  basic_packages <- c("package:base", "package:stats", "package:graphics", 
                      "package:grDevices", "package:utils", "package:datasets", 
                      "package:methods")
  
  # Get all currently loaded packages
  loaded_packages <- search()
  
  # Identify packages to detach (those that start with "package:" but are not in basic packages)
  to_detach <- setdiff(loaded_packages[grepl("^package:", loaded_packages)], basic_packages)
  
  # Detach each package
  for (pkg in to_detach) {
    detach(pkg, character.only = TRUE, unload = TRUE)
  }
}
detach_all_packages()

# Step 3: Unload package namespace if already loaded
if ("WPD" %in% loadedNamespaces()) {
  unloadNamespace("WPD")
}

# Step 4: Garbage collection
gc()

# Step 5: Load package and run your code
library(devtools)
load_all()  # Load the package functions



# Better printing width
options(width = 190)  
