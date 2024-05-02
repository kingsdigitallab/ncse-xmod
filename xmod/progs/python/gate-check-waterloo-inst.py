#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Compare and evaluate the output of GATE using different gazetteer lists 
 
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
from gate_nee_to_mysql_sax import *

gategazetteerpath = "/Applications/textmining/gate/plugins/ANNIE/resources/gazetteer"
# gategazetteerpath = "/opt/textmining/gate/plugins/ANNIE/resources/gazetteer"

# yew
# gateoutlogdir = "/gate_nee_out_logs"
# box
gateoutlogdir = "/projects/cch/ncse/gate_nee_out_logs"

locationsfieldnamelist = []
institutionsfieldnamelist = []
namesfieldnamelist = []

wlinstlist = [
              "waterloo_pubtitle_low.lst",
              "waterloo_issuingbody_low.lst",
              "waterloo_title_low.lst"
              ]

#wlinstlist = [
#              "waterloo_pubtitle_low.lst",
#              ]
#
#wlinstlist = [
#              "waterloo_issuingbody_low.lst"
#              ]

dborder = [
           "def",
           "tow",
           "all"
           ]

dbnamdic = {
          "def" : "ncsegatenee_default_test",
          "tow" : "ncsegatenee_cityuk_wltown",
          "all" : "ncsegatenee_cityuk_wlall"
          }

dbcondic = {
            "def" : "",
            "tow" : "",
            "all" : ""
            }

gazinstdic = {
            "def" : {},
            "tow" : {},
            "all" : {}
              }

gazsrcdic = {}
gazsrcuniqdic = {}
gazinstlistdic = {}

def initFieldNames(con):
    global locationsfieldnamelist, institutionsfieldnamelist, namesfieldnamelist
    locationsfieldnamelist     = initFieldNamesFieldNameList("locations", con)
    institutionsfieldnamelist  = initFieldNamesFieldNameList("institutions", con)
    namesfieldnamelist         = initFieldNamesFieldNameList("names", con)

def setupMySQL(dbhost, dbport, dbuser, dbpasswd, dbname):
    # for the time being we don't do any checking and just assume
    # that dbhost, etc. exist
    # dbhost = "localhost"
    # dbname = dbname
    # dbport = o.dbport
    # dbuser = o.dbuser
    # dbpasswd = o.dbpass
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
        # by_use_unicode = False
        by_use_unicode = True
        by_charset = "utf8"
        # by_charset = "latin1"
    elif prog_host.startswith("ncse") == True:
        # by_use_unicode = True
        by_use_unicode = False
        by_charset = "latin1"
    elif prog_host.startswith("yew") == True:
        # by_use_unicode = True
        by_use_unicode = False
        by_charset = "latin1"
    else:
        # changed: BY 08.02.12
        # by_use_unicode = True
        # by_charset = "latin1"
        by_use_unicode = False
        by_charset = "latin1"
    # print "PROG_HOST:     ", prog_host
    # print "BY_USE_UNICODE:", by_use_unicode
    # print "BY_CHARSET:    ", by_charset
    # print "DBHOST:        ", dbhost
    # print "DBNAME:        ", dbname
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
        # changed back: BY 18.04.2008
        # TODO: work out how "use_unicode" and "charset" are really
        #       handled by the MySQLDB driver
        # mycon        = MySQLdb.connect(
        #                                use_unicode=by_use_unicode,
        #                                charset=by_charset,
        #                                host=dbhost,
        #                                port=dbport,
        #                                user=dbuser,
        #                                passwd=dbpasswd,
        #                                db=dbname
        #                                )
        # changed: BY 12.02.2008
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
    initFieldNames(mycon)
    return mycon

def getSqlQuery(sql, con):
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    reslist = [r[0] for r in rl]
    return rc, rl

