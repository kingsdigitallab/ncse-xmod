#!/bin/sh

# Time-stamp: <Mon 27.08.2007 19:32:12 BST gb>

echo "TTW-20070814-1867.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/TTW-20070814-1867.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "TTW-20070814-1868.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/TTW-20070814-1868.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "TTW-20070814-1869.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/TTW-20070814-1869.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "TTW-20070814-1870.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/TTW-20070814-1870.sql" INTO TABLE tokens' ncse_tokens_innodb

