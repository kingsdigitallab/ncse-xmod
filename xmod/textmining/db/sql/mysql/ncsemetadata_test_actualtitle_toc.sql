-- show count of actualtitle field from TOC file
-- show distinct actualtitle field from TOC file
select count(id) from allmetadata where n_toc_appd_kc_actualtitle != '';
select distinct n_toc_appd_kc_actualtitle from allmetadata where n_toc_appd_kc_actualtitle != '';
