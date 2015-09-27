#load dplyr
library(dplyr)

#Assuming we are starting from the repertory that contains the README.txt file
#Load the activity labels and give appropriate names for each column
activity_labels <- read.table("activity_labels.txt")
names(activity_labels) <- c("activity_ID", "activity_label")
#Load the names of the variables (or features) for both training and test
#datasets, then give each column a proper name
feature_labels <- read.table("features.txt")
names(feature_labels) <- c("count", "feature_label")

#load training data
train_data <- read.table("./train/X_train.txt")
#Load the matching activity for each observation
train_activity <- read.table("./train/y_train.txt")
#Load the subject observed
train_subject <- read.table("./train/subject_train.txt")
#Add meaningful names for both activities' observations and subjects' observation
names(train_activity) <- c("activity_ID")
names(train_subject) <- c("subject_ID")
#Add the names of the variables for the training data
names(train_data) <- feature_labels$feature_label
#add the observed subject's ID and the corresponding activity to the original
#training dataset
train_data <- bind_cols(list(train_subject, train_activity, train_data))

#load test data
test_data <- read.table("./test/X_test.txt")
#Load the matching activity for each observation
test_activity <- read.table("./test/y_test.txt")
#Load the subject observed
test_subject <- read.table("./test/subject_test.txt")
#Add meaningful names for both activities' observations and subjects' observation
names(test_activity) <- c("activity_ID")
names(test_subject) <- c("subject_ID")
#Add the names of the variables for the test data
names(test_data) <- feature_labels$feature_label
#add the observed subject's ID and the corresponding activity to the original
#test dataset
test_data <- bind_cols(list(test_subject, test_activity, test_data))

#Combine the test and training datasets
#NOTA: this also gets rid of some of the fBodyAcc-bandsEnergy() and the
#fBodyAccJerk-bandsEnergy() columns as there are duplicated column name
clean_data <- bind_rows(train_data, test_data)
#Add the activity labels with matching activity ID
clean_data <- merge(clean_data, activity_labels, by = "activity_ID")
#Get all the measurements on mean and standard deviation for each measurement
#and rearrange the table by subject ID and activity; create some groups
#to facilitate the calculation of the average
clean_data <- clean_data %>%
  select(subject_ID, activity_label, contains("mean()"), contains("std()")) %>%
  arrange(subject_ID, activity_label) %>%
  group_by(subject_ID, activity_label)
#Need to modify the variables names by suppressing parenthesis and replacing
# dashes with underscores in order to facilitate further processing
names(clean_data) <- gsub("-", "_", names(clean_data))
names(clean_data) <- gsub("[()]", "", names(clean_data))

#Create the final dataset by averaging each variable by subject and activity
final_data <- clean_data %>% summarise_each(funs(mean))
#Generate the corresponding .txt file
write.table(final_data, file = "coursera_cleaning_project.txt", row.names = FALSE)
