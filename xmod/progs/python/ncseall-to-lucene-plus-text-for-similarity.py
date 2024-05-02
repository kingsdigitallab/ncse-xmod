#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Read a MySQL database containing the output of a GATE run,
#    i. e. locations, institutions and names and write them
#    into a lucene XML files
# include the text for similarity
# tag for text:
# <field indexed="tokenized" name="text" stored="yes" vector="no">

# A T T E N T I O N ! ! !
# currently no lucene output files are produced if actual title or
#    periodical title are empty
#    see: writeLuceneXmlFile

# TODO: fix the following encoding errors:
# NSS-1839-10-05-Ar00201 - line 142: T3####T3\227##3##12.06##99.9
#    i. e. invalid semtag label, char 151, 0x97, 0227
# LDR-1853-10-01-Ar01701 - line 79: T3####T3\227##6##13.92##99.9
#    i. e. invalid semtag label, char 151, 0x97, 0227
# TEC-1880-07-01-Ar00801 - line 270: T3####T3\227##14##10.11##99 
#    i. e. invalid semtag label, char 151, 0x97, 0227
# CLD-1853-10-01-Ar01701 - line 76: T3####T3\227##4##13.91##99.9 
#    i. e. invalid semtag label, char 151, 0x97, 0227
# 
 
# TODO: check with others if NEE only should be output if they
#       have a minimum length
# TODO: check if stop-word list should be implemented 

# TODO: look into character set problem, for example:
# LDR-1853-05-21-Ad02317: left and right double angle brackets
#                         0xAB, 0xBB (o253, o273, d171, d187)
# 
# TODO: check "embedded" information for images
# select c_toc_meta_fullartid, o_ent_meta_embedded_after from allmetadata where o_ent_meta_embedded_after != '';
# select c_toc_meta_fullartid, o_toc_enty_embedded_after from allmetadata where o_toc_enty_embedded_after != '';
# select c_toc_meta_fullartid, o_ent_meta_embedded_into from allmetadata where o_ent_meta_embedded_into != '';
# select c_toc_meta_fullartid, o_toc_enty_embedded_into from allmetadata where o_toc_enty_embedded_into != '';
# 
# DONE: escape XML characters: &lt;, &gt;, etc.
# DONE: do _not_ output empty fields

# REMARKS and QUESTIONS:
# GB has renamed the following fields:
# entity-id -> article-id
# article-id -> fullarticle-id
# 
# GB takes "content-type" from "o_toc_enty_entity_type", which
#    gives "Article", "Ad", or "Picture" - is that OK?
# rename ad to advert
# 
# publication-core in lower case?
#     should it also be:  stored="yes" vector="no"
# 
# dirty OCR chars in names - examples:
# TEC-1884-12-06
# TEC-1884-12-06-Ad26001
# TEC-1883-12-06


# -------------------------------
# for EWJ these EA-provided information is complete
# n_ent_appd_kc_departmentgeneric
# n_ent_appd_kc_departmenttitle
# other EA-provided metadata for all publications that we might want
# to use:
# n_ent_appd_kc_bibliographic ("wrapper" or "number contents") <-----
# the one to use would be this one (on the entity level) and not
# n_toc_appd_kc_bibliographic

import sys
import string

import re
import socket
import platform
import time
import types
import os, os.path
from byutil import *
from bymysqlmap import *
# from xml.etree import ElementTree as ET
# from lxml import etree as ET
from optparse import OptionParser

# from xml.sax import make_parser
# from xml.sax.handler import ContentHandler
# import xml.parsers.expat
# from gate_nee_to_mysql_sax import *

minneelen = 2

reartid = re.compile(r"""^(?P<publ>(EWJ)|(LDR)|(MRP)|(NSS)|(TEC)|(TTW)|(FEWJ)|(FLDR)|(CLD)|(EMRP)|(FMRP)|(SMRP)|(SNSS)|(NS2)|(NS3)|(NS4)|(NS5)|(NS6)|(NS7)|(NS8)|(NS9)|(FTEC)|(TTEC)|(ATTW)|(ETTW)|(FTTW)|(SCLD)|(SLDR)|(SXLDR))-?(?P<year>18\d\d)?-?(?P<month>(0|1)\d)?-?(?P<day>(0|1|2|3)\d)?-?(?P<artid>(Ar|Ad)\d{5,8})?$""")
rebadocrwithinwordprefix = r"""(?<=[A-Za-z0-9])"""
rebadocrwithinwordsuffix = r"""(?=[A-Za-z0-9])"""

goodchars = string.ascii_letters + string.digits + "',.-& "

# tokdbpref = "ncsetoks_"
tokdbpref = "ncsetoks_0802_"

publtuple = (
              "EWJ",
              "LDR",
              "MRP",
              "NSS",
              "TEC",
              "TTW",
              "FEWJ",
              "FLDR",
              "CLD",
              "EMRP",
              "FMRP",
              "SMRP",
              "SNSS",
              "NS2",
              "NS3",
              "NS4",
              "NS5",
              "NS6",
              "NS7",
              "NS8",
              "NS9",
              "FTEC",
              "TTEC",
              "ATTW",
              "ETTW",
              "FTTW",
              "SCLD",
              "SLDR",
              "SXLDR"
             ) 

publcoredic = {
              "EWJ" : "EWJ",
              "LDR" : "LDR",
              "MRP" : "MRP",
              "NSS" : "NSS",
              "TEC" : "TEC",
              "TTW" : "TTW",
              "FEWJ" : "EWJ",
              "FLDR" : "LDR",
              "CLD" : "LDR",
              "EMRP" : "MRP",
              "FMRP" : "MRP",
              "SMRP" : "MRP",
              "SNSS" : "NSS",
              "NS2" : "NSS",
              "NS3" : "NSS",
              "NS4" : "NSS",
              "NS5" : "NSS",
              "NS6" : "NSS",
              "NS7" : "NSS",
              "NS8" : "NSS",
              "NS9" : "NSS",
              "FTEC" : "TEC",
              "TTEC" : "TEC",
              "ATTW" : "TTW",
              "ETTW" : "TTW",
              "FTTW" : "TTW",
              "SCLD" : "LDR",
              "SLDR" : "LDR",
              "SXLDR" : "LDR"
             }

dbdic = {
         "ncsemetadata" : "mdcon",
         "ncsegatenee"  : "necon",
         "semtags"      : "stcon"
         }

dbcondic = {
             "ncsemetadata" : "mdcon",
             "ncsegatenee"  : "necon",
             "semtags"      : "stcon"
            }

# allfullartidslist = []
allfullartidsdic = {}

oldlucenexmlheader = """<?xml version="1.0" encoding="UTF-8"?>
<lucene-document id="%s" xmlns="http://www.cch.kcl.ac.uk/xmlns/ereuna">
  <header>
    <tei/>
  </header>
  <fields>"""

lucenexmlheader_with_ereuna_namespace = """<?xml version="1.0" encoding="UTF-8"?>
<lucene-document id="%(fullarticle-id)s" xmlns="http://www.cch.kcl.ac.uk/xmlns/ereuna">
  <header>
    <tei>
      <bibl id="%(fullarticle-id)s" >
        <title type="full-title">%(full-title)s</title>
        <title type="periodical-title">%(periodical-title)s</title>
        <title type="short-title">%(short-title)s</title>
        <date value="YYYY-MM-DD">%(YYYY-MM-DD)s</date> 
        <biblScope type="price">%(price)s</biblScope>
        <biblScope type="volume">%(volume-series)s</biblScope>
        <biblScope type="volume-part">%(volume-part)s</biblScope>
        <biblScope type="number">%(edition-no)s</biblScope>
        <biblScope type="edition-kind">%(edition-kind)s</biblScope>
        <biblScope type="issue-number">%(number)s</biblScope>
        <biblScope type="page-span">%(page-span)s</biblScope>
        <biblScope type="page-start">%(page-start)s</biblScope>
        <biblScope type="page-internal">%(page-internal)s</biblScope>
        <extent>%(format)s</extent>
      </bibl>
     </tei>
  </header>
   <fields>"""

