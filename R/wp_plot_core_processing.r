
#' Core Internal Plotting Function
#' 
#' @description
#' Internal function that handles the common plotting functionality across all plot types.
#' This function manages the overall plot creation process, including data preprocessing,
#' plot type selection, panel creation, legend handling, and output management.
#' 
#' @keywords internal
#'
#' @param data data.frame that must contain the following columns:
#'        - ISO: ISO 3-letter country codes
#'        - Date: dates in Date format
#'        - Variable: indicator names
#'        - Value: numeric values
#'        - Country: country names (optional, auto-generated from ISO if missing)
#'        - Reference: source citations (optional)
#' @param y_axis string/vector/TRUE/FALSE/NULL; axis labels configuration
#' @param plot_type string; type of plot to create:
#'        - "series": time series plot
#'        - "bar": bar plot
#'        - "scatter": scatter plot
#' @param filename string/NULL; output filename without extension:
#'        - If provided, saves plot as PNG and PDF
#'        - NULL for no file output
#' @param print logical; whether to display the plot
#' @param legend logical; whether to include legend panel
#' @param reference logical; whether to include references panel
#' @param title string/NULL; main title text
#' @param subtitle string/NULL; subtitle text
#' @param subfig_title logical/character; control subplot titles:
#'        - TRUE: auto-generate titles
#'        - Character vector: custom titles
#'        - FALSE: no titles
#' @param verbose logical; control information messages
#' @param debug logical; control debugging output
#' @param size numeric/NULL; plot size preset:
#'        - 1: small (10x7 inches)
#'        - 2: medium (15x7 inches)
#'        - 3: large (15x10 inches)
#'        - 4: extra large (20x10 inches)
#'        - NULL: auto-size based on data
#' @param base_size numeric; base font size in points
#' @param ... Additional arguments passed to specific plotting functions
#'
#' @details
#' This function serves as the central coordinator for all plotting operations:
#'
#' 1. Data Preprocessing:
#'    - Validates and normalizes input data
#'    - Converts dates to proper format
#'    - Handles missing/optional columns
#'
#' 2. Plot Type Selection:
#'    - Determines appropriate plotting function based on plot_type and data structure
#'    - Filters and validates type-specific arguments
#'
#' 3. Panel Management:
#'    - Creates main plot panel
#'    - Adds legend panel if requested
#'    - Adds references panel if requested
#'    - Manages panel layout and dimensions
#'
#' 4. Output Handling:
#'    - Controls plot display
#'    - Manages file output in multiple formats
#'    - Handles plot dimensions
#'
#' The function maintains consistent styling and behavior across all plot types
#' while allowing for type-specific customizations through the ... argument.
#'
#' @note
#' This is an internal function not meant to be called directly by users.
#' Use the public wp_plot_* functions instead.
#'
#' @return ggplot2 object containing the complete plot
#'
#' @seealso 
#' \code{\link{wp_plot_series}}
#' \code{\link{wp_plot_bar}}
#' \code{\link{wp_plot_scatter}}
in_plot_core <- function(data,                   # data.frame with required columns: ISO, Date, Variable, Value
                        y_axis = NULL,           # string/vector/TRUE/FALSE/NULL: axis labels configuration
                        plot_type = "series",    # "series"/"bar"/"scatter": type of plot to create
                        filename = NULL,         # string/NULL: output filename without extension for saving
                        print = TRUE,            # logical: whether to display the plot
                        legend = TRUE,           # logical: whether to add legend panel
                        reference = TRUE,        # logical: whether to add references panel
                        title = NULL,            # string/NULL: main title text
                        subtitle = NULL,         # string/NULL: subtitle text
                        subfig_title = TRUE,     # logical/character: control subplot titles
                        verbose = TRUE,          # logical: print processing information
                        debug = FALSE,           # logical: print debugging output
                        size = NULL,             # 1/2/3/4/NULL: plot size preset or auto-sizing
                        base_size = 16,          # numeric: base font size in points
                        ...) {                   # additional arguments passed to specific plotting functions

    # Capture all arguments
    all_args <- c(as.list(environment()), list(...))
    
    # Extract plot-specific args by removing common args
    common_args <- c("data", "y_axis", "plot_type", "filename", "print", 
                    "legend", "reference", "title", "subtitle",
                    "verbose", "debug", "size", "base_size")
    plot_specific_args <- all_args[!names(all_args) %in% common_args]

    # Common data preprocessing
    data <- in_fast_convert_dates(data)
    
    # Get plot dimensions once
    dimensions <- in_get_plot_dimensions(data = data, size = all_args$size)
    plot_specific_args$dimensions <- dimensions

    # print(paste0("all_args$color=", all_args$color))
    # print(paste0("plot_specific_args$subfig_title=", plot_specific_args$subfig_title))

    
    # Get appropriate plotting function and create base plot
    plot_func <- in_get_plot_function(
        data = data,
        plot_type = plot_type,
        plot_specific_args = plot_specific_args,
        verbose = verbose,
        debug = debug
    )
    
    # Filter arguments based on the plotting function
    filtered_args <- in_filter_args(plot_func, 
                               plot_specific_args, 
                               verbose = verbose, 
                               debug = debug)
    
    # Create base plot with filtered type-specific arguments
    base_plot <- do.call(plot_func, 
                        c(list(data = data,
                             y_axis = y_axis,
                             base_size = base_size),
                          filtered_args))
    
    # Remove legend from base plot
    plot_without_legend <- base_plot + theme(legend.position = "none")
    
    # Initialize panels
    panels <- list()
    # Main plot height
    heights <- c(20)  

    # Add legend panel if requested
    if (legend) {
        legend_fill <- isTRUE(plot_specific_args$area)
        adjust_right_axis <- if (!is.null(plot_specific_args$right_axis)) 0.8 else 1
        
        legend_result <- in_create_legend_panel(
            base_plot = base_plot,
            data = data,
            plot_type = plot_type,
            legend_fill = legend_fill,
            plot_width_inches = dimensions["width"] * adjust_right_axis,
            base_size = base_size,
            verbose = verbose,
            debug = debug
        )
        panels$legend <- legend_result$panel
        extra_leg_height <- if (plot_type == "bar" && !is.null(plot_specific_args$color)) 2 else 0
        heights <- c(heights, legend_result$height + extra_leg_height)
    }
    
    # Add references panel if requested
    if (reference) {
        panels$reference <- in_create_references_panel(
            reference_col = data$Reference,
            dim = dimensions,
            base_size = base_size,
            verbose = verbose,
            debug = debug
        )
        heights <- c(heights, 1.5)
    }
    
    # Combine all panels
    panel_list <- c(list(plot_without_legend), panels)
    final_plot <- wrap_plots(panel_list, ncol = 1, heights = heights)
    
    # Add title and subtitle if provided
    title_result <- in_create_title_panel(
        title = title,
        subtitle = subtitle,
        base_size = base_size
    )
    if (title_result$has_title) {
        final_plot <- final_plot + title_result$annotation
        dimensions["height"] <- dimensions["height"] + 1  # Add extra inch for title/subtitle
    }
    
    # Print and save
    in_print_and_save(plot = final_plot, print = print, filename = filename, dim = dimensions)
    
    return(final_plot)
}




