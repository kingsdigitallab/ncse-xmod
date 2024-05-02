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
  location varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  olocation varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  fullartid varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  frequency integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (location),
  INDEX (fullartid)
) ENGINE=MyISAM;

-- institutions
-- frequency is the frequency of a institution within one article
CREATE TABLE `institutions` (
  id integer unsigned NOT NULL auto_increment,
  institution varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  oinstitution varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  fullartid varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  frequency integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (institution),
  INDEX (fullartid)
) ENGINE=MyISAM;

-- names
CREATE TABLE `names` (
  id integer unsigned NOT NULL auto_increment,
  fullname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  lastname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  firstname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  title varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  fullartid varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  ofullname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  olastname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  ofirstname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  otitle varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  rule varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  rule1 varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  frequency integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (fullname),
  INDEX (lastname),
  INDEX (firstname),
  INDEX (title),
  INDEX (fullartid)
) ENGINE=MyISAM;

