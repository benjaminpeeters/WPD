



#' Create Time Series Plots with Multiple Configuration Options
#' 
#' @description
#' Creates time series plots with support for single or multiple indicators,
#' single or multiple countries, stacked area plots, dual axes, and various visual
#' customizations (e.g., references and legend). 
#' The function automatically determines the most appropriate plot type
#' based on the input data structure and specified parameters.
#' 
#' @param data data.frame that must contain the following columns:
#'        - ISO: ISO 3-letter country codes (required)
#'        - Date: dates in Date format (required)
#'        - Variable: indicator names (required)
#'        - Value: numeric values (required)
#'        - Country: country names (optional, auto-generated from ISO if missing)
#'        - Reference: source citations (required if reference=TRUE)
#' @param y_axis Single string, vector of strings, TRUE, FALSE, or NULL:
#'        - Single string: common y-axis label for all plots
#'        - Vector of strings: individual labels for each plot/axis
#'        - TRUE: use Variable names as labels
#'        - FALSE/NULL: no axis labels
#'        For dual axis plots, must be vector of length 2 for left and right axes.
#'        For multi-indicator plots, length must match number of indicators.
#' @param right_axis controls the right y-axis behavior:
#'        - NULL/FALSE: no right axis (default)
#'        - TRUE: automatically assigns variables to right axis based on scale
#'        - character vector: names of variables to assign to right axis
#'        Only available for plots with 2 or more indicators.
#'        Cannot be used with area=TRUE.
#' @param key_dates data.frame for marking significant events:
#'        - Must have exactly 2 columns
#'        - Column 1: event descriptions
#'        - Column 2: corresponding dates in Date format
#'        - Events outside plot date range are automatically filtered
#'        - NULL for no event markers
#' @param area logical; if TRUE, creates a stacked area plot:
#'        - Only for single-country, multi-indicator plots
#'        - First variable shown as line on top of stacked areas
#'        - Cannot be used with right_axis=TRUE
#'        Default is FALSE.
#' @param by_indicator logical; controls faceting in multi-panel plots:
#'        - TRUE: creates separate panels for each indicator
#'        - FALSE: creates separate panels for each country
#'        - Ignored for single country or single indicator plots
#'        Default is TRUE.
#' @param filename character string for saving plots:
#'        - Specify name without extension
#'        - Plots saved as both PNG and PDF in 'img/' directory
#'        - NULL/FALSE for no file output
#' @param print logical; controls plot display:
#'        - TRUE: displays the plot
#'        - FALSE: creates but doesn't display the plot
#'        Default is TRUE.
#' @param legend logical; controls legend display:
#'        - TRUE: includes a legend
#'        - FALSE: omits the legend
#'        Default is TRUE.
#' @param reference logical; controls reference panel:
#'        - TRUE: includes reference citations panel (requires Reference column)
#'        - FALSE: omits reference panel
#'        - Automatically set to FALSE if Reference column missing/empty
#'        Default is TRUE.
#' @param title character string for main plot title:
#'        - NULL/FALSE for no title
#' @param subtitle character string for plot subtitle:
#'        - NULL/FALSE for no subtitle
#' @param subfig_title controls subplot titles in multi-panel plots:
#'        - TRUE: uses default titles (Variable or Country names)
#'        - FALSE: no subplot titles
#'        - Character vector: custom titles (length must match number of panels)
#'        - Ignored for single panel plots
#'        Default is TRUE.
#' @param verbose logical; controls information messages:
#'        - TRUE: prints processing information
#'        - FALSE: suppresses information messages
#'        Default is TRUE.
#' @param debug logical; controls debugging output:
#'        - TRUE: prints detailed debugging information
#'        - FALSE: suppresses debugging information
#'        Default is FALSE.
#' @param size numeric or NULL; controls plot dimensions:
#'        - 1: small (10x7 inches)
#'        - 2: medium (15x7 inches)
#'        - 3: large (15x10 inches)
#'        - 4: extra large (20x10 inches)
#'        - NULL: auto-sizes based on data
#' @param base_size numeric; base font size in points:
#'        - Controls text size throughout the plot
#'        - Must be positive number
#'        - Default is 16
#'
#' @return A ggplot2 object containing the time series plot
#'
#' @details
#' The function automatically selects the appropriate plotting implementation based on
#' the data structure and parameters:
#'
#' * Single country, multiple indicators:
#'   - Basic line plot (default)
#'   - Stacked area plot (if area = TRUE)
#'   - Dual axis plot (if right_axis specified)
#'
#' * Multiple countries, single indicator:
#'   - Multi-line plot with color-coded countries
#'
#' * Multiple countries, multiple indicators:
#'   - Faceted plot by indicator (if by_indicator = TRUE)
#'   - Faceted plot by country (if by_indicator = FALSE)
#'
#' The function includes multiple features for customization:
#' - Automatic axis scaling and formatting
#' - Event markers with customizable labels
#' - Reference panel for data sources
#' - Flexible legend positioning
#' - Consistent theme across all plot types
#'
#' @examples
#' # Basic time series for one country and multiple indicators
#' data <- data.frame(
#'   Date = rep(seq(as.Date("2000-01-01"), as.Date("2020-01-01"), by = "year"), 2),
#'   ISO = "FRA",
#'   Variable = rep(c("GDP", "Inflation"), each = 21),
#'   Value = c(rnorm(21, 2, 0.5), rnorm(21, 3, 1)),
#'   Reference = "World Bank"
#' )
#' wp_plot_series(data, y_axis = "Percent")
#'
#' # Dual axis plot with manual axis assignment
#' wp_plot_series(data, 
#'                y_axis = c("GDP Growth (%)", "Inflation (%)"),
#'                right_axis = "Inflation")
#'
#' # Stacked area plot
#' wp_plot_series(data, 
#'                y_axis = "Percent",
#'                area = TRUE)
#'
#' # Multiple countries with event markers
#' data_multi <- data.frame(
#'   Date = rep(seq(as.Date("2000-01-01"), as.Date("2020-01-01"), by = "year"), 4),
#'   ISO = rep(c("FRA", "DEU"), each = 42),
#'   Variable = rep(rep(c("GDP", "Inflation"), each = 21), 2),
#'   Value = rnorm(84, 2, 0.5),
#'   Reference = "World Bank"
#' )
#' events <- data.frame(
#'   Event = c("Financial Crisis", "Euro Crisis"),
#'   Date = as.Date(c("2008-09-15", "2010-05-01"))
#' )
#' wp_plot_series(data_multi,
#'                y_axis = "Percent",
#'                key_dates = events,
#'                by_indicator = TRUE)
#'
#' @seealso 
#' \code{\link{wp_plot_bar}} for bar plots
#' \code{\link{wp_plot_scatter}} for scatter plots
#' \code{\link{wp_from_iso}} for ISO code to country name conversion
#'
#' @family plotting functions
#' @export
wp_plot_series <- function(data,                # data.frame with required columns: ISO, Date, Variable, Value; Country auto-generated if missing; Reference needed if reference=TRUE
                          y_axis = NULL,        # string/vector/TRUE/FALSE/NULL: axis labels (single, dual, or per-indicator)
                          right_axis = NULL,    # TRUE/FALSE/NULL/char vector: variables for right axis; TRUE for auto-assignment
                          key_dates = NULL,     # data.frame with 2 cols or NULL: event descriptions and dates
                          area = FALSE,         # logical: create stacked area plot for single country multi-indicator
                          by_indicator = TRUE,  # logical: facet by indicator (TRUE) or country (FALSE) for multi-panel plots
                          filename = NULL,      # string/NULL/FALSE: output filename without extension (saved as PNG and PDF)
                          print = TRUE,         # logical: display the plot
                          legend = TRUE,        # logical: include legend
                          reference = TRUE,     # logical: include reference panel (requires Reference column)
                          title = NULL,         # string/NULL/FALSE: main title
                          subtitle = NULL,      # string/NULL/FALSE: subtitle
                          subfig_title = TRUE,  # TRUE/FALSE/char vector: titles for multi-panel plots
                          verbose = TRUE,       # logical: print processing information
                          debug = FALSE,        # logical: print detailed debugging information
                          size = NULL,          # 1-4 or NULL: plot size presets or auto-sizing
                          base_size = 16) {     # numeric: base font size in points, must be positive
    
    args <- as.list(environment())
    args$plot_type <- "series"
    
    # Validate args
    validated_args <- in_validate_series_args(args)
    
    # Call core plotting function
    do.call(in_plot_core, validated_args)
}