lucenexmlheader = """<?xml version="1.0" encoding="UTF-8"?>
<lucene-document id="%(fullarticle-id)s">
  <header>
    <tei>
      <bibl id="%(fullarticle-id)s" >
        <title type="full-title">%(full-title)s</title>
        <title type="periodical-title">%(periodical-title)s</title>
        <title type="short-title">%(short-title)s</title>
        <date value="YYYY-MM-DD">%(YYYY-MM-DD)s</date> 
        <biblScope type="price">%(price)s</biblScope>
        <biblScope type="volume">%(volume-series)s</biblScope>
        <biblScope type="volume-part">%(volume-part)s</biblScope>
        <biblScope type="number">%(edition-no)s</biblScope>
        <biblScope type="edition-kind">%(edition-kind)s</biblScope>
        <biblScope type="issue-number">%(number)s</biblScope>
        <biblScope type="page-span">%(page-span)s</biblScope>
        <biblScope type="page-start">%(page-start)s</biblScope>
        <biblScope type="page-internal">%(page-internal)s</biblScope>
        <extent>%(format)s</extent>
      </bibl>
     </tei>
  </header>
   <fields>"""

lucenexmlfooter = """  </fields>
</lucene-document>"""

locationsfieldnamelist = []
institutionsfieldnamelist = []
namesfieldnamelist = []

missingtitlebypubdic = {}
missingtitleissueslist = []

counterdic = {
              "totalinstitutions" : 0,
              "totallocations"    : 0,
              "totalnames"        : 0,
              "totalsemtags"      : 0,
              "totalimages"       : 0
}

lucenegeneralfieldlist = [
                           ["un-tokenized", "id", "yes", "no" ],
                           ["un-tokenized", "article-id", "yes", "no" ],
                           ["un-tokenized", "fullarticle-id", "yes", "no" ],
                           ["un-tokenized", "content-type", "yes", "no" ],
                           ["un-tokenized", "publication-core", "yes", "no" ],
                           ["un-tokenized", "publication-key", "yes", "no" ],
                           ["un-tokenized", "publication-thesaurus", "yes", "no" ],
                           ["un-tokenized", "publication-yyyy", "yes", "no" ],
                           ["un-tokenized", "publication-mm", "yes", "no" ],
                           ["un-tokenized", "publication-dd", "yes", "no" ],
                           ["un-tokenized", "price", "yes", "no" ],
                           ["un-tokenized", "format", "yes", "no" ],
                           ["un-tokenized", "page-span", "yes", "no" ],
                           ["un-tokenized", "page-start", "yes", "no" ],
                           ["un-tokenized", "page-int", "yes", "no" ],
                           ["un-tokenized", "edition-no", "yes", "no" ],
                           ["un-tokenized", "edition-kind", "yes", "no" ],
                           ["un-tokenized", "volume-series", "yes", "no" ],
                           ["un-tokenized", "volume-part", "yes", "no" ],
                           ["un-tokenized", "number", "yes", "no" ],
                           # ["by-date", "indexed", "yes", "no" ],
                           # ["by-pub" "indexed", "yes", "no" ]
                           ]

lucenelocationfieldlist = [
                           ["tokenized", "place", "yes", "no"]
                           ]

luceneinstitutionfieldlist = [
                           ["tokenized", "institution", "yes", "no"]
                           ]

lucenenamefieldlist = [
                           ["tokenized", "name", "yes", "no"],
                           ["tokenized", "first-name", "yes", "no"],
                           ["tokenized", "last-name", "yes", "no"],
                           ["tokenized", "title", "yes", "no"]
                           ]

#lucenesemtagfieldlist = [
#                           ["un-tokenized", "semtag-key", "yes", "no"],
#                           ["un-tokenized", "semtag-thesaurus", "yes", "no"],
#                           ["un-tokenized", "semtag-display", "yes", "no"]
#                           ]

lucenesemtagfieldlist = [
                           ["un-tokenized", "semtag-key", "yes", "no"],
                           ["un-tokenized", "semtag-thesaurus", "yes", "no"]
                           ]

#luceneimagefieldlist = [
#                           ["un-tokenized", "image-facet", "yes", "no"],
#                           ["un-tokenized", "image-cat1", "yes", "no"],
#                           ["un-tokenized", "image-cat2", "yes", "no"],
#                           ["un-tokenized", "image-cat3", "yes", "no"]
#                           ]

luceneimagefieldlist = [
                           ["un-tokenized", "image-key", "yes", "no"],
                           ["un-tokenized", "image-thesaurus", "yes", "no"]
                           ]

             # "o_toc_enty_embedded_after",
             # "o_toc_enty_embedded_into"
allmetadatafnamelist = [
             "o_toc_enty_entity_type",
             "o_toc_sect_section_name",
             "n_toc_appd_kc_price",
             "n_toc_appd_dc_format",
             "o_toc_page_page_no", # = o_toc_enty_page_no
             "o_ent_meta_page_label",
             "n_toc_appd_kc_numofedition", # ?????
             "n_toc_appd_kc_edition",
             "n_toc_appd_kc_volume",
             "n_toc_appd_kc_number",
             "c_toc_meta_publname",
             "n_toc_appd_kc_periodicaltitle",
             "o_toc_appd_ep_path",
             "o_toc_meta_pages_number",
             "n_toc_appd_kc_imgdesc",
             "n_ent_appd_kc_imgdesc",
             "o_ent_meta_embedded_after",
             "o_ent_meta_embedded_into"
             ]

fullartidsfnamelist = [
                       "n_toc_appd_kc_actualtitle",
                       "n_toc_appd_kc_volume",
                       "n_toc_appd_kc_number",
                       "n_toc_appd_kc_edition"
                       ]

contenttypedic = {
                  "Ar" : "Article",
                  "Ad" : "Advert",
                  "Pc" : "Picture",
                  "Article" : "Article",
                  "Picture" : "Picture"
                  }

