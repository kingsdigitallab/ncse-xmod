-- SQLite3
DROP TABLE IF EXISTS tokens;
CREATE TABLE tokens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tokenid TEXT,
  entityid TEXT,
  token TEXT,
  spaceaftertoken TEXT,
  olivepageno INTEGER,
  publpageno TEXT,
  entlineno INTEGER,
  artlineno INTEGER,
  coordbox TEXT
);

-- INSERT INTO categories (category) VALUES ('');

