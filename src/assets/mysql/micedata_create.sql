-- MySQL dump 10.11
--
-- Host: localhost    Database: micedata
-- ------------------------------------------------------
-- Server version	5.0.67-0ubuntu6
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `micedata`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `micedata` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `micedata`;

--
-- Table structure for table `ant`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ant` (
  `id` varchar(3) character set utf8 NOT NULL,
  `last` datetime default NULL,
  `data_count` int(10) unsigned default '0',
  `dir_count` int(10) unsigned default '0',
  `res_count` int(10) unsigned default '0',
  `box` varchar(2) character set utf8 NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `box` (`box`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ant_count`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ant_count` (
  `day` date NOT NULL,
  `data_count` int(11) default '0',
  `dir_count` int(11) default '0',
  `res_count` int(11) default '0',
  `counter` int(11) NOT NULL auto_increment,
  `id` varchar(4) NOT NULL,
  PRIMARY KEY  (`counter`),
  KEY `day` (`day`),
  KEY `id` USING BTREE (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=18257 DEFAULT CHARSET=latin1 PACK_KEYS=1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `box`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `box` (
  `id` varchar(2) character set utf8 NOT NULL default '',
  `segment` varchar(1) character set utf8 default NULL,
  `last` datetime default NULL,
  `data_count` int(10) unsigned default NULL,
  `dir_count` int(10) unsigned default '0',
  `res_count` int(10) unsigned default '0',
  `xcoord` smallint(5) unsigned default '0',
  `ycoord` smallint(6) default '0',
  PRIMARY KEY  (`id`),
  KEY `segment` (`segment`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `box_count`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `box_count` (
  `counter` int(11) NOT NULL auto_increment,
  `id` varchar(2) NOT NULL,
  `data_count` int(11) default '0',
  `dir_count` int(11) default '0',
  `res_count` int(11) default '0',
  `day` date NOT NULL,
  PRIMARY KEY  (`counter`),
  KEY `id` (`id`),
  KEY `day` (`day`)
) ENGINE=MyISAM AUTO_INCREMENT=9631 DEFAULT CHARSET=latin1 PACK_KEYS=1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `data`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `data` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `rfid` varchar(10) NOT NULL,
  `time` datetime NOT NULL,
  `millisec` int(11) NOT NULL,
  `ant` varchar(3) NOT NULL,
  `import` varchar(13) NOT NULL,
  `i` tinyint(4) default '0',
  `dir_id` bigint(20) unsigned default NULL,
  `res_id` bigint(20) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `ant` (`ant`),
  KEY `rfid` (`rfid`),
  KEY `time` (`time`),
  KEY `i` (`i`),
  KEY `dir_id` (`dir_id`),
  KEY `res_id` (`res_id`)
) ENGINE=MyISAM AUTO_INCREMENT=8184254 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `dir`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `dir` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `rfid` varchar(10) NOT NULL,
  `time` datetime NOT NULL,
  `box` varchar(2) NOT NULL,
  `dir` varchar(3) NOT NULL,
  `outerdataid` bigint(20) unsigned NOT NULL,
  `innerdataid` bigint(20) unsigned NOT NULL,
  `i` tinyint(4) default '0',
  `res_id` bigint(20) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `i` (`i`),
  KEY `rfid` (`rfid`),
  KEY `time` (`time`),
  KEY `box` (`box`),
  KEY `dir` (`dir`),
  KEY `res_id` (`res_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1492732 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `logs`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL default '0',
  `logfile` varchar(19) default NULL,
  `short` varchar(13) NOT NULL,
  `size` smallint(5) unsigned NOT NULL,
  `start` datetime default NULL,
  `end` datetime default NULL,
  `duration` time default NULL,
  `import` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=609 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `meetings`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `meetings` (
  `id` bigint(20) NOT NULL auto_increment,
  `rfid_from` varchar(10) NOT NULL,
  `res_id_from` bigint(20) NOT NULL,
  `rfid_to` varchar(10) NOT NULL,
  `res_id_to` bigint(20) NOT NULL,
  `from` datetime NOT NULL,
  `to` datetime NOT NULL,
  `dt` time NOT NULL,
  `box` varchar(2) NOT NULL,
  `typ` enum('1','2','3','4') default NULL,
  PRIMARY KEY  (`id`),
  KEY `rfid` (`res_id_from`,`res_id_to`),
  KEY `datetime` (`to`,`from`),
  KEY `box` (`box`),
  KEY `typ` (`typ`),
  KEY `from` (`from`),
  KEY `to` (`to`),
  KEY `dt` (`dt`),
  KEY `res_id_from` (`res_id_from`),
  KEY `rfid_from` (`rfid_from`),
  KEY `rfid_to` (`rfid_to`),
  KEY `res_id_to` (`res_id_to`)
) ENGINE=MyISAM AUTO_INCREMENT=467729 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `res`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `res` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `rfid` varchar(10) NOT NULL,
  `box` varchar(2) NOT NULL,
  `box_in` datetime NOT NULL,
  `box_out` datetime NOT NULL,
  `dt` time NOT NULL,
  `inid` bigint(20) unsigned NOT NULL,
  `outid` bigint(20) unsigned NOT NULL,
  `i` tinyint(4) default '0',
  `meetings` enum('FALSE','TRUE') default 'FALSE',
  `nerv_index` tinyint(3) unsigned default '0',
  PRIMARY KEY  (`id`),
  KEY `meetings` (`meetings`),
  KEY `i` (`i`),
  KEY `box` (`box`),
  KEY `boxin` (`box_in`),
  KEY `boxout` (`box_out`),
  KEY `dt` (`dt`),
  KEY `rfid` (`rfid`),
  KEY `nerv_index` (`nerv_index`)
) ENGINE=MyISAM AUTO_INCREMENT=507695 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rfid`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rfid` (
  `id` varchar(10) NOT NULL,
  `import` datetime default NULL,
  `dir` datetime default NULL,
  `res` datetime default NULL,
  `i` tinyint(4) default '0',
  `data_count` int(10) unsigned default '0',
  `dir_count` int(10) unsigned default '0',
  `res_count` int(10) unsigned default '0',
  `sex` char(1) default '',
  `last` datetime default NULL,
  `implant_date` date default NULL,
  `weight` int(10) unsigned default '0',
  PRIMARY KEY  (`id`),
  KEY `i` (`i`),
  KEY `sex` (`sex`),
  KEY `implant_date` (`implant_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rfid_count`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rfid_count` (
  `counter` int(11) NOT NULL auto_increment,
  `id` varchar(10) NOT NULL,
  `data_count` int(11) default '0',
  `dir_count` int(11) default '0',
  `res_count` int(11) default '0',
  `day` date NOT NULL,
  PRIMARY KEY  (`counter`),
  KEY `id` (`id`),
  KEY `day` (`day`)
) ENGINE=MyISAM AUTO_INCREMENT=32212 DEFAULT CHARSET=latin1 PACK_KEYS=1;
SET character_set_client = @saved_cs_client;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-05-20 15:31:02