semtagstagsetlist = [
                      "A1",
                      "A1.1.1",
                      "A1.1.1-",
                      "A1.1.2",
                      "A1.1.2-",
                      "A1.2",
                      "A1.2+",
                      "A1.2-",
                      "A1.3",
                      "A1.3+",
                      "A1.3-",
                      "A1.4",
                      "A1.4+",
                      "A1.4-",
                      "A1.5",
                      "A1.5.1",
                      "A1.5.1+",
                      "A1.5.1-",
                      "A1.5.2",
                      "A1.5.2+",
                      "A1.5.2-",
                      "A1.6",
                      "A1.7+",
                      "A1.7-",
                      "A1.8+",
                      "A1.8-",
                      "A1.9",
                      "A1.9-",
                      "A2",
                      "A2.1",
                      "A2.1+",
                      "A2.1-",
                      "A2.2",
                      "A2.2+",
                      "A2.2-",
                      "A3",
                      "A3+",
                      "A3-",
                      "A4",
                      "A4.1",
                      "A4.1-",
                      "A4.2",
                      "A4.2+",
                      "A4.2-",
                      "A5",
                      "A5.1",
                      "A5.1+",
                      "A5.1-",
                      "A5.2",
                      "A5.2+",
                      "A5.2-",
                      "A5.3",
                      "A5.3+",
                      "A5.3-",
                      "A5.4",
                      "A5.4+",
                      "A5.4-",
                      "A6",
                      "A6.1",
                      "A6.1+",
                      "A6.1-",
                      "A6.2",
                      "A6.2+",
                      "A6.2-",
                      "A6.3",
                      "A6.3+",
                      "A6.3-",
                      "A7",
                      "A7+",
                      "A7-",
                      "A8",
                      "A9",
                      "A9+",
                      "A9-",
                      "A10",
                      "A10+",
                      "A10-",
                      "A11",
                      "A11.1",
                      "A11.1+",
                      "A11.1-",
                      "A11.2",
                      "A11.2+",
                      "A11.2-",
                      "A12",
                      "A12+",
                      "A12-",
                      "A13",
                      "A13.1",
                      "A13.2",
                      "A13.3",
                      "A13.4",
                      "A13.5",
                      "A13.6",
                      "A13.7",
                      "A14",
                      "A15",
                      "A15+",
                      "A15-",
                      "B1",
                      "B2",
                      "B2+",
                      "B2-",
                      "B3",
                      "B3-",
                      "B4",
                      "B4+",
                      "B4-",
                      "B5",
                      "B5-",
                      "C1",
                      "E1",
                      "E1+",
                      "E1-",
                      "E2",
                      "E2+",
                      "E2-",
                      "E3",
                      "E3+",
                      "E3-",
                      "E4",
                      "E4.1",
                      "E4.1+",
                      "E4.1-",
                      "E4.2",
                      "E4.2+",
                      "E4.2-",
                      "E5",
                      "E5+",
                      "E5-",
                      "E6",
                      "E6+",
                      "E6-",
                      "F1",
                      "F1+",
                      "F1-",
                      "F2",
                      "F2+",
                      "F2-",
                      "F3",
                      "F3+",
                      "F3-",
                      "F4",
                      "F4-",
                      "G1",
                      "G1.1",
                      "G1.1-",
                      "G1.2",
                      "G1.2-",
                      "G2",
                      "G2.1",
                      "G2.1+",
                      "G2.1-",
                      "G2.2",
                      "G2.2+",
                      "G2.2-",
                      "G3",
                      "G3-",
                      "H1",
                      "H2",
                      "H3",
                      "H4",
                      "H4-",
                      "H5",
                      "H5-",
                      "I1",
                      "I1.1",
                      "I1.1+",
                      "I1.1-",
                      "I1.2",
                      "I1.2+",
                      "I1.2-",
                      "I1.3",
                      "I1.3+",
                      "I1.3-",
                      "I2",
                      "I2.1",
                      "I2.1-",
                      "I2.2",
                      "I3",
                      "I3.1",
                      "I3.1-",
                      "I3.2",
                      "I3.2+",
                      "I3.2-",
                      "I4",
                      "I4-",
                      "K1",
                      "K2",
                      "K3",
                      "K4",
                      "K5",
                      "K5.1",
                      "K5.2",
                      "K6",
                      "L1",
                      "L1+",
                      "L1-",
                      "L2",
                      "L2-",
                      "L3",
                      "L3-",
                      "M1",
                      "M2",
                      "M3",
                      "M4",
                      "M4-",
                      "M5",
                      "M6",
                      "M7",
                      "M8",
                      "N1",
                      "N2",
                      "N3",
                      "N3.1",
                      "N3.2",
                      "N3.2+",
                      "N3.2-",
                      "N3.3",
                      "N3.3+",
                      "N3.3-",
                      "N3.4",
                      "N3.4+",
                      "N3.4-",
                      "N3.5",
                      "N3.5+",
                      "N3.5-",
                      "N3.6",
                      "N3.6+",
                      "N3.7",
                      "N3.7+",
                      "N3.7-",
                      "N3.8",
                      "N3.8+",
                      "N3.8-",
                      "N4",
                      "N4-",
                      "N5",
                      "N5+",
                      "N5-",
                      "N5.1",
                      "N5.1+",
                      "N5.1-",
                      "N5.2",
                      "N5.2+",
                      "N6",
                      "N6+",
                      "N6-",
                      "O1",
                      "O1.1",
                      "O1.2",
                      "O1.2-",
                      "O1.3",
                      "O1.3-",
                      "O2",
                      "O3",
                      "O4",
                      "O4.1",
                      "O4.2",
                      "O4.2+",
                      "O4.2-",
                      "O4.3",
                      "O4.4",
                      "O4.5",
                      "O4.6",
                      "O4.6+",
                      "O4.6-",
                      "P1",
                      "P1-",
                      "Q1",
                      "Q1.1",
                      "Q1.2",
                      "Q1.2-",
                      "Q1.3",
                      "Q2",
                      "Q2.1",
                      "Q2.1+",
                      "Q2.1-",
                      "Q2.2",
                      "Q2.2-",
                      "Q3",
                      "Q3-",
                      "Q4",
                      "Q4.1",
                      "Q4.2",
                      "Q4.3",
                      "S1",
                      "S1.1",
                      "S1.1.1",
                      "S1.1.2",
                      "S1.1.2+",
                      "S1.1.2-",
                      "S1.1.3",
                      "S1.1.3+",
                      "S1.1.3-",
                      "S1.1.4",
                      "S1.1.4+",
                      "S1.1.4-",
                      "S1.2",
                      "S1.2.1",
                      "S1.2.1+",
                      "S1.2.1-",
                      "S1.2.2",
                      "S1.2.2+",
                      "S1.2.2-",
                      "S1.2.3",
                      "S1.2.3+",
                      "S1.2.3-",
                      "S1.2.4",
                      "S1.2.4+",
                      "S1.2.4-",
                      "S1.2.5",
                      "S1.2.5+",
                      "S1.2.5-",
                      "S1.2.6",
                      "S1.2.6+",
                      "S1.2.6-",
                      "S2",
                      "S2-",
                      "S2.1",
                      "S2.1-",
                      "S2.2",
                      "S3",
                      "S3.1",
                      "S3.1-",
                      "S3.2",
                      "S3.2+",
                      "S3.2-",
                      "S4",
                      "S4-",
                      "S5",
                      "S5+",
                      "S5-",
                      "S6",
                      "S6+",
                      "S6-",
                      "S7",
                      "S7.1",
                      "S7.1+",
                      "S7.1-",
                      "S7.2",
                      "S7.2+",
                      "S7.2-",
                      "S7.3",
                      "S7.3+",
                      "S7.3-",
                      "S7.4",
                      "S7.4+",
                      "S7.4-",
                      "S8",
                      "S8+",
                      "S8-",
                      "S9",
                      "S9-",
                      "T1",
                      "T1.1",
                      "T1.1.1",
                      "T1.1.2",
                      "T1.1.2-",
                      "T1.1.3",
                      "T1.2",
                      "T1.3",
                      "T1.3+",
                      "T1.3-",
                      "T2",
                      "T2+",
                      "T2-",
                      "T3",
                      "T3+",
                      "T3-",
                      "T4",
                      "T4+",
                      "T4-",
                      "W1",
                      "W2",
                      "W2-",
                      "W3",
                      "W4",
                      "W5",
                      "X1",
                      "X2",
                      "X2.1",
                      "X2.1-",
                      "X2.2",
                      "X2.2+",
                      "X2.2-",
                      "X2.3",
                      "X2.3+",
                      "X2.4",
                      "X2.4+",
                      "X2.4-",
                      "X2.5",
                      "X2.5+",
                      "X2.5-",
                      "X2.6",
                      "X2.6+",
                      "X2.6-",
                      "X3",
                      "X3.1",
                      "X3.1+",
                      "X3.1-",
                      "X3.2",
                      "X3.2+",
                      "X3.2-",
                      "X3.3",
                      "X3.4",
                      "X3.4+",
                      "X3.4-",
                      "X3.5",
                      "X3.5-",
                      "X4",
                      "X4.1",
                      "X4.1-",
                      "X4.2",
                      "X5",
                      "X5.1",
                      "X5.1+",
                      "X5.1-",
                      "X5.2",
                      "X5.2+",
                      "X5.2-",
                      "X6",
                      "X6+",
                      "X6-",
                      "X7",
                      "X7+",
                      "X7-",
                      "X8",
                      "X8+",
                      "X8-",
                      "X9",
                      "X9.1",
                      "X9.1+",
                      "X9.1-",
                      "X9.2",
                      "X9.2+",
                      "X9.2-",
                      "Y1",
                      "Y1-",
                      "Y2",
                      "Y2-",
                      "Z0",
                      "Z1",
                      "Z2",
                      "Z3",
                      "Z4",
                      "Z5",
                      "Z6",
                      "Z7",
                      "Z7-",
                      "Z8",
                      "Z9",
                      "Z99"
                    ]


