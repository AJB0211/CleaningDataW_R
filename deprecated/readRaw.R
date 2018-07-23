# Reassign for encapsulation
features       <- h5read(f,"raw/feature_labels")
activities     <- h5read(f,"raw/activity_labels")
x_test         <- h5read(f,"raw/test/x")
y_test         <- h5read(f,"raw/test/y")
test_subjects  <- h5read(f,"raw/test/subjects")
x_train        <- h5read(f,"raw/train/x")
y_train        <- h5read(f,"raw/train/y")
train_subjects <- h5read(f,"raw/train/subjects")