#######################################################################################################################################################
# BASIC PLOTS


#' Create Multi-Line Plot for One Country
#' 
#' @description
#' Internal function that creates a simple multi-line plot for multiple indicators
#' in a single country. Basic implementation for time series comparison.
#' 
#' Used by: wp_plot_series (via in_plot_core), in_plot_multi_by_ctry
#' Uses: in_scale_y, in_scale_x, in_theme_plot, in_add_date_markers
#' 
#' Features:
#' - Multiple indicators as separate lines
#' - Consistent color coding
#' - Single y-axis scaling
#' - Optional key date markers
#'
#' @keywords internal
in_plot_multi_indic_one_ctry <- function(data,                    # data.frame: input data for single country
                                           y_axis = NULL,            # string/NULL: y-axis label
                                           key_dates = NULL,         # data.frame/NULL: event markers data
                                           base_size = 16) {         # numeric: base font size in points
    
    plot <- ggplot(data, aes(x = Date, y = Value, color = Variable)) +
        geom_line(linewidth = 1.2) +
        in_scale_y(y_axis) +
        scale_color_manual(values = custom_colors[1:length(unique(data$Variable))]) +
        in_scale_x(data) +
        labs(x = NULL, color = "") +
        in_theme_plot(base_size = base_size)
    
    # Add key dates if specified
    plot <- in_add_date_markers(plot, key_dates)
    
    return(plot)
}



