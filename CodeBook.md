# GetDataProject CodeBook

This Code Book is divided into three parts: 

1. **Study design**, where we outline 
the experimental setup from which the data has been obtained; 

2. **Summarisation**, where we explain the steps in going from the 
raw data to the tidy dataset that we have constructed; 

3. **Code book**, where we provide a detailed description of the variables 
in the tidy dataset. 


## Study design

**Thirty volunteers** aged between 19-48 years performed **six activities**: 
- LAYING; 
- SITTING;
- STANDING;
- WALKING;
- WALKING DOWNSTAIRS;
- WALKING UPSTAIRS; 

while wearing a smartphone (Samsung Galaxy S II) on their waist. 
Using the **smartphone's sensor signals** (accelerometer and gyroscope), the 3-axial linear acceleration and 
the 3-axial angular velocity have been recorded at a constant rate of 50Hz. 
The subjects have been video-recorded in order to manually label the data according 
to the activities. 


## Summarisation

The data summarisation comprised two steps: 

- The first step was performed by Jorge L. Reyes-Ortiz *et al.*, and is described in the README.txt and 
features_info.txt files of https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip: 

 >The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then 
sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). 
The sensor acceleration signal, which has gravitational and body motion components, was separated using a 
Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have 
only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a 
vector of [561] features was obtained by calculating variables from the time and frequency domain." 

 From the body linear acceleration and angular velocity the Jerks have been obtained by deriving with respect 
to time. A Fast Fourier Transform was applied to some of the signals (which are in the time domain) to obtain 
frequency domain signals. For more information consult the above link.


- Second, the script **run_analysis.R** has been run upon the reference dataset to obtain 
the summarised tidy dataset, as described in the README.md file. The main steps of the script are: 

 1. parse the data files of feature observations to remove extra-spaces (multiple spaces between 
columns and spaces at the beginning of line) in order for the data to be conveniently loaded into R. The 
parsed data files contain a single-space between any two adjacent columns and no-space at the beginning 
of each file. 

 2. load and merge the "train" and "test" feature observations from the parsed data files obtained in the previous 
step, while adding the activity and subject labels (loaded separately). For details see the README.md file or the 
script. 

 3. with the loaded data, identify the features that pertain to mean and standard-deviation quantities 
and calculate their average across the different observations for each activity-subject pair. This is 
the summarised dataset. 

 4. order the summarised dataset by activity (ascending alphabetically) and then subject 
(ascending numeric). These are the first two columns. Finally, add descriptive variable names 
to each of the columns of the summarised dataset, as described in the next section. The result 
is the summarised tidy dataset. 


## Code book

The summarised tidy dataset contains 68 columns. The first two columns are observation 
labels, identifying the activity (column name: Activity) and the volunteer (column name: SubjectID) 
performing the activity. 
The remaining 66 columns are the average (across different observations for a given Activity-SubjectID 
pair) of the 66-features that pertain to mean and standard-deviation quantities as 
obtained from the reference dataset. Of these 66 variables, 40 are in the time domain and 26 are in 
the frequency domain. For mean quantities, we only selected features that are simple means (and discarded features that are 
frequency weighted means -- identified by "meanFreq()"), which are identified by  **"mean()"** 
in the features_info.txt file accompanying the reference dataset. They amount to 33 variables. For standard-deviation quantities, 
we selected variables identified by **"std()"**, which amount to 33 variables. 

The meaning of each feature-variable can be understood from the way by which its name has been constructed. 
The 1st letter is either **'t'** or **'f'**, for variables in the time or frequency domains, respectively. 
The acceleration and angular signals are identified by the substrings **'Acc'** and **'Gyro'**, respectively. 
As mentioned above, the acceleration signals were separated into body and gravity components, being 
such components identified by the substrings **'Body'** and **'Gravity'**, respectively. 
The Jerk signals are identified by the substring **'Jerk'**. 
The directional components of 3-axial quantities are identified by the letters **'X'**, **'Y'** and **'Z'** in the 
usual way, while their Euclidean norm is identified by the substring *+'Mag'** (abbreviation of Magnitude). 
To all the so-constructed variable names we appended the suffix **'Avg'** to denote the average 
across different observations for each Activity-SubjectID pair. 

In the following we give an individualised description of the variables/columns in the tidy 
dataset: 

- *Label variables* (1:2): 

 - **1. Activity**: labels the activity :: *factor variable* that takes values in the set {LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS}; 
 - **2. SubjectID**: labels the volunteer performing the activity :: *integer variable* that takes values from 1 to 30;

