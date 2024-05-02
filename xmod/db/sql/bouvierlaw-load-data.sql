LOAD DATA INFILE '/mnt/tm/gazetteers/Bouvier_LawDictionary/bouvier.index'
    INTO TABLE bouvierlaw
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\n'
    IGNORE 3 LINES
    (@keyword, @dummy, @dummy)
    SET id = 0, keyword = @keyword;
