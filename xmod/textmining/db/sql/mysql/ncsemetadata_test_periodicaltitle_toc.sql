-- show count of periodicaltitle field from TOC file
-- show distinct periodicaltitle field from TOC file
select count(id) from allmetadata where n_toc_appd_kc_periodicaltitle != '';
select distinct n_toc_appd_kc_periodicaltitle from allmetadata where n_toc_appd_kc_periodicaltitle != '';
