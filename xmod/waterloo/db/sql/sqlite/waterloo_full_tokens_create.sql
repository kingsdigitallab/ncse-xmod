DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category TEXT
);

DROP TABLE IF EXISTS tokens;
CREATE TABLE tokens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  token TEXT
);

DROP TABLE IF EXISTS tokens_wlentries;
CREATE TABLE tokens_wlentries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tokenid INTEGER,
  wlentryid INTEGER,
  tokenpos INTEGER,
  categoryid INTEGER
);

DROP TABLE IF EXISTS wlentries;
CREATE TABLE wlentries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  wlentry TEXT,
  categoryid INTEGER,
  wlid INTEGER
);

DROP TABLE IF EXISTS countynames;
CREATE TABLE countynames (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  wlid INTEGER NOT NULL default '0',
  Name TEXT NOT NULL default ''
);

DROP TABLE IF EXISTS issuingbodynames;
CREATE TABLE issuingbodynames (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  wlid INTEGER NOT NULL default '0',
  Name TEXT NOT NULL default ''
);

DROP TABLE IF EXISTS peoplenames;
CREATE TABLE peoplenames (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  wlid INTEGER NOT NULL default '0',
  ProperName TEXT NOT NULL default '',
  GivenName TEXT NOT NULL default '',
  ExtraInfo TEXT NOT NULL default '',
  IsCompany INTEGER NOT NULL default '0',
  OrderBy TEXT NOT NULL default '',
  PeopleType TEXT NOT NULL default ''
);

DROP TABLE IF EXISTS peoplenames_peopletypes;
CREATE TABLE peoplenames_peopletypes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  peoplenames_id INTEGER NOT NULL default '0',
  peopletypes_id INTEGER NOT NULL default '0'
);

DROP TABLE IF EXISTS peopletypes;
CREATE TABLE peopletypes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  PeopleType TEXT NOT NULL default ''
);

DROP TABLE IF EXISTS subject;
CREATE TABLE subject (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  wlid INTEGER NOT NULL default '0',
  name TEXT NOT NULL default ''
);

DROP TABLE IF EXISTS title;
CREATE TABLE title (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  wlid INTEGER NOT NULL default '0',
  recordID INTEGER NOT NULL default '0',
  laterTitleID INTEGER NOT NULL default '0',
  StartDate TEXT NOT NULL default '',
  EndDate TEXT NOT NULL default '',
  title TEXT,
  SeeRefRecordTitle TEXT NOT NULL default '',
  referenceType TEXT NOT NULL default ''
);

DROP TABLE IF EXISTS townnames;
CREATE TABLE townnames (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  wlid INTEGER NOT NULL default '0',
  Name TEXT NOT NULL default ''
);


INSERT INTO categories (category) VALUES ('');
INSERT INTO categories (category) VALUES ('county');
INSERT INTO categories (category) VALUES ('town');
INSERT INTO categories (category) VALUES ('subject');
INSERT INTO categories (category) VALUES ('issuingbody');
INSERT INTO categories (category) VALUES ('date');
INSERT INTO categories (category) VALUES ('startdate');
INSERT INTO categories (category) VALUES ('enddate');
INSERT INTO categories (category) VALUES ('pubtitle');
INSERT INTO categories (category) VALUES ('firstname');
INSERT INTO categories (category) VALUES ('lastname');
INSERT INTO categories (category) VALUES ('persontitle');
INSERT INTO categories (category) VALUES ('extrainfo');

