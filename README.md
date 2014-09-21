GettingAndCleaningData_CourseProject
====================================

This is a repo for the course project from Coursera Getting and Cleaning Data course.

Tidy Data sets from Human Activity Recognition database
------------------------------------------------------
by Luis Luévano, September 2014.

The **run_analysis.R** script will perform several actions to create two tidy data sets based on the Human Activity Recognition database collected by the SmartLab 
of the Università degli Studi di Genova.

The abstract from their site is:
*"Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted 
smartphone with embedded inertial sensors."*

For more information regarding the source dataset please visit their [site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The R script will download the dataset from this [source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) (zip file), then 
extract all documents in a temp directory. This is a convenient way instead of using the R working directory since the goal is to have two new tidy data sets, 
so when the R session is finish it will clean up the temp folder.

The source data set comes in separated files as train and test data. The script will merge to one data set. Furthermore, it will only take into account the
Mean and Standard deviation measures. In addition, it will replace the Activity number identifiers by the proper label that describes it. Finally, it will rename 
the column names so the standard will be only lowercase letters except for compund names so in each new word the first letter is capitalized.

This first tidy data set is named **humactrec.txt** and contains 68 columns and 10,299 records. Each field separated by a blank space.

The script will also create a second tidy data set based on the first one but taking the average of all measures grouped by subject and activity. The data set 
is named **humactrecBySubAct.txt** and contains 68 columns and 180 records. Each field separated by a blank space.

**Note: Both files will be created in the current R working directory.**

For the meaning in each column of both data sets please refer to the **CodeBook.md** included in the repo.