## 1. Overview

This directory is meant to hold the result of the work on the Coursera **Data Science Specialization - Getting & Cleaning Data** peer
reviewed assessment. The project consists in creating a tidy and unified dataset from a bunch of files containing data about various
measurements performed on people accomplishing a range of different activities while wearing a *Samsung Galaxy S II* smartphone on the
waist.

The provided data are organized in the following structure:

* *activity_labels.txt*
* *features.txt*
* *features_info.txt*
* *README.txt*
* train (directory, contains the training data):
	* *subject_train.txt*
	* *X_train.txt*
	* *y_train.txt*
	* Inertial Signals (contains a bunch of raw data, not used in the script)
* test (directory, contains the test data):
	* *subject_test.txt*
	* *X_test.txt*
	* *y_test.txt*
	* Inertial Signals (contains a bunch of raw data, not used in the script)

## 2. Content

This directory contains the following files:

* *README.md*
* *run_analysis.R*
* *Codebook.pdf*

## 3. Explanations

### . README.md

The present markdown file, meant to provide several basics explanations on the repository structure and the code.

### . run_analysis.R

The actual R script used to generate the tidy dataset. The file assumes the file structure is the same as the original data, as long as the
working directory is set as the root directory holding *activity_labels.txt*, *features.txt* and *features*_*info.txt* along with the train and test
directories with their respective content, one can simply use `source("run_analysis.R")` to directly parse the data, process them and generate
the *coursera*_*cleaning*_*project.txt* dataset. Once created, this dataset can be loaded in R using the following command:

`read.table("coursera_cleaning_project.txt", header = TRUE)`

The script requires the **dplyr** package, with a minimal version of 0.2.0. To check your dplyr version, first load the package with:

`library(dplyr)`

Then run the following command:

`packageVersion("dplyr")`

If dplyr is not installed on your machine, please run the command:

`install.packages("dplyr")`

The code is relatively well commented so it shouldn't be too hard to understand what's going on under the hood. As a summary:

1. Load dplyr package
2. Load the data in *activity_labels.txt* and *features.txt* in order to get the activity numerical ID and its corresponding activity
name along with the names of the 561 variables observed in both training and test datasets
3. Load and process the training data:
	* Load the content of *X_train.txt* inside a variable names *data_train*
	* Rename the columns of *data_train* with the values inside the *features.txt* dataset
	* Append the content of *y_train.txt* and *subject_train.txt* to the *data_train* variable
4. Load and process the test data:
	* Load the content of *X_test.txt* inside a variable names *data_test*
	* Rename the columns of *data_test* with the values inside the *features.txt* dataset
	* Append the content of *y_test.txt* and *subject_test.txt* to the *data_train* variable
5. Combine *data_train* and *data_test* into a *clean_data* dataset using `bind_rows()`; this will also get rid of some duplicated columns
6. Merge *clean_data* with the activity labels obtained in step 2
7. Use dplyr extensively to further process the *clean_data* variable and get every measurements on the mean and standard deviation for
each measurement; `arrange()` and `group_by()` the set by subject ID and activity label
8. Modify some columns names as their formats is inappropriate for `summarise()`
9. Generate a *final_data* data set by using `summarise_each()` with the `mean()` function in order to get the average on each measurement
per subject first and then per activity (thanks to `group_by()`)
10. Generate the *coursera_cleaning_project.txt* file for upload

### . Codebook.pdf

The codebook describes each variable in order to give a better understanding of the structure of the dataset 