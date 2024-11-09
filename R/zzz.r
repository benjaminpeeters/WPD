# R/zzz.R
# can skip zzz.R entirely - it's just for optional startup messages.

# Functions run automatically at specific times:
# .onAttach: Runs when someone loads your package with library()
# .onUnload: Runs when package is unloaded


# .onAttach <- function(libname, pkgname) {
#     packageStartupMessage("\033[0;36m [START] Data will be loaded when wp_data() is first used \033[0m")
# }


.onUnload <- function(libpath) {
    # Clean up when package is unloaded
    rm(list = ls(.pkgenv), envir = .pkgenv)
}
