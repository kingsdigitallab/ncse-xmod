DROP TABLE IF EXISTS `article`;
DROP TABLE IF EXISTS `similar_article`;

CREATE TABLE `article` (
  `id` INT(11) NOT NULL,
  `article_id` VARCHAR(100) NOT NULL default '',
  `publication` VARCHAR(100) NOT NULL default '',
  `year` INT(11),
  `month` INT(11),
  `query` TEXT,
  PRIMARY KEY  (`id`),
  INDEX article_id_idx (article_id),
  INDEX publication_idx (publication),
  INDEX year_idx (year),
  INDEX month_idx (month)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `similar_article` (
  `id` INT(11) NOT NULL,
  `article_id` VARCHAR(100) NOT NULL default '',
  `similar_article_id` VARCHAR(100) NOT NULL default '',
  `score` FLOAT,
  PRIMARY KEY  (`id`),
  INDEX article_id_idx (article_id),
  INDEX similar_article_id_idx (similar_article_id),
  INDEX score_idx (score)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

