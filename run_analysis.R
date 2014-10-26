require(plyr)

# Set working directory
setwd('/Users/user/Desktop/Coursera/UCI HAR Dataset/')

# Read data into data frames
features        <- read.table('./features.txt', header=FALSE, colClasses = c("character"));
activity_labels <- read.table('./activity_labels.txt', header=FALSE, col.names = c("ActivityId", "Activity")); 
subject_train   <- read.table('./train/subject_train.txt', header=FALSE);
subject_test    <- read.table('./test/subject_test.txt', header=FALSE);
X_train         <- read.table('./train/X_train.txt', header=FALSE);
X_test          <- read.table('./test/X_test.txt', header=FALSE);
y_train         <- read.table('./train/y_train.txt', header=FALSE);
y_test          <- read.table('./test/y_test.txt', header=FALSE);

## 1. Merges the training and test sets to create one data set

# Combine files into one data set 
trainingData <- cbind(cbind(X_train, subject_train), y_train)
testData     <- cbind(cbind(X_test, subject_test), y_test)
combineData  <- rbind(trainingData, testData)

# Label columns
combineLabels      <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(combineData) <- combineLabels

## 2. Extracts only the measurements on the mean and standard deviation for each measurement

meanstdcol <- combineData[,grepl("mean|std|Subject|ActivityId", names(combineData))]

## 3. Uses descriptive activity names to name the activities in the data set

meanstdcol <- merge(meanstdcol, activity_labels, by = "ActivityId", all.x=TRUE)
meanstdcol <- meanstdcol[,-1]

## 4. Appropriately labels the data set with descriptive variable names

# Remove parentheses, dash, commas and make clearer names
names(meanstdcol) <- gsub('\\(|\\)',"",names(meanstdcol), perl = TRUE)
names(meanstdcol) <- make.names(names(meanstdcol))
names(meanstdcol) <- gsub('Acc',"Acceleration",names(meanstdcol))
names(meanstdcol) <- gsub('GyroJerk',"GyroJerk",names(meanstdcol))
names(meanstdcol) <- gsub('Gyro',"Gyro",names(meanstdcol))
names(meanstdcol) <- gsub('Mag',"Magnitude",names(meanstdcol))
names(meanstdcol) <- gsub('^t',"TimeDomain.",names(meanstdcol))
names(meanstdcol) <- gsub('^f',"FrequencyDomain.",names(meanstdcol))
names(meanstdcol) <- gsub('\\.mean',".Mean",names(meanstdcol))
names(meanstdcol) <- gsub('\\.std',".StdDev",names(meanstdcol))
names(meanstdcol) <- gsub('Freq\\.',"Frequency.",names(meanstdcol))
names(meanstdcol) <- gsub('Freq$',"Frequency",names(meanstdcol))
names(meanstdcol) <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",names(meanstdcol))

## 5. creates a second, independent tidy data set with the average of each variable for each activity and each subject
# Summarize data
tidyData <- ddply(meanstdcol, c("Subject","Activity"), numcolwise(mean))
# Export tidyData set
write.table(tidyData, file = "tidyData.txt", sep = "\t", row.names = FALSE)
