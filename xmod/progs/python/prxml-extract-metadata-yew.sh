#!/bin/sh
currdatebefore=`date +%Y%m%d%H%M`
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a EWJ
echo "prxml-extract-metadata EWJ"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a LDR
echo "prxml-extract-metadata LDR"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a MRP
echo "prxml-extract-metadata MRP"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a NSS
echo "prxml-extract-metadata NSS"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a TEC
echo "prxml-extract-metadata TEC"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a TTW
echo "prxml-extract-metadata TTW"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a FEWJ
echo "prxml-extract-metadata FEWJ"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a FLDR
echo "prxml-extract-metadata FLDR"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a CLD
echo "prxml-extract-metadata CLD"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a EMRP
echo "prxml-extract-metadata EMRP"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a FMRP
echo "prxml-extract-metadata FMRP"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a SMRP
echo "prxml-extract-metadata SMRP"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a SNSS
echo "prxml-extract-metadata SNSS"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a NS2
echo "prxml-extract-metadata NS2"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a NS3
echo "prxml-extract-metadata NS3"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a NS4
echo "prxml-extract-metadata NS4"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a NS5
echo "prxml-extract-metadata NS5"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a NS6
echo "prxml-extract-metadata NS6"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a NS7
echo "prxml-extract-metadata NS7"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a NS8
echo "prxml-extract-metadata NS8"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a NS9
echo "prxml-extract-metadata NS9"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a FTEC
echo "prxml-extract-metadata FTEC"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a TTEC
echo "prxml-extract-metadata TTEC"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a ATTW
echo "prxml-extract-metadata ATTW"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a ETTW
echo "prxml-extract-metadata ETTW"
./prxml-extract-metadata.py -u gbrey -d ncsemetadata -i /ncserepository/2008/20080501 -l /projects/cch/ncse/progs/python/logs -a FTTW
echo "prxml-extract-metadata FTTW"
currdateafter=`date +%Y%m%d%H%M`
echo "START: $currdatebefore" >/projects/cch/ncse/progs/python/logs/prxml-extract-metadata-all-$currdateafter.log
echo "END  : $currdateafter" >>/projects/cch/ncse/progs/python/logs/prxml-extract-metadata-all-$currdateafter.log
