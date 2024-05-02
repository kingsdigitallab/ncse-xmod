
CREATE DATABASE IF NOT EXISTS `waterloo_full_tokens_foreign_keys`;
USE `waterloo_full_tokens_foreign_keys`;

--
-- Table structure for table `counties`
--

DROP TABLE IF EXISTS `countynames`;
CREATE TABLE `countynames` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;


--
-- Table structure for table `issuingbodies`
--

DROP TABLE IF EXISTS `issuingbodynames`;
CREATE TABLE `issuingbodynames` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;


--
-- Table structure for table `peoplenames`
--

DROP TABLE IF EXISTS `peoplenames`;
CREATE TABLE `peoplenames` (
  `id` int(11) NOT NULL auto_increment,
  wlid INTEGER UNSIGNED NOT NULL,
  `ProperName` varchar(254) NOT NULL default '',
  `GivenName` varchar(254) NOT NULL default '',
  `ExtraInfo` varchar(254) NOT NULL default '',
  `IsCompany` int(11) NOT NULL default '0',
  `OrderBy` varchar(254) NOT NULL default '',
  `PeopleType` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`),
  INDEX (wlid)
) ENGINE=INNODB DEFAULT CHARSET=latin1;


--
-- Table structure for table `peopletypes`
--

DROP TABLE IF EXISTS `peopletypes`;
CREATE TABLE `PeopleTypes` (
  `id` int(11) NOT NULL auto_increment,
  `PeopleType` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

INSERT INTO peopletypes (id, PeopleType) VALUES (1, '');

--
-- Table structure for table `peoplename_peopletypes`
--

DROP TABLE IF EXISTS `peoplenames_peopletypes`;
CREATE TABLE `peoplenames_peopletypes` (
  `id` int(11) NOT NULL auto_increment,
  `peoplenames_id` int(11) NOT NULL,
  `peopletypes_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  INDEX (peoplenames_id),
  INDEX (peopletypes_id),
  FOREIGN KEY (peoplenames_id)
  REFERENCES peoplenames(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (peopletypes_id)
  REFERENCES peopletypes(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=INNODB DEFAULT CHARSET=latin1;


--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subject`;
CREATE TABLE `subject` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;


--
-- Table structure for table `titles`
--

DROP TABLE IF EXISTS `title`;
CREATE TABLE `title` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `recordID` int(11) NOT NULL default '0',
  `laterTitleID` int(11) NOT NULL default '0',
  `StartDate` varchar(254) NOT NULL default '',
  `EndDate` varchar(254) NOT NULL default '',
  `title` text default '',
  `SeeRefRecordTitle` varchar(254) NOT NULL default '',
  `referenceType` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;


--
-- Table structure for table `towns`
--

DROP TABLE IF EXISTS `townnames`;
CREATE TABLE `townnames` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  category VARCHAR(255) NULL,
  PRIMARY KEY(id)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS tokens;
CREATE TABLE tokens (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  token VARCHAR(255) NULL,
  PRIMARY KEY(id)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS wlentries;
CREATE TABLE wlentries (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  wlentry TINYTEXT NULL,
  categoryid INTEGER UNSIGNED NULL,
  wlid INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(id),
  INDEX (categoryid),
  INDEX (wlid),
  FOREIGN KEY (categoryid)
  REFERENCES categories(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (wlid)
  REFERENCES peoplenames(wlid)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=INNODB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS tokens_wlentries;
CREATE TABLE tokens_wlentries (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  tokenid INTEGER UNSIGNED NOT NULL,
  wlentryid INTEGER UNSIGNED NOT NULL,
  tokenpos INTEGER UNSIGNED NULL,
  categoryid INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(id),
  INDEX (tokenid),
  INDEX (wlentryid),
  INDEX (categoryid),
  FOREIGN KEY (tokenid)
  REFERENCES tokens(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (wlentryid)
  REFERENCES wlentries(id)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (categoryid)
  REFERENCES categories(id)
  ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=INNODB DEFAULT CHARSET=latin1;

INSERT INTO categories (id, category) VALUES (0, '');
INSERT INTO categories (id, category) VALUES (0, 'county');
INSERT INTO categories (id, category) VALUES (0, 'town');
INSERT INTO categories (id, category) VALUES (0, 'subject');
INSERT INTO categories (id, category) VALUES (0, 'issuingbody');
INSERT INTO categories (id, category) VALUES (0, 'date');
INSERT INTO categories (id, category) VALUES (0, 'startdate');
INSERT INTO categories (id, category) VALUES (0, 'enddate');
INSERT INTO categories (id, category) VALUES (0, 'pubtitle');
INSERT INTO categories (id, category) VALUES (0, 'firstname');
INSERT INTO categories (id, category) VALUES (0, 'lastname');
INSERT INTO categories (id, category) VALUES (0, 'persontitle');
INSERT INTO categories (id, category) VALUES (0, 'extrainfo');

