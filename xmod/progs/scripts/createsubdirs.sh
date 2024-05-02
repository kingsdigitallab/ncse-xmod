#!/bin/sh
# find lucene-similarity/ -name CLD-1852\* |xargs ls |awk -F '-'  '{print $1} {print $2} {print $3} {print $4} {print $5}'

# find lucene-similarity/ -name CLD-1852\* |xargs ls |awk -F '-'  '{print $1} {print $2} {print $3} {print $4} {print $5} {printf "%s%s%s%s%s" , $1, $2, $3, $4, $5}'

# find lucene-similarity/ -name $1\* |xargs ls |awk -F '-'  '{printf "%s/%s/%s/%s/%s\n" , $1, $2, $3, $4, $5}'

find lucene-similarity/ -name $1\* |xargs ls |(targetdir=`awk -F '-'  '{printf "%s/%s/%s/%s/%s" , $1, $2, $3, $4, $5}'`;echo $targetdir;mkdir -p $targetdir)
