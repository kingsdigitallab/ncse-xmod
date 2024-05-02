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

--
-- Table structure for table `counties`
--

DROP TABLE IF EXISTS `counties`;
CREATE TABLE `counties` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `counties`
--


/*!40000 ALTER TABLE `counties` DISABLE KEYS */;
LOCK TABLES `counties` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `counties` ENABLE KEYS */;

--
-- Table structure for table `issuingbodies`
--

DROP TABLE IF EXISTS `issuingbodies`;
CREATE TABLE `issuingbodies` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `issuingbodies`
--


/*!40000 ALTER TABLE `issuingbodies` DISABLE KEYS */;
LOCK TABLES `issuingbodies` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `issuingbodies` ENABLE KEYS */;

--
-- Table structure for table `people`
--

DROP TABLE IF EXISTS `people`;
CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `ExtraInfo` varchar(254) NOT NULL default '',
  `ProperName` varchar(254) NOT NULL default '',
  `GivenName` varchar(254) NOT NULL default '',
  `IsCompany` int(11) NOT NULL default '0',
  `PeopleType` varchar(254) NOT NULL default '',
  `OrderBy` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `people`
--


/*!40000 ALTER TABLE `people` DISABLE KEYS */;
LOCK TABLES `people` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `people` ENABLE KEYS */;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subjects`
--


/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
LOCK TABLES `subjects` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;

--
-- Table structure for table `titles`
--

DROP TABLE IF EXISTS `titles`;
CREATE TABLE `titles` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `StartDate` varchar(254) NOT NULL default '',
  `EndDate` varchar(254) NOT NULL default '',
  `recordID` int(11) NOT NULL default '0',
  `laterTitleID` int(11) NOT NULL default '0',
  `SeeRefRecordTitle` varchar(254) NOT NULL default '',
  `ReferenceType` varchar(254) NOT NULL default '',
  `Title` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `titles`
--


/*!40000 ALTER TABLE `titles` DISABLE KEYS */;
LOCK TABLES `titles` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `titles` ENABLE KEYS */;

--
-- Table structure for table `towns`
--

DROP TABLE IF EXISTS `towns`;
CREATE TABLE `towns` (
  `id` int(11) NOT NULL auto_increment,
  `wlid` int(11) NOT NULL default '0',
  `Name` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `towns`
--


/*!40000 ALTER TABLE `towns` DISABLE KEYS */;
LOCK TABLES `towns` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `towns` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

