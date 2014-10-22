Getting-and-cleaning-data
=========================

Johns Hopkins Coursera Course - Getting and Cleaning Data

## Steps to use the run_analysis.R script


1. Download and save the run_analysis.R script to current working directory


2. Download and unzip the "getdata_projectfiles_UCI HAR Dataset.zip" file. Copy the "UCI HAR Dataset" folder to current working directory.
(Do not change the folder name)


3. Run the run_analysis.R script to generate an independent tidy data set. The tidy data set is stored in "tidy_data.txt" in current working directory.

4. To verify the tidy data set, use read.table() function to access the "tidy_data.txt" file for viewing in R


## Description of run_analysis.R

####Reading of features and activity labels files
1. Read the list of features from "features.txt" into (featurelist)
2. Read the list of activity labels from "activity_labels.txt" into (activitylabel)
3. Rename the column headers in (activitylabel) to "ActivityCode" and "Activity Label"

####Step 1.Merges the training and the test sets to create one data set.
1. Read the training data set, label and subject into (trgset), (trglabel) and (trgsubject) respectively
2. Column bind (trgset), (trglabel) and (trgsubject) into (trgds)
3. Read the test data set, label and subject into (testset), (testlabel) and (testsubject) respectively
4. Column bind (testset), (testlabel) and (testsubject) into (testds)
5. Row bind (trgds) and (testds) into (mds) i.e. merged data set

####Step 2.Extracts only the measurements on the mean and standard deviation for each measurement.
1. Extract all mean measurements from (featurelist) into (featureMean)
2. Extract all standard deviation measurements from (featurelist) into (featureStd)
3. Merge (featureMean) and (featureStd) into (featureMeanStd) and sort (featureMeanStd)
4. Subset data from (mds) into (mdsMeanStd) using the list of features in (featureMeanStd); This is to retain only mean and 
standard deviation measurements for further analysis

####Step 3.Uses descriptive activity names to name the activities in the data set.
1. Rename the first and second column headers in (mdsMeanStd) to "Subject" and "ActivityCode"
2. Merge (activitylabel) and (mdsMeanStd) by "ActivityCode" into (mds_activity)
3. Remove "ActivityCode" column i.e. first column of (mds_activity) by setting it to NULL 

####Step 4.Appropriately labels the data set with descriptive variable names.
1. Rename column headers of (mds_activity) to "ActivityLabel", "Subject" and the list of feature names in (featureMeanStd)
2. Sort (mds_activity) by "Subject" 

####Step 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
1. Generate summary of (mds_activity) into (mds_summary) using aggregate function with parameters "Activity Label" and "Subject"
2. Rename the first and second column headers in (mds_summary) to "ActivityLevel" and "Subject"
3. Output (mds_summary) to "tidy_data.txt" file in current working directory