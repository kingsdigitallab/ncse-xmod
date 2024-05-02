-- MySQL
-- 
-- tokens, types, fullartids
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
-- COMMENTS:
--   tokens.tokencat: word, punctuation, bad OCR
--   types.typecat:   word, punctuation, bad OCR
-- 
-- EPERIMENTAL:
--   table "annotations" contains annotations about what
--         kind of token a token/type is, i. e.:
--         person name, location, etc., as gained from
--         lookup in gazetteer lists
-- 
-- CREATE DATABASE IF NOT EXISTS `ncse_tokens_and_types`;
-- USE `ncse_tokens_and_types`;

DROP TABLE IF EXISTS `tokens_annotations`;
DROP TABLE IF EXISTS `types_annotations`;
DROP TABLE IF EXISTS `lctypes_annotations`;
DROP TABLE IF EXISTS `tokens`;
DROP TABLE IF EXISTS `types`;
DROP TABLE IF EXISTS `lctypes`;
DROP TABLE IF EXISTS `annotations`;
DROP TABLE IF EXISTS `fullartids`;

-- types - original spelling
CREATE TABLE `types` (
  id integer unsigned NOT NULL auto_increment,
  type varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  frequency integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (type),
  INDEX (frequency)
) ENGINE=INNODB;

-- types - lower case
CREATE TABLE `lctypes` (
  id integer unsigned NOT NULL auto_increment,
  lctype varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  frequency integer unsigned DEFAULT 0,
  PRIMARY KEY (id),
  INDEX (lctype),
  INDEX (frequency)
) ENGINE=INNODB;

-- annotations
CREATE TABLE `annotations` (
  id integer unsigned NOT NULL auto_increment,
  annotation varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  annotationtype varchar(50) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  PRIMARY KEY (id),
  INDEX (annotation)
) ENGINE=INNODB;

-- fullartids
-- full globally unique article id
-- tokencount: our own token count (including punctuation)
-- olivewordcount: word count taken and added up from Olive's
--                 TOC.xml
-- charcount: character count (including spaces and new lines)
-- charnscount: character count (without spaces and new lines)
-- linecount: number of lines in article (should equal "real"
--            number of lines
CREATE TABLE `fullartids` (
  id integer unsigned NOT NULL auto_increment,
  fullartid varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  tokencount integer unsigned,
  olivewordcount integer unsigned,
  charcount integer unsigned,
  charnscount integer unsigned,
  linecount integer unsigned,
  publ varchar(4),
  year integer unsigned,
  month integer unsigned,
  day integer unsigned,
  artid varchar(15),
  PRIMARY KEY (id),
  INDEX (fullartid),
  INDEX (tokencount),
  INDEX (charcount),
  INDEX (charnscount),
  INDEX (linecount),
  INDEX (publ),
  INDEX (year),
  INDEX (month),
  INDEX (day),
  INDEX (artid)
) ENGINE=INNODB;

-- tokens
CREATE TABLE `tokens` (
  id integer unsigned NOT NULL auto_increment,
  tokenid varchar(50),
  token varchar(254) CHARACTER SET latin1 COLLATE latin1_german1_ci,
  spaceaftertoken varchar(5),
  olivepageno integer,
  publpageno varchar(254),
  entlineno integer,
  artlineno integer,
  arttokenno integer unsigned,
  fullartidid integer unsigned NOT NULL,
  entityid varchar(50),
  typeid integer unsigned NOT NULL,
  lctypeid integer unsigned NOT NULL,
  coordbox text,
  apfs varchar(254),
  specialtype varchar(50),
  PRIMARY KEY (id),
  INDEX (tokenid),
  INDEX (token),
  INDEX (arttokenno),
  INDEX (fullartidid),
  INDEX (typeid),
  INDEX (lctypeid),
  FOREIGN KEY (typeid)
  REFERENCES types(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (lctypeid)
  REFERENCES lctypes(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (fullartidid)
  REFERENCES fullartids(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=INNODB;

-- tokens_annotations
CREATE TABLE `tokens_annotations` (
  id integer unsigned NOT NULL auto_increment,
  annotationid integer unsigned NOT NULL,
  tokenid integer unsigned NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (annotationid)
  REFERENCES annotations(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (tokenid)
  REFERENCES tokens(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=INNODB;

-- types_annotations
CREATE TABLE `types_annotations` (
  id integer unsigned NOT NULL auto_increment,
  annotationid integer unsigned NOT NULL,
  typeid integer unsigned NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (annotationid)
  REFERENCES annotations(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (typeid)
  REFERENCES types(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=INNODB;

-- lctypes_annotations
CREATE TABLE `lctypes_annotations` (
  id integer unsigned NOT NULL auto_increment,
  annotationid integer unsigned NOT NULL,
  lctypeid integer unsigned NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (annotationid)
  REFERENCES annotations(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (lctypeid)
  REFERENCES lctypes(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=INNODB;

-- for testing
-- START TRANSACTION;
-- INSERT INTO types (id, type) VALUES (0, 'wort1');
-- INSERT INTO types (id, type) VALUES (0, 'wort2');
-- COMMIT;
