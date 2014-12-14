data <- read.csv("201308NIC-MSOA-practices.csv")

library(ggplot2)
ggplot(data, aes(annual_income, prescriptions_per_capita)) + stat_smooth() + theme_bw()
ggplot(data, aes(annual_income, NIC_per_capita)) + stat_smooth()
ggplot(data, aes(annual_income, residents_per_practice)) + stat_smooth()
ggplot(data, aes(annual_income, avg_generic_ratio)) + stat_smooth()