def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-o', '-d', '-a' , '-t' and '-l'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)

def initFieldNames(con):
    global locationsfieldnamelist, institutionsfieldnamelist, namesfieldnamelist
    locationsfieldnamelist     = initFieldNamesFieldNameList("locations", con)
    institutionsfieldnamelist  = initFieldNamesFieldNameList("institutions", con)
    namesfieldnamelist         = initFieldNamesFieldNameList("names", con)

def setupMySQL(o, dbname):
    # for the time being we don't do any checking and just assume
    # that dbhost, etc. exist
    dbhost = o.dbhost
    # print "DB host:", dbhost
    # dbname = o.dbname
    dbport = o.dbport
    dbuser = o.dbuser
    dbpasswd = o.dbpass
    prog_host = socket.gethostname()
    # Ugly hack to make MySQLDb work on Linux and Windows
    # The LINUX version doesn't recognise the "charset" attribute
    # Look into it more closely:
    # - are the MySQLDb versions slightly different?
    # - do the different platform versions handle UNICODE differently?
    if prog_host.startswith("fir") == True:
        # by_use_unicode = True
        by_use_unicode = False
        by_charset = "latin1"
    elif prog_host.startswith("owl") == True:
        by_use_unicode = False
        # by_charset = "utf8"
        by_charset = "latin1"
    elif prog_host.startswith("box") == True:
        by_use_unicode = False
        # by_charset = "utf8"
        by_charset = "latin1"
    elif prog_host.startswith("numb") == True:
        # by_use_unicode = True
        by_use_unicode = False
        by_charset = "latin1"
    else:
        # changed: BY 08.02.12
        # by_use_unicode = True
        # by_charset = "latin1"
        by_use_unicode = False
        by_charset = "latin1"
    # print by_use_unicode
    # print by_charset
    # print dbhost
    # print dbname
    # sys.exit()
    if prog_host.startswith("owl") == True:
        # MySQL on OWL doesn't accept charset attribute
        mycon        = MySQLdb.connect(
                                       host=dbhost,
                                       port=dbport,
                                       user=dbuser,
                                       passwd=dbpasswd,
                                       db=dbname
                                       )
    else:
        # mycon        = MySQLdb.connect(
        #                                use_unicode=by_use_unicode,
        #                                charset=by_charset,
        #                                host=dbhost,
        #                                port=dbport,
        #                                user=dbuser,
        #                                passwd=dbpasswd,
        #                                db=dbname
        #                                )
        # changed: BY 08.02.12
        # TODO: work out how "use_unicode" and "charset" are really
        #       handled by the MySQLDB driver
        mycon        = MySQLdb.connect(
                                       host=dbhost,
                                       port=dbport,
                                       user=dbuser,
                                       passwd=dbpasswd,
                                       db=dbname
                                       )
    # Do _not_ create new DB structure, as we don't want to
    # delete data inserted in a previous run
    # createStrucMySQL(mycon, varsdic)
    # initFieldNames(mycon)
    return mycon

def writeTotals(r, cdic):
    PrintCF(r, 1, "")
    PrintCF(r, 1, "%50s: %12i" % ("Total no. of 'institutions' written", cdic["totalinstitutions"]))
    PrintCF(r, 1, "%50s: %12i" % ("Total no. of 'locations' written", cdic["totallocations"]))
    PrintCF(r, 1, "%50s: %12i" % ("Total no. of 'names' written", cdic["totalnames"]))
    PrintCF(r, 1, "%50s: %12i" % ("Total no. of 'semtags' written", cdic["totalsemtags"]))
    PrintCF(r, 1, "%50s: %12i" % ("Total no. of 'image descriptions' written", cdic["totalimages"]))
    PrintCF(r, 1, "")

def writeMissingTitleStats(r):
    missingtitleissueslist.sort()
    missingtitlebypublist = missingtitlebypubdic.keys()
    missingtitlebypublist.sort()
    PrintCF(r, 1, "")
    PrintCF(r, 1, "-" * 60)
    PrintCF(r, 1, "Metadata entries for 'actual periodical title' and 'periodical title' missing")
    PrintCF(r, 1, "-" * 60)
    PrintCF(r, 1, "")
    PrintCF(r, 1, "Publ      No. of missing issues per publication")
    PrintCF(r, 1, "-----------------------------------------------")
    for p in missingtitlebypublist:
        s = "%-4s      %10i" % (p, missingtitlebypubdic[p])
        PrintCF(r, 1, s)
    PrintCF(r, 1, "")
    PrintCF(r, 1, "List of issues without titles:")
    PrintCF(r, 1, "-----------------------------------------------")
    for i in missingtitleissueslist:
        PrintCF(r, 1, i)

def writeInvalidSemtags(r):
    if len(invalidsemtagslist) > 0:
        PrintCF(r, 1, "")
        PrintCF(r, 1, "List of omitted invalid semtags:")
        PrintCF(r, 1, "--------------------------------")
        for ist in invalidsemtagslist:
            PrintCF(r, 1, ist)
        PrintCF(r, 1, "")
    
def getSemtagsTagset():
    return sttl


def writeToMySqlTable(tname, fnlist, fvlist, con):
    # print tname, fnlist, fvlist
    insobj = SqlInsert(con=dbcon, 
                       table=tname, 
                       fieldnames=fnlist, 
                       fieldvalues=fvlist)
    # print insobj.getInsertString()
    tid = insobj.getLastRowId()
    del insobj

def escapeInvalidXmlChars(t):
    t = t.replace("&", "&amp;")
    # t = t.replace(chr(163), "&pound;")
    # t = t.replace(chr(233), "&eacute;")
    t = t.replace("<", "&lt;")
    t = t.replace(">", "&gt;")
    # t = t.replace("[", "&lsqb;")
    # t = t.replace("]", "&rsqb;")
    # t = t.replace("`", "&bquo;")
    # t = t.replace("'", "&equo;")
    t = t.replace('"', "&quot;")
    t = t.replace("'", "&apos;")
    return t

def getAllFullartids(ap, con, tcon, whconstr):
    # sql = "SELECT id, fullartid FROM fullartids WHERE fullartid LIKE '%s%%'" % (ap, )
    sql = "SELECT id, fullartid FROM fullartids WHERE fullartid LIKE '%s%%'" % (ap, )

    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    for (id, faid) in rl:
        # print id, faid
        # 
        # CHECK FOR CONSTRAINTS: charcount or linecount
        tsql = "SELECT id FROM fullartids WHERE fullartid LIKE '%s%%'" % (faid, )
        tsql += whconstr
        selobj = SqlResultList(con=tcon, sql=tsql)
        trl = selobj.getRowTuple()
        trc = selobj.getRowCount()
        # print "ROWCOUNT:", trc
        del selobj
        if trc != 0:
            allfullartidsdic[faid] = id

def getFromFullartidsTable(faid, con):
    tablelist = ["fullartids", ]
    where = "fullartid = '%s'" % (faid, )
    selobj = SqlSelectList(con=con,
                           fields=fullartidsfnamelist,
                           tables=tablelist,
                           where=where)
    rl = selobj.getRowTuple()
    # rc = selobj.getRowCount()
    del selobj
    rdic = dict(zip(fullartidsfnamelist, rl[0]))
    return rl[0], rdic

def getFromAllmetadataTable(faid, con):
    tablelist = ["allmetadata", ]
    where = "c_toc_meta_fullartid = '%s'" % (faid, )
    selobj = SqlSelectList(con=con,
                           fields=allmetadatafnamelist,
                           tables=tablelist,
                           where=where)
    rl = selobj.getRowList()
    del selobj
    rdic = dict(zip(allmetadatafnamelist, rl[0]))
    return rl[0], rdic

