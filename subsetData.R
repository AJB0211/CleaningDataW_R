wantedFeatures <- grepl("*mean()*|*std()*",features$V2)

x        <- rbind(x_train,x_test)
y        <- rbind(y_train,y_test)
subjects <- rbind(train_subjects,test_subjects)

x_trim <- x[,wantedFeatures]


data <- cbind(subjects,y,x_trim)

timeCols <- grepl("^t",names(x_trim))
freqCols <- grepl("^f",names(x_trim))

time <- x_trim[,timeCols]
freq <- x_trim[,freqCols]
