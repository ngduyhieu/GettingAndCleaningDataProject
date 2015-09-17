## This codebook is to describe the variables, the data, and transformation for Getting and Cleaning Data Course Project.
## Author: Hieu Duy Nguyen, 17/09/2015.

## How to use "run_analysis.R"
Put the script into a folder which includes the "UCI HAR Dataset".
Suppose that the folder's name is "Xfolder", then "Xfolder" should contain "run_analysis.R" and the folder "UCI HAR Dataset".
The example name paths sould be: "Xfolder/run_analysis.R" and "Xfolder/UCI HAR Dataset/".

## Data
Require the "UCI HAR Dataset".

## The variables 
### Input variables
Nothing. Only requires the data from "UCI HAR Dataset".

### Output variables 
After running "run_analysis.R", we will obtain "tidySet.txt".
The text file "tidySet.txt" contains a data frame with 180 rows and 81 columns.
The "subject" and "activity" columns denote the number of the subject and the activity they perform.
The columns are the time/frequency domain data for the linear acceleration and angular velocity.
More information can be found in the transformation description.

## Transformation
### First step: merge the training and test sets
We first read the columns' name "cname" or the training and test sets from "features.txt".
We then read the training data from "UCI HAR Dataset/train/X_train.txt" and assign the data to corresponding columns based on "cname".
We then read the test data from "UCI HAR Dataset/test/X_test.txt" and assign the data to corresponding columns based on "cname".
The final step is to merge the two data using "rbind" (row merging) into "totalSet".
 
### Second step: extract the mean and standard deviation measurements
We search through the names of "totalSet" to find the ones with either "mean" or "std".
We obtain the index of the corresponding columns and extract them from "totalSet".
The result is the data frame "extractSet".

### Third step: add the activity and subject data to extractSet
We first read the activity data for the training and test sets.
The results are two vectors which contain 1,2,3,4,5,6.
The activity numbers are added to the "extractSet".
Similarly, we read the subject data for the training and test sets.
Then add them to the "extractSet".
The final step is to map the activity numbers to the activity names.
We read the "UCI HAR Dataset/activity_labels.txt" for the mapping.
Then we modify the "extractSet$activity" to the activty names by mapping the numbers to the activities.

### Fourth step: label the data set with descriptive variable names
First, we clear the "." at the end or substitute it with "-".
Now we change "XYZ" to "axisXYZ".
The "t" and "f" notation is modified to "timeDomain" and "frequencyDomain".
The other substitutions are: "std" -> "standardDeviation", "Acc" -> "LinearAcceleration".
"Gyro" -> "AngularVelocity". "Jerk" -> "_JerkSignal". "Mag" -> "_Magnitude".

### Fifth step: create a second, independent tidy set with the average
### of each variable for each activity and each subject
We extract the unique combination of the subset and activity from "extractSet".
For each of this combination, we extract the data frame with the variables.
We use lapply to take the average of each column of the data frame.
Then we add the resulting data frame to the total data frame.
For better visualization, we arrange the data set such that the subject number is increasing.
The result is the "secondSet" data frame.

### Sixth step: write the "secondSet" to a file called "tidySet.txt".