if __name__ == '__main__':
    dbhost = "localhost"
    for dbk in dborder:
        dbcondic[dbk] = setupMySQL(dbhost, 51524, "ncse", "J0urnal", dbnamdic[dbk])
    for wlinst in wlinstlist:
        gazsrcdic[wlinst] = {}
        gazsrcuniqdic[wlinst] = {}
        print wlinst
        for dbk in dborder:
            gazsrcdic[wlinst][dbk] = 0
            gazsrcuniqdic[wlinst][dbk] = 0
        wlinstpath = os.path.join(gategazetteerpath, wlinst)
        instfileobj = file(wlinstpath, "r")
        for line in instfileobj:
            line = line.strip()
            searchline = line.lower()
            searchlinenoesc = searchline
            searchline = MySQLEscape(searchline)
            # if "[" in line:
            #     print line
            for dbk in dborder:
                # sql = "SELECT fullartid, institution FROM institutions WHERE institution like '%s%%'" % (searchline, )
                sql = "SELECT fullartid, institution FROM institutions WHERE institution = '%s'" % (searchline, )
                # print  sql
                (rc, rt) = getSqlQuery(sql, dbcondic[dbk])
                if rc > 0:
                    for faid, title in rt:
                        # print dbnamdic[dbk], faid, title
#                        if gazinstdic[dbk].has_key(searchlinenoesc):
#                            gazinstdic[dbk][searchlinenoesc] += 1
#                            gazsrcdic[wlinst][dbk] += 1
#                        else:
#                            gazinstdic[dbk][searchlinenoesc] = 1
#                            gazsrcdic[wlinst][dbk] += 1
#                            gazsrcuniqdic[wlinst][dbk] += 1
#                            # print searchlinenoesc
                        if gazinstdic[dbk].has_key(title):
                            gazinstdic[dbk][title] += 1
                            gazsrcdic[wlinst][dbk] += 1
                        else:
                            gazinstdic[dbk][title] = 1
                            gazsrcdic[wlinst][dbk] += 1
                            gazsrcuniqdic[wlinst][dbk] += 1
                            # print searchlinenoesc

    repf = getRepfileObject(gateoutlogdir, "INSTITUTIONS", "gate-eval-waterloo-gazetteers")

    for dbk in dborder:
        # gazinstlist = gazinstdic[dbk].keys()
        # gazinstlist.sort()
        # uniqtotal = len(gazinstlist)
        gazinstlistdic[dbk] = gazinstdic[dbk].keys()
        gazinstlistdic[dbk].sort()
        uniqtotal = len(gazinstlistdic[dbk])
        allcounter = 0
        PrintCF(repf, 1, "Gazetteer entries (using title, exact search) in: %s" % (dbnamdic[dbk], ))
        PrintCF(repf, 1, "")
        for gi in gazinstlistdic[dbk]:
            allcounter += gazinstdic[dbk][gi]
        #     PrintCF(repf, 1, "%s: %s %d" % (dbk, gi, gazinstdic[dbk][gi]))
        PrintCF(repf, 1, "")
        PrintCF(repf, 1, "Total uniq entries:  % 10d" % (uniqtotal, ))
        PrintCF(repf, 1, "Total cumul entries: % 10d" % (allcounter, ))
        PrintCF(repf, 1, "")
        PrintCF(repf, 1, "")
        PrintCF(repf, 1, "")
    for wlinst in wlinstlist:
        PrintCF(repf, 1, "Possible source: %s" % (wlinst, ))
        for dbk in dborder:
            PrintCF(repf, 1, "DB: %-26s  ::  cumul.: % 12d   ::   unique: % 12d" % (dbnamdic[dbk], gazsrcdic[wlinst][dbk], gazsrcuniqdic[wlinst][dbk]))

    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Only entries in 'ALL' that are not in 'DEF' or 'TOW':")
    PrintCF(repf, 1, "   (for totals see bottom of list)")
    PrintCF(repf, 1, "")
    uniqcounter = 0
    allcounter = 0
    for gi in gazinstlistdic["all"]:
        if (gi not in gazinstlistdic["def"]) or (gi not in gazinstlistdic["tow"]):
            PrintCF(repf, 1, "% 10d %s" % (gazinstdic[dbk][gi], gi))
            uniqcounter += 1
            allcounter += gazinstdic[dbk][gi]
            
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Total uniq entries:  % 10d" % (uniqcounter, ))
    PrintCF(repf, 1, "Total cumul entries: % 10d" % (allcounter, ))
    PrintCF(repf, 1, "")
            
    # print institutionsfieldnamelist
    # print locationsfieldnamelist
    # print namesfieldnamelist
    repf.close()
    print "--== FINISHED ==--"
