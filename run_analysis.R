######################################################################
#Coursera "Getting and Cleaning Data" Course Project
#Author: Oscar Mendoza
#

#You should create one R script called run_analysis.
#R that does the following:
#1. Merges the training and the test sets to create one data set
#2. Extract only the measurements on the mean and standard deviation for each measurement
#3. Use descriptive activity names to name the activities in the data set
#4. Appropriately label the data set with descriptive activity names.
#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

######################################################################
######################################################################

#1. Merges the training and the test sets to create one data set

#load dplyr package

library(dplyr)

#clean the workspace

rm(list=ls())

#Files reading. Since this is an R project linked to a Github Repo
#the datafiles are pasted in the same directory. 

files_directory <- paste(getwd(), "/UCI HAR Dataset/", sep = "")

#It is worthy to note that the datafiles are on .txt format.

#First, the files located in the main directory

#please notice that, although the lectures recommend using variable names all in lower case, the reading of the names becomes difficult if an upper case is
#not used to separate the words

activity_labels <- read.table(file = paste(files_directory, "activity_labels.txt", sep = ""), header = FALSE, col.names = c("activityId","activityType"))
features <- read.table(file = paste(files_directory, "features.txt", sep = ""), header = FALSE, col.names = c("featureId","featureType") )

#the files located in the /test folder

subject_test <- read.table(file = paste(files_directory,"test/subject_test.txt", sep = ""), header = FALSE)
X_test <- read.table(file = paste(files_directory, "test/X_test.txt", sep = ""), header = FALSE)
y_test <- read.table(file = paste(files_directory, "test/y_test.txt", sep = ""), header =  FALSE)

#the files located in the /train folder

subject_train <- read.table(file = paste(files_directory, "train/subject_train.txt", sep = ""), header = FALSE)
X_train <- read.table(file = paste(files_directory, "train/X_train.txt", sep = ""),header = FALSE)
y_train <- read.table(file = paste(files_directory, "train/y_train.txt", sep = ""), header = FALSE)

#assign column names
colnames(subject_test) <- "subjectId"
colnames(X_test) <- features[,2]
colnames(y_test) <- "activityId"

colnames(subject_train) <- "subjectId"
colnames(X_train) <- features[,2]
colnames(y_train) <- "activityId"

#Create the test dataset by merging X_test, y_test, subject_test

test_dataset <- cbind(subject_test, y_test, X_test)

#Create the train dataset by merging X_train, y_train, subject_train

train_dataset <- cbind(subject_train, y_train, X_train)

#Create the new dataset by merging both the train and test datasets

final_dataset <- rbind(test_dataset, train_dataset)

######################################################################
######################################################################

#2. Extract only the measurements on the mean and standard deviation for each measurement

selected_columns <- grepl("mean()", names(final_dataset)) | grepl("std()", names(final_dataset))

selected_dataset <- final_dataset[, selected_columns]

######################################################################
######################################################################

#3. Use descriptive activity names to name the activities in the data set

#there are two ways of doing this activity, the first one is to merge the final_dataset with the activity_labels
#and reordering the columns in a way that the activityType is next to the activityID

#final_dataset <- merge(x = final_dataset, y = activity_labels, by = "activityId", all.x = TRUE)

#the other one, is to declare activityId as a factor, assigning levels according to the activity_levels files
#and labeles according to the same file

final_dataset$activityId <- factor(x = final_dataset$activityId, levels = activity_labels$activityId, labels = activity_labels$activityType )

######################################################################
######################################################################

#4. Appropriately label the data set with descriptive activity names.

#remove the ()
names(final_dataset) <- gsub(pattern = "\\()", replacement = "", names(final_dataset))

#change the f and t at the beggining of each word by time and frequency
names(final_dataset) <- gsub(pattern = "^t", replacement = "time", names(final_dataset))
names(final_dataset) <- gsub(pattern = "^f", replacement = "frequency", names(final_dataset))

#replace - and , with .
names(final_dataset) <- gsub(pattern = "\\-", replacement = ".", names(final_dataset))
names(final_dataset) <- gsub(pattern = "\\,", replacement = ".", names(final_dataset))

#although there are other rules for naming variables in Data Science, I do believe that besides these changes
#the names of the variables are representative enough.

######################################################################
######################################################################

#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#declare subjectId as factor as well

final_dataset$subjectId <- as.factor(final_dataset$subjectId)

#melt the dataframe to create another one to compute the mean()

library(reshape2)

final_dataset_melted <- melt(final_dataset, id = c("subjectId","activityId"))

#cast a new dataset with the means

final_dataset_tidy <- dcast(final_dataset_melted, subjectId + activityId ~ variable, mean)

#export the tidy dataset in a txt

write.table(x = final_dataset_tidy, file = "tidydataset.txt", row.names = FALSE, quote = FALSE )


