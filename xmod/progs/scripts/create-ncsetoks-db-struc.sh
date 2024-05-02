#!/bin/sh

sqlloc="/projects/cch/ncse/textmining/db/sql/mysql/ncsetoks_create_myisam.sql"

echo "ncsetoks_attw"
mysqladmin -u gbrey create ncsetoks_attw
mysql -u gbrey ncsetoks_attw <$sqlloc

echo "ncsetoks_cld"
mysqladmin -u gbrey create ncsetoks_cld
mysql -u gbrey ncsetoks_cld <$sqlloc

echo "ncsetoks_emrp"
mysqladmin -u gbrey create ncsetoks_emrp
mysql -u gbrey ncsetoks_emrp <$sqlloc

echo "ncsetoks_ettw"
mysqladmin -u gbrey create ncsetoks_ettw
mysql -u gbrey ncsetoks_ettw <$sqlloc

echo "ncsetoks_ewj"
mysqladmin -u gbrey create ncsetoks_ewj
mysql -u gbrey ncsetoks_ewj <$sqlloc

echo "ncsetoks_fewj"
mysqladmin -u gbrey create ncsetoks_fewj
mysql -u gbrey ncsetoks_fewj <$sqlloc

echo "ncsetoks_fldr"
mysqladmin -u gbrey create ncsetoks_fldr
mysql -u gbrey ncsetoks_fldr <$sqlloc

echo "ncsetoks_fmrp"
mysqladmin -u gbrey create ncsetoks_fmrp
mysql -u gbrey ncsetoks_fmrp <$sqlloc

echo "ncsetoks_ftec"
mysqladmin -u gbrey create ncsetoks_ftec
mysql -u gbrey ncsetoks_ftec <$sqlloc

echo "ncsetoks_fttw"
mysqladmin -u gbrey create ncsetoks_fttw
mysql -u gbrey ncsetoks_fttw <$sqlloc

echo "ncsetoks_ldr"
mysqladmin -u gbrey create ncsetoks_ldr
mysql -u gbrey ncsetoks_ldr <$sqlloc

echo "ncsetoks_mrp"
mysqladmin -u gbrey create ncsetoks_mrp
mysql -u gbrey ncsetoks_mrp <$sqlloc

echo "ncsetoks_ns2"
mysqladmin -u gbrey create ncsetoks_ns2
mysql -u gbrey ncsetoks_ns2 <$sqlloc

echo "ncsetoks_ns3"
mysqladmin -u gbrey create ncsetoks_ns3
mysql -u gbrey ncsetoks_ns3 <$sqlloc

echo "ncsetoks_ns4"
mysqladmin -u gbrey create ncsetoks_ns4
mysql -u gbrey ncsetoks_ns4 <$sqlloc

echo "ncsetoks_ns5"
mysqladmin -u gbrey create ncsetoks_ns5
mysql -u gbrey ncsetoks_ns5 <$sqlloc

echo "ncsetoks_ns6"
mysqladmin -u gbrey create ncsetoks_ns6
mysql -u gbrey ncsetoks_ns6 <$sqlloc

echo "ncsetoks_ns7"
mysqladmin -u gbrey create ncsetoks_ns7
mysql -u gbrey ncsetoks_ns7 <$sqlloc

echo "ncsetoks_ns8"
mysqladmin -u gbrey create ncsetoks_ns8
mysql -u gbrey ncsetoks_ns8 <$sqlloc

echo "ncsetoks_ns9"
mysqladmin -u gbrey create ncsetoks_ns9
mysql -u gbrey ncsetoks_ns9 <$sqlloc

echo "ncsetoks_nss"
mysqladmin -u gbrey create ncsetoks_nss
mysql -u gbrey ncsetoks_nss <$sqlloc

echo "ncsetoks_scld"
mysqladmin -u gbrey create ncsetoks_scld
mysql -u gbrey ncsetoks_scld <$sqlloc

echo "ncsetoks_sldr"
mysqladmin -u gbrey create ncsetoks_sldr
mysql -u gbrey ncsetoks_sldr <$sqlloc

echo "ncsetoks_smrp"
mysqladmin -u gbrey create ncsetoks_smrp
mysql -u gbrey ncsetoks_smrp <$sqlloc

echo "ncsetoks_snss"
mysqladmin -u gbrey create ncsetoks_snss
mysql -u gbrey ncsetoks_snss <$sqlloc

echo "ncsetoks_sxldr"
mysqladmin -u gbrey create ncsetoks_sxldr
mysql -u gbrey ncsetoks_sxldr <$sqlloc

echo "ncsetoks_tec"
mysqladmin -u gbrey create ncsetoks_tec
mysql -u gbrey ncsetoks_tec <$sqlloc

echo "ncsetoks_ttec"
mysqladmin -u gbrey create ncsetoks_ttec
mysql -u gbrey ncsetoks_ttec <$sqlloc

echo "ncsetoks_ttw"
mysqladmin -u gbrey create ncsetoks_ttw
mysql -u gbrey ncsetoks_ttw <$sqlloc

