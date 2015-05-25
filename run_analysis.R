##Gets zip data from link, uncompress and read it
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFileName <- "UCI-HAR-Dataset.zip"

##Finds if zipFile needs to be downloaded
if(!file.exists(zipFileName)){
    download.file(url = url, zipFileName)
    ## store donwload date
    dateDownloaded <- date()
    message(paste("Download date: ", dateDownloaded))        
}

##Unzip downloaded file
dataPath <- "./UCI HAR Dataset";
if(!file.exists(dataPath)){
    message("Unzip file")
    unzip(zipFileName)
}

##Try to find features file
featuresFile <- paste(dataPath, "features.txt", sep = "/")
if(!file.exists(featuresFile))
    stop("features.txt file not found.")

##Loads data set header
message("Loading data header")
features <- read.csv(featuresFile, header = FALSE, sep = "")

##Try to find training files
trainingFileX <- paste(dataPath, "train/X_train.txt", sep = "/")
if(!file.exists(trainingFileX))
    stop("Training data X_train.txt file not found.")

##Loads training set
message("Loading training data")
trainingSet <- read.csv(trainingFileX, header = FALSE, sep = "")


##Try to find test file
testFileX <- paste(dataPath, "test/X_test.txt", sep = "/")
if(!file.exists(testFileX))
    stop("Testing data X_test.txt file not found.")

##Loads the test set
message("Loading test data")
testSet <- read.csv(testFileX, header = FALSE, sep = "")

##Bind test and training data rows
boundDataSet <- rbind(testSet, trainingSet)
##Setup data set column names
names(boundDataSet) <- features$V2

##Keeps only columns that contains mean() or std() measurements
##It isn't using select from dplyr because of duplicated column names
meanAndStdColumns <- sort(c(grep("mean()", names(boundDataSet), fixed = T), 
                         grep("std()", names(boundDataSet), fixed = T)))
meanAndStdDataSet <- boundDataSet[,meanAndStdColumns]

##Try to find activity labels file
activityLabelsFile <- paste(dataPath, "activity_labels.txt", sep = "/")
if(!file.exists(activityLabelsFile))
    stop("activity_labels.txt file not found.")

##Loads activity labels
message("Loading activity labels")
activityLabels <- read.csv(activityLabelsFile, header = FALSE, sep = "")

##Loads trainingSet labels
trainingFileY <- paste(dataPath, "train/Y_train.txt", sep = "/")
if(!file.exists(trainingFileY))
    stop("Training data Y_train.txt file not found.")
trainingSetY <- read.csv(trainingFileY, header = FALSE, sep = "")
##Sets activity column name
names(trainingSetY) <- c("activities")

##Loads testSet labels
testFileY <- paste(dataPath, "test/Y_test.txt", sep = "/")
if(!file.exists(testFileY))
    stop("Training data Y_test.txt file not found.")
testSetY <- read.csv(testFileY, header = FALSE, sep = "")
##Sets activity column name
names(testSetY) <- c("activities")

##Adds activity column to mean and std dev dataSet
meanAndStdDataSet <- cbind(rbind(testSetY, trainingSetY), meanAndStdDataSet)

##Labels activities with names from loaded labels
meanAndStdDataSet$activities <- factor(meanAndStdDataSet$activities, labels = activityLabels[,2])

##Rename columns containing -mean() and -std() to Mean and Std respectively to avoid function syntax.
##i.e. tBodyAcc-mean()-X renamed to tBodyAccMean-X
names(meanAndStdDataSet) <- gsub("-mean()", "Mean", names(meanAndStdDataSet), fixed = T)
names(meanAndStdDataSet) <- gsub("-std()", "Std", names(meanAndStdDataSet), fixed = T)

##Replaces t by time and f by fourier for better understanding
names(meanAndStdDataSet) <- sub("^t", "time", names(meanAndStdDataSet))
names(meanAndStdDataSet) <- sub("^f", "fourier", names(meanAndStdDataSet))

##Loads trainingSet subjects
trainingSubjectFile <- paste(dataPath, "train/subject_train.txt", sep = "/")
if(!file.exists(trainingSubjectFile))
    stop("Training data subject_train.txt file not found.")
trainingSubjectSet <- read.csv(trainingSubjectFile, header = FALSE, sep = "")
##Sets subjects column name
names(trainingSubjectSet) <- c("subjects")

##Loads testSet labels
testSubjectFile <- paste(dataPath, "test/subject_test.txt", sep = "/")
if(!file.exists(testSubjectFile))
    stop("Training data subject_test.txt file not found.")
testSubjectSet <- read.csv(testSubjectFile, header = FALSE, sep = "")
##Sets subjects column name
names(testSubjectSet) <- c("subjects")

##Adds subject column to mean and std dev dataSet
meanAndStdDataSet <- cbind(rbind(testSubjectSet, trainingSubjectSet), meanAndStdDataSet)

##Group data by subjects and activities and calculate mean for each measurement
tidyActivityDataSet <- summarise_each(group_by(meanAndStdDataSet, subjects, activities), funs(mean))

##Save data to text file
write.table(tidyActivityDataSet, file = "tidyActivityDataSet.txt", row.names = FALSE)