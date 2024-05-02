--
-- fix errors in semtagnames table introduced by faulty regex in semtag-to-mysql.py
-- 
-- select name, TRIM(LEFT(name, LOCATE(" Z", name))), TRIM(RIGHT(name, LENGTH(name) - LOCATE(" Z", name))) from semtagnames;
-- 
UPDATE semtagnames SET semtag='Z1', semtaglong='Personal names', name=TRIM(LEFT(name, LOCATE(" Z1", name))) WHERE name like '% Z1';
UPDATE semtagnames SET semtag='Z2', semtaglong='Geographical names', name=TRIM(LEFT(name, LOCATE(" Z2", name))) WHERE name like '% Z2';
UPDATE semtagnames SET semtag='Z3', semtaglong='Other proper names', name=TRIM(LEFT(name, LOCATE(" Z3", name))) WHERE name like '% Z3';
