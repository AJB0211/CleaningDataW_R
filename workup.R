suppressMessages(library(dplyr))

# replace data.frame with table_df
time <- tbl_df(time)
freq <- tbl_df(time)

time_summary <- time %>% group_by(subject,activity) %>% summarize_all(mean)
freq_summary <- freq %>% group_by(subject,activity) %>% summarize_all(mean)

dir.create("./data/ave")
write.table(time_summary,"./data/ave/time.txt",sep="\t")
write.table(freq_summary,"./data/ave/freq.txt",sep="\t")