CodeBook.md
=====================

##Original data description
The data for this project was obtained [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) on May 24, 2015.
A full description of the data is available in this [link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The following set of files were used to generate a single tidy dataset
* 'features.txt': List of all features, used to name dataset columns.
* 'activity_labels.txt': Links the class labels with their activity name. Used to set meaningfull names to each activity label.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels. Used to merge activity labels to each training measurement row.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels. Used to merge activity labels to each test measurement row.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. Used to merge subject Id for each row.

##run_analysis.R script
###Requirements:
* UCI HAR Dataset file must be available to download at this [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
* library dplyr installed.

###Cleaning process description:
1. 'UCI-HAR-Dataset.zip' file is downloaded from this [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
2. Downloaded file is uncompressed to 'UCI HAR Dataset' folder.
3. Testing and training measurements loaded from files and data merged to 'boundDataSet'.
4. Column names loaded from 'features.txt' files and set to 'features' variable.
5. 'meanAndStdDataSet' generated from measurements on the mean and standard deviation for each measurement.
6. Measurement activity labels loaded and merged to 'meanAndStdDataSet'.
7. Columns renamed.
8. Subject data loaded and merged to 'meanAndStdDataSet'.
9. 'tidyActivityDataSet' tidy data set containing with the average of each variable for each activity and each subject generated.
10. 'tidyActivityDataSet' exported to 'tidyActivityDataSet.txt' file.

###Tidy dataset description
Columns from the tidy dataset was obtained calculating average for each activity and each subject. Time related measurements starts with time and frequency domain measurements starts with fourier. Each measurement type has a Mean and a Standard deviation column indicated by Mean and Std respectively.
