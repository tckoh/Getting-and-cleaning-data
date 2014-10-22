## Course Name: Getting and Cleaning Data
## Purpose: Generate a tidy data set from Samsung data

##Reading of features and activity labels files

##1.Read the list of features from "features.txt" into (featurelist)
featurelist = read.table("./UCI HAR Dataset/features.txt", sep="")

##2.Read the list of activity labels from "activity_labels.txt" into (activitylabel)
activitylabel = read.table("./UCI HAR Dataset/activity_labels.txt", sep="")

##3.Rename the column headers in (activitylabel) to "ActivityCode" and "Activity Label"
colnames(activitylabel) <- c("ActivityCode","Activity Label")


##Step 1.Merges the training and the test sets to create one data set.

##1.Read the training data set, label and subject into (trgset), (trglabel) and (trgsubject) respectively
trgset = read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
trglabel = read.table("./UCI HAR Dataset/train/Y_train.txt", sep="")
trgsubject = read.table("./UCI HAR Dataset/train/subject_train.txt", sep="")

##2.Column bind (trgset), (trglabel) and (trgsubject) into (trgds)
trgds <- cbind(trgsubject,trglabel,trgset)

##3.Read the test data set, label and subject into (testset), (testlabel) and (testsubject) respectively
testset = read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
testlabel = read.table("./UCI HAR Dataset/test/Y_test.txt", sep="")
testsubject = read.table("./UCI HAR Dataset/test/subject_test.txt", sep="")

##4.Column bind (testset), (testlabel) and (testsubject) into (testds)
testds <- cbind(testsubject,testlabel,testset)

##5.Row bind (trgds) and (testds) into (mds) i.e. merged data set
mds <- rbind(trgds,testds)


##Step 2.Extracts only the measurements on the mean and standard deviation 
##for each measurement.

##1.Extract all mean measurements from (featurelist) into (featureMean)
featureMean <- featurelist[grepl("mean()",featurelist$V2,fixed=TRUE),]

##2.Extract all standard deviation measurements from (featurelist) into (featureStd)
featureStd <- featurelist[grepl("std()",featurelist$V2,fixed=TRUE),]

##3.Merge (featureMean) and (featureStd) into (featureMeanStd) and sort (featureMeanStd)
featureMeanStd <- rbind(featureMean, featureStd)
featureMeanStd <- featureMeanStd[order(as.numeric(as.character(featureMeanStd$V1))),]

##4.Subset data from (mds) into (mdsMeanStd) using the list of features in (featureMeanStd)
mdsMeanStd <- mds[,c(1,2,(featureMeanStd$V1)+2)]


##Step 3.Uses descriptive activity names to name the activities in the data set.

##1.Rename the first and second column headers in (mdsMeanStd) to "Subject" and "ActivityCode"
colnames(mdsMeanStd)[1] <- "Subject"
colnames(mdsMeanStd)[2] <- "ActivityCode"

##2.Merge (activitylabel) and (mdsMeanStd) by "ActivityCode" into (mds_activity)
mds_activity <- merge(activitylabel, mdsMeanStd, by = "ActivityCode")

##3.Remove "ActivityCode" column i.e. first column of (mds_activity) by setting it to NULL
mds_activity[1] <- NULL


##Step 4.Appropriately labels the data set with descriptive variable names. 

##1.Rename column headers of (mds_activity) to "ActivityLabel", "Subject" and the list of feature names in (featureMeanStd)
colnames(mds_activity) <- c("ActivityLabel","Subject",lapply(featureMeanStd$V2, as.character))

##2.Sort (mds_activity) by "Subject"
mds_activity <- mds_activity[order(as.numeric(as.character(mds_activity$Subject))),]


##Step 5.From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.

##1.Generate summary of (mds_activity) into (mds_summary) using aggregate function with parameters "Activity Label" and "Subject"
mds_summary <- aggregate(mds_activity[,(3:(ncol(mds_activity)-2))], by=list(mds_activity$ActivityLabel,mds_activity$Subject), mean)

##2.Rename the first and second column headers in (mds_summary) to "ActivityLevel" and "Subject"
colnames(mds_summary)[1] <- "ActivityLevel"
colnames(mds_summary)[2] <- "Subject"

##3.Output (mds_summary) to "tidy_data.txt" file in current working directory
write.table(mds_summary, "./tidy_data.txt", row.name=FALSE)