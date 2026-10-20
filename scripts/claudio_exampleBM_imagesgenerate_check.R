library(dplyr)
library(stringr)

# ==========================================
# 1. SETUP PATHS - pick the location of the root directory that contains the image folders and the specimens.csv file
# ==========================================
#root_dir <- "/Users/claudio/Library/CloudStorage/OneDrive-UW-Madison/Eleanor Greene's files - Claudio_testing/Upload_Batch_5"
root_dir <- "/Volumes/Extreme SSD/Summer 2025 Field Collection"
# ==========================================
# 2. EXTRACT PHYSICAL FILES & RELATIVE PATHS
# ==========================================
img_ext <- c("jpg", "jpeg", "png", "tif", "tiff", "heic")
pattern <- paste0("\\.(", paste(img_ext, collapse = "|"), ")$")

files_list <- list.files(
  path = root_dir,
  pattern = pattern,
  recursive = TRUE,
  full.names = TRUE,
  ignore.case = TRUE
)

# Normalize paths for clean subtraction
root_norm <- normalizePath(root_dir)
files_norm <- normalizePath(files_list)

# Build the New CSV Structure
new_images_df <- data.frame(
  Full_Path = files_norm,
  stringsAsFactors = FALSE
) %>%
  mutate(
    # Extract filename (e.g., Lasioglossum_Cinctipes_M0105-1.jpg)
    filename_only = basename(Full_Path),
    
    # Extract Relative Path (e.g., Lasioglossum_Cinctipes_M0105/Lasioglossum_Cinctipes_M0105-1.jpg)
    filename = substring(Full_Path, nchar(root_norm) + 2),
    
    # Extract specimenId (e.g., M0105 or S0101 or whatever is needed)
    specimenId = str_extract(filename_only, "S\\d{4}"),
    
    # Create empty columns for metadata you'll fill in later
    angle = "",
    imager = "",
    notes = ""
  ) %>%
  # Select and reorder columns to match your requested structure
  select(specimenId, angle, filename, imager, notes)


##############
##  Use this option for filename with this format:  DC_071525_0231-1.jpg
##############

# Build the New CSV Structure
new_images_df <- data.frame(
  Full_Path = files_norm,
  stringsAsFactors = FALSE
) %>%
  mutate(
    # 1. Extract filename (e.g., DC_071525_0231-1.jpg)
    filename_only = basename(Full_Path),
    
    # 2. Extract Relative Path
    filename = substring(Full_Path, nchar(root_norm) + 2),
    
    # 3. Extract specimenId AND add "S" prefix
    # paste0() combines "S" with the 4 digits found before the hyphen
    specimenId = paste0("S", str_extract(filename_only, "\\d{4}(?=-)")),
    
    # 4. Create empty columns for metadata
    angle = "",
    imager = "",
    notes = ""
  ) %>%
  # Select and reorder columns
  select(specimenId, angle, filename, imager, notes)
# ==========================================
# 3. SAVE THE NEW CSV
# ==========================================
write.csv(new_images_df, 
          file.path(root_dir, "new_generated_images.csv"), 
          row.names = FALSE)

cat("Success! Generated a clean CSV with", nrow(new_images_df), "rows.\n")
cat("File saved to:", file.path(root_dir, "new_generated_images.csv"))

########

library(dplyr)
library(stringr)

# ==========================================
# 1. SETUP PATHS
# ==========================================
#root_dir <- "/Users/claudio/Library/CloudStorage/OneDrive-UW-Madison/Eleanor Greene's files - Claudio_testing/Upload_Batch_5"
root_dir <- "/Volumes/Extreme SSD/Summer 2025 Field Collection"
# ==========================================
# 2. DEFINE THE ANGLE LOOKUP TABLE
# ==========================================
# This matches the trailing number (e.g., -1) to the angle name

