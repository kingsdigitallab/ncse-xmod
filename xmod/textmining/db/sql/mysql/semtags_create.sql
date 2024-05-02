-- MySQL
-- 
-- semtags: table with raw, non-normalised version of the semtag output as it came in
-- semtagsal: table as an authority list version of the semtags only
-- llhv: table of log-likelyhood values, to be used with semtagsal and fullartids
-- fullartids: table of article ids, to be used with semtagsal and llhv
-- 
-- 
-- USE `semtags`;

DROP TABLE IF EXISTS `semtags`;
DROP TABLE IF EXISTS `semtagnames`;
DROP TABLE IF EXISTS `semtagsal`;
DROP TABLE IF EXISTS `llhv`;
DROP TABLE IF EXISTS `fullartids`;

-- semtags
CREATE TABLE `semtags` (
  id integer unsigned NOT NULL auto_increment,
  fullartid varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  fullartidid integer unsigned NOT NULL,
  semtag varchar(30) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  semtaglong varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  semtagsalid integer unsigned NOT NULL,
  llh double(10, 2) unsigned DEFAULT 0,
  rank integer unsigned DEFAULT 0,
  freqtxt integer unsigned DEFAULT 0,
  freqtxtrel double(10, 2) unsigned DEFAULT 0,
  freqbnc integer unsigned DEFAULT 0,
  freqbncrel double(10, 2) unsigned DEFAULT 0,
  overuse varchar(5) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  PRIMARY KEY (id),
  INDEX (fullartid),
  INDEX (fullartidid),
  INDEX (semtag),
  INDEX (semtaglong),
  INDEX (semtagsalid),
  INDEX (rank),
  INDEX (freqtxt),
  INDEX (freqtxtrel),
  INDEX (llh)
) ENGINE=MyISAM;

-- semtagnames
CREATE TABLE `semtagnames` (
  id integer unsigned NOT NULL auto_increment,
  fullartid varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  fullartidid integer unsigned NOT NULL,
  semtag varchar(30) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  semtaglong varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  name varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  freq integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (fullartid),
  INDEX (fullartidid),
  INDEX (semtag),
  INDEX (name),
  INDEX (freq)
) ENGINE=MyISAM;

-- semtagsal
CREATE TABLE `semtagsal` (
  id integer unsigned NOT NULL auto_increment,
  semtag varchar(30) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  semtaglong varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  totalfreq integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (semtag),
  INDEX (semtaglong),
  INDEX (totalfreq)
) ENGINE=MyISAM;

-- fullartids
CREATE TABLE `fullartids` (
  id integer unsigned NOT NULL auto_increment,
  fullartid varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  publ varchar(4),
  year integer unsigned,
  month integer unsigned,
  day integer unsigned,
  artid varchar(15),
  PRIMARY KEY (id),
  INDEX (fullartid),
  INDEX (publ),
  INDEX (year),
  INDEX (month),
  INDEX (day),
  INDEX (artid)
) ENGINE=MyISAM;

-- llhv
CREATE TABLE `llhv` (
  id integer unsigned NOT NULL auto_increment,
  fullartidid integer unsigned NOT NULL,
  semtagsalid integer unsigned NOT NULL,
  llh double(10, 2) unsigned DEFAULT 0,
  freqtxt integer unsigned DEFAULT 0,
  freqtxtrel double(10, 2) unsigned DEFAULT 0,
  freqbnc integer unsigned DEFAULT 0,
  freqbncrel double(10, 2) unsigned DEFAULT 0,
  overuse varchar(5) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  PRIMARY KEY (id),
  INDEX (fullartidid),
  INDEX (semtagsalid),
  INDEX (llh)
) ENGINE=MyISAM;

