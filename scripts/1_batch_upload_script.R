###################################################
# Batch Upload script 
###################################################

# Big picture idea 
# Create the dataframe column by column 
# Combine the columns into one dataframe
# Use violet's class 'write.csv' to write the dataframe into an excel file 

# Little steps 

# Part 1: creating the specimens csv file 
# Step 1: Create relative pathing 
# Step 2: pull list of names from file 
# Step 3: Add a column called 'project' that is hte same size as however many specimens you get and fill it all with 'Braatz and Krol Community Research' 
# 
# step 4: repeat this (same fill) until Column F (preparation type) -- everything should be 'wild'. See example in this folder. 
# Step 5 (if you get beyond here) -- tip, I'd look into extracting parts of a name since we can standardize the names 
# getting the locations 
# not totally sure how to do this but heads up it'll probably involve a lookup table and left joins 
# # Lookup data (df2)

##################################################################
# Justin's code magic 
##################################################################


# Step 2: Pulling list of names from file 
# ---------------------------------------------------

# Source - https://stackoverflow.com/a/55719142
# Posted by PavoDive
# Retrieved 2026-09-16, License - CC BY-SA 4.0

# use the list.files command to extract all of the names in this filepath
(files <- list.files(path = input_folder_path))   


# Load latlong key 
latlong_df <- read.csv("latlong_key.csv", fileEncoding = "latin1")

##############################################################
# Creating images.csv 
##############################################################

# save the names as a dataframe 
df_images = as.data.frame(list.files(path = input_folder_path))

# Rename the column name 
names <- names(df_images)[names(df_images) == 'list.files(path = input_folder_path)'] <- 'filename'

# adding additional columns 
#--------------------------------------------------------

# adding an angle column 
df_images$angle = ""            

# adding a specimenId column 
df_images = df_images |> 
  mutate(specimenId = sub("\\.jpg$","",filename))

# adding imager column 
df_images$imager = "E.Braatz and V. Krol" 

# adding notes 
df_images$notes = NA 

# reorganizing our columns 

df_images = df_images |> 
  select(specimenId, angle, filename, imager, notes)


#Define the outpath and delete the file if it exists since the code will just appened
#to an existing file then recreate a blank file.
outpath_images <- here("output", "images.csv")
if(file.exists(outpath_images)){
  file.remove(outpath_images)
}

# Write the images csv file 
write.csv(df_images, outpath_images, row.names = FALSE)


##############################################################
# Creating specimens.csv 
##############################################################

#Define the outpath and delete the file if it exists since the code will just appened
#to an existing file then recreate a blank file.
outpath_specimens <- here("output", "specimens.csv")
if(file.exists(outpath_specimens)){
  file.remove(outpath_specimens)
}

# save the names as a dataframe 
df_specimens = as.data.frame(list.files(path = input_folder_path))

# Rename the column name 
names <- names(df_specimens)[names(df_specimens) == 'list.files(path = input_folder_path)'] <- 'filename'

# Adding additional columns 
# --------------------------------------------------

# adding a specimenId column 
df_specimens = df_specimens |> 
  mutate(specimenID = sub("\\.jpg$","",filename))
df_specimens$project = "Pollinator Garden Community Science Project"
df_specimens$genus = "unknown"
df_specimens$specificEpithet = "unknown"
df_specimens$sex = NA 
df_specimens$preparation = "wild" 
df_specimens$collectionDate <- ymd(substr(df_specimens$specimenID, 1, 8))  #subset it first to extract the date, THEN convert to date using ymd() from lubridate
df_specimens$collector = "E. Braatz"
df_specimens$identifiedBy = NA 
df_specimens$notes = NA 

# Extracting latitude, longitude, and address 

# extract the partner number 
df_specimens$partner_number <- str_extract(
  df_specimens$specimenID,
  "(?<=_)p\\d{1,2}(?=_)"
)   

# leftjoin the lat long dataframe
# note, make sure the 'partner_number' column names match between latlong_df and df_specimens 
df_specimens <- df_specimens |>
  left_join(latlong_df, by = "partner_number")



# reorganizing and cleaning the df_specimens dataframe 
df_specimens = df_specimens |> 
  select(specimenID,
         project,
         genus, 
         specificEpithet, 
         sex, 
         preparation, 
         collectionDate,
         collector, 
         identifiedBy, 
         latitude, 
         longitude, 
         localityVerbatim, 
         notes) 

# write the specimens csv file 
write.csv(df_specimens, outpath_specimens, row.names = FALSE)


# Alternate Loop Version 


#Loop to iterate over all of the files in the data folder
# for(file in files) {
  
  #split the file name string on '_' characters
#  strarr <- strsplit(file, "_")
  
  #subset the array of strings to get the date, partnerId, and partnerName
#  collectionDate <- ymd(strarr[[1]][1])
#  partnerNum <- strarr[[1]][2]
  
  #Subset the list based on index and last index to create the siteId
#  siteId <- paste(strarr[[1]][4:length(strarr[[1]])-1], collapse = "_")
  
  #Reference from the lat/long sheet based on either the matching partnerNum and siteId  
#  latLong <- latlong_df[toupper(latlong_df$site_id) == toupper(siteId)]
#  lat <- latLong$lat
#  long <- latLong$long
  
  #Append the row to the csv file
#  row <- data.frame() #Add the column as the name
#  write.table(row, file=outpath_specimens, sep=",", col.names=FALSE, row.names=FALSE, quote=FALSE);
# }





