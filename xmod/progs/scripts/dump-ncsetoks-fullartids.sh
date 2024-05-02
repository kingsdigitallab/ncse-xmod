#!/bin/sh
# dump 'fullartids' table (just for backup) that was created during
# the run of 'prxml-to-tokenDB-tokfaid-loadfmt.py'
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_attw fullartids >/ncseloaddata/ATTW_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_cld fullartids >/ncseloaddata/CLD_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_emrp fullartids >/ncseloaddata/EMRP_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ettw fullartids >/ncseloaddata/ETTW_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ewj fullartids >/ncseloaddata/EWJ_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_fewj fullartids >/ncseloaddata/FEWJ_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_fldr fullartids >/ncseloaddata/FLDR_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_fmrp fullartids >/ncseloaddata/FMRP_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ftec fullartids >/ncseloaddata/FTEC_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_fttw fullartids >/ncseloaddata/FTTW_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ldr fullartids >/ncseloaddata/LDR_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_mrp fullartids >/ncseloaddata/MRP_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ns2 fullartids >/ncseloaddata/NS2_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ns3 fullartids >/ncseloaddata/NS3_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ns4 fullartids >/ncseloaddata/NS4_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ns5 fullartids >/ncseloaddata/NS5_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ns6 fullartids >/ncseloaddata/NS6_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ns7 fullartids >/ncseloaddata/NS7_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ns8 fullartids >/ncseloaddata/NS8_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ns9 fullartids >/ncseloaddata/NS9_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_nss fullartids >/ncseloaddata/NSS_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_scld fullartids >/ncseloaddata/SCLD_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_sldr fullartids >/ncseloaddata/SLDR_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_smrp fullartids >/ncseloaddata/SMRP_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_snss fullartids >/ncseloaddata/SNSS_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_sxldr fullartids >/ncseloaddata/SXLDR_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_tec fullartids >/ncseloaddata/TEC_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ttec fullartids >/ncseloaddata/TTEC_fullartids_dump.sql
mysqldump -u gbrey --skip-extended-insert --add-drop-table ncsetoks_ttw fullartids >/ncseloaddata/TTW_fullartids_dump.sql
