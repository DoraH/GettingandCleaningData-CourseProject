require(plyr)

# Set working directory
setwd('/Users/user/Desktop/Coursera/UCI HAR Dataset/')

# Read data into data frames
features        <- read.table('./features.txt', header=FALSE);
activity_labels <- read.table('./activity_labels.txt', header=FALSE); 
subject_train   <- read.table('./train/subject_train.txt', header=FALSE);
subject_test    <- read.table('./test/subject_test.txt', header=FALSE);
X_train         <- read.table('./train/X_train.txt', header=FALSE);
X_test          <- read.table('./test/X_test.txt', header=FALSE);
y_train         <- read.table('./train/y_train.txt', header=FALSE);
y_test          <- read.table('./test/y_test.txt', header=FALSE);

## 3. Uses descriptive activity names to name the activities in the data set
colnames(activity_labels) <- c("activityid", "activity")
colnames(subject_train)   <- "subjectid"
colnames(subject_test)    <- "subjectid"
colnames(y_train)         <- "activity"
colnames(y_test)          <- "activity"
colnames(X_train)         <- features$V2
colnames(X_test)          <- features$V2

## 1. Merges the training and the test sets to create one data set

# Combine files into one data set 
trainingData <- cbind(subject_train, y_train, X_train)
testData     <- cbind(subject_test, y_test, X_test)
combineData  <- rbind(trainingData, testData)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement

# Determine the columns containing "mean()" or "std()"
meanstdcol <- grepl("mean\\(\\)", colnames(combineData)) | grepl("std\\(\\)", colnames(combineData))
# Keep the subjectID and activity columns
meanstdcol[1:2] <- TRUE
# Remove unnecessary columns
combineData <- combineData[, meanstdcol]

## 4. Appropriately labels the data set with descriptive variable names
# Remove parentheses, dash, commas
cleancolnames = gsub("\\(|\\)|-|,", "", colnames(combineData))
colnames(combineData) <- tolower(cleancolnames)

## 5. creates a second, independent tidy data set with the average of each variable for each activity and each subject
# Summarize data
tidyData = ddply(combineData, .(subjectid, activity), numcolwise(mean))
# Export tidyData set
write.table(tidyData, file="tidyData.txt", sep = "\t", row.names = FALSE)
