-- SQLite3

DROP TABLE IF EXISTS tokens_annotations;
DROP TABLE IF EXISTS types_annotations;
DROP TABLE IF EXISTS lctypes_annotations;
DROP TABLE IF EXISTS tokens;
DROP TABLE IF EXISTS types;
DROP TABLE IF EXISTS lctypes;
DROP TABLE IF EXISTS annotations;
DROP TABLE IF EXISTS fullartids;

-- types - original spelling
CREATE TABLE types (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT,
  frequency INTEGER
);
CREATE INDEX typestype_idx ON types(type);
CREATE INDEX typesfrequency_idx ON types(frequency);

-- types - lower case
CREATE TABLE lctypes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  lctype TEXT,
  frequency INTEGER
);
CREATE INDEX lctypestype_idx ON lctypes(lctype);
CREATE INDEX lctypesfrequency_idx ON lctypes(frequency);

-- annotations
CREATE TABLE annotations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  annotation TEXT,
  annotationtype TEXT
);
CREATE INDEX annotationsannotation ON annotations(annotation);

-- fullartids
-- full globally unique article id
-- tokencount: our own token count (including punctuation)
-- olivewordcount: word count taken and added up from Olive's
--                 TOC.xml
-- charcount: character count (including spaces and new lines)
-- charnscount: character count (without spaces and new lines)
-- linecount: number of lines in article (should equal "real"
--            number of lines
CREATE TABLE fullartids (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fullartid TEXT,
  tokencount INTEGER,
  olivewordcount INTEGER,
  charcount INTEGER,
  charnscount INTEGER,
  linecount INTEGER,
  publ TEXT,
  year INTEGER,
  month INTEGER,
  day INTEGER,
  artid TEXT
);
CREATE INDEX fullartidsfullartid ON fullartids(fullartid);
CREATE INDEX fullartidstokencount ON fullartids(tokencount);
CREATE INDEX fullartidscharcount ON fullartids(charcount);
CREATE INDEX fullartidscharnscount ON fullartids(charnscount);
CREATE INDEX fullartidslinecount ON fullartids(linecount);
CREATE INDEX fullartidspubl ON fullartids(publ);
CREATE INDEX fullartidsyear ON fullartids(year);
CREATE INDEX fullartidsmonth ON fullartids(month);
CREATE INDEX fullartidsday ON fullartids(day);
CREATE INDEX fullartidsartid ON fullartids(artid);

-- tokens
CREATE TABLE tokens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tokenid TEXT,
  token TEXT,
  spaceaftertoken TEXT,
  olivepageno INTEGER,
  publpageno TEXT,
  entlineno INTEGER,
  artlineno INTEGER,
  arttokenno INTEGER,
  fullartidid INTEGER,
  entityid TEXT,
  typeid INTEGER,
  lctypeid INTEGER,
  coordbox TEXT,
  apfs TEXT,
  specialtype TEXT
);
CREATE INDEX tokenstokenid ON tokens(tokenid);
CREATE INDEX tokenstoken ON tokens(token);
CREATE INDEX tokensarttokenno ON tokens(arttokenno);
CREATE INDEX tokensfullartidid ON tokens(fullartidid);
CREATE INDEX tokenstypeid ON tokens(typeid);
CREATE INDEX tokenslctypeid ON tokens(lctypeid);

-- tokens_annotations
CREATE TABLE tokens_annotations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  annotationid INTEGER,
  tokenid INTEGER
);

-- types_annotations
CREATE TABLE types_annotations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  annotationid INTEGER,
  typeid INTEGER
);

-- lctypes_annotations
CREATE TABLE lctypes_annotations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  annotationid INTEGER,
  lctypeid INTEGER
);


