#
# summarise_cnt.awk, 14 Dec 14

BEGIN {
# cnt_T201406...
	m_num=substr(f_str, 8, 4)
	}

	{
	bnc[$2] += $3
	next
	}

END {
	for (b in bnc)
	   print m_num " " b " " bnc[b]
	}

