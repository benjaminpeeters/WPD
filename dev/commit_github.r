#!/usr/bin/env Rscript

#' Comprehensive GitHub Update Script
#' Handles version updates, package checks, documentation, and GitHub synchronization

#' Execute git commands with error handling
#' @param cmd The git command to execute
#' @param silent Whether to suppress command echo
#' @return List containing success status and any output/error messages
git_command <- function(cmd, silent = FALSE) {
  if (!silent) message("Executing: ", cmd)
  
  result <- tryCatch({
    output <- system(cmd, intern = TRUE, ignore.stderr = FALSE)
    list(success = TRUE, output = output)
  }, warning = function(w) {
    list(success = TRUE, output = w$message, warning = TRUE)
  }, error = function(e) {
    list(success = FALSE, error = e$message)
  })
  
  if (!result$success) {
    message("Error in git command: ", result$error)
  }
  return(result)
}

#' Function to validate commit message
#' @param msg The commit message to validate
#' @return List with validation result and error message if any
validate_commit_message <- function(msg) {
  # Remove leading/trailing whitespace
  msg <- trimws(msg)
  
  # Check for problematic characters
  if (grepl('["|\'|`]', msg)) {
    return(list(valid = FALSE, error = "Commit message should not contain quotes"))
  }
  
  # Check for other potential problematic patterns
  if (grepl("^[[:punct:]]+$", msg)) {
    return(list(valid = FALSE, error = "Commit message should contain some text, not just punctuation"))
  }
  
  return(list(valid = TRUE, msg = msg))
}

#' Get and validate commit message in a loop
#' @return Valid commit message
get_valid_commit_message <- function() {
  while (TRUE) {
    commit_msg <- readline(prompt = "Enter commit message (or press Enter for default message): ")
    
    # Handle empty input (default message)
    if (commit_msg == "") {
      default_msg <- sprintf("Update package to version %s", desc::desc_get_version())
      message("Using default message: ", default_msg)
      return(default_msg)
    }
    
    # Validate the message
    result <- validate_commit_message(commit_msg)
    if (result$valid) {
      return(result$msg)
    } else {
      message("Invalid commit message: ", result$error)
      message("Please try again.")
    }
  }
}

#' Update package version
#' @param increment_type Type of version increment: "patch", "minor", or "major"
update_version <- function(increment_type = "patch") {
  tryCatch({
    # Read current version
    desc <- desc::desc_get_version()
    version_parts <- strsplit(as.character(desc), "\\.")[[1]]
    
    # Increment version
    major <- as.integer(version_parts[1])
    minor <- as.integer(version_parts[2])
    patch <- as.integer(version_parts[3])
    
    if (increment_type == "major") {
      major <- major + 1
      minor <- 0
      patch <- 0
    } else if (increment_type == "minor") {
      minor <- minor + 1
      patch <- 0
    } else {
      patch <- patch + 1
    }
    
    # Create new version string
    new_version <- sprintf("%d.%d.%d", major, minor, patch)
    
    # Update DESCRIPTION file
    desc::desc_set_version(new_version)
    
    message("Version updated to: ", new_version)
    return(TRUE)
  }, error = function(e) {
    message("Error updating version: ", e$message)
    return(FALSE)
  })
}

