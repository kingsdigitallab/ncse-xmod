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

txtfilebasedir = "/projects/cch/ncse/ncsecorpusxmlfaid"


validpublidlist = [
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
                   ]

def setupMySQL(dbhost, dbuser, dbpasswd, dbport, dbname):
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

def getSqlQuery(sql, con):
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    reslist = [r[0] for r in rl]
    return rc, rl

def getFileId(dbcon):
    sql = "SELECT max(Fileid1) FROM Proximity"
    (rc, rt) = getSqlQuery(sql, dbcon)
    print rt

def getFaidFromFullFilePath(p):
    return faid

def getBaseHrefFromFullFilePath(p):
    for publid in validpublidlist:
        if p.find("/" + publid + "/") > -1:
            bhrefpos = p.find("/" + publid + "/")
    bhrefpos += 1
    print bhrefpos
    bhref = p[bhrefpos:]
    return bhref

def processSimilarityTable(dbcon, fid, measure):
    sql = 'SELECT Filename, Fileid1, Fileid2, Measure FROM FileList, Proximity WHERE Fileid = %i AND Fileid1 = %i AND Measure > %d'
    sql = sql % (fid, fid, measure)
    # sql = "SELECT title FROM title WHERE title != ''"
    (rc, rt) = getSqlQuery(sql, dbcon)
    tmplist = []
    for r in rt:
        # title = r[0]
        print r
        basehref = getBaseHrefFromFullFilePath(r[0])
        print basehref

if __name__ == '__main__':
    con = setupMySQL("localhost", "ncse", "J0urnal", 51524, "classification_ldr")
    rowcount = 0

    maxfileid = getFileId(con)
    print maxfileid
    fileid = 0
    simmeasure = 0.4 
    processSimilarityTable(con, fileid, simmeasure)

    print "--== FINISHED ==--"
