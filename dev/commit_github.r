#' Update Package and Push to GitHub
#' This script handles documentation updates, website building, and GitHub synchronization

# 1. CLEANUP AND PREPARATION
message("\n1. CLEANUP AND PREPARATION")
message("------------------------")

# Clean up
message("Cleaning up...")
unlink("man", recursive = TRUE)
unlink("docs", recursive = TRUE)
unlink("NAMESPACE")
rm(list = ls())
gc()

# Function to handle git commands
git_command <- function(cmd, silent = FALSE) {
  if (!silent) message("Executing: ", cmd)
  result <- tryCatch({
    system(cmd)
    TRUE
  }, warning = function(w) {
    message("Warning in Git command: ", w$message)
    TRUE
  }, error = function(e) {
    message("Error in Git command: ", e$message)
    FALSE
  })
  return(result)
}

# 2. DOCUMENTATION AND WEBSITE
message("\n2. DOCUMENTATION AND WEBSITE")
message("--------------------------")

# Update documentation
message("Updating package documentation...")
tryCatch({
  devtools::document()
}, error = function(e) {
  stop("Error in documentation generation: ", e$message)
})

# Build pkgdown site
message("Building pkgdown site...")
tryCatch({
  pkgdown::build_site(preview = FALSE)
}, error = function(e) {
  stop("Error in pkgdown site building: ", e$message)
})

# 3. GIT OPERATIONS
message("\n3. GIT OPERATIONS")
message("----------------")

# First check if we're in a git repository
if (!dir.exists(".git")) {
  stop("Not a git repository. Initialize git first.")
}

# Check current branch
current_branch <- system("git rev-parse --abbrev-ref HEAD", intern = TRUE)
message("Current branch: ", current_branch)

# Stage 1: Handle .gitignore aggressively
message("\nStage 1: Handling .gitignore...")
if (file.exists(".gitignore")) {
  # Read current content
  gitignore_content <- readLines(".gitignore")
  original_content <- gitignore_content
  
  # Remove any docs-related patterns
  patterns_to_remove <- c("docs/", "docs", "/docs/", "/docs")
  gitignore_content <- gitignore_content[!gitignore_content %in% patterns_to_remove]
  gitignore_content <- gitignore_content[!grepl("^docs.*$", gitignore_content)]
  
  # Compare if changes were made
  if (!identical(original_content, gitignore_content)) {
    message("Updating .gitignore to include docs directory...")
    
    # Write new content
    writeLines(gitignore_content, ".gitignore")
    
    # Force update .gitignore in git
    git_command("git rm --cached .gitignore")
    git_command("git add .gitignore")
    git_command('git commit -m "Update .gitignore to include docs directory"')
    
    # Force push .gitignore changes
    git_command(paste("git push origin", current_branch))
    
    # Verify the change
    message("Verifying .gitignore update...")
    system("git show HEAD:.gitignore")
  }
}

# Stage 2: Handle docs directory
message("\nStage 2: Ensuring docs directory is tracked...")

# Remove docs from git cache if it exists
git_command("git rm -r --cached docs/", silent = TRUE)

# Add docs directory back
if (dir.exists("docs")) {
  git_command("git add docs/")
}

# Stage 3: Handle package updates
message("\nStage 3: Handling package updates...")

# Get user input for commit message
commit_msg <- readline(prompt = "Enter commit message (or press Enter for default message): ")
if (commit_msg == "") {
  commit_msg <- "Update package files and documentation"
}

# Make sure we have the latest changes
git_command(paste("git pull origin", current_branch))

# Add all changes
git_command("git add .")

# Check if there are changes to commit
git_status <- system("git status --porcelain", intern = TRUE)
if (length(git_status) == 0) {
  message("No changes to commit.")
} else {
  # Show what's being committed
  message("\nChanges to be committed:")
  system("git status", intern = TRUE)
  
  # Commit and push changes
  git_command(sprintf('git commit -m "%s"', commit_msg))
  git_command(paste("git push origin", current_branch))
}

# 4. FINAL STEPS
message("\n4. FINAL STEPS")
message("-------------")

# Verify docs directory exists in git
docs_in_git <- system("git ls-files docs/", intern = TRUE)
if (length(docs_in_git) == 0) {
  message("Warning: docs/ directory might not be properly tracked in git.")
  message("Please check your repository on GitHub.")
} else {
  message("docs/ directory is properly tracked in git.")
}

# Show final status
message("\nFinal git status:")
system("git status")

# Optional: Open the website
website_url <- "https://benjaminpeeters.github.io/WPD"
message("\nYou can view your website at: ", website_url)
response <- readline(prompt = "Would you like to open the website? (y/n): ")
if (tolower(response) == "y") {
  browseURL(website_url)
}

message("\nScript completed successfully!")
