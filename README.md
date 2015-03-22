This script is part of the Coursera Getting and Cleaning Data course offered by Johns Hopkins University. The data used in this analysis was obtained from the raw Samsung smartphone data collected by the Smartlab - Non Linear Complex Systems Laboratory at the DITEN - Universit‡ degli Studi di Genova [1].

The R script titled run_analysis.R will run assuming that it is stored in the same working directory as the raw data collected at …

The steps involved in the run_analysis.R script are as follows:

1 - Merge the training and test datasets
Read data line by line from the X-test.txt and X_train.txt files, combine them together and store them in a data.frame titled “data” 
Separate the data DF into separate columns for each of the measurements

4 - Descriptively label the dataset
This step is out of order from the recommended lists of steps in the assignment
During this step the features.txt is read into a vector titled “labels” and each of the fields in this vector are assigned as a heading for each unique column in the data DF

2 - Choose only the mean and std dev measurements
This step uses the labels vector and identifies all of the label names that have either mean() or std() in them. The data DF is then reduced to only these columns.

3 - Name the activities in the dataset
For each row in the data DF, there is a corresponding activity ID stored in the y_test.txt and y_train.txt files. The activity ID contains numbers from 1 to 6. The activity_labels.txt contains descriptive labels for each of the activity ID’s.

Therefore, for this step the y_test.txt and y_train.txt files were read and stored in the testID and trainID data.frames. These two data frames were then combined and joined with the data DF. The end result was a new column in the data DF titled “activityID”.

Next, the activity_labels.txt file was read and stored as a data.frame titled activity. This DF was joined with the data DF, with the end result being a new column in the data DF titled activityID.

Step 5a - Add a subject id to each obs

Subject information for each of the data DF readings is stored in the subject_test.txt and subject_train.txt files. These files were read into the testSubj and trainSubj data frames. These two DFs were then combined and joined with the data DF. The end result being a new column added to the data DF titled subject.

Step 5b - Create tidy dataset 

A tidy dataset of the data DF was created and stored as a data frame titled tidy. The tidy DF consists of four columns:
* subject - the subject id
* activity - a descriptive label of the activity being analyzed
* measurement - a column listing each of the specific measurements
* average - the average value for each measurement of each activity for each subject

The tidy DF is written to the file run_analysis_output.txt


[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
