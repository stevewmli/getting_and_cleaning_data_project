###############################################################################
# run_analysis.R
# 
# run_analysis is the main function in this script that analysis the smart phone
# dataset for human activity
# 
# The directory parameter is the root directory of the unzipped dataset. 
# The default directory is '.' (current directory) with
# assuming that the script executed at the root of the dataset directory
#
# This script:
# a. collect label information. 
# b. load and combine the training data set
# c. transforming the combined dataset into the tidy result
#
# Dependency: library(dplyr) library(tidyr)
# Author: Steve
###############################################################################
run_analysis <- function(directory = ".") {
	# setup path vairable to all the files
	activity_label_path <- paste(c(directory, .Platform$file.sep, "activity_labels.txt"), collapse = '') 
	feature_path <- paste(c(directory, .Platform$file.sep, "features.txt"), collapse = '') 

	
	# load activities file and order the activites by their code
    activity_labels <- read.table(activity_label_path)
	activity_labels <- activity_labels[order(activity_labels$V1),]
	
	# load features list
	features <- read.table(feature_path)
	features <- features[order(features$V1),]

	# load training activities dat
	train <- load_table("train", activity_labels, features)

    # load test activities data	
	test <- load_table("test", activity_labels, features)
	
	
	# combine the test and training data set
	combined <- bind_rows(train, test)
	
	# arrange result data
	combined %>%
        #retrieve the column subject, activity, and any colums that include means and standard derivations
		select (subject, activity, contains("-mean()"), contains("-std()")) %>%
        # gather the signals for features and separate features into signal, varable and axial
		gather(feature, value, -c(subject, activity)) %>%
		separate(feature, c("signal", "variable", "axial")) %>%
        # regroup the data and find out the means of each group
        group_by(subject, activity, signal, axial, variable) %>%
		summarize(avg_value = mean(value)) %>%
        # rearrange mean and standard derivation into value column
        spread(variable, avg_value) %>%
        # reorder the data
		arrange(subject, activity, signal, axial)
}

###############################################################################
# load_table
# 
# This function retrieve the subject information, activity details, and signals.
# It also assign column name to the retrieved data set and merge them into one table
# 
#  Parameters:
#  data_type: value can be test or train. It can be used to identify the test/train
#      data directory and it corresponding data file
#  activity_labels: table of activities (WALKING, SITTING, ...)
#  features: inforamtion about the signals
#
#  This is the data directory structure:
#  Directory: [data_type] -
#       File: X_[data_type].txt
#       File: y_[data_type].txt
#       File: subject_[data_type].txt
#
# Author: Steve
###############################################################################
load_table <- function(data_type, activity_labels, features) {
    subject_path <- paste(c(directory, .Platform$file.sep, data_type, .Platform$file.sep, "subject_", data_type, ".txt"), collapse = '') 
	activity_path <- paste(c(directory, .Platform$file.sep, data_type, .Platform$file.sep, "y_", data_type, ".txt"), collapse = '') 
	signal_path <- paste(c(directory, .Platform$file.sep, data_type, .Platform$file.sep, "X_", data_type, ".txt"), collapse = '') 
    
    # retrieve the ID of the subject that carry out the activities
    subjects <- read.table(subject_path)
    colnames(subjects) <- c("subject")
    
	
	# convert activity value to a factor and map them to the features description (column 2 of the feature table);
    activities <- read.table(activity_path)
	colnames(activities) <- c("activity")
    activities$activity <- as.factor(activities$activity)
	levels(activities$activity) <- activity_labels$V2

	# retrieve signals recorded for the subject's activities
    signals <- read.table(signal_path)
    
    # assign signal titles
	colnames(signals) <- features[,2]
	
	# combine the subjects, activities, and signals into a table
	tbl_df(cbind(subjects, activities, signals))
}