def getGeneralArticleFields(faid, con):
    (publ, year, month, day, artid) = faid.split("-")
    frl, frdic = getFromFullartidsTable(faid, con)
    arl, ardic = getFromAllmetadataTable(faid, con)
    faiddic = {}
    faiddic["article-id"] = artid
    faiddic["fullarticle-id"] = faid
    faiddic["content-type"] = contenttypedic[ardic["o_toc_enty_entity_type"]] # toccontenttype
    faiddic["id"]  = faid
    faiddic["publication-core"]  = publcoredic[publ].lower()
    faiddic["publication-key"]  = publ.lower()
    # publication-key(lower-case)- the same key used in publication-key directly
    #   above##Full Name (c_toc_meta_publname)## Periodical Title (n_toc_appd_kc_periodicaltitle) ##
    #   Short title (n_toc_appd_kc_actualtitle)
    faiddic["publication-thesaurus"]  = "%s#%s#%s" % (publ.lower(), frdic["n_toc_appd_kc_actualtitle"], publ.lower())
    faiddic["publication-yyyy"]  = year
    faiddic["publication-mm"] = month
    faiddic["publication-dd"]   = day
    faiddic["by-date"]   = year + month + day
    faiddic["by-pub"]   = frdic["n_toc_appd_kc_actualtitle"] # tocactualtitle
    faiddic["sectionname"] = ardic["o_toc_sect_section_name"] # sectionname 
    faiddic["price"] = ardic["n_toc_appd_kc_price"] # price
    faiddic["format"] = ardic["n_toc_appd_dc_format"] # format
    faiddic["page-internal"] = ardic["o_toc_page_page_no"]
    faiddic["page-int"] = ardic["o_toc_page_page_no"]
    faiddic["page-span"] = ardic["o_toc_meta_pages_number"]
    faiddic["page-start"] = ardic["o_ent_meta_page_label"] # page_start 
    faiddic["edition-no"] = ardic["n_toc_appd_kc_numofedition"] # edition_no
    faiddic["edition-kind"] = ardic["n_toc_appd_kc_edition"] # edition_kind 
    faiddic["volume-series"] = ardic["n_toc_appd_kc_volume"] # volume_series 
    faiddic["number"] = ardic["n_toc_appd_kc_number"] # number
    # faiddic["full-title"] = ardic["c_toc_meta_publname"]
    # ugly hack to replace the wrongly converted "curly" apostrophe
    #    to a normal apostrophe, and to replace mis-spelled Olive titles
    faiddic["full-title"] = ardic["c_toc_meta_publname"].replace(chr(146), "'")
    faiddic["full-title"] = faiddic["full-title"].replace("English Womens", "English Woman's")
    faiddic["full-title"] = faiddic["full-title"].replace("Publishers Circular", "Publishers' Circular")
    # faiddic["full-title"] = ardic["n_toc_appd_kc_periodicaltitle"]
    faiddic["periodical-title"] = ardic["n_toc_appd_kc_periodicaltitle"]
    faiddic["short-title"] = frdic["n_toc_appd_kc_actualtitle"]
    faiddic["ep-path"] = ardic["o_toc_appd_ep_path"]
    volume_part_pos = faiddic["ep-path"].rfind("|") + 1
    faiddic["volume-part"] = faiddic["ep-path"][volume_part_pos:]
    # TL suggests to take it from
    # o_toc_meta_base_href or o_ent_meta_base_href
    # GB decided to generate it from year, month, day
    faiddic["YYYY-MM-DD"] = "%s-%s-%s" % (year, month, day)
    faiddic["imgdesc_ent"] = ardic["n_ent_appd_kc_imgdesc"]
    faiddic["imgdesc_toc"] = ardic["n_toc_appd_kc_imgdesc"]
    # we only need "o_ent_meta_embedded_after" and "o_ent_meta_embedded_into"
    #   as their contents is identical to
    #              "o_toc_enty_embedded_after" and "o_toc_enty_embedded_into"
    #   respectively (see output of ncseimg_stat.py)
    faiddic["embedded_after_ent"] = ardic["o_ent_meta_embedded_after"]
    # faiddic["embedded_after_toc"] = ardic["o_toc_enty_embedded_after"]
    faiddic["embedded_into_ent"] = ardic["o_ent_meta_embedded_into"]
    # faiddic["embedded_into_toc"] = ardic["o_toc_enty_embedded_into"]
    for k in faiddic.keys():
        faiddic[k] = escapeInvalidXmlChars(faiddic[k])
    # print fullartidsfieldnamelist
    # print faiddic
    # lastinsertid = writeRecord("fullartids", fullartidsfieldnamelist, faiddic, con)
    # fullartididsdic[faid] = lastinsertid
    return faiddic

def filterBadOcr(text, fbadocr):
    newtext = ""
    # newtext = text
    # for t in newtext:
    #     if t not in goodchars:
    #         rebadocrwithinword = rebadocrwithinwordprefix + t + rebadocrwithinwordsuffix
    #         print rebadocrwithinword
    #         print re.findall(rebadocrwithinword, newtext)
    #         newtext = re.sub(rebadocrwithinword, fbadocr, newtext)

    text = re.sub(chr(197) + ".", chr(197), text)
    text = re.sub(chr(194) + ".", chr(194), text)
    # textlist = list(text)
    tlen = len(text)
    # print text, tlen
    for pos in range(0, tlen):
        # print text[pos], ord(text[pos])
        if text[pos] in goodchars:
            newtext += text[pos]
        elif (pos - 1 >= 0) and (pos + 1 < tlen):
            if (text[pos-1] != " ") or (text[pos+1] != " "):
                newtext += fbadocr
            elif (pos == 0) and (text[pos+1] != " "):
                newtext += fbadocr
            elif (pos == tlen) and (text[pos-1] != " "):
                newtext += fbadocr
        else:
            newtext += fbadocr
            # print text[pos-1:pos+2]
            # print text[pos-1], text[pos], text[pos+1]

    # strip underscore from beginning of string if not followed
    #    by alphanumeric chars
    newtext = re.sub(r"^(" + fbadocr + r"+)([^A-Za-z0-9'])", r"\2", newtext)
    # strip underscore from end of string if not preceded
    #    by alphanumeric chars
    newtext = re.sub(r"([^A-Za-z0-9'])(" + fbadocr + r"+)$", r"\1", newtext)
    # strip underscore from within string if not surrounded
    #    by alphanumeric chars
    newtext = re.sub(r"([^A-Za-z0-9'])(" + fbadocr + r"+)([^A-Za-z0-9'])", r"\1\3", newtext)
    if newtext == fbadocr:
        newtext = ""
    # newtext = newtext.strip(" ")
    newtext = newtext.lstrip(" .,-")
    newtext = newtext.rstrip(" ,-")

    # while ((len(newtext) > 0) and (newtext[0] in " .,")):
    #     newtext = newtext[1:]

    newtext = re.sub(r" +", " ", newtext)

    # if text != newtext:
    #     print "-" * 30
    #     print text
    #     print newtext
    # return text
    return newtext

def getLocations(faid, con):
    sql = "SELECT olocation FROM locations WHERE fullartid = '%s'" % (faid, )
    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    reslist = [r[0] for r in rl]
    # reslist = [r[0].decode("latin1") for r in rl]
    # print reslist
    return reslist

def getInstitutions(faid, con):
    sql = "SELECT oinstitution FROM institutions WHERE fullartid = '%s'" % (faid, )
    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    reslist = [r[0] for r in rl]
    # reslist = [r[0].decode("latin1") for r in rl]
    # print reslist
    return reslist

