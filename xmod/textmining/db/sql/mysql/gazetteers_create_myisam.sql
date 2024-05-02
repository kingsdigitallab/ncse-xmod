-- MySQL
-- 
-- lastnames, firstnames, fullnames, places, institutions
-- 
-- we use collating sequence latin1_german1_ci
--       it sorts umlauts after single character
-- we could also try collating sequence latin1_german2_ci
--       as it sorts umlauts according to German phone
--       book rules, i. e. u-umlaut as ue
--       but look int latin1_general_ci, latin1_general_cs, and
--       latin1_bin as well
--       MySQL-Documentation, 9.1, 9.2, 9.3, and 9.5
--       look more closely into the following:
--       CHARACTER SET latin1 COLLATE latin1_german2_ci;
--       CHARACTER SET utf8 COLLATE utf8_unicode_ci;
--       the choice of the collation sequence has also
--       consequences for searching (see 9.5.6.
--       Examples of the Effect of Collation)
-- 
-- Given "Bar" and "Bär" in a field:
--    latin1_german1_ci finds: "Bar" and "Bär"
--    latin1_german2_ci finds: "Bär"
--    utf8_unicode_ci finds: "Bar" and "Bär"
-- 
-- CREATE DATABASE IF NOT EXISTS `gazetteers`;
-- USE `gazetteers`;

DROP TABLE IF EXISTS `lastnames`;
DROP TABLE IF EXISTS `firstnames`;
DROP TABLE IF EXISTS `placenames`;
DROP TABLE IF EXISTS `sources`;
DROP TABLE IF EXISTS `lastnames_sources`;
DROP TABLE IF EXISTS `firstnames_sources`;
DROP TABLE IF EXISTS `placenames_sources`;
DROP TABLE IF EXISTS `usclastnames`;
DROP TABLE IF EXISTS `uscfirstnames`;

-- lastnames
CREATE TABLE `lastnames` (
  id integer unsigned NOT NULL auto_increment,
  lastname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  PRIMARY KEY (id),
  INDEX (lastname)
) ENGINE=MyISAM;

-- firstnames
CREATE TABLE `firstnames` (
  id integer unsigned NOT NULL auto_increment,
  firstname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  sex varchar(5) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  PRIMARY KEY (id),
  INDEX (firstname)
) ENGINE=MyISAM;

-- placenames
CREATE TABLE `placenames` (
  id integer unsigned NOT NULL auto_increment,
  placename varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  PRIMARY KEY (id),
  INDEX (placename)
) ENGINE=MyISAM;

-- sources
CREATE TABLE `sources` (
  id integer unsigned NOT NULL auto_increment,
  source varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  PRIMARY KEY (id),
  INDEX (source)
) ENGINE=MyISAM;

-- lastnames_sources
CREATE TABLE `lastnames_sources` (
  id integer unsigned NOT NULL auto_increment,
  lastnameid integer unsigned NOT NULL,
  sourceid integer unsigned NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (lastnameid)
  REFERENCES lastnames(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (sourceid)
  REFERENCES sources(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=MyISAM;

-- firstnames_sources
CREATE TABLE `firstnames_sources` (
  id integer unsigned NOT NULL auto_increment,
  firstnameid integer unsigned NOT NULL,
  sourceid integer unsigned NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (firstnameid)
  REFERENCES firstnames(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (sourceid)
  REFERENCES sources(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=MyISAM;

-- placenames_sources
CREATE TABLE `placenames_sources` (
  id integer unsigned NOT NULL auto_increment,
  placenameid integer unsigned NOT NULL,
  sourceid integer unsigned NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (placenameid)
  REFERENCES placenames(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (sourceid)
  REFERENCES sources(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=MyISAM;

-- US census 1990 - lastnames
CREATE TABLE `usclastnames` (
  id integer unsigned NOT NULL auto_increment,
  lastname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  freq float(6,3),
  freqcumul float(6,3),
  rank integer,
  PRIMARY KEY (id),
  INDEX (lastname)
) ENGINE=MyISAM;

-- US census 1990 - lastnames
CREATE TABLE `uscfirstnames` (
  id integer unsigned NOT NULL auto_increment,
  firstname varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  freq float(6,3),
  freqcumul float(6,3),
  rank integer,
  sex varchar(5),
  PRIMARY KEY (id),
  INDEX (firstname)
) ENGINE=MyISAM;


-- for testing
-- START TRANSACTION;
-- INSERT INTO lastnames (id, lastname) VALUES (0, 'wort1');
-- INSERT INTO lastnames (id, lastname) VALUES (0, 'wort2');
-- COMMIT;
