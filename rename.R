y[,1] <- as.factor(y[,1])
levels(y[,1]) <- tolower(activities[,2])
levels(y[,1]) <- sub("_u","U",levels(y[,1]))
levels(y[,1]) <- sub("_d","D",levels(y[,1]))

timeLabels <- names(time)
freqLabels <- names(freq)

# Drop the lowercase letter that has been taken care of by separating the tables
timeLabels <- sub("t","",timeLabels)
freqLabels <- sub("f","",freqLabels)

## Weird naming mistake?
freqLabels <- sub("BodyBody","Body",freqLabels)

# Some full word replacement
timeLabels <- sub("Mag","Magnitude",timeLabels)
freqLabels <- sub("Mag","Magnitude",freqLabels)

timeLabels <- sub("Acc","Acceleration",timeLabels)
freqLabels <- sub("Acc","Acceleration",freqLabels)

timeLabels <- sub("-mean[(][)]","_mean",timeLabels)
freqLabels <- sub("-mean[(][)]","_mean",freqLabels)

timeLabels <- sub("-std[(][)]","_std",timeLabels)
freqLabels <- sub("-std[(][)]","_std",freqLabels)

freqLabels <- sub("-meanFreq[(][)]","_meanFreq",freqLabels)

timeLabels <- sub("-","_",timeLabels)
freqLabels <- sub("-","_",freqLabels)

# camelCase

timeLabels <- sub("^B","b",timeLabels)
freqLabels <- sub("^B","b",freqLabels)

timeLabels <- sub("^G","g",timeLabels)
freqLabels <- sub("^G","g",freqLabels)

names(time) <- timeLabels
names(freq) <- freqLabels

time <- cbind(subjects,y,time)
freq <- cbind(subjects,y,freq)

dir.create("data/clean")

write.table(time,"data/clean/time.txt",sep="\t")
write.table(freq,"data/clean/freq.txt",sep="\t")