#' Create Multi-Line Plot for Multiple Countries
#' 
#' @description
#' Internal function that creates a line plot comparing one indicator across
#' multiple countries. Used for cross-country comparison over time.
#' 
#' Used by: wp_plot_series (via in_plot_core), in_plot_multi_by_indic
#' Uses: in_scale_y, in_scale_x, in_theme_plot, in_add_date_markers
#' 
#' Features:
#' - One line per country
#' - Color coding by country
#' - Single scale
#' - Optional key date markers
#'
#' @keywords internal
in_plot_one_indic_multi_ctry <- function(data,                    # data.frame: input data for multiple countries
                                             y_axis = NULL,            # string/NULL: y-axis label
                                             key_dates = NULL,         # data.frame/NULL: event markers data
                                             base_size = 16) {         # numeric: base font size in points
    
    plot <- ggplot(data, aes(x = Date, y = Value, color = Country)) +
        geom_line(linewidth = 1.2) +
        in_scale_y(y_axis) +
        scale_color_manual(values = custom_colors[1:length(unique(data$Country))]) +
        in_scale_x(data) +
        labs(x = NULL,
             y = y_axis,
             color = "") +
        in_theme_plot(base_size = base_size)
    
    # Add key dates if specified
    plot <- in_add_date_markers(plot, key_dates)
    
    return(plot)
}



#######################################################################################################################################################
# BASIC MULTI PLOTS


#' Create Panel Plot with Indicators as Facets
#' 
#' @description
#' Internal function that creates a multi-panel plot with one panel per indicator.
#' Each panel shows cross-country comparison for one indicator.
#' 
#' Used by: wp_plot_series (via in_plot_core)
#' Uses: in_plot_one_indic_multi_ctry, in_add_date_markers, wrap_plots
#' 
#' Features:
#' - One panel per indicator
#' - Consistent scales across panels
#' - Panel titles
#' - Shared legend
#' - Optional key date markers
#'
#' @keywords internal
in_plot_multi_by_indic <- function(data,                    # data.frame: input data
                                     y_axis = NULL,            # vector/NULL: y-axis labels for each panel
                                     key_dates = NULL,         # data.frame/NULL: event markers data
                                     base_size = 16,           # numeric: base font size in points
                                     subfig_title = TRUE) {    # logical/character: panel titles

    
    indicators_list <- unique(data$Variable)
    n_indicators <- length(indicators_list)
    
    # Assuming subfig_title can be NULL, TRUE, FALSE, or a character vector
    add_subfig_title <- isTRUE(subfig_title) || is.character(subfig_title)

    # If not specified but TRUE, use column Variable
    subfig_title <- if (isTRUE(subfig_title)) indicators_list else subfig_title
    y_axis <- if (isTRUE(y_axis)) indicators_list else y_axis


    # Create plots without legends
    plot_list <- lapply(1:n_indicators, function(i) {
        subdata <- data[data$Variable == indicators_list[i],]
        plot <- in_plot_one_indic_multi_ctry(
            data = subdata,
            y_axis = y_axis[i],
            key_dates = NULL,
            base_size = base_size
        )
        # Add key dates if specified
        plot <- in_add_date_markers(plot, key_dates, add_subfig_title)

        # Add title with extra margin if key_dates are present
        if (add_subfig_title) {
            plot <- plot + ggtitle(subfig_title[i]) +
                theme(plot.title = element_text(
                                            size = base_size,  # Scale title size
                                            margin = margin(b = ifelse(!is.null(key_dates), 25, 5), t = 0, unit = "pt")
                                            ))
        }
        
        # Remove legend
        plot + theme(legend.position = "none")
    })
    
    # Combine plots in a grid
    combined_plot <- wrap_plots(plot_list)
    
    return(combined_plot)
}


