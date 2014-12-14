# run R --no-save --args 201309 < MSOA.R
fixPostCode <- function(x) {
  x <- gsub("\\s*$", "", x)
  gsub("\\s+", " ", x)
}
args <- commandArgs(trailingOnly = TRUE)
month <- args[1]
library(sqldf)
pdpi <- read.csv(paste("T", month, "PDPI_BNFT.CSV",sep=""), header=T)
pdpi$generic <- 0
pdpi[grep("^.{10}AA", pdpi$BNF.CODE),"generic"] <- 1
addr <- read.csv(paste("T", month, "ADDR_BNFT.CSV",sep=""), header=F)
addr <- addr[,c("V2","V8")]
names(addr) <- c("PRACTICE","postcode")
addr$postcode <- fixPostCode(addr$postcode)

income <- read.csv("income-per-msoa-postcode.csv")
income$postcode <- fixPostCode(income$postcode)
practices <- sqldf("select PRACTICE, sum(NIC) as NIC, count(*) as prescriptions, sum(ITEMS) as ITEMS, avg(generic) as generic_ratio from pdpi group by PRACTICE")

m <- merge(merge(addr, practices), income)
population <- read.csv("population.csv")
pop <- population[,c("MSOA","residents")]
g <- merge(m, pop)
ms <- sqldf("select MSOA, residents, gross_income*52 as annual_income, sum(NIC) as NIC, sum(ITEMS) as ITEMS_SUM, sum(ITEMS)/residents as ITEMS_per_capita, sum(prescriptions)/residents as prescriptions_per_capita, sum(prescriptions) as prescriptions, sum(NIC)/residents as NIC_per_capita, avg(generic_ratio) as avg_generic_ratio, min(generic_ratio) as min_generic_ratio, max(generic_ratio) as max_generic_ratio, count(distinct(PRACTICE)) as practices, residents/count(distinct(PRACTICE)) as residents_per_practice from g group by MSOA, residents, gross_income")
ms$prescriptions_per_capita <- round(ms$prescriptions/ms$residents,3)
ms$ITEMS_per_capita <- round(ms$ITEMS_SUM/ms$residents,3)
ms$avg_generic_ratio <- round(ms$avg_generic_ratio, 3)
ms$NIC_per_capita <- round(ms$NIC_per_capita,3)
write.csv(ms, paste(month,"NIC-MSOA-practices.csv",sep=""))
