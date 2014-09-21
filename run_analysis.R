library(plyr)
library(dplyr)

##### Download the zip file from website and extract it in temp folder #####

srcUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
tmpDir <- tempdir() # open a temporary directory to store data
tmpFile <- tempfile(tmpdir = tmpDir, fileext = ".zip") # temp file placeholder
download.file(srcUrl, tmpFile) #get the file
unzip(tmpFile, exdir = tmpDir, overwrite = TRUE) # unzip the file to the temp dir

##### Merge the training and the test sets to create one data set #####

## For easy file reference, read full names of all that has been extracted into a ##
## list and put the file name as the list's member names.                         ##
cfiles <- list.files(tmpDir, full.names = TRUE, recursive = TRUE) # get full pathnames in temp Dir
files <- as.list(cfiles) # we better use a list
names(files) <- basename(cfiles) #basename = file name (without path)
unlink(tmpDir) # unlink the temporary directory

## Merge test/train data. Note: The source file name will be included in first column. ##
subDf <- ldply(files[c("subject_test.txt", "subject_train.txt")], read.table) # subject
XDf <- ldply(files[c("X_test.txt", "X_train.txt")], read.table) # X
yDf <- ldply(files[c("y_test.txt", "y_train.txt")], read.table) # y

## At this point, I see convenient to label properly the column names ##
colnames(subDf) <- c("subjectFileId", "subject") # subject
featDf <- read.table(files$features.txt) #get the names for X data from features.txt file
colnames(XDf) <- c("featuresFileId", as.vector(featDf[, "V2"])) # X
colnames(yDf) <- c("activityFileId", "activityId") # y

## Make one single master data frame ##
colsXDf <- grep("mean\\(\\)|std\\(\\)", names(XDf), value=TRUE)       # Include only mean and std variables from XDf,
masterDf <- cbind(subDf[c("subject")],yDf["activityId"],XDf[colsXDf]) # plus the Subject and Activity.

###### Lets change a bit the column names from X data so they look better. #######

renColsXDf <- gsub("mean\\(\\)","Mean",colsXDf)  # Change mean() by Mean,
renColsXDf <- gsub("std\\(\\)","Std",renColsXDf) # change std() by Std,
renColsXDf <- gsub("-","",renColsXDf)            # remove all hyphens,
renColsXDf <- gsub("^[t]+","time",renColsXDf)    # replace the initial t by time,
renColsXDf <- gsub("^[f]+","freq",renColsXDf)    # replace the initial f by freq,
names(masterDf)[3:ncol(masterDf)] <- renColsXDf  # and finally replace selected names in data frame.

##### Add the activity labels #####

actLabDf <- read.table(files$activity_labels.txt) # Get the labels from activity_labels.txt file,
names(actLabDf) <- c("activityId","activity")     # assign column names
masterDf <- merge(masterDf,actLabDf)              # and finaly merge both data frames. 
masterDf <- subset(masterDf, select = -c(activityId)) # We do not need anymore the activityId

##### Output the tidy data set to a txt file #####

write.table(masterDf,"humactrec.txt",row.names=FALSE)



####### Create a new tidy data that will hold the mean for each variable group by Subject, Activity #####

grpMasDf <- as.data.frame(masterDf %>% group_by(subject,activity) %>% summarise_each(funs(mean)))

## Lest change the column names so they reflect the average meaning on them

colsGrpDf <- names(grpMasDf)                         # Get column names,
renColsGrpDf <- gsub("^time","avgTime",colsGrpDf)    # replace time by avgTime,
renColsGrpDf <- gsub("^freq","avgFreq",renColsGrpDf) # replace freq by avgFreq;
names(grpMasDf) <- renColsGrpDf                      # and finally replace names.

## Output the tidy data set to a txt file ##

write.table(grpMasDf,"humactrecBySubAct.txt",row.names=FALSE)

