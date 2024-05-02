LOAD DATA INFILE '/home/ncsedata/lucene-similarity/hsqldb/similar_article.txt'
    INTO TABLE similar_article
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n';
