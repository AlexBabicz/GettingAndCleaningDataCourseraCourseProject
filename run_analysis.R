# Set Working directory
setwd(paste0("C:/R_Course_Coursera/GettingAndCleaningData/CourseProject/",
             "GettingAndCleaningDataCourseraCourseProject"))

## Read activity_labels.txt with all the measured activities for reference
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities

## Read features.txt with all measures features
features <- read.table("./UCI HAR Dataset/features.txt")
head(features[2])

##Reading Sets
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt")
trainSet <- read.table("./UCI HAR Dataset/train/X_train.txt")
# Joining the two sets
mergedSet <- rbind(testSet,trainSet)        

##Reading Movement data
testMoves <- read.table("./UCI HAR Dataset/test/Y_test.txt")
trainMoves <- read.table("./UCI HAR Dataset/train/Y_train.txt")
mergedMoves <- rbind(testMoves, trainMoves)

##Reading Person-IDs
testPerson <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainPerson <- read.table("./UCI HAR Dataset/train/subject_train.txt")
mergedPerson <- rbind(testPerson, trainPerson)

##Extracting the columns which include the interesting measurements
names(mergedSet) <- features[ ,2]
# Only those with mean or std data
mergedSetFiltered <- mergedSet[grepl("std|mean", names(mergedSet), ignore.case = TRUE)] 

## Merge and name appropriately 
# Merge the Movement data with activity labels (keep only the descriptive name)
mergedMoves <- merge(mergedMoves, activities, by.x = "V1", by.y = "V1")[2]
# Merge all together for a tidy data set
mergedSetFiltered <- cbind(mergedPerson, mergedMoves, mergedSetFiltered)
# Rename the Person-IDs and activity variable for better understanding
names(mergedSetFiltered)[1:2] <- c("PersonID", "Activity")
# Optional view of the final tidy data set
#View(mergedSetFiltered)

## Calculate the mean values as the average of each variable for each activity 
# and each subject.
library(dplyr)
tidySummarizedData <- group_by(mergedSetFiltered, PersonID, Activity) %>%
  summarise_all(mean)
tidySummarizedData

# Writing the tidy summarized data into a .txt file for assignment upload 
# and potential further use.
write.table(tidySummarizedData, file = "tidySummarizedData.txt", row.name=FALSE)
