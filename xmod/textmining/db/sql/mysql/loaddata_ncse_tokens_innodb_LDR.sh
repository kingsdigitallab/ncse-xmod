#!/bin/sh

# Time-stamp: <Mon 27.08.2007 19:29:54 BST gb>

echo "LDR-20070322-1850.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1850.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1851.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1851.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1852.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1852.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1853.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1853.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1854.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1854.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1855.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1855.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1856.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1856.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1857.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1857.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1858.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1858.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1859.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1859.sql" INTO TABLE tokens' ncse_tokens_innodb
echo "LDR-20070322-1860.sql"
mysql -u gbrey -e 'LOAD DATA INFILE "/mnt/ncse_svn/textmining/db/sql/mysql/LDR-20070322-1860.sql" INTO TABLE tokens' ncse_tokens_innodb

