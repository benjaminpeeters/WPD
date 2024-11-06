# R/zzz.R
# can skip zzz.R entirely - it's just for optional startup messages.

# Functions run automatically at specific times:
# .onAttach: Runs when someone loads your package with library()
# .onUnload: Runs when package is unloaded



.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Data will be loaded when wp_data() is first used")
}

.onUnload <- function(libpath) {
    # Clean up when package is unloaded
    rm(list = ls(.pkgenv), envir = .pkgenv)
}
