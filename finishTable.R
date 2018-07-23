# to make the final data set for uplaoad

t <- read.table("./data/ave/time.txt")
f <- read.table("./data/ave/freq.txt")

final <- cbind(t,f[-c(1,2)])

keys <- names(t)[c(1,2)]
t_names <- names(t)[-c(1,2)]
f_names <- names(f)[-c(1,2)]



lambda <- function(x,s){paste(s,x,sep="")}

t_names <- lapply(t_names,lambda,"time_")
f_names <- lapply(f_names,lambda,"freq_")

names(final) <- c(keys,t_names,f_names)

write.table(final,"./data/my_tidy.txt",sep="\t")
write.table(final,"./data/tidy.txt",row.name=FALSE)