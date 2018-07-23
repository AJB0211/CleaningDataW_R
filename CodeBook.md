---
title: "CodeBook"
author: "AJB0211"
date: "July 21, 2018"
output: 
  html_document: 
    keep_md: true
---



### Note:  
This document mirrors the functionality of the `run.analysis.R` script with visualization and annotation of the data cleaning process.

## Packages

```r
suppressMessages(library(dplyr))
suppressMessages(library(lubridate))
#library(rhdf5)
```

## Data Summary  
This work up concerns Samsung Galaxy accelerometer data detailed [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). Here the data are:  
- Downloaded and extracted  
- Stored in an HDF5 for compactness  
- Merged across training and test sets  
- Cleaned following the principles of tidy data  
- Relabeled  
- Averaged over activity types  


## Acquisition, Extraction, and Archiving
These operations are contained in `importData.R`.  

```r
srcURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!exists("activityData.zip")){
  download.file(srcURL,destfile = "activityData.zip")
  unzip("activityData.zip",exdir = "./activityData")
}
```

Inside the target directory of the unzip operation is another master folder containing the data. We work from here for data importing. The data sets are divided into train and test data. The data labels (y values) are the activities defined in `activity_labels.txt` while the data itself (x values) are in headerless tables for which the features are defined in `features.txt`. Clearly, this data set was intended for some classification task in machine learning. Conveniently, all these files are easily imported using the native `read.table()` function.  


```r
saveDir <- getwd()                            # to return to later
setwd("./activityData/UCI HAR Dataset/")

features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")

x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")

test_subjects <- read.table("./test/subject_test.txt")
train_subjects <- read.table("./train/subject_train.txt")

names(x_test)  <- as.character(features$V2)
names(x_train) <- as.character(features$V2)
names(test_subjects)  <- c("subject")
names(train_subjects) <- c("subject")
names(y_test)  <- c("activity")
names(y_train) <- c("activity")

setwd(saveDir)                                # return to top level
```


Originally, this data was to be stored in hdf5 but the `rhdf5` package is straight trash and rusn just fine from the command line but will not function in a script. Now it's stored in a a directory `./data` using `write.table`.


## Merge and Trim Data
Contained in `subsetData.R`.  

Since we aren't performing machine learning tasks, we are going to merge the data sets by row binding them. However, we care about a limited number of columns. To extract these, we search for `mean()` and `std()` in the features set. We then bind the subject list, the activity label (y), and the culled x data into our final data set of interest.  

It is worth noting that the script deviates slightly from what is presented here in the inclusion of import statements from the h5 file.

```r
wantedFeatures <- grepl("*mean()*|*std()*",features$V2)

x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subjects <- rbind(train_subjects,test_subjects)

x_trim <- x[,wantedFeatures]
```

This data is of two different types. One set is time measurements and one set is measurements of frequencies. These quantities warrant splitting the data sets into separate time and frequency tables. Time data begins with a lowercase "t" while frequency data begins with a lowercase "f" in the raw feature names.


```r
timeCols <- grepl("^t",names(x_trim))
freqCols <- grepl("^f",names(x_trim))

time <- x_trim[,timeCols]
freq <- x_trim[,freqCols]
```

At this point it's worth noting that the potential naming conventions are still not great. These measurements are vectors, which means that they are easily represented as 3-tuples of doubles. However, R is a garbage language and does not natively support tuples. A better language such as Scala or Python would allow more intuitive compactification of this data set. The alternative is splitting the data up into a number of tables for each measurement type (time/freq) and feature but that is unwieldy and excessive.

## Renaming
This and the follow section are the functions of `rename.R`.  

The raw activity data from the "y" data sets is in numbered categories rather than named. Names are converted to camelCase for style consistency.


```r
y[,1] <- as.factor(y[,1])
levels(y[,1]) <- tolower(activities[,2])
levels(y[,1]) <- sub("_u","U",levels(y[,1]))
levels(y[,1]) <- sub("_d","D",levels(y[,1]))

print(levels(y[,1]))
```

```
## [1] "walking"           "walkingUpstairs"   "walkingDownstairs"
## [4] "sitting"           "standing"          "laying"
```

Now the feature names all need to be corrected. 


```r
timeLabels <- names(time)
freqLabels <- names(freq)

# Drop the lowercase letter that has been taken care of by separating the tables
timeLabels <- sub("t","",timeLabels)
freqLabels <- sub("f","",freqLabels)

## Weird naming mistake?
freqLabels <- sub("BodyBody","Body",freqLabels)

# Some full word replacement
timeLabels <- sub("Mag","Magnitude",timeLabels)
freqLabels <- sub("Mag","Magnitude",freqLabels)

timeLabels <- sub("Acc","Acceleration",timeLabels)
freqLabels <- sub("Acc","Acceleration",freqLabels)

timeLabels <- sub("-mean[(][)]","_mean",timeLabels)
freqLabels <- sub("-mean[(][)]","_mean",freqLabels)

timeLabels <- sub("-std[(][)]","_std",timeLabels)
freqLabels <- sub("-std[(][)]","_std",freqLabels)

freqLabels <- sub("-meanFreq[(][)]","_meanFreq",freqLabels)

timeLabels <- sub("-","_",timeLabels)
freqLabels <- sub("-","_",freqLabels)

# camelCase

timeLabels <- sub("^B","b",timeLabels)
freqLabels <- sub("^B","b",freqLabels)

timeLabels <- sub("^G","g",timeLabels)
freqLabels <- sub("^G","g",freqLabels)


print(timeLabels)
```

