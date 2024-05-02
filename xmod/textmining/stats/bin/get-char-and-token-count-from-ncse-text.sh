#!/bin/sh
# 
# CHARCOUNT / TOKENCOUNT / LINECOUNT: number of chars, tokens, lines
# NO: number of instances of the above CHARCOUNT / TOKENCOUNT
# 
lower=$1
upper=`echo $1 | tr [:lower:] [:upper:]`
# 
# ------------------------------------------------
# 
echo "$upper-charcount.tab"
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsetoks_$lower -e 'select distinct charcount AS CHARCOUNT, count(charcount) AS FREQ from fullartids group by charcount' >$upper-charcount.tab
# 
echo "$upper-charcount-order_by_no.tab"
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsetoks_$lower -e 'select distinct charcount AS CHARCOUNT, count(charcount) AS FREQ from fullartids group by charcount ORDER BY NO' >$upper-charcount-order_by_no.tab
# 
echo "$upper-charcount-order_by_charcount.tab"
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsetoks_$lower -e 'select distinct charcount AS CHARCOUNT, count(charcount) AS FREQ from fullartids group by charcount ORDER BY CHARCOUNT' >$upper-charcount-order_by_charcount.tab
# 
# ------------------------------------------------
# 
echo "$upper-tokencount.tab"
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsetoks_$lower -e 'select distinct tokencount AS TOKENCOUNT, count(tokencount) AS FREQ from fullartids group by tokencount' >$upper-tokencount.tab
# 
echo "$upper-tokencount-order_by_no.tab"
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsetoks_$lower -e 'select distinct tokencount AS TOKENCOUNT, count(tokencount) AS FREQ from fullartids group by tokencount ORDER BY NO' >$upper-tokencount-order_by_no.tab
# 
echo "$upper-tokencount-order_by_tokencount.tab"
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsetoks_$lower -e 'select distinct tokencount AS TOKENCOUNT, count(tokencount) AS FREQ from fullartids group by tokencount ORDER BY TOKENCOUNT' >$upper-tokencount-order_by_tokencount.tab
# 
# ------------------------------------------------
# 
echo "$upper-linecount.tab"
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsetoks_$lower -e 'select distinct linecount AS LINECOUNT, count(linecount) AS FREQ from fullartids group by linecount' >$upper-linecount.tab
# 
echo "$upper-linecount-order_by_no.tab"
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsetoks_$lower -e 'select distinct linecount AS LINECOUNT, count(linecount) AS FREQ from fullartids group by linecount ORDER BY NO' >$upper-linecount-order_by_no.tab
# 
echo "$upper-linecount-order_by_linecount.tab"
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsetoks_$lower -e 'select distinct linecount AS LINECOUNT, count(linecount) AS FREQ from fullartids group by linecount ORDER BY LINECOUNT' >$upper-linecount-order_by_linecount.tab