#' Create Panel Plot with Countries as Facets
#' 
#' @description
#' Internal function that creates a multi-panel plot with one panel per country.
#' Each panel shows multiple indicators for one country.
#' 
#' Used by: wp_plot_series (via in_plot_core)
#' Uses: in_plot_multi_indic_one_ctry, in_add_date_markers, wrap_plots
#' 
#' Features:
#' - One panel per country
#' - Consistent scales across panels
#' - Panel titles
#' - Shared legend
#' - Optional key date markers
#'
#' @keywords internal
in_plot_multi_by_ctry <- function(data,                    # data.frame: input data
                                    y_axis = NULL,            # vector/NULL: y-axis labels for each panel
                                    key_dates = NULL,         # data.frame/NULL: event markers data
                                    base_size = 16,           # numeric: base font size in points
                                    subfig_title = TRUE) {    # logical/character: panel titles
    
    # Get list of unique countries
    countries_list <- unique(data$Country)
    n_countries <- length(countries_list)

    # Assuming subfig_title can be NULL, TRUE, FALSE, or a character vector
    add_subfig_title <- isTRUE(subfig_title) || is.character(subfig_title)

    # If not specified but TRUE, use column Country
    subfig_title <- if (isTRUE(subfig_title)) countries_list else subfig_title
    y_axis <- if (isTRUE(y_axis)) countries_list else y_axis
    
    # Create plots without legends, one for each country
    plot_list <- lapply(1:n_countries, function(i) {
        # Filter data for current country
        subdata <- data[data$Country == countries_list[i],]
        
        # Use existing in_plot_multi_indic_one_ctry function
        plot <- in_plot_multi_indic_one_ctry(
            data = subdata,
            y_axis = y_axis[i],
            key_dates = NULL,
            base_size = base_size
        )
        # Add key dates if specified
        plot <- in_add_date_markers(plot, key_dates, add_subfig_title)

        # Add title only if title parameter is TRUE
        if (add_subfig_title) {
            plot <- plot + ggtitle(subfig_title[i]) +
                theme(plot.title = element_text(
                                            size = base_size,  # Scale title size
                                            margin = margin(b = ifelse(!is.null(key_dates), 25, 5), t = 0, unit = "pt")
                                            ))
        }
        
        # Remove legend
        plot + theme(legend.position = "none")

    })
    
    # Combine plots in a grid
    combined_plot <- wrap_plots(plot_list)
    
    return(combined_plot)
}






#######################################################################################################################################################
# AREA PLOTS