```
##  [1] "bodyAcceleration_mean_X"           
##  [2] "bodyAcceleration_mean_Y"           
##  [3] "bodyAcceleration_mean_Z"           
##  [4] "bodyAcceleration_std_X"            
##  [5] "bodyAcceleration_std_Y"            
##  [6] "bodyAcceleration_std_Z"            
##  [7] "gravityAcceleration_mean_X"        
##  [8] "gravityAcceleration_mean_Y"        
##  [9] "gravityAcceleration_mean_Z"        
## [10] "gravityAcceleration_std_X"         
## [11] "gravityAcceleration_std_Y"         
## [12] "gravityAcceleration_std_Z"         
## [13] "bodyAccelerationJerk_mean_X"       
## [14] "bodyAccelerationJerk_mean_Y"       
## [15] "bodyAccelerationJerk_mean_Z"       
## [16] "bodyAccelerationJerk_std_X"        
## [17] "bodyAccelerationJerk_std_Y"        
## [18] "bodyAccelerationJerk_std_Z"        
## [19] "bodyGyro_mean_X"                   
## [20] "bodyGyro_mean_Y"                   
## [21] "bodyGyro_mean_Z"                   
## [22] "bodyGyro_std_X"                    
## [23] "bodyGyro_std_Y"                    
## [24] "bodyGyro_std_Z"                    
## [25] "bodyGyroJerk_mean_X"               
## [26] "bodyGyroJerk_mean_Y"               
## [27] "bodyGyroJerk_mean_Z"               
## [28] "bodyGyroJerk_std_X"                
## [29] "bodyGyroJerk_std_Y"                
## [30] "bodyGyroJerk_std_Z"                
## [31] "bodyAccelerationMagnitude_mean"    
## [32] "bodyAccelerationMagnitude_std"     
## [33] "gravityAccelerationMagnitude_mean" 
## [34] "gravityAccelerationMagnitude_std"  
## [35] "bodyAccelerationJerkMagnitude_mean"
## [36] "bodyAccelerationJerkMagnitude_std" 
## [37] "bodyGyroMagnitude_mean"            
## [38] "bodyGyroMagnitude_std"             
## [39] "bodyGyroJerkMagnitude_mean"        
## [40] "bodyGyroJerkMagnitude_std"
```

```r
print(freqLabels)
```

```
##  [1] "bodyAcceleration_mean_X"               
##  [2] "bodyAcceleration_mean_Y"               
##  [3] "bodyAcceleration_mean_Z"               
##  [4] "bodyAcceleration_std_X"                
##  [5] "bodyAcceleration_std_Y"                
##  [6] "bodyAcceleration_std_Z"                
##  [7] "bodyAcceleration_meanFreq_X"           
##  [8] "bodyAcceleration_meanFreq_Y"           
##  [9] "bodyAcceleration_meanFreq_Z"           
## [10] "bodyAccelerationJerk_mean_X"           
## [11] "bodyAccelerationJerk_mean_Y"           
## [12] "bodyAccelerationJerk_mean_Z"           
## [13] "bodyAccelerationJerk_std_X"            
## [14] "bodyAccelerationJerk_std_Y"            
## [15] "bodyAccelerationJerk_std_Z"            
## [16] "bodyAccelerationJerk_meanFreq_X"       
## [17] "bodyAccelerationJerk_meanFreq_Y"       
## [18] "bodyAccelerationJerk_meanFreq_Z"       
## [19] "bodyGyro_mean_X"                       
## [20] "bodyGyro_mean_Y"                       
## [21] "bodyGyro_mean_Z"                       
## [22] "bodyGyro_std_X"                        
## [23] "bodyGyro_std_Y"                        
## [24] "bodyGyro_std_Z"                        
## [25] "bodyGyro_meanFreq_X"                   
## [26] "bodyGyro_meanFreq_Y"                   
## [27] "bodyGyro_meanFreq_Z"                   
## [28] "bodyAccelerationMagnitude_mean"        
## [29] "bodyAccelerationMagnitude_std"         
## [30] "bodyAccelerationMagnitude_meanFreq"    
## [31] "bodyAccelerationJerkMagnitude_mean"    
## [32] "bodyAccelerationJerkMagnitude_std"     
## [33] "bodyAccelerationJerkMagnitude_meanFreq"
## [34] "bodyGyroMagnitude_mean"                
## [35] "bodyGyroMagnitude_std"                 
## [36] "bodyGyroMagnitude_meanFreq"            
## [37] "bodyGyroJerkMagnitude_mean"            
## [38] "bodyGyroJerkMagnitude_std"             
## [39] "bodyGyroJerkMagnitude_meanFreq"
```

## Storing Cleaned data


```r
names(time) <- timeLabels
names(freq) <- freqLabels

time <- cbind(subjects,y,time)
freq <- cbind(subjects,y,freq)

# table storage in scripts
```


## Data workup
This is the function of `workup.R`

We want the average over each variable grouped by activity and subject. The cleaned data is ideal for producing this rapidly.


```r
# replace data.frame with table_df
time <- tbl_df(time)
freq <- tbl_df(time)

time_summary <- time %>% group_by(subject,activity) %>% summarize_all(mean)
freq_summary <- freq %>% group_by(subject,activity) %>% summarize_all(mean)
```

The files are saved in the script.

## Running
Run `source("run_analysis.R")` to produce the saved raw, clean, and averaged data sets as described previously. The workspace is cleaned with `cleanWorkspace.R`, removing all intermediates and leaving the `time_summary` and `freq_summary` tbl_df objects. The raw and cleaned data can be imported as data frames using the respective `readRaw.R` and `readClean.R` scripts. After `run_analysis.R` has been run once, the cleaned data can be imported as tbl_df objects again using `readAve.R`.







