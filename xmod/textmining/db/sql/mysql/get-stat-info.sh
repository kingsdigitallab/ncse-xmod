

mysql -B -u gbrey ncsetoks_ldr -e 'select distinct charcount, count(charcount) from fullartids group by charcount order by count(charcount)' >LDR-charcount-sample.tab

mysql -B -h 137.73.122.85 -P 51524 -u gbrey ncsetoks_ewj -e 'select distinct charcount AS CHARCOUNT, count(charcount) AS NO from fullartids group by charcount' >EWJ-charcount.tab

mysql -B -h 137.73.122.85 -P 51524 -u gbrey ncsetoks_ewj -e 'select distinct charcount AS CHARCOUNT, count(charcount) AS NO from fullartids group by charcount ORDER BY NO' >EWJ-charcount-order_no.tab

mysql -B -h 137.73.122.85 -P 51524 -u gbrey ncsetoks_ewj -e 'select distinct charcount AS CHARCOUNT, count(charcount) AS NO from fullartids group by charcount ORDER BY CHARCOUNT' >EWJ-charcount-order_charcount.tab

