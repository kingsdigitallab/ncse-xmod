-- show count of actualtitle field from TOC file
-- show distinct actualtitle field from TOC file
select count(id) from allmetadata where n_toc_appd_kc_actualtitle != '' and n_ent_appd_kc_actualtitle != '';
select distinct n_toc_appd_kc_actualtitle, n_ent_appd_kc_actualtitle from allmetadata where n_toc_appd_kc_actualtitle != '' and n_ent_appd_kc_actualtitle != '';
select count(id) from allmetadata where (n_toc_appd_kc_actualtitle != '' and n_ent_appd_kc_actualtitle != '') and (n_toc_appd_kc_actualtitle != n_ent_appd_kc_actualtitle);
select distinct n_toc_appd_kc_actualtitle, n_ent_appd_kc_actualtitle from allmetadata where (n_toc_appd_kc_actualtitle != '' and n_ent_appd_kc_actualtitle != '') and (n_toc_appd_kc_actualtitle != n_ent_appd_kc_actualtitle);
