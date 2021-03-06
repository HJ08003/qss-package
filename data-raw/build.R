# Compile and save rdata
library("readr")
library("stringr")
library("purrr")

# Do not include these
IGNORES <- c("chechen", "resources")

# Rename these csv files from QSS
RENAMES <- c(names = "cnames", FLCensusVTD = "FLCensus")

# copy csv files from qss/ to data-raw/
# ----------------------------------------
csv_files <- dir("qss", pattern = ".*\\.csv$", full.names = TRUE,
                 recursive = TRUE)
csv_dir <- file.path("data-raw", "csv")
dir.create(csv_dir, recursive = TRUE, showWarnings = FALSE)
ignore_files <-
  c("qss/PREDICTION/social.csv",
    "qss/PREDICTION/intrade08.csv")
for (fn in csv_files) {
  if (fn %in% ignore_files) {
    next
  }
  dst <- file.path("data-raw", "csv", basename(fn))
  file.copy(fn, dst)
  cat("Copy ", fn, " to ", dst, "\n")
}

# For all csv files in data-raw/ save to data/*.rda
data_raw_csv <- dir(csv_dir, pattern = ".*\\.csv",
                    full.names = TRUE)
spec_dir <- "data-raw/spec"
#' PREDICTION/social.csv uses the wrong primary date
#' PROBABILITY/intrade08.csv is a superset of PREDICTION/intrade08.csv
dir.create(spec_dir, showWarnings = FALSE, recursive = TRUE)
qss_data <- new.env()
for (fn in dir(csv_dir, pattern = "\\.csv$", full.names = TRUE)) {
  dataname <- make.names(tools::file_path_sans_ext(basename(fn)))
  if (dataname %in% IGNORES) {
    message("Ignoring ", dataname)
    next
  }
  if (dataname %in% names(RENAMES)) {
    print(dataname)
    newname <- RENAMES[dataname]
    message("Renaming ", dataname, " to ", newname)
    dataname <- newname
  }
  if (dataname == "names") {
    message("For names, using cnames instead")
    dataname <- "cnames"
  }
  spec_file <- file.path(spec_dir, paste0(dataname, ".R"))
  spec_file_exists <- file.exists(spec_file)
  if (spec_file_exists) {
    cat("Using col_type spec in ", spec_file, "\n")
    col_types <- dget(spec_file)
    .data <- read_csv(fn,
                      skip = 1,
                      col_types = col_types,
                      col_names = names(col_types$cols)) %>%
      as.data.frame()
  } else {
    cat("File ", spec_file, " does not exist.\n")
    .data <- read_csv(fn) %>% as.data.frame()
    cat("Writing col_type specs to ", spec_file, ".\n")
    cat(format(spec(.data)), file = spec_file)
  }
  qss_data[[dataname]] <- .data
  cat("Reading ", fn, "\n")
}

#' copy some RData files
load("qss/PROBABILITY/fraud.RData", envir = qss_data)

for (dataset in ls(qss_data)) {
  rda_name <- file.path("data", paste0(dataset, ".rda"))
  save(list = dataset, file = rda_name, envir = qss_data,
      compress = "bzip2")
  cat("Saving ", rda_name, "\n")
}

# Copy federalist papers
# --------------------------------------------------
dir.create("inst/extdata/", showWarnings = FALSE,
           recursive = TRUE)
file.copy("qss/DISCOVERY/federalist/", "inst/extdata/",
          recursive = TRUE)

# Copy some other non-csv files to inst/extdata
# --------------------------------------------------
data_files <- c("qss/INTRO/UNpop.RData", "qss/INTRO/UNpop.dta",
                "qss/INTRO/UNpop.csv")
dir.create("inst/extdata/data_files/", showWarnings = FALSE,
           recursive = TRUE)
for (fn in data_files) {
  file.copy(fn, "inst/extdata/data_files")
  cat("Copy ", fn, " to inst/extdata/data_files\n")
}


# Create book Documentation
devtools::document()

# Check package
devtools::check()
