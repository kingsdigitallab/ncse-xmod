-- show count of periodicaltitle field from individual articles
-- show distinct periodicaltitle field from individual articles
select count(id) from allmetadata where n_ent_appd_kc_periodicaltitle != '';
select distinct n_ent_appd_kc_periodicaltitle from allmetadata where n_ent_appd_kc_periodicaltitle != '';
