#####################################################3
# Data prep script

# Create relative paths for batch upload and grab images' names 
######################################################

rm(list=ls())  # clear stuff 

# Load libraries / R packages 
#-----------------------------------------------------
# Check for dependencies and install the ones that aren't installed

packages <- c("here", "dplyr", "lubridate", "janitor")
missing_packages <- packages[!sapply(packages, requireNamespace, quietly = TRUE)]
if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}
library(dplyr)       # for organizing dataframes 
library(here)         # for setting relative paths 
library(lubridate)   # for parsing dates easier 
library(stringr)     # for parsing strings easier

# setting up filepaths 
# ------------------------------------------------------

# Create relative pathing 
input_folder_path = here("input") 

