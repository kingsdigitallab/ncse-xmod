-- MySQL
-- 
-- PrXML uses character set cp1252, i. e. latin1
--       we therefore use latin1, too
--       not utf8 as in an early versio of the DB
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
-- CREATE DATABASE IF NOT EXISTS `ncse_tokens_and_types`;
-- USE `ncse_tokens_and_types`;

DROP TABLE IF EXISTS `tokens`;
DROP TABLE IF EXISTS `types`;

CREATE TABLE `types` (
  id integer unsigned NOT NULL auto_increment,
  type varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  PRIMARY KEY (id),
  INDEX (type)
) ENGINE=INNODB;

CREATE TABLE `tokens` (
  id int(11) NOT NULL auto_increment,
  publ varchar(4),
  year integer unsigned,
  month integer unsigned,
  day integer unsigned,
  artid varchar(15),
  fullartidid integer unsigned NOT NULL,
  arttokenno integer unsigned,
  tokenid varchar(50),
  entityid varchar(50),
  token varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  typeid integer unsigned NOT NULL,
  spaceaftertoken varchar(5),
  olivepageno int(11),
  publpageno varchar(254),
  entlineno int(11),
  artlineno int(11),
  coordbox text,
  PRIMARY KEY (id),
  INDEX (publ),
  INDEX (year),
  INDEX (month),
  INDEX (day),
  INDEX (artid),
  INDEX (arttokenno),
  INDEX (typeid),
  FOREIGN KEY (typeid)
  REFERENCES types(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=INNODB;

-- for testing
-- START TRANSACTION;
-- INSERT INTO types (id, type) VALUES (0, 'wort1');
-- INSERT INTO types (id, type) VALUES (0, 'wort2');
-- COMMIT;