#' Main execution function
main <- function() {
  # 1. Initial Setup and Checks
  message("\n=== Initial Setup and Checks ===")
  
  # Check if we're in a package directory
  if (!file.exists("DESCRIPTION")) {
    stop("Not in a package directory. Please run this script from the package root.")
  }
  
  # Check if we're in a git repository
  if (!dir.exists(".git")) {
    stop("Not a git repository. Initialize git first.")
  }
  
  # 2. Clean up and Preparation
  message("\n=== Cleaning up and Preparing ===")
  unlink("man", recursive = TRUE)
  unlink("docs", recursive = TRUE)
  unlink("NAMESPACE")
  
  # 3. Version Update
  message("\n=== Updating Version ===")
  version_type <- readline(prompt = "Enter version increment type (patch/minor/major) [patch]: ")
  if (version_type == "") version_type <- "patch"
  if (!update_version(version_type)) {
    stop("Version update failed")
  }
  
  # 4. Package Checks and Documentation
  message("\n=== Running Package Checks and Updating Documentation ===")
  
  # Run R CMD check
  check_result <- tryCatch({
    devtools::check(document = FALSE, quiet = FALSE)
    TRUE
  }, error = function(e) {
    message("Warning: Package check failed: ", e$message)
    response <- readline(prompt = "Continue despite check failure? (y/n): ")
    tolower(response) == "y"
  })
  
  if (!check_result) {
    stop("Stopping due to package check failures")
  }
  
  # Update documentation
  message("Updating package documentation...")
  tryCatch({
    devtools::document()
  }, error = function(e) {
    stop("Documentation generation failed: ", e$message)
  })
  
  # Build pkgdown site
  message("Building pkgdown site...")
  tryCatch({
    pkgdown::build_site(preview = FALSE)
  }, error = function(e) {
    stop("Pkgdown site building failed: ", e$message)
  })
  
  # 5. Git Operations
  message("\n=== Handling Git Operations ===")
  
  # Get current branch
  current_branch <- system("git rev-parse --abbrev-ref HEAD", intern = TRUE)
  message("Current branch: ", current_branch)
  
  # Update .gitignore to minimize excluded files
  minimal_gitignore <- c(
    ".Rhistory",
    ".RData",
    ".Ruserdata",
    "*.Rproj.user",
    ".DS_Store"
  )
  
  # Only update .gitignore if it's different
  if (file.exists(".gitignore")) {
    current_gitignore <- readLines(".gitignore")
    if (!identical(current_gitignore, minimal_gitignore)) {
      writeLines(minimal_gitignore, ".gitignore")
      git_command("git add .gitignore")
      git_command('git commit -m "Update .gitignore to track more files"')
    }
  } else {
    writeLines(minimal_gitignore, ".gitignore")
    git_command("git add .gitignore")
    git_command('git commit -m "Add minimal .gitignore"')
  }
  
  # Pull latest changes
  pull_result <- git_command(paste("git pull origin", current_branch))
  if (!pull_result$success) {
    stop("Failed to pull latest changes. Please resolve conflicts manually.")
  }
  
  # Add all changes
  git_command("git add .")
  
  # Check if there are changes to commit
  status_result <- git_command("git status --porcelain", silent = TRUE)
  if (length(status_result$output) == 0) {
    message("No changes to commit.")
    return(invisible())
  }
  
  # Get valid commit message
  commit_msg <- get_valid_commit_message()
  
  # Commit and push changes
  commit_result <- git_command(sprintf("git commit -m '%s'", commit_msg))
  if (!commit_result$success) {
    stop("Failed to commit changes")
  }
  
  push_result <- git_command(paste("git push origin", current_branch))
  if (!push_result$success) {
    stop("Failed to push changes. Please pull latest changes and try again.")
  }
  
  # 6. Final Verification
  message("\n=== Final Verification ===")
  
  # Verify docs directory is tracked
  docs_in_git <- git_command("git ls-files docs/", silent = TRUE)
  if (length(docs_in_git$output) == 0) {
    message("Warning: docs/ directory might not be properly tracked in git.")
  } else {
    message("docs/ directory is properly tracked in git.")
  }
  
  # Show final status
  message("\nFinal git status:")
  system("git status")
  
  # Success message
  message("\nScript completed successfully!")
  message("New version: ", desc::desc_get_version())
  
  # Optionally open the website
  if (file.exists("_pkgdown.yml")) {
    pkg_name <- desc::desc_get_field("Package")
    website_url <- sprintf("https://%s.github.io/%s", 
                          system("git config user.name", intern = TRUE),
                          pkg_name)
    message("\nYou can view your website at: ", website_url)
    response <- readline(prompt = "Would you like to open the website? (y/n): ")
    if (tolower(response) == "y") {
      browseURL(website_url)
    }
  }
}

# Execute main function
tryCatch({
  main()
}, error = function(e) {
  message("\nScript failed with error: ", e$message)
  message("Please resolve any issues and try again.")
})
