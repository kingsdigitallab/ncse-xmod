#!/bin/sh

# Time-stamp: <Mon 27.08.2007 19:35:14 BST gb>

echo "EWJ-20070626-1858.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/EWJ-20070626-1858.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "EWJ-20070626-1859.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/EWJ-20070626-1859.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "EWJ-20070626-1860.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/EWJ-20070626-1860.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "EWJ-20070626-1861.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/EWJ-20070626-1861.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "EWJ-20070626-1862.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/EWJ-20070626-1862.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "EWJ-20070626-1863.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/EWJ-20070626-1863.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "EWJ-20070626-1864.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/EWJ-20070626-1864.sql" INTO TABLE tokens' ncse_tokens_innodb

