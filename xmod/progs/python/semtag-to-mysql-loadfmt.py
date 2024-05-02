#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Tue 12.02.2008 00:46:29 GMT gb>

# TODO: fix character encoding

# output in MySQL 'LOAD DATA INFILE' format
# read a semtag output file and write each line as record to a MySQL database
# 
# fields separated by at least on space (except last column)
# 
# semtag short
# frequency of semtag in text
# relative frequency of semtag in text
# frequency of semtag in BNC
# relative frequency of semtag in BNC
# overuse of semtag in text
# log-likelyhood
# semtag description
# S2.1           80     1.10   1364     0.14 +   186.22     People: Female
# Z8            810    11.17  72023     7.44 +   116.35     Pronouns
# E4.1-          45     0.62    979     0.10 +    86.53     Sad 


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

reartid = re.compile(r"""^(?P<publ>(EWJ)|(LDR)|(MRP)|(NSS)|(TEC)|(TTW)|(FEWJ)|(FLDR)|(CLD)|(EMRP)|(FMRP)|(SMRP)|(SNSS)|(NS2)|(NS3)|(NS4)|(NS5)|(NS6)|(NS7)|(NS8)|(NS9)|(FTEC)|(TTEC)|(ATTW)|(ETTW)|(FTTW))-?(?P<year>18\d\d)?-?(?P<month>(0|1)\d)?-?(?P<day>(0|1|2|3)\d)?-?(?P<artid>(Ar|Ad)\d{5,8})?$""")

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-i', '-o' and '-a'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)

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
    return mycon

def prepLogs(cop, pu):
    """Prepare log file directories."""
    logdir = os.path.join(cop, "00_LOGS", pu)
    # if not os.path.exists(logdir):
    #     os.makedirs(logdir, 0755)
    print logdir

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-o", "--outdir", dest="semtagoutpath",
                      help="write output to toplevel directory DIR - no default", metavar="DIR")
    parser.add_option("-i", "--indir", dest="semtaginpath",
                      help="read from directory DIR, containing semtag output files in further subdirectories - no default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be extracted ('LDR-1859-09-24-Ar02417') - no default", metavar="PATH")
    (options, args) = parser.parse_args()
    if ((options.semtaginpath == None) or (options.semtagoutpath == None) or (options.articlepath == None)):
        printUsage()
    semtagoutpath = options.semtagoutpath
    semtaginpath = options.semtaginpath
    if not os.path.exists(semtagoutpath):
        os.makedirs(semtagoutpath, 0755)
    elif not os.path.isdir(semtagoutpath):
        print
        print "Semtag output path '%s' exists, but is not a directory!" % (corpusoutpath, )
        print
        sys.exit(2)
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
    outformat = options.outformat
    outhier = options.outhier
    minchars = options.minchars
    minlines = options.minlines
    repf = getRepfileObject(corpusoutpath, articlepath)
    logmsgdic = {}
    
    (ddir, commandline) = os.path.split(sys.argv[0])
    commandline += " "
    commandline += " ".join(sys.argv[1:])

