#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Tue 26.02.2008 01:52:04 GMT gb>

import sys
import string
import re
import socket
import platform
import time
import types
import os, os.path
import shutil

from optparse import OptionParser

# import bygetconfigparse
# from xml.etree import ElementTree as ET
# from lxml import etree as ET
from bymysqlmap import *

dbbasename = "ncsetoks_"
dbsuffixlist = [
                "ewj",
                "ldr",
                "mrp",
                "nss",
                "tec",
                "ttw",
                "fewj",
                "fldr",
                "cld",
                "emrp",
                "fmrp",
                "smrp",
                "snss",
                "ns2",
                "ns3",
                "ns4",
                "ns5",
                "ns6",
                "ns7",
                "ns8",
                "ns9",
                "ftec",
                "ttec",
                "attw",
                "ettw",
                "fttw"
                ]

mincharsize = 300
maxcharsize = 1600
mintokensize = 100
maxtokensize = 1100

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply option '-d'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)

def setupMySQL(dbpd):
    # for the time being we don't do any checking and just assume
    # that dbhost, etc. exist
    dbhost = dbpd["dbhost"]
    dbport = dbpd["dbport"]
    dbuser = dbpd["dbuser"]
    dbpasswd = dbpd["dbpasswd"]
    dbname = dbpd["dbname"]
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


if __name__ == '__main__':
    # parser = OptionParser()
    # parser.add_option("-d", "--dbname", dest="dbname",
    #                   help="DB name - no default", metavar="DB")
    # parser.add_option("-s", "--dbserver", dest="dbhost", default="localhost",
    #                   help="DB host - default: localhost", metavar="HOST")
    # parser.add_option("-P", "--port", dest="dbport", default=51524, type="int",
    #                   help="DB port - default: 51524", metavar="PORT")
    # parser.add_option("-u", "--user", dest="dbuser", default="gbrey",
    #                   help="DB user - default: gbrey", metavar="USER")
    # parser.add_option("-p", "--password", dest="dbpass", default="Ujs92ila",
    #                   help="DB password - default: XXX", metavar="PW")
    # if options.dbname == None:
    #     printUsage()
    dbparamdic = {}
    dbparamdic["dbhost"] = "ncse-text.cch.kcl.ac.uk"
    dbparamdic["dbport"] = 51524
    dbparamdic["dbuser"] = "gbrey"
    dbparamdic["dbpasswd"] = "Ujs92ila"
    sql = "select count(*) from fullartids where %s > %i"
    for dbsuffix in dbsuffixlist:
        dbname = dbbasename + dbsuffix
        # print dbname
        dbparamdic["dbname"] = dbname
        dbcon = setupMySQL(dbparamdic)
        tsql = "select count(*) from fullartids"
        selobj = SqlResultList(con=dbcon, sql=tsql)
        rl = selobj.getRowList()
        del selobj
        totalartcount = rl[0][0]
        print 
        print "% 4s - Total number of articles:  % 9i" % (dbsuffix.upper(), totalartcount)
        print "-" * 50
        for charsize in range(mincharsize, maxcharsize, 100):
            msql = sql % ("charcount", charsize)
            selobj = SqlResultList(con=dbcon, sql=msql)
            rl = selobj.getRowList()
            del selobj
            currartcount = rl[0][0]
            currpercentage = (currartcount * 100.0) / totalartcount
            currpercentage = int(round(currpercentage))
            # print charsize, totalartcount, currartcount, currpercentage
            print "        articles > % 6i chars:  % 9i = % 3i%%" % (charsize, currartcount, currpercentage)
        print 
        for tokensize in range(mintokensize, maxtokensize, 100):
            msql = sql % ("tokencount", tokensize)
            selobj = SqlResultList(con=dbcon, sql=msql)
            rl = selobj.getRowList()
            del selobj
            currartcount = rl[0][0]
            currpercentage = (currartcount * 100.0) / totalartcount
            currpercentage = int(round(currpercentage))
            # print charsize, totalartcount, currartcount, int(round(currpercentage))
            print "        articles > % 6i tokens: % 9i = % 3i%%" % (tokensize, currartcount, currpercentage)

        del dbcon

    print "--== FINISHED ==--"
    
    