# CodeBook

Although the script file is full of comments explaining the code, here I will describe the algorithms and the datasets, in that order.

SCRIPT

The first exercise required the merging of the test and training data. After examination the files and folders, it was required to use all the files with data excepting the one in the "Inertial Signals" folders, because these were raw datafiles.

The dplyr library was loaded and the workspace and Environment cleaned.

Since the data was in .txt format, the read.table function was used. In order, first the files located in the main folder (activity_labels, features), then the files located in the test folder and finally the ones in the train folder.
Names were assigned accordingly the files and columns.
Each train and test files were merged in separated datafiles using the cbind() function. 
Finally, a single final dataset was created using the rbind() function. The dataframe is called final_dataset.

The second exercise required to extract the measurements on the mean and standard deviation for each measurement. This wasdone by creating a logical vector, selected_columns,  using the grepl() function on two regular expressions "mean()" and "std()" on the names() of the dataset. 
The selected_dataset is a new dataframe with with columns filtered based on the logical vector.

The third exercise asks for naming desciptive activity names. This can be done through to different ways: 
a) by merging the final_dataset with the activity_labels dataframe.
b) by redefining the activityID column of the final_dataset as a factor, using levels and labels based on the activity_labels dataframe. I personally prefer this way.


