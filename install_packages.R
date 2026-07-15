# Install packages required to reproduce the analysis
#
# Run this file once from the project root:
# source("install_packages.R")

required_packages <- c(
  "tidyverse",
  "janitor",
  "readxl",
  "readr",
  "stringr",
  "scales",
  "ggrepel"
)

# Use a reliable CRAN mirror when none has been configured.
current_repos <- getOption("repos")

if (
  is.null(current_repos) ||
  is.na(current_repos["CRAN"]) ||
  current_repos["CRAN"] == "@CRAN@" ||
  !nzchar(current_repos["CRAN"])
) {
  options(repos = c(CRAN = "https://cloud.r-project.org"))
}

# Install only packages that are not already available.
missing_packages <- required_packages[
  !vapply(
    required_packages,
    requireNamespace,
    logical(1),
    quietly = TRUE
  )
]

if (length(missing_packages) > 0) {
  message(
    "Installing missing packages: ",
    paste(missing_packages, collapse = ", ")
  )

  install.packages(
    missing_packages,
    dependencies = c("Depends", "Imports", "LinkingTo")
  )
} else {
  message("All required packages are already installed.")
}

# Verify that every required package can now be loaded.
unavailable_packages <- required_packages[
  !vapply(
    required_packages,
    requireNamespace,
    logical(1),
    quietly = TRUE
  )
]

if (length(unavailable_packages) > 0) {
  stop(
    "The following packages could not be installed or loaded: ",
    paste(unavailable_packages, collapse = ", "),
    ". Check the installation messages above and try again."
  )
}

package_versions <- data.frame(
  package = required_packages,
  version = vapply(
    required_packages,
    function(package_name) {
      as.character(utils::packageVersion(package_name))
    },
    character(1)
  ),
  row.names = NULL
)

message("Package setup completed successfully.")
print(package_versions)
