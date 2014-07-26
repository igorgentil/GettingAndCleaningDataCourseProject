library(data.table)
library(plyr)

setwd('~/Downloads')

subject_Test <- read.table("Dataset/UCI HAR Dataset/test/subject_test.txt")
y_Test <- read.table("Dataset/UCI HAR Dataset/test/y_test.txt")
x_Test <- read.table("Dataset/UCI HAR Dataset/test/X_test.txt")

subject_Train <- read.table("Dataset/UCI HAR Dataset/train/subject_train.txt")
y_Train <- read.table("Dataset/UCI HAR Dataset/train/y_train.txt")
x_Train <- read.table("Dataset/UCI HAR Dataset/train/X_train.txt")

features <- read.table("Dataset/UCI HAR Dataset/features.txt")
headings <- features$V2

colnames(x_Train) = headings
colnames(x_Test) = headings

y_Test <- rename(y_Test, c(V1="activity"))
y_Train <- rename(y_Train, c(V1="activity"))

activity <- read.table("Dataset/UCI HAR Dataset/activity_labels.txt")

activityLabels = tolower(levels(activity$V2))

y_Train$activity = factor(
        y_Train$activity, 
        labels = activityLabels
)

y_Test$activity = factor(
        y_Test$activity, 
        labels = activityLabels
)

subject_Train <- rename(subject_Train, c(V1="subjectid"))
subject_Test <- rename(subject_Test, c(V1="subjectid"))

train = cbind(x_Train, subject_Train, y_Train)
test = cbind(x_Test, subject_Test, y_Test)

fullData = rbind(train, test)

pattern = "mean|std|subjectid|activity"
tidyData = fullData[,grep(pattern , names(fullData), value=TRUE)]

cleanNames = gsub("\\(|\\)|-|,", "", names(tidyData))
names(tidyData) <- tolower(cleanNames)

result = ddply(tidyData, .(activity, subjectid), numcolwise(mean))

write.table(result, file="tidy_data_set.txt", sep = "\t", append = F)
