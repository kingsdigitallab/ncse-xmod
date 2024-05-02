LOAD DATA INFILE '/mnt/tm/gazetteers/ADL/adlgaz-namelist.txt'
    INTO TABLE adl
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '\n'
    (@adlid, @place, @date)
    SET id = 0, place = @place;
