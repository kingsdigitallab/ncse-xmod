-- MySQL
-- 
-- locations, institutions, names
-- 

DROP TABLE IF EXISTS `locations`;
DROP TABLE IF EXISTS `institutions`;
DROP TABLE IF EXISTS `names`;


-- locations
-- frequency is the frequency of a location within one article
CREATE TABLE `locations` (
  id integer unsigned NOT NULL auto_increment,
  location varchar(254) CHARACTER SET utf8,
  olocation varchar(254) CHARACTER SET utf8,
  fullartid varchar(254) CHARACTER SET utf8,
  frequency integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (location),
  INDEX (fullartid)
) ENGINE=MyISAM;

-- institutions
-- frequency is the frequency of a institution within one article
CREATE TABLE `institutions` (
  id integer unsigned NOT NULL auto_increment,
  institution varchar(254) CHARACTER SET utf8,
  oinstitution varchar(254) CHARACTER SET utf8,
  fullartid varchar(254) CHARACTER SET utf8,
  frequency integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (institution),
  INDEX (fullartid)
) ENGINE=MyISAM;

-- names
CREATE TABLE `names` (
  id integer unsigned NOT NULL auto_increment,
  fullname varchar(254) CHARACTER SET utf8,
  lastname varchar(254) CHARACTER SET utf8,
  firstname varchar(254) CHARACTER SET utf8,
  title varchar(254) CHARACTER SET utf8,
  fullartid varchar(254) CHARACTER SET utf8,
  ofullname varchar(254) CHARACTER SET utf8,
  olastname varchar(254) CHARACTER SET utf8,
  ofirstname varchar(254) CHARACTER SET utf8,
  otitle varchar(254) CHARACTER SET utf8,
  rule varchar(254) CHARACTER SET utf8,
  rule1 varchar(254) CHARACTER SET utf8,
  frequency integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (fullname),
  INDEX (lastname),
  INDEX (firstname),
  INDEX (title),
  INDEX (fullartid)
) ENGINE=MyISAM;

