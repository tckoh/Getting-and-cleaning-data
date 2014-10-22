##Read list of features and activity labels
featurelist = read.table("./UCI HAR Dataset/features.txt", sep="")
activitylabel = read.table("./UCI HAR Dataset/activity_labels.txt", sep="")
colnames(activitylabel) <- c("ActivityCode","Activity Label")


##Step 1.Merges the training and the test sets to create one data set.

##Read training set, label and subject
trgset = read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
trglabel = read.table("./UCI HAR Dataset/train/Y_train.txt", sep="")
trgsubject = read.table("./UCI HAR Dataset/train/subject_train.txt", sep="")
trgds <- cbind(trgsubject,trglabel,trgset)

##Read test set, label and subject
testset = read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
testlabel = read.table("./UCI HAR Dataset/test/Y_test.txt", sep="")
testsubject = read.table("./UCI HAR Dataset/test/subject_test.txt", sep="")
testds <- cbind(testsubject,testlabel,testset)

##Merge training and test data sets into merged dataset ("mds")
mds <- rbind(trgds,testds)


##Step 2.Extracts only the measurements on the mean and standard deviation 
##for each measurement.

##Extract all mean measurements
featureMean <- featurelist[grepl("mean()",featurelist$V2,fixed=TRUE),]

##Extract all standard deviation measurements
featureStd <- featurelist[grepl("std()",featurelist$V2,fixed=TRUE),]

##Merge and sort featureMean and featureStd
featureMeanStd <- rbind(featureMean, featureStd)
featureMeanStd <- featureMeanStd[order(as.numeric(as.character(featureMeanStd$V1))),]

##Subset data to retain only mean and standard deviation measurements
mdsMeanStd <- mds[,c(1,2,(featureMeanStd$V1)+2)]


##Step 3.Uses descriptive activity names to name the activities in the data set.
##Rename column header
colnames(mdsMeanStd)[1] <- "Subject"
colnames(mdsMeanStd)[2] <- "ActivityCode"

##Merge by Activity Code to include descriptive activity names
mds_activity <- merge(activitylabel, mdsMeanStd, by = "ActivityCode")

##Remove Activity Code column
mds_activity[1] <- NULL


##Step 4.Appropriately labels the data set with descriptive variable names. 

##Rename column header
colnames(mds_activity) <- c("ActivityLabel","Subject",lapply(featureMeanStd$V2, as.character))

##Sort by Subject
mds_activity <- mds_activity[order(as.numeric(as.character(mds_activity$Subject))),]


##Step 5.From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.

##Generate summary
mds_summary <- aggregate(mds_activity[,(3:(ncol(mds_activity)-2))], by=list(mds_activity$ActivityLabel,mds_activity$Subject), mean)

##Rename column header
colnames(mds_summary)[1] <- "ActivityLevel"
colnames(mds_summary)[2] <- "Subject"

##Write mds_summary to a txt file
write.table(mds_summary, "./tidy_data.txt", row.name=FALSE)