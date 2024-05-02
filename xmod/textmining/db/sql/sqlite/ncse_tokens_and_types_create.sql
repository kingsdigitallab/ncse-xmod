-- SQLite3
DROP TABLE IF EXISTS tokens;
CREATE TABLE tokens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  publ TEXT,
  year INTEGER,
  month INTEGER,
  day INTEGER,
  artid TEXT,
  arttokenno INTEGER,
  tokenid TEXT,
  entityid TEXT,
  token TEXT,
  typeid INTEGER,
  spaceaftertoken TEXT,
  olivepageno INTEGER,
  publpageno TEXT,
  entlineno INTEGER,
  artlineno INTEGER,
  coordbox TEXT
);

DROP TABLE IF EXISTS types;
CREATE TABLE types (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT
);

CREATE INDEX publ_idx ON tokens(publ);
CREATE INDEX year_idx ON tokens(year);
CREATE INDEX month_idx ON tokens(month);
CREATE INDEX day_idx ON tokens(day);
CREATE INDEX artid_idx ON tokens(artid);
CREATE INDEX arttokenno_idx ON tokens(arttokenno);
CREATE INDEX typeid_idx ON tokens(typeid);

CREATE INDEX type_idx ON types(type);


-- INSERT INTO categories (category) VALUES ('');

