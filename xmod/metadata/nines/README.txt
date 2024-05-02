
one number/issue per file - OCR text - decision will be made if
unprintable characters should be replaced or not

TL will send me a template RDF file
this will be similar to this one
http://www.performantsoftware.com/nines_wiki/index.php/Submitting_RDF

RDFs should be grouped into batches for uploading via NINES web
service

for the question if text should be included in the RDF or kept
externally see description for
<nines:text> in the wiki

Date:
if there is a date within one of the metadata fields, take it from
there, otherwise take from article ID

LB and JM will prepare a spreadsheet that contains information about
editors by year or month or issue (= day)


select distinct o_toc_meta_base_href, n_toc_appd_dc_date, n_toc_appd_kc_actualtitle, n_toc_appd_kc_volume, n_toc_appd_kc_number, n_toc_appd_kc_edition, n_ent_appd_kc_edition from allmetadata limit 100;

for ncse-text:
mysql -B -h ncse-text.cch.kcl.ac.uk -P 51524 -u gbrey ncsemetadata-20090518 -e "select distinct o_toc_meta_base_href, n_toc_appd_dc_date, n_toc_appd_kc_actualtitle, n_toc_appd_kc_volume, n_toc_appd_kc_number, n_toc_appd_kc_edition, n_ent_appd_kc_edition from allmetadata" >/projects/cch/ncse/metadata/nines/issues.tab

for yew:
mysql -B -h localhost -P 51524 -u gbrey ncsemetadata-20090709 -e "select distinct o_toc_meta_base_href, n_toc_appd_dc_date, n_toc_appd_kc_actualtitle, n_toc_appd_kc_volume, n_toc_appd_kc_number, n_toc_appd_kc_edition, n_ent_appd_kc_edition from allmetadata" >/projects/cch/ncse/metadata/nines/issues-20090709.tab

