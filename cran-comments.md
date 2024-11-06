# Package size note

This package includes a 50MB database in inst/extdata that is essential for the use of wp_data(). 
The data is:
1. Only loaded when explicitly requested by package functions
2. Necessary for the core functionality of the package
3. Cannot be reasonably reduced in size without compromising functionality