def getNames(faid, con):
    sql = "SELECT ofullname, olastname, ofirstname, otitle FROM names WHERE fullartid = '%s'" % (faid, )
    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    # reslist = [r[0] for r in rl]
    # print rl
    # print reslist
    # return reslist
    return rl

def getSemtags(faid, con):
    sql = "SELECT semtag, semtaglong, llh, rank FROM semtags WHERE fullartid = '%s' order by rank" % (faid, )
    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    # reslist = [r[0] for r in rl]
    # print rl
    # print reslist
    # return reslist
    return rl

def getPublicationInformation(faid, lpfieldslist, con):
    faiddic = getGeneralArticleFields(faid, con)
    sortfieldslist = []
    sortfieldslist.append(["by-date", faiddic["by-date"]])
    sortfieldslist.append(["by-pub", faiddic["by-pub"]])
    for lg in lucenegeneralfieldlist:
        tmplist = [t for t in lg]
        tmplist.append(faiddic[lg[1]])
        lpfieldslist.append(tmplist)
    # print sortfieldslist
    return lpfieldslist, sortfieldslist, faiddic

def getPersonNameEntities(faid, lofieldslist, con, fdoit, fbadocr):
    perslist = getNames(faid, con)
    for (fullname, lastname, firstname, title) in perslist:
        if len(fullname) >= minneelen:
            # fullname
            # counterdic["totalnames"] += 1
            tmplist = ["tokenized", "name", "yes", "no"]
            if fdoit == True:
                fullname = filterBadOcr(fullname, fbadocr)
            # we have to check again for the minimum length of
            # the entry, as it might have changed after
            # filtering OCR
            if len(fullname) >= minneelen:
                counterdic["totalnames"] += 1
                # fullname = escapeInvalidXmlChars(fullname)
                fullname = fullname.decode("latin1")
                fullname = escapeInvalidXmlChars(fullname.encode("utf8"))
                tmplist.append(fullname)
                lofieldslist.append(tmplist)
                if firstname != '':
                    # firstname
                    tmplist = ["tokenized", "first-name", "yes", "no"]
                    if fdoit == True:
                        firstname = filterBadOcr(firstname, fbadocr)
                    # we have to check again if the entry is not empty
                    # as it might have changed after filtering OCR
                    if firstname != '':
                        # firstname = escapeInvalidXmlChars(firstname)
                        firstname = firstname.decode("latin1")
                        firstname = escapeInvalidXmlChars(firstname.encode("utf8"))
                        tmplist.append(firstname)
                        lofieldslist.append(tmplist)
                if lastname != '':
                    # lastname
                    tmplist = ["tokenized", "last-name", "yes", "no"]
                    if fdoit == True:
                        lastname = filterBadOcr(lastname, fbadocr)
                    # we have to check again if the entry is not empty
                    # as it might have changed after filtering OCR
                    if lastname != '':
                        # lastname = escapeInvalidXmlChars(lastname)
                        lastname = lastname.decode("latin1")
                        lastname = escapeInvalidXmlChars(lastname.encode("utf8"))
                        tmplist.append(lastname)
                        lofieldslist.append(tmplist)
                if title != '':
                    # title
                    tmplist = ["tokenized", "title", "yes", "no"]
                    if fdoit == True:
                        title = filterBadOcr(title, fbadocr)
                    # we have to check again if the entry is not empty
                    # as it might have changed after filtering OCR
                    if title != '':
                        # title = escapeInvalidXmlChars(title)
                        title = title.decode("latin1")
                        title = escapeInvalidXmlChars(title.encode("utf8"))
                        tmplist.append(title)
                        lofieldslist.append(tmplist)
    return lofieldslist

# semtag-key:       the class number for the tag, excluding Z class
# semtag-thesaurus: composed field with:
#                   semtag-key##semtag-label##rank##llh##significance level (excluding Z class)
# semtag-display:   semtag label
def getSemtagEntities(faid, lofieldslist, con):
    semtagslist = getSemtags(faid, con)
    # print semtagslist
    rankcorrection = 0
    # print "-" * 30
    for (semtag, semtaglong, llh, rank) in semtagslist:
        # Ugly hack to fix wrong UNICODE apostrophe
        # print "-" * 30
        # print semtaglong
        semtaglong = semtaglong.replace(chr(146), "'")
        # print semtaglong
        # for s in semtaglong:
        #     print s, ord(s), chr(146)
        if semtag.startswith("Z"):
            rankcorrection += 1
            continue
        elif semtag.find(chr(151)) != -1:
            rankcorrection += 1
            continue
        else:
            # counterdic["totalsemtags"] += 1
            rank -= rankcorrection
            if llh >= 15.13:
                degofconf = "ninenineninenine"
                percentile = "99.99"
            elif llh >= 10.83:
                degofconf = "nineninenine"
                percentile = "99.9"
            elif llh >= 6.63:
                degofconf = "ninenine"
                percentile = "99"
            elif llh >= 3.84:
                degofconf = "ninefive"
                percentile = "95"
            else:
                degofconf = "underninefive"
                percentile = "&lt;95"
                # cap output of semtags at 95%
                continue
            semtagcan = semtag
            while (not (semtagcan in semtagstagsetlist)) and (len(semtagcan) > 1):
                semtagcan = semtagcan[:-1]
            if semtagcan not in semtagstagsetlist:
                rank -= rankcorrection
                logmsg = "%s (%s)" % (faid, semtag)
                invalidsemtagslist.append(logmsg)
            else:
                counterdic["totalsemtags"] += 1
                # print semtag, semtagcan
                semtag_thesaurus = "%s##%s##%s##%s##%s##%s" % (semtagcan, semtaglong, semtag, rank, llh, percentile)
                semtag = escapeInvalidXmlChars(semtag)
                semtagcan = escapeInvalidXmlChars(semtagcan)
                # semtaglong = escapeInvalidXmlChars(semtaglong)
                # semtag = semtag.decode("latin1")
                # semtaglong = semtaglong.decode("latin1")
                # semtag = escapeInvalidXmlChars(semtag.encode("utf8"))
                semtag_thesaurus = escapeInvalidXmlChars(semtag_thesaurus)
                # semtag_thesaurus = escapeInvalidXmlChars(semtag_thesaurus.encode("utf8"))
                tmplist = [t for t in lucenesemtagfieldlist[0]]
                tmplist.append(semtagcan)
                lofieldslist.append(tmplist)
                tmplist = [t for t in lucenesemtagfieldlist[1]]
                tmplist.append(semtag_thesaurus)
                lofieldslist.append(tmplist)
                # tmplist = [t for t in lucenesemtagfieldlist[2]]
                # tmplist.append(semtaglong)
                # lofieldslist.append(tmplist)
    return lofieldslist

# image-facet: 1. code from Ai_Item element
# image-cat1:  2. code from Ai_Item element
# image-cat2:  3. code from Ai_Item element
# image-cat3:  4. code from Ai_Item element
#  n_ent_appd_kc_imgdesc is the metadata field to use
#  n_toc_appd_kc_imgdesc is empty
def getImageEntities(faid, faiddic, lofieldslist, con):
    if faiddic["imgdesc_ent"] != '':
        # print "ENT", faiddic["imgdesc_ent"]
        multiimgdesclist = faiddic["imgdesc_ent"].split("::")
        for fullsinglehier in multiimgdesclist:
            counterdic["totalimages"] += 1
            hieritemlist = fullsinglehier.split("/")
            for (hcount, hieritem) in enumerate(hieritemlist):
                # tmplist = [t for t in luceneimagefieldlist[hcount]]
                # hieritem = escapeInvalidXmlChars(hieritem)
                hieritem = escapeInvalidXmlChars(hieritem.encode("utf8"))
                idpos = hieritem.find(" id:")
                hierdesc = hieritem[:idpos]
                hierdesc = hierdesc.strip()
                hiercode = hieritem[idpos+1:]
                hiercode = hiercode.strip()
                hierdesc = hierdesc.replace("--", "/")
                image_thesaurus = hiercode + "##" + hierdesc
                tmplist = [t for t in luceneimagefieldlist[0]]
                tmplist.append(hiercode)
                # print tmplist
                lofieldslist.append(tmplist)
                tmplist = [t for t in luceneimagefieldlist[1]]
                tmplist.append(image_thesaurus)
                # print tmplist
                lofieldslist.append(tmplist)
                # print "FFFFFFFFFFFFF", faid
                # print "%i :: HIERDESC:>>%s<< -- HIERCODE:>>%s<<" % (hcount, hierdesc, hiercode)
    return lofieldslist

