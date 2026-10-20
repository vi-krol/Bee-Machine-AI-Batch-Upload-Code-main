library(dplyr)
library(stringr)

# ==========================================
# 1. SETUP PATHS
# ==========================================
root_dir <- "/Users/claudio/Library/CloudStorage/OneDrive-UW-Madison/Eleanor Greene's files - Claudio_testing/Upload_Batch_3"
original_csv_path <- file.path(root_dir, "images.csv")
corrected_csv_path <- file.path(root_dir, "images_corrected.csv")

# ==========================================
# 2. CORRECT CSV CAPITALIZATION
# ==========================================
img_df <- read.csv(original_csv_path, stringsAsFactors = FALSE)

img_df <- img_df %>%
  mutate(filename = {
    # Capitalize start of string
    x <- str_replace(filename, "^([a-z])", function(m) toupper(m))
    # Capitalize after underscores
    str_replace_all(x, "(_)([a-z])", function(m) toupper(m))
  })

write.csv(img_df, corrected_csv_path, row.names = FALSE)
cat("Step 1 Complete: Capitalization corrected.\n")

# ==========================================
# 3. EXTRACT PHYSICAL FILES & RELATIVE PATHS
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

# Normalize root_dir to ensure string subtraction works perfectly
root_norm <- normalizePath(root_dir)
files_norm <- normalizePath(files_list)

# Extract the relative path (Subfolder/Filename.jpg)
# We add +1 to nchar to remove the trailing slash
relative_paths <- substring(files_norm, nchar(root_norm) + 2)

folder_data <- data.frame(
  ID = seq_along(files_list),
  Full_Path = files_list,
  Relative_Path_Actual = relative_paths, # This is our "Apples"
  Actual_File_Name = basename(files_list),
  stringsAsFactors = FALSE
) %>%
  mutate(specimenId = str_extract(Actual_File_Name, "M\\d{4}"))

# ==========================================
# 4. PERFORM AUDIT (JOIN & COMPARE)
# ==========================================
final_comparison <- folder_data %>%
  left_join(img_df, by = "specimenId") %>%
  mutate(
    # Compare Relative_Path_Actual to the 'filename' from CSV
    Mismatch_Flag = if_else(is.na(filename) | Relative_Path_Actual != filename, "*", "")
  )

# ==========================================
# 5. SAVE FINAL REPORT
# ==========================================
write.csv(final_comparison, 
          file.path(root_dir, "final_audit_report.csv"), 
          row.names = FALSE)

mismatches <- sum(final_comparison$Mismatch_Flag == "*")
cat("Step 2 Complete: Audit finished.\n")
cat("------------------------------------------\n")
cat("Total files found:", nrow(final_comparison), "\n")
cat("Mismatches found:", mismatches, "\n")
cat("Report saved to:", file.path(root_dir, "final_audit_report.csv"), "\n")