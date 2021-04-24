The run_analysis.R script performs the data preparation and then the 5 steps required as described in the course project’s definition.

**1. Download the dataset:**

Dataset is downloaded and extracted in a folder called "UCI HAR Dataset"

**2. Read data and assign variables**

*a)* features <- features.txt : 561 rows, 2 columns
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.

*b)* activities <- activity_labels.txt : 6 rows, 2 columns
List of activities performed when the corresponding measurements were taken and its codes (labels)

*c)* testsub <- test/subject_test.txt : 2947 rows, 1 column
contains test data of 9/30 volunteer test subjects being observed

*d)* testX <- test/X_test.txt : 2947 rows, 561 columns
contains recorded features test data

*e)* testY <- test/y_test.txt : 2947 rows, 1 columns
contains test data of activities' code labels

*f)* trainsub <- test/subject_train.txt : 7352 rows, 1 column
contains train data of 21/30 volunteer subjects being observed

*g)* trainX <- test/X_train.txt : 7352 rows, 561 columns
contains recorded features train data

*h)* trainY <- test/y_train.txt : 7352 rows, 1 columns
contains train data of activities' code labels

**3. Tidy up the data from the test data set.**

*a)* Create a second column in testY with the activity name (read from the second column of "actitives").

*b)* Assign column names:

	- testsub: "person_number"
	- testY: "activity_number", "activity"
	- testX: labels are taken from second column of "features"
	
*c)* Dataframe "test" is obtained by rowbinding testsub,testY and testX

The same steps are performed for the training data set. This results ina dataframe "training" containing all data from the training set.

**4. Merge Data**

"overalldata" is obtained by merging the dataframes "test" and "training". 

**5. Give descriptive column names**

We make the following replacements in order to make it easier to understand the information contained in each column.

- All Acc replaced by Accelerometer
- All Gyro replaced by Gyroscope
- All BodyBody replaced by Body
- All Mag in replaced by Magnitude
- First character f in column’s name replaced by Frequency
- First character t in column’s name replaced by Time

**6. Extract only the measurements on the mean and standard deviation for each measurement**

"tidyData" is obtained by selecting the columns "person_number", "activity", "activity_number" as well as all columns containing means and standard deviations (std) of measuresments

**7. From the data set in step 6, creates a second, independent tidy data set with the average of each variable for each activity and each subject**

"meanPerSubjectActivity" is created by taking the means of each variable, factorized by subject and activity.

**8. Write data**

tidydata.txt: export of "tidyData"
means-per-subject-and-actitivty: export of "meanPerSubjectActivity"