#!/bin/sh

# Time-stamp: <Fri 31.08.2007 18:15:09 BST gb>

echo "TTW-20070814-1867-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/TTW-20070814-1867-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
echo "TTW-20070814-1868-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/TTW-20070814-1868-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
echo "TTW-20070814-1869-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/TTW-20070814-1869-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
echo "TTW-20070814-1870-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/TTW-20070814-1870-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
