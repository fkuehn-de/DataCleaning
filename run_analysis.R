filename <- "DataCleaning.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("DataCleaning")) { 
  unzip(filename) 
}

testsub <- read.table("UCI HAR Dataset/test/subject_test.txt") #measurements (test set)
testX <- read.table("UCI HAR Dataset/test/X_test.txt") #info on subject which was measured (test set)
testY <- read.table("UCI HAR Dataset/test/y_test.txt") #info on activity which was measured (test set)
trainsub <- read.table("UCI HAR Dataset/train/subject_train.txt") #measurements (training set)
trainX <- read.table("UCI HAR Dataset/train/X_train.txt") #info on subject which was measured (training set)
trainY <- read.table("UCI HAR Dataset/train/y_train.txt") #info on activity which was measured (training set)
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

#tidy up testY: format as integer. Give descriptive names for activities and columns

testY[,1] <- as.integer(testY[,1])

findActivity <- function(x){tolower(activities[x,2])}

testY$activity <- mapply(findActivity,testY)

colnames(testY) <- c("activity_number","activity")

#tidy up testsub: format as integer. Give descriptive column name

testsub[,1] <- as.integer(testsub[,1])

colnames(testsub) <- c("person_number")

#tidy up testX: Give descriptive column names

colnames(testX)<- features[,2]

# create one data frame containing all information about test set

test <- cbind(testsub,testY,testX)

#Repeat the above steps for the traning set

#tidy up trainY: format as integer. Give descriptive names for activities and columns

trainY[,1] <- as.integer(trainY[,1])

trainY$activity <- mapply(findActivity,trainY)

colnames(trainY) <- c("activity_number","activity")

#tidy up trainsub: format as integer. Give descriptive column name

trainsub[,1] <- as.integer(trainsub[,1])

colnames(trainsub) <- c("person_number")

#tidy up trainX: Give descriptive column names

colnames(trainX)<- features[,2]

# create one data frame containing all information about test set

train <- cbind(trainsub,trainY,trainX)

#Merge training set and test set

overalldata <- rbind(train,test)

#Assign descriptive columns names

names(overalldata)<-gsub("Acc", "Accelerometer", names(overalldata))
names(overalldata)<-gsub("Gyro", "Gyroscope", names(overalldata))
names(overalldata)<-gsub("BodyBody", "Body", names(overalldata))
names(overalldata)<-gsub("Mag", "Magnitude", names(overalldata))
names(overalldata)<-gsub("^t", "Time", names(overalldata))
names(overalldata)<-gsub("^f", "Frequency", names(overalldata))
names(overalldata)<-gsub("tBody", "TimeBody", names(overalldata))
names(overalldata)<-gsub("-mean()", "Mean", names(overalldata), ignore.case = TRUE)
names(overalldata)<-gsub("-std()", "STD", names(overalldata), ignore.case = TRUE)
names(overalldata)<-gsub("-freq()", "Frequency", names(overalldata), ignore.case = TRUE)
names(overalldata)<-gsub("angle", "Angle", names(overalldata))
names(overalldata)<-gsub("gravity", "Gravity", names(overalldata))

#Extracts only the mean and standard deviation for each measurement

means <- grepl("mean()",colnames(overalldata),ignore.case = TRUE)
stds <- grepl("std()",colnames(overalldata),ignore.case = TRUE)

tidyData <- overalldata[,union(1:3,sort(union(which(means),which(stds))))]


#create a second independent tidy data set with the average of each variable for each activity and each subject

tidyData$person_numer <- as.factor(tidyData$person_number)
tidyData$activity <- as.factor(tidyData$activity)

meanPerSubjectActivity <-aggregate(tidyData[,4:83],list(person=tidyData$person_number,activity=tidyData$activity),mean, rm.na=TRUE)

#write Data

write.table(tidyData,"tidydata.txt",row.name=FALSE)
write.table(meanPerSubjectActivity ,"means-per-subject-and-activity.txt",row.name=FALSE)
