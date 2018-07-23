dir.create("./data")
dir.create("./data/raw")
dir.create("./data/raw/test",showWarnings=FALSE)
dir.create("data/raw/train",showWarnings=FALSE)

write.table(activities,"data/raw/activities.txt",sep="\t")
write.table(features,"data/raw/features.txt",sep="\t")

write.table(x_test, "data/raw/test/x_test.txt",sep="\t")
write.table(x_train, "data/raw/train/x_test.txt",sep="\t")
write.table(y_test, "data/raw/test/y_test.txt",sep="\t")
write.table(y_train,"data/raw/train/y_train.txt",sep="\t")
write.table(test_subjects,"data/raw/test/test_subjects.txt",sep="\t")
write.table(train_subjects,"data/raw/train/train_subjects.txt",sep="\t")