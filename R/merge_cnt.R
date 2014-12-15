#
# merge_cnt.R, 14 Dec 14

sum_path="~/med-web/prescriptions"
sum_files=list.files(sum_path, pattern="cnt.*.sum", full.names=TRUE)

s1=read.csv(sum_files[1], as.is=TRUE, header=FALSE, sep=" ")
s2=read.csv(sum_files[2], as.is=TRUE, header=FALSE, sep=" ")

ss=merge(s1, s2, by="V2", all=TRUE)

merge_all=function(file_str)
{
# print(file_str)
t=read.csv(file_str, as.is=TRUE, header=FALSE, sep=" ")

t=subset(t, V3 > 50000)

if (ss == 0)
   ss <<- t
else
   ss <<- merge(ss, t, by="V2", all=TRUE)

return(NULL)
}

ss=0

dummy=sapply(sum_files, merge_all)

all_top=c("0103050P0AAAAAA",
	"0212000Y0AAADAD",
	"0209000A0AAABAB",
	"0407010H0AAAMAM",
	"0202010B0AAABAB",
	"0206020A0AAAAAA",
	"0212000Y0AAABAB",
	"0103050L0AAAAAA",
	"0601022B0AAABAB",
	"0301011R0AAAPAP",
	"0602010V0AABZBZ",
	"0205051R0AAADAD",
	"0602010V0AABXBX",
	"0602010V0AABWBW",
	"0206020A0AAABAB")


plot_pop=function(pop_bnc, not_first=TRUE)
{
par(new=not_first)
pt=subset(ss, V2 == pop_bnc)
# print(pt)
# print(pt[ , grepl("V1", names(pt))])
# plot(t(pt[ , grepl("V1", names(pt))]),
#      t(pt[ , grepl("V3", names(pt))]))
plot(t(pt[ , grepl("V3", names(pt))]), type="l",
	ylim=c(0, max_y),
	xlab="Month", ylab="Total items")
}

pt=subset(ss, V2 == "0103050P0AAAAAA")
max_y=max(pt[ , grepl("V3", names(pt))], na.rm=TRUE)

plot_pop(all_top[1], FALSE)

for (at in 2:length(all_top))
   plot_pop(all_top[at])

