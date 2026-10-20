# Bee-Machine-AI-Batch-Upload-Code
Code for automatically entering batches of photos into bee machine AI. It will search a folder of photos, extract photo names, and generate csv files for batch uploads via Bee Machine AI Lab. 


# Part 1: Download the images 
  1. Go into our shared box folder https://uwmadison.box.com/s/b52wugv276vj3qx7hbyh205nabp7s47l 
  2. Go into 03_Field_data_pdfs_and_photos
  3. Download some bee images. Make sure they are only images. Their file names should be along the line of 20260705_p2_site_name_blablabla(1). If not, update the name or it won't work. 
  4. Stick the image files into our shared Bee-Machine-AI-Batch-Upload repository under the 'input' folder (if there are old images there, delete them).      It will only accept images, they don't have to all be from the same site or date, but they can't be in subfolders. 

# Part 2: Run the code to generate csv files 
  1. Open the project folder for Bee-Machine-AI-Batch-Upload-Code (hopefully you already have if you are reading this) 
  2. Open the 'scripts' folder 
  3. Open the 0_setup_script.R script and run it 
  4. Open the 1_batch_upload_script.R script and run it. This should automatically generate two csv files in the 'output' folder named: 
        images.csv 
        specimens.csv 

# Part 3: Upload things into Bee Machine AI 

# Part 3a: Logging into Bee Machine AI 
  1.  UPload hte back upload website for Bee Machine AI at: https://beemachine-lab.ai/ 
  2. Log in 
      Hopefully you'll be added to the Gratton Lab so that our images go into our stuff 
      If you aren't, just pretend to be me. Message me if it looks like you'll need my login info. 
  
  
# Part 3b: Starting tihe batch upload 
I suggest starting with a small batch and if things work then start doing larger batches 
   1. Click 'initiate batch upload' 
   2. Fill out the following blanks: 
      Lab Name: Gratton Lab 
      Capture Device Type: other 
      Specimen notes (optional): can leave blank or leave a small note, esp early might be helpful to add a note 
   3. Make sure to check the box "Run BeeMachine classification" 
      Otherwise it won't identify the images for us 
   4. Click 'select root folder' 
   5. Navigate to the 'input' folder within our Bee-Machine-AI-Batch-Upload-Code folder, which is stored locally somewhere on your computer, and select        that input folder 
   6. BeeMachine will prompt, 'do you trust this folder'. Say 'yes', and it should say how many images you have in the folder. Remember, we can't have         subfolders (I think) 
   7. Click the 'select specimens.csv' button 
      Navigate to the 'specimens.csv' file inside the 'output' subfolder in Bee-machine-AI-Batch-Upload-Code folder and select it 
   8. Click the 'select images.csv' button 
      Navigate to the 'images.csv' file inside the 'output' subfolder in Bee-machine-AI-Batch-Upload-Code folder and select it 
   9. Under 'validation and upload', click the 'run preflight' 
      This will check if your images and csv files will work. If there is any kind of conflict, it will give an error. 
      Common errors include everything not working. If that's the case, make sure you checked the checkbox "Run BeeMachine classification" 
      Another common error is that our project name is invalid. It can sitll run the preflight but we'll lose the project name. Not hte worst but    
      hopefuly we can get Claudio to create us a project to make filtering easier later. 
  10. After hte preflight runs (it won't let you move on otherwise) click the 'upload images' button 
      BeeMachine will tak ea long time just uploading and identifying hte images. Go get some tea or do something else. 
  11. Come back when it's done. Huzzah! Great work! You've uploaded a batch to BeeMachine AI. 
  
# Part 4. Cleanup 

  1. Delete your images from the image folder (they are too large to store in github, it's poor practice and itll complain and make later merges slower) 
  2. Click 'git' in the top right window of R studio 
  3. click 'pull' to make sure your stuff is up to date 
  4. click 'commit' to commit any changes (should be basically none to the code, but small things might change so we'll try and just update every time?) along with a note about what you did 
  5. Push the changes 
  6. escape R studio 
