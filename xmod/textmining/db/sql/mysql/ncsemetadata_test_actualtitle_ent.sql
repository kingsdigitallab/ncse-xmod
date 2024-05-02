-- show count of actualtitle field from individual articles
-- show distinct actualtitle field from individual articles
select count(id) from allmetadata where n_ent_appd_kc_actualtitle != '';
select distinct n_ent_appd_kc_actualtitle from allmetadata where n_ent_appd_kc_actualtitle != '';
