## 

run_analysis <- function() {
    
    ## gets zip data from link, uncompress and read it
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipFileName <- "UCI-HAR-Dataset.zip"
    
    if(!file.exists(zipFileName)){
        download.file(url = url, zipFileName)
        ## store donwload date
        dateDownloaded <- date()
        message(paste("Download date: ", dateDownloaded))        
    }
    
    dataPath <- "./UCI HAR Dataset";
    if(!file.exists(dataPath)){
        message("Unzip file")
        unzip(zipFileName)
    }
    
    ## Try to find features file
    featuresFile <- paste(dataPath, "features.txt", sep = "/")
    if(!file.exists(featuresFile))
        stop("features.txt file not found.")
 
    ## loads data set header
    message("Loading data header")
    features <- read.csv(featuresFile, header = FALSE, sep = "")
    
    
    ## Try to find training file
    trainingFile <- paste(dataPath, "train/X_train.txt", sep = "/")
    if(!file.exists(trainingFile))
        stop("Training data X_train.txt file not found.")

    ## loads training set
    message("Loading training data")
    trainingSet <- read.csv(trainingFile, header = FALSE, sep = "")
    
    
    ## Try to find test file
    testFile <- paste(dataPath, "test/X_test.txt", sep = "/")
    if(!file.exists(testFile))
        stop("Testing data X_test.txt file not found.")
    
    ## loads the test set
    message("Loading test data")
    testSet <- read.csv(testFile, header = FALSE, sep = "")
    
    dataSet <- rbind(testSet, trainingSet)
    names(dataSet) <- features$V2
    
    dataSet
}