# time R --no-save --args "201308NIC-MSOA-practices.csv" < charts.R
setwd("~/ohdh14/Winners-take-All/R")
month <- commandArgs(trailingOnly = TRUE)
#month <- "201308"
fname <- paste("../data/",month,"NIC-MSOA-practices.csv",sep="")
data <- read.csv(fname)
data$prescriptions_per_capita <- data$prescriptions/data$residents
library(ggplot2)


months <- read.csv("../data/months.txt",header=F)
m <- data.frame()
for (month in months$V1) {
  fname <- paste("../data/",month,"NIC-MSOA-practices.csv",sep="")
  data <- read.csv(fname)
  data$month <- month
  m <- rbind(m, data)
}

data <- m
generatePlot <- function(param,ptext,ytext,ymin,ymax) {
  for (month in sort(unique(data$month))) {
    monthName <- gsub("([0-9]{4})([0-9]{2})","\\1-\\2",month)
    sdata <- data[data$month == month,]
   
    ymin <- mean(data[,param])-sd(data[,param]) 
    ymax <- mean(data[,param])+sd(data[,param]) 
    p <- ggplot(sdata, aes_string(x="annual_income", y=param)) + 
      xlim(17680,88920) + 
      ylim(ymin,ymax) +
      stat_smooth() + theme_bw() + ggtitle(paste(monthName,ptext,sep=": ")) +xlab("Average household annual income in MSOA") + ylab(ytext)
    ggsave(p, filename=paste(month,"_",param,".png",sep=""))
    
  }
}
generatePlot("prescriptions_per_capita", "Prescriptions per capita", "Prescriptions per capita", 0.1, 0.25)
generatePlot("NIC_per_capita", "Prescription costs per capita", "Prescription costs per capita (£)", 5,17)
generatePlot("residents_per_practice", "Residents per practice", "Residents", 4500,10000)
generatePlot("avg_generic_ratio", "Ratio of generic drugs in prescriptions", "Ratio",0.55,0.64)
