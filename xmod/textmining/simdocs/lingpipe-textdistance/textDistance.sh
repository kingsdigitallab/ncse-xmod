#!/bin/bash
date +%T
java -Xms256m -Xmx1024m -cp lib/lingpipe-3.4.0.jar:lib/mysql-connector-java-3.1.14-bin.jar:build/classes TextDistance $*

date +%T
echo "Starting database activity....\n"
mysql -h localhost -P 51524 -u gbrey classification <<EOFMYSQL
LOAD DATA LOCAL INFILE 'report/FileNames.txt'
INTO TABLE FileList
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'report/distanceReport.txt'
INTO TABLE Proximity
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
EOFMYSQL

date +%T
echo "Job finished!!!"