#' Create Stacked Area Plot for One Country
#' 
#' @description
#' Internal function that creates a stacked area plot with first variable as line.
#' Used for showing composition over time for multiple indicators in one country.
#' 
#' Used by: wp_plot_series (via in_plot_core)
#' Uses: reshape, in_scale_y, in_scale_x, in_theme_plot, in_add_date_markers
#' 
#' Features:
#' - First variable plotted as line on top
#' - Remaining variables as stacked areas
#' - Custom color palette with black line for first variable
#' - Optional key date markers
#'
#' @keywords internal
in_plot_one_ctry_area <- function(data,                    # data.frame: input data for single country
                                    y_axis = NULL,            # string/NULL: y-axis label
                                    key_dates = NULL,         # data.frame/NULL: event markers data
                                    base_size = 16) {         # numeric: base font size in points

    # Ensure data is ordered by Date
    data <- data[order(data$Date), ]
    variable_order <- unique(data$Variable)
    sum_variable <- variable_order[1]
    
    # Prepare data for area plot
    wide_data <- reshape(data[, c("Date", "Country", "Variable", "Value")],
                        direction = "wide",
                        idvar = c("Date", "Country"),
                        timevar = "Variable",
                        v.names = "Value")
    
    colnames(wide_data) <- gsub("Value\\.", "", colnames(wide_data))
    
    data_area <- reshape(wide_data,
                             direction = "long",
                             varying = variable_order,
                             v.names = "Value",
                             timevar = "Variable",
                             times = variable_order)
    
    data_area$Variable <- factor(data_area$Variable, levels = variable_order)
    
    color_palette <- c("black", custom_colors[2:length(variable_order)])
    names(color_palette) <- variable_order
    
    # Create plot
    plot <- ggplot(data_area, aes(x = Date, y = Value)) +
        geom_area(data = subset(data_area, Variable != sum_variable),
                 aes(fill = Variable), position = "stack") +
        geom_line(data = subset(data_area, Variable == sum_variable),
                 aes(color = Variable), linewidth = 1.2) +
        in_scale_y(y_axis) +
        in_scale_x(data) +
        scale_fill_manual(values = color_palette[-1], breaks = variable_order[-1]) +
        scale_color_manual(values = color_palette[1], breaks = variable_order[1]) +
        labs(x = NULL, fill = "", color = "") +
        in_theme_plot(base_size = base_size) +
        guides(fill = guide_legend(order = 2),
               color = guide_legend(override.aes = list(linetype = 1, shape = NA)),
               fill = guide_legend(override.aes = list(linetype = 0, shape = 15)))
    
    # Add key dates if specified
    plot <- in_add_date_markers(plot, key_dates)
    
    return(plot)
}


#' Create Multi-Panel Area Plots
#' 
#' @description
#' Internal function that creates a multi-panel plot with stacked areas for multiple
#' countries. Each panel shows composition over time for one country.
#' 
#' Used by: wp_plot_series (via in_plot_core)
#' Uses: in_plot_one_ctry_area, in_add_date_markers, wrap_plots
#' 
#' Features:
#' - One stacked area panel per country
#' - Consistent scales across panels
#' - Optional panel titles
#' - Shared legend
#' - Key date markers support
#' - First variable as line on areas
#'
#' @keywords internal
in_plot_multi_area <- function(data,                    # data.frame: input data for multiple countries
                              y_axis = NULL,            # vector/NULL: y-axis labels for each panel
                              key_dates = NULL,         # data.frame/NULL: event markers data
                              base_size = 16,           # numeric: base font size in points
                              subfig_title = TRUE) {    # logical/character: panel titles
    
    # Get list of unique countries
    countries_list <- unique(data$Country)
    n_countries <- length(countries_list)

    # Assuming subfig_title can be NULL, TRUE, FALSE, or a character vector
    add_subfig_title <- isTRUE(subfig_title) || is.character(subfig_title)

    # If not specified but TRUE, use column Country
    subfig_title <- if (isTRUE(subfig_title)) countries_list else subfig_title
    y_axis <- if (isTRUE(y_axis)) countries_list else y_axis
    
    # Create plots without legends, one for each country
    plot_list <- lapply(1:n_countries, function(i) {
        # Filter data for current country
        subdata <- data[data$Country == countries_list[i],]
        
        # Use existing in_plot_multi_indic_one_ctry function
        plot <- in_plot_one_ctry_area(
            data = subdata,
            y_axis = y_axis[i],
            key_dates = NULL,
            base_size = base_size
        )
        # Add key dates if specified
        plot <- in_add_date_markers(plot, key_dates, add_subfig_title)

        # Add title only if title parameter is TRUE
        if (add_subfig_title) {
            plot <- plot + ggtitle(subfig_title[i]) +
                theme(plot.title = element_text(
                                            size = base_size,  # Scale title size
                                            margin = margin(b = ifelse(!is.null(key_dates), 25, 5), t = 0, unit = "pt")
                                            ))
        }
        
        # Remove legend
        plot + theme(legend.position = "none")

    })
    
    # Combine plots in a grid
    combined_plot <- wrap_plots(plot_list)
    
    return(combined_plot)
}




#######################################################################################################################################################
# DUAL-AXIS PLOTS



