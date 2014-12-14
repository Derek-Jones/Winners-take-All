# time R --no-save --args "201308NIC-MSOA-practices.csv" < charts.R
setwd("~/ohdh14/Winners-take-All/R")

month <- commandArgs(trailingOnly = TRUE)
fname <- paste("../data/",month,"NIC-MSOA-practices.csv",sep="")
data <- read.csv(fname)
data$prescriptions_per_capita <- data$prescriptions/data$residents
library(ggplot2)
monthName <- gsub("([0-9]{4})([0-9]{2})","\\1-\\2",month)
generatePlot <- function(param,ptext,ytext) {
  p <- ggplot(data, aes_string(x="annual_income", y=param)) + stat_smooth() + theme_bw() + ggtitle(paste(monthName,ptext,sep=": ")) +xlab("Average household annual income in MSOA") + ylab(ytext)
  ggsave(p, filename=paste(month,"_",param,".png",sep=""))
}
generatePlot("prescriptions_per_capita", "Prescriptions per capita", "Prescriptions per capita")
generatePlot("NIC_per_capita", "Prescription costs per capita", "Prescription costs per capita (£)")
generatePlot("residents_per_practice", "Residents per practice", "Residents")
generatePlot("avg_generic_ratio", "Ratio of generic drugs in prescriptions", "Ratio")