def getInstitutionEntities(faid, lofieldslist, con, fdoit, fbadocr):
    instlist = getInstitutions(faid, con)
    for i in instlist:
        if len(i) >= minneelen:
            # counterdic["totalinstitutions"] += 1
            tmplist = ["tokenized", "institution", "yes", "no"]
            if fdoit == True:
                i = filterBadOcr(i, fbadocr)
            # we have to check again for the minimum length of
            # the entry, as it might have changed after
            # filtering OCR
            if len(i) >= minneelen:
                counterdic["totalinstitutions"] += 1
                # i = escapeInvalidXmlChars(i)
                i = i.decode("latin1")
                i = escapeInvalidXmlChars(i.encode("utf8"))
                tmplist.append(i)
                lofieldslist.append(tmplist)
                # print >> outfileobj, '    <field indexed="tokenized" name="institution" stored="yes" vector="no">%s</field>' % (i, )
    return lofieldslist
    
def getLocationEntities(faid, lofieldslist, con, fdoit, fbadocr):
    loclist = getLocations(faid, con)
    for i in loclist:
        if len(i) >= minneelen:
            # counterdic["totallocations"] += 1
            tmplist = ["tokenized", "place", "yes", "no"]
            if fdoit == True:
                i = filterBadOcr(i, fbadocr)
            # we have to check again for the minimum length of
            # the entry, as it might have changed after
            # filtering OCR
            if len(i) >= minneelen:
                counterdic["totallocations"] += 1
                # i = escapeInvalidXmlChars(i)
                i = i.decode("latin1")
                i = escapeInvalidXmlChars(i.encode("utf8"))
                tmplist.append(i)
                lofieldslist.append(tmplist)
                # print >> outfileobj, '    <field indexed="tokenized" name="place" stored="yes" vector="no">%s</field>' % (l, )
    return lofieldslist

# def formatArticleAsLucene(rl, faid, fdoit, fbadocr):
def formatArticleAsLucene(rl, faid, fbadocr):
    # "XMLFAID", "XMLFTOKENID", "XMLSTOKENID"
#    lucheader = """<?xml version="1.0" encoding="UTF-8"?>
#<lucene-document xmlns="http://www.cch.kcl.ac.uk/xmlns/ereuna" id="%s">
#  <header>
#     <tei/>
#  </header>
#  <fields>
#     <field indexed="un-tokenized" name="id" stored="yes" vector="no">%s</field>
#     <field indexed="tokenized" name="text" stored="yes" vector="no">
#"""
    lucheader = '    <field indexed="tokenized" name="text" stored="yes" vector="no">\n'
#    lucfooter = """</field>
#  </fields>
#</lucene-document>
#"""
    lucfooter = '    </field>'
    # arttext = lucheader % (faid, faid)
    arttext = lucheader
    # arttext += "<DOC>\n"
    # arttext += "<ARTID>%s</ARTID>\n" % (faid, )
    # arttext += "<TEXT>\n"
    # arttext += "<artid>%s</artid>\n" % (faid, )
        
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (ftokenid, token, spaceaftertoken, artlineno, specialtype) = r
        # print "-" * 30
        # print type(token), token
        # token = token.decode("cp1252")
        # print type(token)
        token = filterBadOcr(token, fbadocr)
        token = escapeInvalidXmlChars(token)
        # token = token.encode("cp1252")
        # print type(token), token
        if artlineno == prevartlineno:
            arttext += token + spaceaftertoken
        else:
            if prevartlineno == 0:
                arttext += token + spaceaftertoken
            else:
                arttext += "\n" + token + spaceaftertoken
        prevartlineno = artlineno
    arttext += "\n"
    # arttext += "</TEXT>\n"
    # arttext += "</DOC>"
    arttext += lucfooter
    return arttext

def getArticle(con, faid, fbadocr):
    # arttext = ""
    fnamelist = ("tokenid", "token", "spaceaftertoken", "artlineno", "specialtype")
    tablelist = ("tokens", )
    # where     = "fullartidid = %d" % (faidid, )
    where     = "tokenid LIKE '%s%%'" % (faid, )
    orderlist = ("arttokenno", )
    selobj = SqlSelectList(con=con,
                           fields=fnamelist,
                           tables=tablelist,
                           where=where,
                           order=orderlist)
    # print selobj.getSqlString()
    rl = selobj.getRowList()
    # print tokenlist
    # print "RC:", selobj.getRowCount()
    del selobj
#    artlineno = 0
#    prevartlineno = 0
#    for r in rl:
#        (tokenid, token, spaceaftertoken, artlineno, specialtype) = r
#
#        if artlineno == prevartlineno:
#            arttext += token + spaceaftertoken
#        else:
#            if prevartlineno == 0:
#                arttext += token + spaceaftertoken
#            else:
#                arttext += "\n" + token + spaceaftertoken
#        prevartlineno = artlineno
    arttext = formatArticleAsLucene(rl, faid, fbadocr)
        
    # fullartid = tokenid[:tokenid.rindex("-")]
    # print tokenid, token
    # print fullartid

    return arttext
    
def getArticleText(faid, tokcon, fbadocr):
    articletext = getArticle(tokcon, fullartid, fbadocr)
    return articletext

def writeLuceneXmlFile(faid, mcon, ncon, scon, tokcon, lucoutpath, lucfcounter, fdoit, fbadocr):
    lucpublfieldslist = []
    lucotherfieldslist = []
    lucpublfieldslist, sortlist, faiddic = getPublicationInformation(faid, lucpublfieldslist, mcon)

    # if there is no periodical title or actual title in the metadata
    # i. e. the following fields not filled in:
    # n_toc_appd_kc_periodicaltitle
    # n_toc_appd_kc_actualtitle
    # do not output a lucene file and collect missing issue ref
    # in global variables
    # missingtitlebypubdic
    # missingtitleissueslist
    if (faiddic["periodical-title"] == "") or (faiddic["short-title"] == ""):
        publ = faiddic["publication-key"].upper()
        issueid = "%s-%s-%s-%s" % (publ, faiddic["publication-yyyy"], faiddic["publication-mm"], faiddic["publication-dd"])
        # faiddic["publication-key"]
        # faiddic["publication-yyyy"]
        # faiddic["publication-mm"]
        # faiddic["publication-dd"]
        # print "XXXXXXXXXXXXXXXXXXXXXXXXX", issueid
        if issueid not in missingtitleissueslist:
            missingtitleissueslist.append(issueid)
            if missingtitlebypubdic.has_key(publ):
                missingtitlebypubdic[publ] += 1
            else:
                missingtitlebypubdic[publ] = 1
        return
    
    lucotherfieldslist = getInstitutionEntities(faid, lucotherfieldslist, ncon, fdoit, fbadocr)
    lucotherfieldslist = getLocationEntities(faid, lucotherfieldslist, ncon, fdoit, fbadocr)
    lucotherfieldslist = getPersonNameEntities(faid, lucotherfieldslist, ncon, fdoit, fbadocr)
    lucotherfieldslist = getSemtagEntities(faid, lucotherfieldslist, scon)
    lucotherfieldslist = getImageEntities(faid, faiddic, lucotherfieldslist, scon)
    luctext = getArticleText(faid, tokcon, fbadocr)
    # only get publication info and output a file if any of the other
    # fields is not empty
    if lucotherfieldslist != []:
        lucfcounter += 1
        # lucpublfieldslist = []
        # lucpublfieldslist, sortlist, faiddic = getPublicationInformation(faid, lucpublfieldslist, mcon)
        outfile = faid + ".xml"
        outfilepath = os.path.join(lucoutpath, outfile)
        outfileobj = file(outfilepath, "w")
        # print faiddic
        print >> outfileobj, lucenexmlheader % faiddic
        for l in sortlist:
            # write sort fields
            l = tuple(l)
            print >> outfileobj, '    <sort name="%s">%s</sort>' % l
        for l in lucpublfieldslist:
            # write publication information
            l = tuple(l)
            print >> outfileobj, '    <field indexed="%s" name="%s" stored="%s" vector="%s">%s</field>' % l
        for l in lucotherfieldslist:
            # write all other fields
            l = tuple(l)
            print >> outfileobj, '    <field indexed="%s" name="%s" stored="%s" vector="%s">%s</field>' % l
        print >> outfileobj, luctext
        print >> outfileobj, lucenexmlfooter
        outfileobj.close()

    # prepare log messages
    entrycounter = lucfcounter
    outlogmsg = lucoutpath
    if outlogmsg not in logmsgdic:
        logmsgdic[outlogmsg] = entrycounter
    else:
        logmsgdic[outlogmsg] += entrycounter
    

