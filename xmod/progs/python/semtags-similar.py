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

from optparse import OptionParser

# import bygetconfigparse
# from xml.etree import ElementTree as ET
# from lxml import etree as ET
from bymysqlmap import *

percentiledic = {
            "99.99" : 15.13,
            "99.9"  : 10.83,
            "99"    : 6.63,
            "95"    : 3.84
            }


faidinlist = [
    "EWJ-1858-04-01-Ar00103"
    ]
# faidinlist = [
#     "LDR-1853-04-02-Ar00902"
#     ]
# faidinlist = [
#     "NSS-1839-03-02-Ar00301"
#     ]

# EWJ-1858-04-01-Ar00103 (Nightingale)
# EWJ-1858-04-01-Ar00802 (Blackwell)
# LDR-1853-04-02-Ar00902 ("The white slaves of the west end)
# NSS-1839-03-02-Ar00301 ("about Canada and US, crime, etc.)

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-i', '-d' and '-a'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)

def initFieldNamesFieldNameList(table, con):
    fnlist = []
    sql = "SHOW COLUMNS FROM " + table
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    for r in rl:
        fn = r[0]
        ft = r[1].lower()
        fi = r[3]
        if fi != "PRI":
            if ((ft.startswith("varchar")) or (ft.startswith("char")) or (ft.startswith("textchar"))):
                fnlist.append([fn, "'"])
            else:
                fnlist.append([fn, ""])
    return fnlist

def initFieldNames(con):
    global semtagsfieldnamelist, semtagnamesfieldnamelist, fullartidsfieldnamelist, llhvfieldnamelist, semtagsalfieldnamelist
    semtagsfieldnamelist     = initFieldNamesFieldNameList("semtags", con)
    semtagnamesfieldnamelist = initFieldNamesFieldNameList("semtagnames", con)
    fullartidsfieldnamelist  = initFieldNamesFieldNameList("fullartids", con)
    llhvfieldnamelist        = initFieldNamesFieldNameList("llhv", con)
    semtagsalfieldnamelist   = initFieldNamesFieldNameList("semtagsal", con)

def setupMySQL(o):
    # for the time being we don't do any checking and just assume
    # that dbhost, etc. exist
    dbhost = o.dbhost
    dbname = o.dbname
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
    initFieldNames(mycon)
    return mycon

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-d", "--dbname", dest="dbname",
                      help="DB name - no default", metavar="DB")
    parser.add_option("-s", "--dbserver", dest="dbhost", default="localhost",
                      help="DB host - default: localhost", metavar="HOST")
    parser.add_option("-P", "--port", dest="dbport", default=51524, type="int",
                      help="DB port - default: 51524", metavar="PORT")
    parser.add_option("-u", "--user", dest="dbuser", default="gbrey",
                      help="DB user - default: gbrey", metavar="USER")
    parser.add_option("-p", "--password", dest="dbpass", default="Ujs92ila",
                      help="DB password - default: XXX", metavar="PW")
    parser.add_option("-o", "--outofplace", dest="useoutofplace",
                      help="minimum 'outofplace' value for output - default: %default",
                      default=5000, type="int", metavar="OOP")
    parser.add_option("-i", "--indir", dest="semtaginpath",
                      help="read from directory DIR, containing semtag output files in further subdirectories - no default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be extracted ('LDR-1859-09-24-Ar02417') - no default", metavar="PATH")
    parser.add_option("-c", "--percentile", dest="percentile",
                      type="choice", choices=["99.99", "99.9", "99", "95"], default="95",
                      help="upto which confidence level should semtags be taken into consideration ('99.99', '99.9', '99', '95') - default: %default", metavar="PERC")
    (options, args) = parser.parse_args()
    # if ((options.semtaginpath == None) or (options.semtagoutpath == None) or (options.articlepath == None)):
    #     printUsage()
    # if ((options.semtaginpath == None) or (options.dbname == None) or (options.articlepath == None)):
    if (options.dbname == None):
        printUsage()
    dbcon = setupMySQL(options)
    percentile = options.percentile
    useoutofplace = options.useoutofplace
    for faidin in faidinlist:
        sql = "SELECT semtag, llh FROM semtags WHERE fullartid = '%s' AND semtag NOT LIKE 'Z%%' AND llh >= %s ORDER BY llh DESC" % (faidin, percentiledic[percentile])
        selobj = SqlResultList(con=dbcon, sql=sql)
        rl = selobj.getRowTuple()
        rc = selobj.getRowCount()
        del selobj
        srcprofiledic = {}
        rank = 0
        for r in rl:
            rank += 1
            srcprofiledic[r[0]] = rank
            # print r
        srcmaxrank = rank
        # print srcprofiledic
        print "MAX SOURCE RANK:", srcmaxrank
        sql = "SELECT fullartid FROM fullartids"
        selobj = SqlResultList(con=dbcon, sql=sql)
        rl = selobj.getRowTuple()
        rc = selobj.getRowCount()
        del selobj
        for f in rl:
            faidout = f[0]
            sql = "SELECT semtag, llh FROM semtags WHERE fullartid = '%s' AND semtag NOT LIKE 'Z%%' AND llh >= %s ORDER BY llh DESC" % (faidout, percentiledic[percentile])
            selobj = SqlResultList(con=dbcon, sql=sql)
            rl = selobj.getRowTuple()
            rc = selobj.getRowCount()
            del selobj
            targetprofiledic = {}
            rank = 0
            for r in rl:
                rank += 1
                targetprofiledic[r[0]] = rank
                # print r
            targetmaxrank = rank
            # print targetprofiledic
            # print targetmaxrank
            # maxoutofplace = max rank of smaller maxrank
            # maxoutofplace = min(srcmaxrank, targetmaxrank)
            # maxoutofplace = max rank of src rank
            #
            # do an intersection first and then compare ranks
            # 
            maxoutofplace = srcmaxrank
            outofplace = 0
            for semtag in srcprofiledic.keys():
                if targetprofiledic.has_key(semtag):
                    outofplace += abs(srcprofiledic[semtag] - targetprofiledic[semtag])
                    # print semtag, abs(srcprofiledic[semtag] - targetprofiledic[semtag])
                else:
                    outofplace += maxoutofplace
            # if outofplace < 1100:
            if outofplace < useoutofplace:
                print faidout, outofplace
                # print srcprofiledic
                # print targetprofiledic
                

        
    
