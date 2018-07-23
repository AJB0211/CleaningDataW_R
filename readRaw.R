

activities       <- read.table("data/raw/activities.txt",sep="\t")
features         <- read.table("data/raw/features.txt",sep="\t")

x_test           <- read.table("data/raw/test/x_test.txt",sep="\t")
x_train          <- read.table("data/raw/train/x_test.txt",sep="\t")
y_test           <- read.table("data/raw/test/y_test.txt",sep="\t")
y_train          <- read.table("data/raw/train/y_train.txt",sep="\t")
test_subjects    <- read.table("data/raw/test/test_subjects.txt",sep="\t")
train_subjects   <- read.table("data/raw/train/train_subjects.txt",sep="\t")