angle_lookup <- data.frame(
  suffix = as.character(1:15),
  angle_name = c(
    "left_side_parallel",  # -1
    "left_side_front", # -2
    "left_side_back",  # -3
    "left_top_side_parallel",  # -4
    "left_top_side_front",  # -5
    "left_top_side_back",  # -6
    "right_side_parallel",  # -7
    "right_side_front", # -8
    "right_side_back",  # -9
    "right_top_side_parallel",  # -10
    "right_top_side_front",  # -11
    "right_top_side_back",  # -12
    "dorsal",         # -13
    "face",           # -14
    "label"           # -15
  ),
  stringsAsFactors = FALSE
)

# ==========================================
# 3. EXTRACT PHYSICAL FILES & RELATIVE PATHS - uses the old "M" version of filenames
# ==========================================
img_ext <- c("jpg", "jpeg", "png", "tif", "tiff", "heic")
pattern <- paste0("\\.(", paste(img_ext, collapse = "|"), ")$")

files_list <- list.files(
  path = root_dir,
  pattern = pattern,
  recursive = TRUE,
  full.names = TRUE,
  ignore.case = TRUE
)

# Normalize for exact path subtraction
root_norm <- normalizePath(root_dir)
files_norm <- normalizePath(files_list)

# Build the New Data Structure
new_images_df <- data.frame(
  Full_Path = files_norm,
  stringsAsFactors = FALSE
) %>%
  mutate(
    # A. Get Filename (e.g., Lasioglossum_Cinctipes_M0105-1.jpg)
    filename_only = basename(Full_Path),
    
    # B. Get Relative Path (Subfolder/Filename)
    filename = substring(Full_Path, nchar(root_norm) + 2),
    
    # C. Extract specimenId (M followed by 4 digits)
    specimenId = str_extract(filename_only, "M\\d{4}"),
    
    # D. Extract the suffix number (the digit between '-' and '.')
    # This regex looks for '-' followed by digits just before the extension
    suffix_num = str_extract(filename_only, "(?<=-)\\d+(?=\\.)")
  ) %>%
  # E. Join with our Angle Lookup table
  left_join(angle_lookup, by = c("suffix_num" = "suffix")) %>%
  # Rename for your final structure
  rename(angle = angle_name) %>%
  # F. Add placeholder columns
  mutate(imager = "", notes = "") %>%
  # G. Final Column Selection & Order
  select(specimenId, angle, filename, imager, notes)


# ==========================================
# 3. EXTRACT PHYSICAL FILES & RELATIVE PATHS - for the "S" naming
# ==========================================
img_ext <- c("jpg", "jpeg", "png", "tif", "tiff", "heic")
pattern <- paste0("\\.(", paste(img_ext, collapse = "|"), ")$")

files_list <- list.files(
  path = root_dir,
  pattern = pattern,
  recursive = TRUE,
  full.names = TRUE,
  ignore.case = TRUE
)

# Normalize for exact path subtraction
root_norm <- normalizePath(root_dir)
files_norm <- normalizePath(files_list)

# Build the New Data Structure
new_images_df <- data.frame(
  Full_Path = files_norm,
  stringsAsFactors = FALSE
) %>%
  mutate(
    # A. Get Filename (e.g., DC_071525_0231-1.jpg)
    filename_only = basename(Full_Path),
    
    # B. Get Relative Path (Subfolder/Filename)
    filename = substring(Full_Path, nchar(root_norm) + 2),
    
    # C. Extract specimenId (Add "S" + 4 digits preceding the hyphen)
    # This looks for 4 digits that are followed by a '-'
    specimenId = paste0("S", str_extract(filename_only, "\\d{4}(?=-)")),
    
    # D. Extract the suffix number (the digit between '-' and '.')
    suffix_num = str_extract(filename_only, "(?<=-)\\d+(?=\\.)")
  ) %>%
  # E. Join with our Angle Lookup table
  left_join(angle_lookup, by = c("suffix_num" = "suffix")) %>%
  # Rename for your final structure
  rename(angle = angle_name) %>%
  # F. Add placeholder columns
  mutate(imager = "", notes = "") %>%
  # G. Final Column Selection & Order
  select(specimenId, angle, filename, imager, notes)




