# globals
group1 <- "subject"  # first grouping variable
group2 <- "activity"  # second grouping variable
mergedData <- data.frame()  # merged data in global space

# URL for source data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# download folder for zip file
downloadFolder <- ".\\"  # working directory

# data folder within zip file
# if zip structure changes this may need to be updated.
dataFolder <- paste0(downloadFolder, "UCI HAR Dataset\\")

# final output file for tidy data set grading
outputFile <- "tidyData.txt"
    
downLoadFile <- function (url) {
    # Download zip file from URL to local drive.
    tempFile <- paste0(downloadFolder, "tempfile.zip")
    print(paste0("downloading file: ", url, " to: ", tempFile))
    f = download.file(url, destfile=tempFile, mode='wb')
    print("file downloaded")
    tempFile  # return temp file name
}

extractZipFile <- function(tempFile) {
    # extract zip file
    # tempFile = zip filename (full path)
    print(paste0("unzipping file: ", tempFile, " to: ", downloadFolder))
    library(utils)
    suppressWarnings(unzip(zipfile = tempFile, overwrite=FALSE))
    # if data files already exist in folder then line above will generate 28
    # warnings. I have overwrite set to FALSE in case a different data set is
    # being used for grading.
    
    print("unzipping complete")
}

loadDFFromFile <- function(targetFolder, targetFile) {
    # Read file 'targetFile' from zipped folder 'targetFolder' and return data set.
    fullFilePath <- paste0(targetFolder, targetFile)
    dat <- read.delim(fullFilePath, header=FALSE, sep="")
}

mergeAndReduce <- function () {
    # Merge test and training data sets.
    # add detailed data column names
    # prepend subject and activity data columns
    # reduce data set to just mean and std value columns

    # url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    #targetFolder <- downLoadFile(url)  # get data file

    print("merging test and training data sets")
    # get test subjects
    testFolder <- paste0(dataFolder, "test\\")
    testSubjectFile <- "subject_test.txt"
    testSubjectDF <- loadDFFromFile(testFolder, testSubjectFile)
    names(testSubjectDF) <- c(group1)

    # get activity labels
    activitiesFile <- "activity_labels.txt"
    activitiesDF <- loadDFFromFile(dataFolder, activitiesFile)

    # get column names
    namesFile <- "features.txt"
    namesDF <- loadDFFromFile(dataFolder, namesFile)

    # get test data labels
    testLabels <- "Y_test.txt"
    testLabelsDF <- loadDFFromFile(testFolder, testLabels)

    # add activity descriptors and column headers to test data labels
    testLabelsDF <- merge(testLabelsDF, activitiesDF, by.x = "V1", by.y="V1")
    names(testLabelsDF) <- c("activity_number", group2)
    testLabelsDF = subset(testLabelsDF, select = -c(activity_number))

    # get test data set
    testFile <- "X_test.txt"
    testDF <- loadDFFromFile(testFolder, testFile)

    # add column names to data set
    names(testDF) <- namesDF[,2]
    
    # merge activity labels and test data set
    testMerged <- cbind(testSubjectDF, testLabelsDF, testDF)

    ##### training data set #####

    # get train subjects
    trainFolder <- paste0(dataFolder, "train\\")
    trainSubjectFile <- "subject_train.txt"
    trainSubjectDF <- loadDFFromFile(trainFolder, trainSubjectFile)
    names(trainSubjectDF) <- c(group1)

    # get train data labels
    trainLabels <- "Y_train.txt"
    trainLabelsDF <- loadDFFromFile(trainFolder, trainLabels)

    # add activity descriptors and column headers
    trainLabelsDF <- merge(trainLabelsDF, activitiesDF, by.x = "V1", by.y="V1")
    names(trainLabelsDF) <- c("activity_number", group2)
    trainLabelsDF = subset(trainLabelsDF, select = -c(activity_number))

    # get train data set
    trainFile <- "X_train.txt"
    trainDF <- loadDFFromFile(trainFolder, trainFile)

    # add column names to data set
    names(trainDF) <- namesDF[,2]

    # merge activity labels and test data set
    trainMerged <- cbind(trainSubjectDF, trainLabelsDF, trainDF)

    # question 1: merge the two data sets
    mergedDF <- rbind(testMerged, trainMerged)
    print("merged data set complete, reducing data...")

    # question 2: reduce data set to mean and stdev cols only
    pattern <- paste0("mean|std|", group1, "|", group2)
    reducedDF <- mergedDF[, grep(pattern, names(mergedDF))]

    # return merged data
    print("merged and reduced data set complete")
    reducedDF  # return reduced data set
}

createTidyDataSet <- function(df) {
    # step 5: create tidy date set of summarized data from reduced data set.
    # inputs:
    # df = data frame
    # returns data frame
    print("creating a table of column means")
    # build grouping list
    group_list <- list(df$subject, df$activity)
    summarizedData <- aggregate(df[,3:dim(df)[2]],
                                group_list,
                                mean, na.rm=TRUE)
    names(summarizedData)[1] <- group1
    names(summarizedData)[2] <- group2
    print("summarized data set complete")
    summarizedData
}

main <- function() {
    # main routine to run all steps

    # download file
    tempFile = downLoadFile(url)

    # extract zip file
    extractZipFile(tempFile)

    # merge data
    mergedData <<- mergeAndReduce()  # save globally
    
    # create data set of means
    tidyData <<- createTidyDataSet(mergedData)
    print("merged/reduced data is stored in global object 'mergedData'")
    print("summarized data is stored in global object 'tidyData'")
    tidyData  # return tidyData object
    print(paste("saving tidyData to", outputFile))
    write.table(tidyData, file=outputFile, row.name = FALSE)
}