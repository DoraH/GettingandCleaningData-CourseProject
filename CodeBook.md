## Overview
This file describes the variables, the data, and the work that has been performed to clean up the data.

## Source Data
Below is a full description of the data used in this project:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Below are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Data Set Information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Attribute Information
For each record in the dataset it is provided:
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope.
* A 561-feature vector with time and frequency domain variables.
* Its activity label.
* An identifier of the subject who carried out the experiment.
 
## 1. Merges the training and the test sets to create one data set.
After setting the source directory for the files, read into tables the data located in:
* features.txt
* activity_labels.txt
* subject_train.txt
* subject_test.txt
* X_train.txt
* X_test.txt
* y_train.txt
* y_test.txt
Assign column names and merge to create one data set.

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
Determine the columns containing mean or standard deviation while keeping the subjectID and activity columns.
Thereafter, remove the unnecessary columns.

## 3. Uses descriptive activity names to name the activities in the data set.
This is already done in  1. when assigning column names to the data set.
```
colnames(activity_labels) <- c("activityid", "activity")
colnames(subject_train)   <- "subjectid"
colnames(subject_test)    <- "subjectid"
colnames(y_train)         <- "activity"
colnames(y_test)          <- "activity"
colnames(X_train)         <- features$V2
colnames(X_test)          <- features$V2
```

## 4. Appropriately labels the data set with descriptive variable names.
Clean up the data by removing parentheses, dash, commas
```
cleancolnames = gsub("\\(|\\)|-|,", "", colnames(combineData))
colnames(combineData) <- tolower(cleancolnames)
```

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Using the dplyr package.
```
tidyData = ddply(combineData, .(subjectid, activity), numcolwise(mean))
write.table(tidyData, file="tidyData.txt", sep = "\t", row.names = FALSE)
```
