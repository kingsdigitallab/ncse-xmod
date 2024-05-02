DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  category VARCHAR(255) NULL,
  PRIMARY KEY(id)
);

DROP TABLE IF EXISTS tokens;
CREATE TABLE tokens (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  token VARCHAR(255) NULL,
  PRIMARY KEY(id)
);

DROP TABLE IF EXISTS tokens_wlentries;
CREATE TABLE tokens_wlentries (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  tokenid INTEGER UNSIGNED NULL,
  wlentryid INTEGER UNSIGNED NULL,
  tokenpos INTEGER UNSIGNED NULL,
  categoryid INTEGER UNSIGNED NULL,
  PRIMARY KEY(id)
);

DROP TABLE IF EXISTS wlentries;
CREATE TABLE wlentries (
  id INTEGER NOT NULL AUTO_INCREMENT,
  wlentry TINYTEXT NULL,
  categoryid INTEGER UNSIGNED NULL,
  wlid INTEGER UNSIGNED NULL,
  PRIMARY KEY(id)
);

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

