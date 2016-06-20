#Project for the course "gettinga and Cleaning Data

#load the file name as provided in the project. 
filename <- "getdata-projectfiles-UCI HAR Dataset.zip"

#Downloading Dataset

#Load activity labels + features

activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activityLabels <- as.character(activityLabels[,2])
featuresData <- read.table("./data/UCI HAR Dataset/features.txt")
features <- as.character(featuresData[,2])


#Extract the data only on mean and standard deviation 

extractedFeaturesWanted <- grep(".*mean.*|.*std.*", features)
extractedFeaturesWanted.names <- featuresData[extractedFeaturesWanted,2]
extractedFeaturesWanted.names <- gsub("-mean", "Mean",extractedFeaturesWanted.names)
extractedFeaturesWanted.names <- gsub("-std", "Std", extractedFeaturesWanted.names)
extractedFeaturesWanted.names <- gsub("[-()-]", "", extractedFeaturesWanted.names)

#Load train and test dataset
trainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt")[extractedFeaturesWanted]
trainActivitiesData <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainSubjectData <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
trainDataFinal <- cbind(trainSubjectData, trainActivitiesData, trainData)

testData  <- read.table("./data/UCI HAR Dataset/test/X_test.txt")[extractedFeaturesWanted]
testActivitiesData <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testSubjectData <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
testDataFinal <- cbind(testSubjectData, testActivitiesData, testData)

#merge datasets and add labels

allData <- rbind(trainDataFinal, testDataFinal)
colnames(allData) <- c("subject", "activity", extractedFeaturesWanted.names)

#turn activities and subjects into labels

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "./data/UCI HAR Dataset/tidy.txt", row.names = FALSE, quote = FALSE)



