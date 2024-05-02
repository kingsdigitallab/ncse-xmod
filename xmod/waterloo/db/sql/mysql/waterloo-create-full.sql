-- MySQL dump 10.10
--
-- Host: localhost    Database: waterloo
-- ------------------------------------------------------
-- Server version	5.0.24a-Debian_9ubuntu1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES latin1 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `waterloo_full`;
USE `waterloo_full`;

--
-- Table structure for table `counties`
--

DROP TABLE IF EXISTS `CountyNames`;
CREATE TABLE `CountyNames` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


--
-- Table structure for table `issuingbodies`
--

DROP TABLE IF EXISTS `issuingbodynames`;
CREATE TABLE `issuingbodynames` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


--
-- Table structure for table `PeopleNames`
--

DROP TABLE IF EXISTS `PeopleNames`;
CREATE TABLE `PeopleNames` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `ProperName` varchar(254) NOT NULL default '',
  `GivenName` varchar(254) NOT NULL default '',
  `ExtraInfo` varchar(254) NOT NULL default '',
  `IsCompany` int(11) NOT NULL default '0',
  `OrderBy` varchar(254) NOT NULL default '',
  `PeopleType` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


--
-- Table structure for table `PeopleTypes`
--

DROP TABLE IF EXISTS `PeopleTypes`;
CREATE TABLE `PeopleTypes` (
  `id` int(11) NOT NULL auto_increment,
  `PeopleType` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO PeopleTypes (id, PeopleType) VALUES (1, '');

--
-- Table structure for table `PeopleName_PeopleTypes`
--

DROP TABLE IF EXISTS `PeopleNames_PeopleTypes`;
CREATE TABLE `PeopleNames_PeopleTypes` (
  `id` int(11) NOT NULL auto_increment,
  `peoplenames_id` int(11) NOT NULL,
  `peopletypes_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subject`;
CREATE TABLE `subject` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


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
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


--
-- Table structure for table `towns`
--

DROP TABLE IF EXISTS `TownNames`;
CREATE TABLE `TownNames` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

