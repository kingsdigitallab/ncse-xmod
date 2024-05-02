-- MySQL
-- CREATE DATABASE IF NOT EXISTS `ncse_tokens_innodb`;
-- USE `ncse_tokens_innodb`;
DROP TABLE IF EXISTS `tokens`;
CREATE TABLE `tokens` (
  id int(11) NOT NULL auto_increment,
  tokenid varchar(50),
  entityid varchar(50),
  token varchar(254) CHARACTER SET utf8,
  spaceaftertoken varchar(5),
  olivepageno int(11),
  publpageno varchar(254),
  entlineno int(11),
  artlineno int(11),
  coordbox text,
  PRIMARY KEY (id),
  INDEX tokenid_idx (tokenid),
  INDEX token_idx (token)
) ENGINE=INNODB;
