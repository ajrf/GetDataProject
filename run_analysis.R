# Constructs a summarised tidy dataset from the (reference) dataset obtained 
# from https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip. 
# The summarised tidy dataset is written to 'outfile' in the directory calling the script
outfile<-"AvgTidyDataset.txt";
# 
# To view the tidy dataset in R do: 
#   dtb<-read.table("<path_to_file>/AvgTidyDataset.txt"); 
#   View(dtb); 
#
# The summarisation consists in averaging, for each activity and each subject, the feature-variables 
# that correspond to mean or standard-deviation quantities. 
# For mean quantities, we selected features that are simple means (and discarded features that are frequency 
# weighted means -- identified by "meanFreq()"), which are identified by "mean()" in the features_info.txt 
# file accompanying the reference dataset. They amount to 33 variables. For standard-deviation quantities, we selected 
# variables identified by "std()", which amounts to 33 variables. For a detailed description see the CodeBook.md 
# file. 
#
# Composition of the reference dataset: 
#   - Separated in 70% train data and 30% test data (total of 10299 observations); 
#   - Test/Train data is in the "test"/"train" directory inside the main dir ('dataDir')
dataDir<-"UCI HAR Dataset";
#
#   - 561-features/variables observed; 
#   - Observations have activity and subject labels:
#       -- 1-30 subject IDs;
#       -- 1-6 activity IDs;
#   - Inside the main dir: 
#       -- 'featLablFile': file identifying the 561-features in terms descriptive labels; 
featLabFile<-"features.txt";
#
#       -- 'actLabFile': file w/ the map from integer to descriptive activity labels;
actLabFile<-"activity_labels.txt";
#
#   - Inside the "test"/"train" directory: 
#       -- 'featObsFile': prefix of the file with the 561-features observations (suffix "test"/"train")
featObsFile<-"X_";
#
#       -- 'actObsLabFile': prefix of the file with the corresponding activity IDs (suffix "test"/"train")
actObsLabFile<-"y_";
#
#       -- 'subjObsLabFile': prefix of the file with the corresponding subject IDs (suffix "test"/"train")
subjObsLabFile<-"subject_";
#
#
####### Script description #############################################################################################
# The script adds the activity and subject labels to the 561-features observations, and merges the 
# "train" and "test" data into a single data.table object 'obsData'. In order to load the features' data, the 
# script first parses the original features' data files so that only a single-space separates adjacent columns and 
# no-space appears at the beginning of each line. The parsed files are temporarily stored in the 'dataDir' directory 
# with the suffix "_tmp.txt", from which the features data is then loaded. The summarised data 
# obtained from 'obsData' is then stored in the data.table object 'obsMeanData', which is finally written to the file 
# 'outfile' in the working directory from which the script has been called. 
# The data is ordered by the first-column values and then by the second-column values, which are the dataset labels. 
# By default, the first two columns are |Activity|SubjectID|. 'Activity' is ordered alphabetically and 
# 'SubjectID' numerically, both ascending. 
#
# Script's FLAGs:
#   - boolean 'ordBySubjID' sets the relative order of the first two columns (the dataset labels): 
#   if TRUE the order is |SubjectID|Activity|, and if FALSE it is |Activity|SubjectID| (the default); 
#   - boolean 'rmTmpFiles' (debugging): whether to remove the temporary features parsed files (default: TRUE). 
#
# This script uses data.table package (faster for data loading) 
library(data.table);

# Current work dir (to which to return after loading the reference dataset) 
curDir<-getwd();

# Go to reference dataset dir
setwd(dataDir);
# Array of descriptive feature labels
featLab<-read.table(featLabFile, sep=" ");
# Array of descriptive activity labels
actLab<-read.table(actLabFile, sep=" ");

# Retrieve the feature labels we are interested in 
selFeatLab<-featLab[grep("-mean\\(\\)|-std\\(\\)", featLab[,2]),];
rm(featLab);
# Reformat the selected feature labels 
# (remove redundant "Body" in "fBodyBody" feature names, drop '()', '-' and capitalise first letter)
selFeatLab[,2]<-gsub("fBodyBody","fBody", 
                     gsub("\\(\\)|-", "", 
                          gsub("-std", "Std", 
                               gsub("-mean","Mean",selFeatLab[,2]))));


# Initialising the data.table into which the interesting part of the reference dataset will be loaded
obsData<-data.table(SubjectID=factor(), Activity=factor());
for (feat in selFeatLab[,2]) # add the columns of selected features
    obsData[,as.character(feat):=numeric()];