- *Directional features in the time domain* (3:32): 

 - **3. tBodyAccMeanXAvg**: average value of the mean body acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **4. tBodyAccMeanYAvg**: average value of the mean body acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **5. tBodyAccMeanZAvg**: average value of the mean body acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **6. tBodyAccStdXAvg**: average value of the standard-deviation of the body acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **7. tBodyAccStdYAvg**: average value of the standard-deviation of the body acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **8. tBodyAccStdZAvg**: average value of the standard-deviation of the body acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **9. tGravityAccMeanXAvg**: average value of the mean gravity acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **10. tGravityAccMeanYAvg**: average value of the mean gravity acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **11. tGravityAccMeanZAvg**: average value of the mean gravity acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **12. tGravityAccStdXAvg**: average value of the standard-deviation of the gravity acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **13. tGravityAccStdYAvg**: average value of the standard-deviation of the gravity acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **14. tGravityAccStdZAvg**: average value of the standard-deviation of the gravity acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **15. tBodyAccJerkMeanXAvg**: average value of the mean body Jerk acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **16. tBodyAccJerkMeanYAvg**: average value of the mean body Jerk acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **17. tBodyAccJerkMeanZAvg**: average value of the mean body Jerk acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **18. tBodyAccJerkStdXAvg**: average value of the standard-deviation of the body Jerk acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **19. tBodyAccJerkStdYAvg**: average value of the standard-deviation of the body Jerk acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **20. tBodyAccJerkStdZAvg**: average value of the standard-deviation of the body Jerk acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **21. tBodyGyroMeanXAvg**: average value of the mean angular acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **22. tBodyGyroMeanYAvg**: average value of the mean angular acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **23. tBodyGyroMeanZAvg**: average value of the mean angular acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **24. tBodyGyroStdXAvg**: average value of the standard-deviation of the angular acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **25. tBodyGyroStdYAvg**: average value of the standard-deviation of the angular acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **26. tBodyGyroStdZAvg**: average value of the standard-deviation of the angular acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **27. tBodyGyroJerkMeanXAvg**: average value of the mean of the angular Jerk acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **28. tBodyGyroJerkMeanYAvg**: average value of the mean of the angular Jerk acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **29. tBodyGyroJerkMeanZAvg**: average value of the mean of the angular Jerk acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **30. tBodyGyroJerkStdXAvg**: average value of the standard-deviation of the angular Jerk acceleration along the X direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **31. tBodyGyroJerkStdYAvg**: average value of the standard-deviation of the angular Jerk acceleration along the Y direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **32. tBodyGyroJerkStdZAvg**: average value of the standard-deviation of the angular Jerk acceleration along the Z direction and in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;

- *Magnitude features in the time domain* (33:42): 

 - **33. tBodyAccMagMeanAvg**: average value of the magnitude of the mean body acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **34. tBodyAccMagStdAvg**: average value of the standard-deviation of the mean body acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **35. tGravityAccMagMeanAvg**: average value of the magnitude of the mean gravity acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **36. tGravityAccMagStdAvg**: average value of the magnitude of the standard-deviation of the gravity acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **37. tBodyAccJerkMagMeanAvg**: average value of the magnitude of the mean Jerk acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **38. tBodyAccJerkMagStdAvg**: average value of the magnitude of the standard-deviation of the Jerk acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **39. tBodyGyroMagMeanAvg**: average value of the magnitude of the mean angular acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **40. tBodyGyroMagStdAvg**: average value of the magnitude of the standard-deviation of the angular acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **41. tBodyGyroJerkMagMeanAvg**: average value of the magnitude of the mean angular Jerk acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **42. tBodyGyroJerkMagStdAvg**: average value of the magnitude of the standard-deviation of the angular Jerk acceleration in the time domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;


- *Directional features in the frequency domain* (43:60): 

 - **43. fBodyAccMeanXAvg**: average value of the mean body acceleration along the X direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*; 
 - **44. fBodyAccMeanYAvg**: average value of the mean body acceleration along the Y direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **45. fBodyAccMeanZAvg**: average value of the mean body acceleration along the Z direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **46. fBodyAccStdXAvg**: average value of the standard-deviation of the body acceleration along the X direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **47. fBodyAccStdYAvg**: average value of the standard-deviation of the body acceleration along the Y direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **48. fBodyAccStdZAvg**: average value of the standard-deviation of the body acceleration along the Z direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **49. fBodyAccJerkMeanXAvg**: average value of the mean body Jerk acceleration along the X direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **50. fBodyAccJerkMeanYAvg**: average value of the mean body Jerk acceleration along the Y direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **51. fBodyAccJerkMeanZAvg**: average value of the mean body Jerk acceleration along the Z direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **52. fBodyAccJerkStdXAvg**: average value of the standard-deviation of the body Jerk acceleration along the X direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **53. fBodyAccJerkStdYAvg**: average value of the standard-deviation of the body Jerk acceleration along the Y direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **54. fBodyAccJerkStdZAvg**: average value of the standard-deviation of the body Jerk acceleration along the Z direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **55. fBodyGyroMeanXAvg**: average value of the mean angular acceleration along the X direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **56. fBodyGyroMeanYAvg**: average value of the mean angular acceleration along the Y direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **57. fBodyGyroMeanZAvg**: average value of the mean angular acceleration along the Z direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **58. fBodyGyroStdXAvg**: average value of the standard-deviation of the angular acceleration along the X direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **59. fBodyGyroStdYAvg**: average value of the standard-deviation of the angular acceleration along the Y direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **60. fBodyGyroStdZAvg**: average value of the standard-deviation of the angular acceleration along the Z direction and in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;

- *Magnitude features in the frequency domain* (61:68): 

 - **61. fBodyAccMagMeanAvg**: average value of the magnitude of the mean body acceleration in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **62. fBodyAccMagStdAvg**: average value of the standard-deviation of the mean body acceleration in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **63. fBodyAccJerkMagMeanAvg**: average value of the magnitude of the mean Jerk acceleration in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **64. fBodyAccJerkMagStdAvg**: average value of the magnitude of the standard-deviation of the Jerk acceleration in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **65. fBodyGyroMagMeanAvg**: average value of the magnitude of the mean angular acceleration in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **66. fBodyGyroMagStdAvg**: average value of the magnitude of the standard-deviation of the angular acceleration in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **67. fBodyGyroJerkMagMeanAvg**: average value of the magnitude of the mean angular Jerk acceleration in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*;
 - **68. fBodyGyroJerkMagStdAvg**: average value of the magnitude of the standard-deviation of the angular Jerk acceleration in the frequency domain (units: none; normalised and bounded within [-1,1]) :: *float variable*.

