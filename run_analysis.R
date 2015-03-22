library(tidyr)
library(dplyr)
library(splitstackshape)

#####################################################
### Step 1 - Merge the training and test datasets ###
#####################################################

test<-read.table("~/UCI HAR Dataset/test/X_test.txt", sep="\t", stringsAsFactors=F)
train<-read.table("~/UCI HAR Dataset/train/X_train.txt", sep="\t", stringsAsFactors=F)

data<-rbind(test, train)

rm(test, train)

# Separate the data DF into columns
# Challenge is that the columns are space separated, but there are two spaces in front of pos numbers
# and only one space in front of neg numbers. The cSplit command handles this.
data<-cSplit(data, "V1", sep=" ")


#####################################################
### Step 4 - Descriptively label the dataset      ###
#####################################################

labels<-read.table(file="~/UCI HAR Dataset/features.txt", sep=" ", stringsAsFactors=F)
labels<-labels[,2] # Only interested in the second column of the labels DF
names(data)<-labels


##############################################################
### Step 2 - Choose only the mean and std dev measurements ###
##############################################################

newLabels1<-grepl("mean", labels) # id all column names that have a mean or meaFreq in them
newLabels2<-grepl("meanFreq", labels) # id all column names that only have meanFreq in them
newLabels3<-newLabels1 & !newLabels2 # id column names that contain only mean and not meanFreq 
newLabels4<-grepl("std", labels) # id all column names that contain std
newLabels5<-newLabels3 | newLabels4 # id all column names that contain std or mean
count<-1:length(labels)
count<-count[newLabels5==T]

data<-data %>% select(count)

rm(count, newLabels1, newLabels2, newLabels3, newLabels4, newLabels5)

###################################################
### Step 3 - Name the activities in the dataset ###
###################################################

testID<-read.table(file="~/UCI HAR Dataset/test/y_test.txt", sep="\t", stringsAsFactors=F)
trainID<-read.table(file="~/UCI HAR Dataset/train/y_train.txt", sep="\t", stringsAsFactors=F)
activity<-read.table(file="~/UCI HAR Dataset/activity_labels.txt", sep=" ", stringsAsFactors=F)

id<-rbind(testID, trainID) 
rm(testID, trainID)

# Add the activity id to each observation
names(id)<-"activityID"
data<-cbind(id, data)
rm(id)

# Add activity descriptions to the data DF
names(activity)<-c("activityID", "activity")
data<-left_join(data, activity, by="activityID")
rm(activity)


##############################################
### Step 5a - Add a subject id to each obs ###
##############################################

# First add a subject id to each obs
testSubj<-read.table(file="~/UCI HAR Dataset/test/subject_test.txt", sep="\t", stringsAsFactors=F)
trainSubj<-read.table(file="~/UCI HAR Dataset/train/subject_train.txt", sep="\t", stringsAsFactors=F)

subject<-rbind(testSubj, trainSubj) 
rm(testSubj, trainSubj)

# Add the subject id to each observation
names(subject)<-"subject"
data<-cbind(subject, data)
rm(subject)


####################################
### Step 5b - Create tidy dataset ###
####################################

tidy<-data %>% gather(measurement, value, -activityID, -subject, -activity)
tidy<-tidy %>% select(-activityID) %>% group_by(subject, activity, measurement) %>% summarize(average=mean(value))

write.table(tidy, "run_analysis_output.txt", sep=",", quote=F, row.name=F)