#' Create Dual-Axis Plot for One Country
#' 
#' @description
#' Internal function that creates a plot with two y-axes for different scales.
#' Handles automatic or manual assignment of variables to axes based on scales.
#' 
#' Used by: wp_plot_series (via in_plot_core)
#' Uses: in_assign_axes, in_scale_x, in_theme_plot, in_add_date_markers
#' 
#' Features:
#' - Two independent y-axes
#' - Automatic scale normalization
#' - Manual or automatic variable assignment
#' - Legend with axis indication
#'
#' @keywords internal
in_plot_multi_indic_one_ctry_two_axes <- function(data,                    # data.frame: input data for single country
                                                    y_axis = NULL,            # vector/NULL: labels for both axes
                                                    key_dates = NULL,         # data.frame/NULL: event markers data
                                                    right_axis = TRUE,        # logical/character: variables for right axis
                                                    base_size = 16,           # numeric: base font size in points
                                                    verbose = TRUE,           # logical: controls information messages
                                                    debug = FALSE) {          # logical: controls debug messages
    
    # Validate inputs
    if(length(unique(data$Variable)) < 2) {
        stop("Need at least 2 indicators for two-axis plot")
    }
    
    if(!is.null(y_axis) && length(y_axis) != 2) {
        stop("y_axis must be NULL or a vector of length 2")
    }
    
    # Determine right axis indicators if not specified
    if(isTRUE(right_axis)) {
        right_indicators <- in_assign_axes(data, verbose, debug)
    } else {
        right_indicators <- right_axis
    }
    
    # Validate right_axis
    if(!all(right_indicators %in% unique(data$Variable))) {
        stop("Invalid right_axis specified")
    }
    
    # Split data into left and right axis indicators
    left_data <- subset(data, !Variable %in% right_indicators)
    right_data <- subset(data, Variable %in% right_indicators)
    
    # Calculate scaling factor for right axis
    left_max <- max(abs(left_data$Value), na.rm = TRUE)
    right_max <- max(abs(right_data$Value), na.rm = TRUE)
    scale_factor <- left_max / right_max
    
    # Create base plot with explicit mapping for correct legend handling
    plot <- ggplot(mapping = aes(x = Date, y = Value, colour = Variable)) +
        # Add left axis data
        geom_line(data = left_data,
                 linewidth = 1.2) +
        # Add right axis data (scaled)
        geom_line(data = right_data,
                 aes(y = Value * scale_factor),
                 linewidth = 1.2)
    
    # Set up scales
    plot <- plot +
        in_scale_x(data) +
        scale_color_manual(
            values = custom_colors[1:length(unique(data$Variable))],
            breaks = unique(data$Variable),
            labels = function(x) {
                paste0(x, " (", ifelse(x %in% right_indicators, "Right", "Left"), ")")
            }
        )
    
    # Add y-axis scales and labels with consistent rotation
    if(!is.null(y_axis)) {
        plot <- plot +
            scale_y_continuous(
                name = y_axis[1],
                labels = scales::comma_format(scale = 1),
                breaks = scales::pretty_breaks(n = 9),
                sec.axis = sec_axis(
                    ~./scale_factor,
                    name = y_axis[2],
                    labels = scales::comma_format(scale = 1),
                    breaks = scales::pretty_breaks(n = 9)
                )
            )
    } else {
        plot <- plot +
            scale_y_continuous(
                labels = scales::comma_format(scale = 1),
                breaks = scales::pretty_breaks(n = 9),
                sec.axis = sec_axis(
                    ~./scale_factor,
                    labels = scales::comma_format(scale = 1),
                    breaks = scales::pretty_breaks(n = 9)
                )
            )
    }
    
    # Add theme and labels with consistent axis text rotation
    plot <- plot + in_theme_plot(base_size = base_size) + 
                labs(x = NULL, color = "")
    
    # Add key dates if specified
    plot <- in_add_date_markers(plot, key_dates)
    
    return(plot)
}


