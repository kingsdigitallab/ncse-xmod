#!/bin/sh

# Time-stamp: <Mon 27.08.2007 16:50:10 BST gb>

export filename=$1
echo LOADING ${filename}
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/'${filename}'" INTO TABLE tokens' ncse_tokens

