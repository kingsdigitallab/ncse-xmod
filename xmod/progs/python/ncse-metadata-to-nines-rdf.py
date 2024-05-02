#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Wed 22.07.2009 15:25:43 BST gb>

# Write NINES RDF files

import sys
import string
import re
import socket
import platform
import time
import types
import os, os.path
from xml.etree import ElementTree as ET

from optparse import OptionParser

from bymysqlmap import *


# ncse_metadata_db = "ncsemetadata-20090709"
# ncse_gatedata_db  = "ncsegatenee"

dbmddic = {
    "dbhost" : "localhost",
    "dbname" : "ncsemetadata-20090709",
    "dbport" : 51524,
    "dbuser" : "ncse",
    "dbpasswd" : "J0urnal"
       }

dbgddic = {
    "dbhost" : "localhost",
    "dbname" : "ncsegatenee",
    "dbport" : 51524,
    "dbuser" : "ncse",
    "dbpasswd" : "J0urnal"
       }


reartid = re.compile(r"""^(?P<publ>(EWJ)|(LDR)|(MRP)|(NSS)|(TEC)|(TTW)|(FEWJ)|(FLDR)|(CLD)|(EMRP)|(FMRP)|(SMRP)|(SNSS)|(NS2)|(NS3)|(NS4)|(NS5)|(NS6)|(NS7)|(NS8)|(NS9)|(FTEC)|(TTEC)|(ATTW)|(ETTW)|(FTTW)|(SCLD)|(SLDR)|(SXLDR))-?(?P<year>18\d\d)?-?(?P<month>(0|1)\d)?-?(?P<day>(0|1|2|3)\d)?-?(?P<artid>(Ar|Ad)\d{5,8})?$""")


validchars = string.ascii_letters + string.digits + ",.-/&'"

def getRepfileObject(cop, ap):
    repfiledir = cop
    repfilefile = ap
    repfilefile += "-"
    # repfilefile += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
    repfilefile += time.strftime("%Y%m%d%H%M", time.localtime())
    repfilefile += ".LOG"
    repfilepath = os.path.join(repfiledir, repfilefile)
    repf = file(repfilepath, "w")
    return repf

# PrintCF
# print to console and file
# 1: filehandle
# 2: if newline should be added at end
# 3: string to print
def PrintCF(fh, newline, s):
    if newline == 0:
        print s,
        fh.write(s)
        fh.flush()
    else:
        print s
        fh.write(s + "\n")
        fh.flush()

def setupMySQL(o):
    # for the time being we don't do any checking and just assume
    # that dbhost, etc. exist
    dbhost = o["dbhost"]
    dbname = o["dbname"]
    dbport = o["dbport"]
    dbuser = o["dbuser"]
    dbpasswd = o["dbpasswd"]
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

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-d', '-o' and '-a'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)




if __name__ == '__main__':

    mdcon = setupMySQL(dbmddic)
    gdcon = setupMySQL(dbgddic)
    

    print "--== FINISHED ==--"
