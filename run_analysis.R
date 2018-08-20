# install required packages
install.packages("data.table")
library(data.table)

#Download data set

# if(!file.exists("./data")){dir.create("./data")}
# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileUrl, destfile = "./data/phonedata.zip", method = "curl")
# unzip(zipfile="./data/phonedata.zip",exdir="./data")
# setwd("./data/UCI HAR Dataset")

# Load activity labels and extract features needed

activity_labels <- read.table("activity_labels.txt", col.names = c("activityId", "activityType"))
features <- read.table("features.txt", col.names = c("index", "name"))
features_extracts <- subset(features, grepl(".*mean|.*std", features$name))

# Load training dataset, labels, and subjets.

train <- read.table("train/X_train.txt")[ ,features_extracts$name]
colnames(train) <- features_extracts[,2]
train_activity <- read.table("train/Y_train.txt", col.names = "activityId")
train_subject <- read.table("train/subject_train.txt", col.names = "subjectId")


# Merge training, activity and subject dataset

train_mrg <- cbind(train_subject, train_activity, train)

# Load test dataset, activity and subject

test <- read.table("test/X_test.txt")[ ,features_extracts$index]
colnames(test) <- features_extracts[,2]
test_activity <- read.table("test/Y_test.txt", col.names = "activityId")
test_subject <- read.table("test/subject_test.txt", col.names = "subjectId")


# Merge test, activity , and subject

test_mrg <- cbind(test_activity, test_subject, test)

# Merge train and test dataset

new_data <- rbind(train_mrg, test_mrg) 

new_data$activityId <- factor(new_data$activityId, levels = activity_labels[, 1], labels = activity_labels[, 2])
new_data$subjectId <- as.factor(new_data$subjectId)

str(new_data)

# Create a tidy dataset

summary_data <-aggregate(new_data[, 3:ncol(new_data)], by=list(new_data$subjectId, new_data$activityId), FUN=mean, na.rm=TRUE)
colnames(summary_data) [1:2]<- c("subject", "activity") 

write.table(summary_data, file="summary_data.txt", row.names = FALSE)

head(summary_data)
