

###############################################################################
## Part 1: merge the training and test sets
###############################################################################

## Create the column names
tmp <- read.table("UCI HAR Dataset/features.txt")
cname <- as.character(tmp$V2)

## Read the training and test sets
trainingSet <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = cname)
testSet <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = cname)

## Merge the training and test sets
totalSet <- rbind(trainingSet, testSet)

###############################################################################
## Part 2: extract only the measurements on the mean and standard deviation
## for each measurement
###############################################################################

## Indexes of the column names containing either mean or std
idm <- grep("mean",names(totalSet))
ids <- grep("std",names(totalSet))

## Extract the measurements on either mean or std
extractSet <- totalSet[,c(idm,ids)]


###############################################################################
## Part 3: add the activities and subjects, then use descriptive names for 
## the activities
###############################################################################

#---------------------------------------------------------------------------#
## Read the activities list
tmp1 <- scan("UCI HAR Dataset/train/y_train.txt")
tmp2 <- scan("UCI HAR Dataset/test/y_test.txt")

## Add the activities to the training and test sets
extractSet$activity <- c(tmp1,tmp2)

#---------------------------------------------------------------------------#
## Read the subject list
tmp1 <- scan("UCI HAR Dataset/train/subject_train.txt")
tmp2 <- scan("UCI HAR Dataset/test/subject_test.txt")

## Add the subjects to the training and test sets
extractSet$subject <- c(tmp1,tmp2)

#---------------------------------------------------------------------------#
## Read the activities' names
actname <- read.table("UCI HAR Dataset/activity_labels.txt")

## Modify the names of the activities
for (ii in 1:length(actname$V2) ) {
    extractSet$activity <- sub(actname$V1[ii], actname$V2[ii], extractSet$activity)
}

###############################################################################
## Part 4: Label the data set with descriptive variable names
###############################################################################

## Assign names of extractSet to tmp for ease of coding
tmp <- names(extractSet)
tmp <- gsub("[.]","_",tmp)
tmp <- gsub("__","",tmp)
tmp <- sub("X","axisX",tmp)
tmp <- sub("Y","axisY",tmp)
tmp <- sub("Z","axisZ",tmp)

tmp <- sub("^t","timeDomain_",tmp)
tmp <- sub("^f","freqDomain_",tmp)

tmp <- sub("std","standardDeviation",tmp);

tmp <- sub("Acc","LinearAcceleration",tmp)
tmp <- sub("Gyro","AngularVelocity",tmp)
tmp <- sub("Jerk","_JerkSignal",tmp)
tmp <- sub("Mag","_Magnitude",tmp)

## Modify the names of extractSet
names(extractSet) <- tmp


###############################################################################
## Part 5: create a second, independent tidy set with the average
## of each variable for each activity and each subject
###############################################################################

## Extract the independent pairs of activity and subject from
## extractSet
secondSet <- expand.grid(unique(extractSet$subject), unique(extractSet$activity))
names(secondSet) <- c("subject","activity")

## Arrange the data frame based on the subject
secondSet <- secondSet[with(secondSet, order(secondSet$subject)), ]

#---------------------------------------------------------------------------#
## Create the data set with average values
## Initialize as a NULL data frame
tmp <- data.frame()

## Take the mean of each variable and add to tmp
for (ii in 1:length(secondSet$subject)) {
    ## Extract the data frame for each combination of subject and activity
    tmp2 <- extractSet[extractSet$subject == secondSet$subject[ii] & extractSet$activity == secondSet$activity[ii],]
    acttmp <- tmp2$activity[1]
    
    tmp2$activity <- NULL
    
    ## Take the mean of each column of the data frame
    tmp2 <- lapply(tmp2,mean)

    tmp2$activity <- acttmp
    
    ## Add the data frame to the total data frame
    tmp <- rbind(tmp,tmp2)
    tmp$activity <- as.character(tmp$activity)
}

#---------------------------------------------------------------------------#s
## Assign the data set with average values to the secondSet
secondSet <- tmp

## Arrange the data set so that the subejct number is increasing
secondSet <- arrange(secondSet,subject)

###############################################################################
## Part 6:save the tidy data set as a text file
###############################################################################

write.table(secondSet, file = "tidySet.txt", row.name = FALSE) 







