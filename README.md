# Getting And Cleaning Data Coursera Course Project
Final course Project repo for the course "Getting and Cleaning Data" from the Coursera Data Science Specialization.

## Introduction
This is the final Project/Assignment for the "Getting and Cleaning Data" Course on Coursera. 

## Content
Within this repo you can find:

1. The raw data collected from the accelerometers from the Samsung Galaxy S smartphone. The data was obtained here
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

2. A code book that clarifies all the variables and summaries calculated, along with units, and any other relevant information.

3. The submitted data set as "tidy"" data set.

4. A R-Script containing all the necessary steps to get from the raw to the tidy data. It is called "run_analysis.R".

5. This explanatory README file of course.

## Course Challenge Instructions
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

You should create one R script called run_analysis.R that does the following. 

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!

### Data Preperation process
First I set the appropriate working directory. (Using paste0 to split it on multiple lines)
```{r}
# Set Working directory
setwd(paste0("C:/R_Course_Coursera/GettingAndCleaningData/CourseProject/",
             "GettingAndCleaningDataCourseraCourseProject"))
```
I applied the same function (read.table) to read all .txt files necessary. Separator and Header did not need to be specified here since the default it what we needed.
```{r}
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
```
Next the names of the mergedSet where specified using the features variable (561 in total).
```{r}
##Extracting the columns which include the interesting measurements
names(mergedSet) <- features[ ,2]
```
Afterwards all variables on mean or std measurements where filtered as part of the assignment.
```{r}
# Only those with mean or std data
mergedSetFiltered <- mergedSet[grepl("std|mean", names(mergedSet), ignore.case = TRUE)] 
```
Once we have got a clean data set with the interesting variables I merged the movement data with the activity labels to get a name on them.
```{r}
## Merge and name appropriately 
# Merge the Movement data with activity labels (keep only the descriptive name)
mergedMoves <- merge(mergedMoves, activities, by.x = "V1", by.y = "V1")[2]
```
Afterwards the data frames could all be bind together to generate a comprehensive data set.
```{r}
# Merge all together for a tidy data set
mergedSetFiltered <- cbind(mergedPerson, mergedMoves, mergedSetFiltered)
```
The first two columns were renamed for simpler overview and the data could be viewed in total( optional, hence commented out).
```{r}
# Rename the Person-IDs and activity variable for better understanding
names(mergedSetFiltered)[1:2] <- c("PersonID", "Activity")
# Optional view of the final tidy data set
#View(mergedSetFiltered)
```
Lastly a new data frame with the average (here: mean) values for all measures was calculated with the dplyr package.
```{r}
## Calculate the mean values as the average of each variable for each activity 
# and each subject.
library(dplyr)
tidySummarizedData <- group_by(mergedSetFiltered, PersonID, Activity) %>%
  summarise_all(mean)
tidySummarizedData
```
The data frame was written into a .txt for course assignment upload.
```{r}
# Writing the tidy summarized data into a .txt file for assignment upload 
# and potential further use.
write.table(tidySummarizedData, file = "tidySummarizedData.txt", row.name=FALSE)
```

### Further Information
This analysis and project assignment was conducted by: Alex Babicz in August 2021.

More information on the Coursera Data Science Specialization can be found here:  
https://www.coursera.org/specializations/jhu-data-science
