suppressMessages(library(rhdf5))


srcURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!exists("activityData.zip")){
  download.file(srcURL,destfile = "activityData.zip")
  unzip("activityData.zip",exdir = "./activityData")
}

saveDir <- getwd()                            # to return to later
setwd("./activityData/UCI HAR Dataset/")


features       <- read.table("features.txt")
activities     <- read.table("activity_labels.txt")
x_test         <- read.table("./test/X_test.txt")
y_test         <- read.table("./test/y_test.txt")
x_train        <- read.table("./train/X_train.txt")
y_train        <- read.table("./train/y_train.txt")
test_subjects  <- read.table("./test/subject_test.txt")
train_subjects <- read.table("./train/subject_train.txt")


names(x_test)         <- as.character(features$V2)
names(x_train)        <- as.character(features$V2)
names(test_subjects)  <- c("subject")
names(train_subjects) <- c("subject")
names(y_test)         <- c("activity")
names(y_train)        <- c("activity")


setwd(saveDir)                                # return to top level

source("writeRaw.R")

if(file.exists("activityData.zip")) file.remove("activityData.zip")
unlink("./activityData", recursive = TRUE)    # Clean up the downloaded files