#' Determine Right Axis Variable Assignment
#' 
#' @description
#' Internal function that analyzes variable ranges to determine optimal
#' axis assignment for dual-axis plots. Ensures sensible scale combinations.
#' 
#' Used by: in_plot_multi_indic_one_ctry_two_axes
#' Uses: No direct function calls
#' 
#' Assignment logic:
#' - Two variables: Larger range to left axis
#' - Multiple variables: Uses gap analysis to split into two groups
#' - Preserves scale relationships
#'
#' @keywords internal
in_assign_axes <- function(data,                    # data.frame: input data
                          verbose = TRUE,           # logical: controls information messages
                          debug = FALSE) {          # logical: controls debug messages

    # Get unique indicators
    indicators <- unique(data$Variable)
    if(length(indicators) < 2) {
        stop("Need at least 2 indicators for two-axis plot")
    }
    
    # Calculate ranges for each indicator
    ranges <- sapply(indicators, function(ind) {
        values <- data$Value[data$Variable == ind]
        max_abs <- max(abs(values), na.rm = TRUE)
        return(max_abs)
    })
    
    # If we have exactly two indicators, put larger range on left
    if(length(indicators) == 2) {
        right_indicators <- names(ranges)[which.min(ranges)]
    } else {
        # For more than two indicators:
        sorted_ranges <- sort(ranges, decreasing = TRUE)
        gaps <- diff(sorted_ranges)
        split_point <- which.max(gaps)
        right_indicators <- names(ranges)[ranges <= sorted_ranges[split_point + 1]]
    }
    
    if(verbose) {
        msg <- paste0("Automatic axis assignment - Right axis: ", paste(right_indicators, collapse = ", "))
        in_print_debug(msg, verbose, debug, type = "info", "AXES")
    }
    
    return(right_indicators)
}






#######################################################################################################################################################
# DATE MARKERS



#' Add Event Markers to Time Series Plots
#' 
#' @description
#' Internal function that adds vertical lines and labels for significant dates.
#' Handles positioning and appearance of event markers.
#' 
#' Used by: All time series plotting functions
#' Uses: No direct function calls
#' 
#' Features:
#' - Vertical lines at event dates
#' - Angled text labels
#' - Automatic date range filtering
#' - Margin adjustment for labels
#' - Title-aware positioning
#'
#' @keywords internal
in_add_date_markers <- function(plot,                    # ggplot object: base plot to add markers to
                               key_dates,                # data.frame/NULL: event data with dates and labels
                               title = FALSE) {          # logical: whether plot has title (affects margins)

    # If no key dates, return plot unchanged
    if (is.null(key_dates) || nrow(key_dates) == 0) {
        return(plot)
    }

    in_print_debug("add key dates", TRUE, FALSE, type = "info", "DATES")


    if (!is.null(key_dates) && nrow(key_dates) > 0) {


        # Extract date range from plot data
        plot_data <- plot$data
        start_date <- min(plot_data$Date, na.rm = TRUE)
        end_date <- max(plot_data$Date, na.rm = TRUE)

        # Create data frame of key dates
        key_dates_df <- data.frame(
            event = key_dates[,1],
            date = as.Date(key_dates[,2])
        )

        # Filter key dates to only include those within the plot's date range
        key_dates_df <- key_dates_df[
            key_dates_df$date >= start_date & 
            key_dates_df$date <= end_date,
        ]

        # If no dates remain after filtering, return plot unchanged
        if (nrow(key_dates_df) == 0) {
            return(plot)
        }

        # Get the current theme
        current_theme <- plot$theme

        extra_top_margin <- if (title) 0 else 20
        
        # Extract the current margins if they exist
        if (!is.null(current_theme$plot.margin)) {
            current_margins <- as.numeric(current_theme$plot.margin)
            new_margins <- margin(
                t = current_margins[1] + extra_top_margin,       # Set top margin for key dates
                r = current_margins[2],  # Preserve right margin
                b = current_margins[3],  # Preserve bottom margin
                l = current_margins[4],  # Preserve left margin
                unit = "pt"
            )
        } else {
            # If no margins exist, create new ones
            new_margins <- margin(t = 20, r = 0, b = 0, l = 0, unit = "pt")
        }
        
        plot <- plot +
            geom_vline(data = key_dates_df, 
                      aes(xintercept = date), 
                      color = "black", 
                      alpha = 0.5, 
                      size = 0.5) +
            geom_text(data = key_dates_df, 
                     aes(x = date, y = Inf, label = event),
                     vjust = -0.5,
                     hjust = 1,
                     angle = 0,
                     size = 5,
                     color = "black",
                     nudge_x = -1.) +
            coord_cartesian(clip = "off") +
            theme(plot.margin = new_margins)
    }
    
    return(plot)
}
