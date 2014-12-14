months <- read.csv("../data/months.txt",header=F)
m <- data.frame()
for (month in months$V1) {
  fname <- paste("../data/",month,"NIC-MSOA-practices.csv",sep="")
  data <- read.csv(fname)
  data$month <- month
  m <- rbind(m, data)
}
range(m$prescriptions_per_capita)
range(m$avg_generic_ratio)