## Load the selected features data of the reference dataset and attach subject and activity IDs
rmTmpFiles<-TRUE; # (debugging only)
forceGenTmpFiles<-FALSE; # (debugging only)
for (dataSep in c("test","train")){
    
    # Tmp file that will store the parsed features' data file 
    tmpFile<-paste0(featObsFile,dataSep,"_tmp.txt");
    # Write new "tmp" file that removes the beginning of line spaces and sets a single space 
    # for column separation, and from which data can be conveniently loaded
    if (forceGenTmpFiles || !file.exists(tmpFile)) 
        writeLines(gsub("^ +", "", 
                        gsub(" +"," ", 
                             readLines(paste0(dataSep,"/",featObsFile,dataSep,".txt")))), 
                   tmpFile);
    
    # Load to tmp data.table the selected features data and attach subject ID and activity ID labels 
    tmpData<-cbind(fread(paste0(dataSep,"/",subjObsLabFile,dataSep,".txt"), 
                         header=FALSE, colClasses="character"), 
                   cbind(fread(paste0(dataSep,"/",actObsLabFile,dataSep,".txt"), 
                               header=FALSE, colClasses="character"), 
                         fread(tmpFile, sep=" ", header=FALSE, 
                                     colClasses=rep("numeric", 561), 
                                     select=selFeatLab[,1])
                         )
                   );
    if (rmTmpFiles) # remove tmp file
        file.remove(tmpFile);
    
    # Rename columns of tmp data.table
    setnames(tmpData,c("SubjectID", "Activity", as.character(selFeatLab[,2])))
    # Add tmp data.table to permanent data.table
    obsData<-rbind(obsData, tmpData);
    rm(tmpData);
}
# Return to the working dir that called the script 
setwd(curDir);

# Re-order observations by subject ID and activity ID (seen as numbers)
obsData[,SubjectID:=as.numeric(SubjectID)];
obsData[,Activity:=as.numeric(Activity)];
obsData<-obsData[order(SubjectID,Activity)];
# Set activity IDs to factor variables and load the corresponding descriptive names 
obsData[,Activity:=as.factor(Activity)];
levels(obsData$Activity)<-as.character(actLab[which(levels(obsData$Activity)==actLab[,1]),2]);

## Constructs the summarised dataset (stores in data.table object 'obsMeanData')
obsMeanData<-NULL;
# Procedure: 
#   1 - Split the data by subject ID; 
#   2 - For each subject ID, use 'sapply' to iterate through the columns of selected features (3:ncol(subjObs)); 
#   3 - For each column of selected features, use 'tapply' to calculate the mean within each Activity; 
#   4 - The result, i.e. the mean per activity for a given subject ID, is 'tmpMeanTb'
#   5 - Add tmpMeanTb to 'obsMeanData', appending the corresponding subject ID
for (subjObs in split(obsData,obsData$SubjectID)){ 
    # A table with the mean per activity for the subject ID 'subjObs' 
    tmpMeanTb<-sapply(subjObs[,3:ncol(subjObs), with=FALSE], 
                      function(x) tapply(x,subjObs$Activity,mean));
    # Add tmpMeanTb to 'obsMeanData', appending the corresponding subject ID
    if (is.null(obsMeanData)) # initialise data.table 
        obsMeanData<-cbind(SubjectID=subjObs[[1,1]], Activity=rownames(tmpMeanTb), 
                           as.data.table(tmpMeanTb))
    else # additions to the data.table
        obsMeanData<-rbind(obsMeanData, 
                           cbind(SubjectID=subjObs[[1,1]], Activity=rownames(tmpMeanTb), 
                                 as.data.table(tmpMeanTb)));
}
# Remove unnecessary data
rm(tmpMeanTb, obsData); 

# Re-orders the summarised dataset by the observation labels (the first two columns). 
# 'Activity' is ordered alphabetically and 'SubjectID' numerically, both ascending. 
# If ordBySubjID == TRUE, sets the first column to SubjectID and the second to Activity. 
# If ordBySubjID == FALSE, sets the first column to Activity and the second to SubjectID. 
ordBySubjID<-FALSE;
# (The current summarised dataset is already ordered as |SubjectID|Activity|)
if (!ordBySubjID){ 
    setcolorder(obsMeanData, c("Activity", "SubjectID", 
                               colnames(obsMeanData)[3:ncol(obsMeanData)]));
    obsMeanData<-obsMeanData[order(Activity,SubjectID)];
    obsMeanData[,Activity:=as.factor(Activity)];
};
# Load descriptive names for the selected feature variables (appending "Avg")
setnames(obsMeanData, selFeatLab[,2], paste0(selFeatLab[,2],"Avg"));

# Write the summarised tidy dataset to 'outfile'
write.table(obsMeanData, file=outfile, row.name=FALSE);
