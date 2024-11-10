
# Build vignettes first to ensure they're up to date
devtools::build_vignettes()

# Render README.md from README.Rmd
rmarkdown::render("README.Rmd")
