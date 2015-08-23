library(reshape2)

#Download and unzip the file
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, "HAR_Dataset.zip", mode = "wb")
unzip("HAR_Dataset.zip")

#load the activity lables and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#Extract the mean and standard deviation for each measurement
extract_features <- grep(".*mean.*|.*std.*", features[,2])
extract_features.names <- features[extract_features,2]


#Load the datasets X and Y (test and train)
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")[extract_features]
trainY <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, trainY, trainX)

testX <- read.table("UCI HAR Dataset/test/X_test.txt")[extract_features]
testY <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, testY, testX)

#Merge test and train data
Data <- rbind(train, test)
colnames(Data) <- c("subject", "activity", extract_features.names)

#Label datasets + calculate mean + create a tidy.txt
Data$activity <- factor(Data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
Data$subject <- as.factor(Data$subject)
Data.melted <- melt(Data, id = c("subject", "activity"))
Data.mean <- dcast(Data.melted, subject + activity ~ variable, mean)

write.table(Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