#' Determine Appropriate Plotting Function Based on Data and Parameters
#' 
#' @description
#' Internal router that selects the specialized plotting function based on data 
#' characteristics (number of countries/indicators) and plot specifications.
#' Central decision point for all plotting operations.
#' 
#' Used by: in_plot_core
#' Uses: No direct function calls
#' 
#' Returns references to specialized plotting functions:
#' - For series: in_plot_one_ctry_area, in_plot_multi_indic_one_ctry, etc.
#' - For bar: in_plot_one_indic_bar, in_plot_multi_indic_bar 
#' - For scatter: in_plot_scatter_two_vars, in_plot_scatter_multi_vars
#'
#' @keywords internal
in_get_plot_function <- function(data,                    # data.frame with required columns for plotting
                                plot_type,                # string: "series"/"bar"/"scatter" - determines branch of logic to use
                                plot_specific_args,        # list of arguments specific to chosen plot type
                                verbose = TRUE,           # logical: controls information message output
                                debug = FALSE) {          # logical: controls debug message output
    # Calculate dimensions from data
    n_countries <- length(unique(data$Country))
    n_indicators <- length(unique(data$Variable))
    
    if (plot_type == "series") {
        # Existing series logic remains unchanged
        if (n_countries == 1 && n_indicators > 1 && plot_specific_args$area) {
            in_print_debug("call 'in_plot_one_ctry_area'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_one_ctry_area)
            
        } else if (n_countries == 1 && n_indicators >= 1 && is.null(plot_specific_args$right_axis)) {
            in_print_debug("call 'in_plot_multi_indic_one_ctry'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_multi_indic_one_ctry)
            
        } else if (n_countries %in% c(1,2) && n_indicators > 1 && !is.null(plot_specific_args$right_axis)) {
            in_print_debug("call 'in_plot_multi_indic_one_ctry_two_axes'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_multi_indic_one_ctry_two_axes)
            
        } else if (n_countries > 1 && n_indicators == 1) {
            in_print_debug("call 'in_plot_one_indic_multi_ctry'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_one_indic_multi_ctry)
            
        # Multiple plots
        } else if (n_countries > 1 && n_indicators > 1 && plot_specific_args$area) {
            in_print_debug("call 'in_plot_multi_area'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_multi_area)

        } else if (n_countries > 1 && n_indicators > 1 && plot_specific_args$by_indicator) {
            in_print_debug("call 'in_plot_multi_by_indic'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_multi_by_indic)
            
        } else if (n_countries > 1 && n_indicators > 1 && !plot_specific_args$by_indicator) {
            in_print_debug("call 'in_plot_multi_by_ctry'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_multi_by_ctry)
        }
        
    } else if (plot_type == "bar") {
        # Existing bar logic remains unchanged
        if (n_countries >= 1 && n_indicators == 1) {
            in_print_debug("call 'in_plot_one_indic_bar'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_one_indic_bar)
        } else if (n_countries >= 1 && n_indicators > 1) {
            in_print_debug("call 'in_plot_multi_indic_bar'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_multi_indic_bar)
        }
        
    } else if (plot_type == "scatter") {
        if (n_indicators == 2) {
            in_print_debug("call 'in_plot_scatter_two_vars'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_scatter_two_vars)
        } else if (n_indicators > 2) {
            in_print_debug("call 'in_plot_scatter_multi_vars'", verbose, debug, type = "info", "SUBPLOT")
            return(in_plot_scatter_multi_vars)
        } else {
            stop("Scatter plots require at least 2 variables")
        }
    }
    
    stop("Invalid plot configuration")
}





#' Calculate Plot Dimensions Based on Data or Size Preset
#' 
#' @description
#' Internal function that determines appropriate plot dimensions (width/height in inches)
#' based on either data characteristics or a specified size preset.
#' Ensures consistent sizing across different plot types.
#' 
#' Used by: in_plot_core, in_create_legend_panel, in_create_references_panel
#' Uses: No direct function calls
#' 
#' Size presets:
#' - 1: Small (10x7) - Simple plots
#' - 2: Medium (15x7) - Wider plots
#' - 3: Large (15x10) - Complex plots
#' - 4: Extra large (20x10) - Very detailed plots
#'
#' @keywords internal
in_get_plot_dimensions <- function(data = NULL,          # data.frame: used for auto-sizing if size not specified
                                  size = NULL) {         # numeric 1-4: manual size preset, overrides data-based sizing
    # Determine size if not provided
    if (is.null(size) && !is.null(data)) {
        n_countries <- length(unique(data$Country))
        n_indicators <- length(unique(data$Variable))
        
        size <- if (n_countries == 1 || (n_countries > 1 && n_indicators == 1)) {
            1  # Single country or multiple countries with one indicator
        } else if (n_countries > 1 && n_indicators == 1) {
            2  # Multiple countries with one indicator (larger width)
        } else {
            3  # Multiple countries with multiple indicators
        }
    }
    
    # Default to size 1 if still NULL
    size <- if(is.null(size)) 1 else size
    
    # Define dimensions based on size with fixed height ratios
    dimensions <- switch(size,
        c(width = 10, height = 7),    # size 1
        c(width = 15, height = 7),    # size 2
        c(width = 15, height = 10),   # size 3
        c(width = 20, height = 10)    # size 4
    )
    
    return(dimensions)
}

#' Filter and Validate Function Arguments
#' 
#' @description
#' Internal function that filters argument lists against function parameters,
#' removing irrelevant arguments and providing debug information about argument usage.
#' Helps prevent invalid argument passing between functions.
#' 
#' Used by: in_plot_core
#' Uses: in_print_debug
#' 
#' Important for maintaining clean function interfaces and debugging argument flow
#' through the plotting system.
#'
#' @keywords internal
in_filter_args <- function(func,                    # function: target function to check arguments against
                          args,                     # list: arguments to filter
                          verbose = FALSE,          # logical: controls information message output
                          debug = FALSE) {          # logical: controls detailed debug message output
    valid_args <- names(formals(func))
    unused_args <- names(args)[!names(args) %in% valid_args]
    used_args <- names(args)[names(args) %in% valid_args]
    
    if(length(unused_args) > 0) {
        msg <- paste0("Unused arguments for function '", deparse(substitute(func)), "': ",
                     paste(unused_args, collapse = ", "))
        in_print_debug(msg, verbose, debug, type = "info", "ARGS")
    }
    
    if(verbose && debug) {
        msg <- paste0("Used arguments: ", paste(used_args, collapse = ", "))
        in_print_debug(msg, verbose, debug, type = "info", "ARGS")
    }
    
    return(args[names(args) %in% valid_args])
}