# ==========================================
# 4. SAVE THE FINAL CSV
# ==========================================
output_path <- file.path(root_dir, "generated_images_final.csv")
write.csv(new_images_df, output_path, row.names = FALSE)

cat("Success! Clean CSV generated with angle mappings.\n")
cat("Total images processed:", nrow(new_images_df), "\n")
cat("File saved to:", output_path)

###########  Check against specimens.csv file

library(dplyr)
library(stringr)
library(tidyr)

# 1. SETUP PATHS
#root_dir <- "/Users/claudio/Library/CloudStorage/OneDrive-UW-Madison/Eleanor Greene's files - Claudio_testing/Upload_Batch_5"
root_dir <- "/Volumes/Extreme SSD/Summer 2025 Field Collection"
generated_csv <- file.path(root_dir, "generated_images_final.csv")
specimens_csv  <- file.path(root_dir, "specimens.csv")

# 2. LOAD DATA
gen_df <- read.csv(generated_csv, stringsAsFactors = FALSE)
spec_df <- read.csv(specimens_csv, stringsAsFactors = FALSE)

# 3. PERFORM TAXONOMY CHECK
# We split the filename to get the Genus/Epithet from the folder name
audit_report <- gen_df %>%
  separate(filename, into = c("folder_genus", "folder_epithet"), sep = "_", 
           extra = "drop", remove = FALSE) %>%
  left_join(spec_df, by = "specimenId") %>%
  mutate(
    Taxonomy_Mismatch = if_else(
      is.na(genus) | 
        tolower(folder_genus) != tolower(genus) | 
        tolower(folder_epithet) != tolower(specificEpithet), 
      "*", ""
    )
  ) %>%
  # Keep only necessary columns for the final audit view
  select(specimenId, angle, filename, genus, specificEpithet, Taxonomy_Mismatch)

# 4. SAVE AUDIT REPORT
write.csv(audit_report, file.path(root_dir, "taxonomy_audit_report.csv"), row.names = FALSE)

# 5. CONSOLE SUMMARY
mismatches <- sum(audit_report$Taxonomy_Mismatch == "*")
cat("Audit Complete!\n")
cat("Total specimens checked:", nrow(audit_report), "\n")
cat("Mismatches found:", mismatches, "\n")
if(mismatches > 0) {
  cat("Check 'taxonomy_audit_report.csv' and look for the '*' column.\n")
}

###############
# File checks to see if speciesID is accounted for in both .csv files
###############
library(dplyr)
library(readr)

# 1. SETUP PATHS
root_dir       <- "/Volumes/Extreme SSD/Summer 2025 Field Collection"
generated_csv  <- file.path(root_dir, "generated_images_final.csv")
specimens_csv  <- file.path(root_dir, "specimens.csv")
output_audit   <- file.path(root_dir, "collection_audit_summary.csv")

# 2. LOAD DATA
df_images    <- read_csv(generated_csv, col_types = cols(.default = "c"))
df_specimens <- read_csv(specimens_csv, col_types = cols(.default = "c"))

# 3. PROCESS DATA
# Count how many images exist for each specimenId
image_counts <- df_images %>%
  group_by(specimenId) %>%
  summarise(image_count = n(), .groups = "drop")

# Create a master list of all unique IDs from both files
all_ids <- data.frame(specimenId = unique(c(df_specimens$specimenId, df_images$specimenId)))

# 4. BUILD SUMMARY TABLE
audit_table <- all_ids %>%
  mutate(
    # Check if the ID exists in the specimens.csv
    in_specimens_csv = specimenId %in% df_specimens$specimenId
  ) %>%
  # Join the image counts
  left_join(image_counts, by = "specimenId") %>%
  # Replace NA counts with 0
  mutate(image_count = ifelse(is.na(image_count), 0, image_count)) %>%
  # Rename columns for clarity
  rename(
    num_rows_in_generated_images = image_count,
    is_present_in_specimens_csv = in_specimens_csv
  )

# 5. WRITE TO CSV
write_csv(audit_table, output_audit)

message(paste("Audit CSV created at:", output_audit))