if __name__ == '__main__':
    parser = OptionParser()
    # parser.add_option("-d", "--dbname", dest="dbname",
    #                   help="DB name - no default", metavar="DB")
    parser.add_option("-s", "--dbserver", dest="dbhost", default="localhost",
                      help="DB host - default: localhost", metavar="HOST")
    parser.add_option("-P", "--port", dest="dbport", default=51524, type="int",
                      help="DB port - default: 51524", metavar="PORT")
    parser.add_option("-u", "--user", dest="dbuser", default="ncse",
                      help="DB user - default: ncse", metavar="USER")
    parser.add_option("-p", "--password", dest="dbpass", default="J0urnal",
                      help="DB password - default: XXX", metavar="PW")
    parser.add_option("-o", "--outdir", dest="luceneoutpath",
                      help="write output to directory DIR - no default", metavar="DIR")
    parser.add_option("-l", "--logdir", dest="logdir",
                      help="write log file to directory DIR - no default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be extracted ('LDR', 'LDR-1859', or 'LDR-1859-09-24-Ar02417') - no default", metavar="PATH")
    parser.add_option("-c", "--minchars", dest="minchars", default=0, type="int",
                      help="only extract articles with a minimum length of CHARS characters - default: %default", metavar="CHARS")
    parser.add_option("-m", "--minlines", dest="minlines", default=0, type="int",
                      help="only extract articles with a minimum number of LINES lines - default: %default", metavar="LINES")
    parser.add_option("-r", "--filter-bad-ocr", dest="filterbadocr", type="string",
                      help="do not output 'unprintable' characters, if they are part of a word, replace with character given as argument - default: %default", metavar="FILTERCHAR")
    # parser.add_option("-t", "--type", dest="neetype",
    #                   type="choice", choices=["locations", "institutions", "names", "all"],
    #                   help="type of NEE information to be processed (locations, institutions, names, all) - default: %default", metavar="HIER")
    (options, args) = parser.parse_args()
    # if ((options.semtaginpath == None) or (options.semtagoutpath == None) or (options.articlepath == None)):
    #     printUsage()
    if ((options.luceneoutpath == None) or (options.articlepath == None) or (options.logdir == None)):
        printUsage()
    if ((options.minchars > 0) and (options.minlines > 0)):
        print
        print "Options '-c (--minchars)'  and '-m (--minlines)' are mutually exclusive."
        print "        Use only one of these options."
        print
        sys.exit(2)
    # dbcon = setupMySQL(options)
    for dk in dbcondic:
        dbcondic[dk] = setupMySQL(options, dk)
        # print dbcondic[dk]
    # print locationsfieldnamelist
    # print institutionsfieldnamelist
    # print namesfieldnamelist
    # sys.exit()

    # neetype = options.neetype
    luceneoutpath = options.luceneoutpath
    logpath = options.logdir
    if not os.path.exists(luceneoutpath):
        print
        print "Lucene output path '%s' does not exist!" % (luceneoutpath, )
        print
        sys.exit(2)
    elif not os.path.isdir(luceneoutpath):
        print
        print "Lucene output path '%s' exists, but is not a directory!" % (luceneoutpath, )
        print
        sys.exit(2)
    if not os.path.exists(logpath):
        print
        print "Repository log path '%s' does not exist!" % (logpath, )
        print
        sys.exit(2)
    elif not os.path.isdir(logpath):
        print
        print "Repository log path '%s' exists, but is not a directory!" % (logpath, )
        print
        sys.exit(2)
    # neeshorttype =neetype.lower()[0] 
    # if neeshorttype not in ("l", "i", "n", "a"):
    #     print
    #     print "Wrong NEE output type '%s'. Should be one of '(l)ocations', '(i)nstitutions', '(n)ames', '(a)ll'." % (neetype, )
    #     print
    #     sys.exit(2)
    articlepath = options.articlepath
    r = re.search(reartid, articlepath)
    try:
        artiddic = r.groupdict()
        # prepLogs(corpusoutpath, artiddic["publ"])
    except AttributeError:
        print
        print 'Error in format of article id: "%s"' % (articlepath, )
        print
        sys.exit(2)

    if '-' in articlepath:
        # hiercount = articlepath.count('-') + 1
        publ = articlepath.split('-')[0]
        wholepubl = False
    else:
        publ = articlepath
        wholepubl = True
    tokdbpubl = publ.lower()
    tokdbname = tokdbpref + tokdbpubl
    # dbcon = setupMySQL(options)
    tokdbcon = setupMySQL(options, tokdbname)
        
    minchars = options.minchars
    minlines = options.minlines
    filterbadocr = options.filterbadocr
    # if (filterbadocr == "") and (filterbadocr != None):
    #     print
    #     print 'Option "filter-bad-ocr", but no replacement character provided.'
    #     print
    #     sys.exit(2)
    if filterbadocr == None:
        filterdoit = False
    else:
        filterdoit = True
        
    repf = getRepfileObject(logpath, articlepath, "ncseall-to-lucene")

    logmsgdic = {}
    invalidsemtagslist = []
    errorlogdic = {}

    # write command line to report file before anything else happens
    # so we have the commandline as reference in case a crash happens
    writeReportCommandLine(repf)
    
    if minchars > 0:
        whereconstraint = " AND charcount > %d" % (minchars, )
        outminimum = "Articles extracted have a minimum length of %d characters." % (minchars, )
    elif minlines > 0:
        whereconstraint = " AND linecount > %d" % (minlines, )
        outminimum = "Articles extracted have a minimum length of %d lines." % (minlines, )
    else:
        whereconstraint = ""
        outminimum = "Articles extracted with no minimum length restriction."

    articlefilepath = articlepath.replace("-", "/")
    # allfullartidsdic = getAllFullartids(articlepath, dbcondic["ncsemetadata"])
    # print "DB name:", tokdbname
    getAllFullartids(articlepath, dbcondic["ncsemetadata"], tokdbcon, whereconstraint)
    lucfilecounter = 0
    for fullartid in allfullartidsdic:
        print fullartid
        writeLuceneXmlFile(fullartid, dbcondic["ncsemetadata"], dbcondic["ncsegatenee"], dbcondic["semtags"], tokdbcon, luceneoutpath, lucfilecounter, filterdoit, filterbadocr)


    writeReport(repf, logmsgdic, articlepath, "no. of records")
    PrintCF(repf, 1, outminimum)
    PrintCF(repf, 1, '')
    writeTotals(repf, counterdic)
    writeMissingTitleStats(repf)
    writeInvalidSemtags(repf)

    print "--== FINISHED ==--"
