BEGIN {
        FS=","
        is_first=1
        }

is_first == 0 {
        bnf_cnt[$3 " " $4] += $6
        next
        }

        {
        is_first=0
        }

END {
        for (b in bnf_cnt)
           print b " " bnf_cnt[b]
        }
