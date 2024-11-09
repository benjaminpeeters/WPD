# 1. First clean everything
unlink("man", recursive = TRUE)
unlink("docs", recursive = TRUE)
unlink("NAMESPACE")
rm(list = ls())
gc()

# 2. Run roxygen with error checking
options(roxygen.check = TRUE)
devtools::document(roclets = c("rd", "collate", "namespace"))

# 3. If that succeeds, try building the site with more verbose output
options(pkgdown.internet = FALSE) # Disable external internet access
pkgdown::build_site(devel = TRUE, preview = FALSE)

# Might require to install the latest version:
# Install latest version from GitHub
# remotes::install_github("r-lib/pkgdown")
