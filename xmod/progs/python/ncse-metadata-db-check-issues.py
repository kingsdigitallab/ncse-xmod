#!/usr/bin/env python
# -*- coding: utf-8 -*-

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

reartid = re.compile(r"""^(?P<publ>(EWJ)|(LDR)|(MRP)|(NSS)|(TEC)|(TTW)|(FEWJ)|(FLDR)|(CLD)|(EMRP)|(FMRP)|(SMRP)|(SNSS)|(NS2)|(NS3)|(NS4)|(NS5)|(NS6)|(NS7)|(NS8)|(NS9)|(FTEC)|(TTEC)|(ATTW)|(ETTW)|(FTTW))-?(?P<year>18\d\d)?-?(?P<month>(0|1)\d)?-?(?P<day>(0|1|2|3)\d)?-?(?P<artid>(Ar|Ad)\d{5,8})?$""")

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply option '-a'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)


def setupMySQL(dbhost, dbport, dbuser, dbpasswd, dbname):
    # for the time being we don't do any checking and just assume
    # that dbhost, etc. exist
    # dbhost = o.dbhost
    # dbname = o.dbname
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

def getFullArtIds(con, ap):
    faidlist = []
    # sql = "SELECT fullartid FROM fullartids WHERE fullartid LIKE '%s%%'" % (ap, )
    sql = "select distinct publ, year, month, day from fullartids"
    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    for faid in rl:
        f = "%s-%4i-%02i-%02i" % faid
        # print f
        faidlist.append(f)
    return faidlist

if __name__ == '__main__':
    # parser = OptionParser()
    # parser.add_option("-a", "--articlepath", dest="articlepath",
    #                   help="Path of article to be extracted ('LDR', 'LDR-1859', or 'LDR-1859-09-24-Ar02417') - no default", metavar="PATH")
    # (options, args) = parser.parse_args()
    # if (options.articlepath == None):
    #     printUsage()

    dbhost = "ncse-text.cch.kcl.ac.uk"
    dbport = 51524
    dbuser = "ncse"
    dbpasswd = "J0urnal"
    db04 = "ncsemetadata-20080409"
    db05 = "ncsemetadata"
    md04con = setupMySQL(dbhost, dbport, dbuser, dbpasswd, db04)
    md05con = setupMySQL(dbhost, dbport, dbuser, dbpasswd, db05)
    articlepath = "ALL"
    # r = re.search(reartid, articlepath)
    # try:
    #     artiddic = r.groupdict()
    #     # prepLogs(corpusoutpath, artiddic["publ"])
    # except AttributeError:
    #     print
    #     print 'Error in format of article id: "%s"' % (articlepath, )
    #     print
    #     sys.exit(2)
    logpath = "./logs"
    repf = getRepfileObject(logpath, articlepath, "ncse-metadata-db-check-issues")

    print "Reading fullartids from 04 version ..."
    faid04list = getFullArtIds(md04con, articlepath)
    PrintCF(repf, 1, "-" * 50)
    PrintCF(repf, 1, "%s: total no. of issues in 04: %i" % (articlepath, len(faid04list)))

    print "Reading fullartids from 05 version ..."
    faid05list = getFullArtIds(md05con, articlepath)
    PrintCF(repf, 1, "-" * 50)
    PrintCF(repf, 1, "%s: total no. of issues in 05: %i" % (articlepath, len(faid05list)))

    # print "04", len(faid04list)
    # print "05", len(faid05list)
    
    faidnotin04list = []
    faidnotin05list = []
    
    print "Looking up issues from 05 in 04 ..."
    faidnotin05list = [f for f in faid04list if f not in faid05list]
    print "Looking up issues from 04 in 05 ..."
    faidnotin04list = [f for f in faid05list if f not in faid04list]
    print "NOT in 05:", len(faidnotin05list)
    print "NOT in 04:", len(faidnotin04list)

    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "-" * 50)
    PrintCF(repf, 1, "%s: issues in 04, but not in 05" % (articlepath, ))
    PrintCF(repf, 1, "-" * 50)
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "     Number of issues not in 05: %i" % (len(faidnotin05list), ))
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "     List of issues not in 05:")
    
    for f in faidnotin05list:
        # print f
        PrintCF(repf, 1, "     %s" % (f, ))

    PrintCF(repf, 1, "-" * 50)
    PrintCF(repf, 1, "%s: issues in 05, but not in 04" % (articlepath, ))
    PrintCF(repf, 1, "-" * 50)
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "     Number of issues not in 04: %i" % (len(faidnotin04list), ))
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "     List of issues not in 04:")
    
    for f in faidnotin04list:
        # print f
        PrintCF(repf, 1, "     %s" % (f, ))

    print "--== FINISHED ==--"


