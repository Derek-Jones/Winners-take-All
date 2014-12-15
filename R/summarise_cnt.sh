#
# summarise_cnt.sh, 14 Dec 14

for f in cnt_T*CSV
   do
   awk -f summarise_cnt.awk -v f_str="$f" < "$f" | sort -rg -k3 > `basename "$f" .CSV`.sum
   done

cat cnt*CSV | awk -f summarise_cnt.awk -v f_str="1234567all_" | sort -rg -k3 > all_month.sum

