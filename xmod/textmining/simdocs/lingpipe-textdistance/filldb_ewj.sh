#!/bin/bash
mysql -h localhost -P 51524 -u gbrey classification_ewj <<EOFMYSQL
LOAD DATA LOCAL INFILE 'report/BYFileNames.txt'
INTO TABLE FileList
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'report/distanceReport.txt'
INTO TABLE Proximity
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
EOFMYSQL
