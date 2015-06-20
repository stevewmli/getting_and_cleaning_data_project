#Getting and Cleaning data

## run_analysis.R

## function run_analysis

## Description
run_analysis load the sample data set and perform data transformation to convert the result to a tidy dataset.
The source data is https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones for details.

These are the actiions carry out by the main function:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Dependencies
library: dplyr, tidyr

## Usage

> library(dplyr); library(tidyr)
>
> source("run_analysis.R")
> 
> setwd("C:\\DIRECTORY TO SAMPLE DATASET\UCI HAR Dataset")
>
> result <- run_analysis()

or

> result <- run_analysis("C:\\DIRECTORY TO SAMPLE DATASET\UCI HAR Dataset")

## Arguments
directory: root directory of the sample data. Default to current directory (.)

## Details
The main function, run_analysis, load the activity labels and featues, retrieve the test and training as dataset and  merge the two into one. We apply transformation to covert the combined data into the tidy dataset.

run_analysis utilize load_table function to retrieve the test and training dataset. load_table function takes four arguments:

* directory: data set root directory
* data_type: value can be test or train. It can be used to identify the test/train data directory and it corresponding data file
* activity_labels: table of activities (WALKING, SITTING, ...)
* features: inforamtion about the signals

load_table combines information from subject, activities, and the data set and return the tbl wrapped data frame.

## Assumption
This is the dataset directory structure:

> Directory: [data_type] -
>      File: X_[data_type].txt
>      File: y_[data_type].txt
>      File: subject_[data_type].txt
