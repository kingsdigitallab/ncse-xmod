#!/bin/sh

# Time-stamp: <Fri 31.08.2007 18:13:07 BST gb>

echo "EWJ-20070626-1858-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/EWJ-20070626-1858-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
echo "EWJ-20070626-1859-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/EWJ-20070626-1859-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
echo "EWJ-20070626-1860-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/EWJ-20070626-1860-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
echo "EWJ-20070626-1861-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/EWJ-20070626-1861-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
echo "EWJ-20070626-1862-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/EWJ-20070626-1862-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
echo "EWJ-20070626-1863-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/EWJ-20070626-1863-f2.tab" INTO TABLE tokens' ncse_tokens_and_types
echo "EWJ-20070626-1864-f2.tab"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/load/2/EWJ-20070626-1864-f2.tab" INTO TABLE tokens' ncse_tokens_and_types

