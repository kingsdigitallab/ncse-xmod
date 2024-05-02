
DROP database IF EXISTS `classification_ldr`;
create database `classification_ldr`;
use  `classification_ldr`;

DROP TABLE IF EXISTS `FileList`;
CREATE TABLE `FileList` (
  `Fileid` int(11)  NOT NULL ,
  `Filename` VARCHAR(254) default '' ,
  PRIMARY KEY  (`Fileid`)	
)
ENGINE = MYISAM
CHARACTER SET utf8 COLLATE utf8_general_ci;

DROP TABLE IF EXISTS `Proximity`;
CREATE TABLE `Proximity` (
  `Fileid1` int(11)  NOT NULL default '0',
  `Fileid2` int(11)  NOT NULL default '0' ,
  `Measure` double default '0.0'
)
ENGINE = MYISAM
CHARACTER SET utf8 COLLATE utf8_general_ci;



