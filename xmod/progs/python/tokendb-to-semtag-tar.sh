#!/bin/sh
currdatebefore=`date +%Y%m%d%H%M`
cd /home/ncsedata/corpussemtag-20090204
tar cvzf EWJ-20090204.tar.gz EWJ/*
rm -fr EWJ
tar cvzf LDR-20090204.tar.gz LDR/*
rm -fr LDR
tar cvzf MRP-20090204.tar.gz MRP/*
rm -fr MRP
tar cvzf NSS-20090204.tar.gz NSS/*
rm -fr NSS
tar cvzf TEC-20090204.tar.gz TEC/*
rm -fr TEC
tar cvzf TTW-20090204.tar.gz TTW/*
rm -fr TTW
tar cvzf FEWJ-20090204.tar.gz FEWJ/*
rm -fr FEWJ
tar cvzf FLDR-20090204.tar.gz FLDR/*
rm -fr FLDR
tar cvzf CLD-20090204.tar.gz CLD/*
rm -fr CLD
tar cvzf EMRP-20090204.tar.gz EMRP/*
rm -fr EMRP
tar cvzf FMRP-20090204.tar.gz FMRP/*
rm -fr FMRP
tar cvzf SMRP-20090204.tar.gz SMRP/*
rm -fr SMRP
tar cvzf SNSS-20090204.tar.gz SNSS/*
rm -fr SNSS
tar cvzf NS2-20090204.tar.gz NS2/*
rm -fr NS2
tar cvzf NS3-20090204.tar.gz NS3/*
rm -fr NS3
tar cvzf NS4-20090204.tar.gz NS4/*
rm -fr NS4
tar cvzf NS5-20090204.tar.gz NS5/*
rm -fr NS5
tar cvzf NS6-20090204.tar.gz NS6/*
rm -fr NS6
tar cvzf NS7-20090204.tar.gz NS7/*
rm -fr NS7
tar cvzf NS8-20090204.tar.gz NS8/*
rm -fr NS8
tar cvzf NS9-20090204.tar.gz NS9/*
rm -fr NS9
tar cvzf FTEC-20090204.tar.gz FTEC/*
rm -fr FTEC
tar cvzf TTEC-20090204.tar.gz TTEC/*
rm -fr TTEC
tar cvzf ATTW-20090204.tar.gz ATTW/*
rm -fr ATTW
tar cvzf ETTW-20090204.tar.gz ETTW/*
rm -fr ETTW
tar cvzf FTTW-20090204.tar.gz FTTW/*
rm -fr FTTW
tar cvzf SCLD-20090204.tar.gz SCLD/*
rm -fr SCLD
tar cvzf SLDR-20090204.tar.gz SLDR/*
rm -fr SLDR
tar cvzf SXLDR-20090204.tar.gz SXLDR/*
rm -fr SXLDR
currdateafter=`date +%Y%m%d%H%M`
echo "START: $currdatebefore" >/home/ncsedata/corpussemtag-20090204/tokendb-to-semtag-tar-$currdateafter.log
echo "END  : $currdateafter" >>/home/ncsedata/corpussemtag-20090204/tokendb-to-semtag-tar-$currdateafter.log
