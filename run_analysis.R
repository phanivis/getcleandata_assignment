#course 3 Getting and Cleaning Data
#Course Assignment

#setting path for working directory
path <- "~/Desktop/coursera/course3/assignment"
setwd(path)
#check if data directory exists. If it doesnt, create directory and download data
if(!dir.exists("./data")){
  
  dir.create("./data")
  data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(data_url,destfile = "./data/dataset.zip" , method = "curl" )
}
#unzip data
unzip(zipfile = "./data/dataset.zip", exdir = "./data")


#Assignment requires us to do the following
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#1.1 Reading data
#1.1.1 Reading data from training table
  feature_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
  activity_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
  subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
#1.1.2 Reading data from testing table
  feature_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
  activity_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
  subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
#1.1.3 Reading activity label list and features list
  activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
  features <- read.table("./data/UCI HAR Dataset/features.txt")

#1.2.1 merge train and test data to get the complete data in order

  dataSubject <- rbind(subject_train,subject_test)
  dataActivity <- rbind(activity_train,activity_test)
  dataFeatures <- rbind(feature_train,feature_test)
#1.2.2 assign names to the data  
  names(dataSubject) <- "Subject"
  names(dataActivity) <- "ActivityId"
  names(dataFeatures) <- features[,2]
  names(activity) <- c("ActivityId", "ActivityDesc")
#1.3 merge data
data <- cbind(dataSubject, dataActivity,dataFeatures)

#2 Extract only Mean & Standard deviation ie colnames with mean() or std()
#2.1 identify columns with mean or std

colNames <- colnames(data)
reqcol <- grep("Subject|ActivityId|mean|std", colNames)
#2.2  subset with only required columns
reqdata <- data[, reqcol]

#3 Use Descriptive Activity names for Activity ID

newreqdata <- merge(reqdata, activity, by = "ActivityId")

#4 Approx label names with descriptive variable names 

names(newreqdata)<-gsub("^t", "time", names(newreqdata))
names(newreqdata)<-gsub("^f", "frequency", names(newreqdata))
names(newreqdata)<-gsub("Acc", "Accelerometer", names(newreqdata))
names(newreqdata)<-gsub("Gyro", "Gyroscope", names(newreqdata))
names(newreqdata)<-gsub("Mag", "Magnitude", names(newreqdata))
names(newreqdata)<-gsub("BodyBody", "Body", names(newreqdata))

#5 create independent tidy data set

library(plyr)
data <- aggregate(. ~Subject + ActivityId, newreqdata, mean )
newreqdata <- newreqdata[order(newreqdata$Subject, newreqdata$ActivityId),]

write.table(newreqdata, "finaldata.txt", row.names = FALSE)




  

