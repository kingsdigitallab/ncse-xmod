DROP TABLE IF EXISTS `tokens`;
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
) ENGINE=MyISAM;
