#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Read a MySQL database containing the output of a GATE run,
#    i. e. locations, institutions and names and write them
#    into a lucene XML file

# TODO: escape XML characters: &lt;, &gt;, etc.

# REMARKS:
# I have renamed the following fields:
# entity-id -> article-id
# article-id -> fullarticle-id

# ASK JMV or TL:
# sort fields???

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

reartid = re.compile(r"""^(?P<publ>(EWJ)|(LDR)|(MRP)|(NSS)|(TEC)|(TTW)|(FEWJ)|(FLDR)|(CLD)|(EMRP)|(FMRP)|(SMRP)|(SNSS)|(NS2)|(NS3)|(NS4)|(NS5)|(NS6)|(NS7)|(NS8)|(NS9)|(FTEC)|(TTEC)|(ATTW)|(ETTW)|(FTTW))-?(?P<year>18\d\d)?-?(?P<month>(0|1)\d)?-?(?P<day>(0|1|2|3)\d)?-?(?P<artid>(Ar|Ad)\d{5,8})?$""")

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
              "FTTW"
             ) 

locationsfieldnamelist = []
institutionsfieldnamelist = []
namesfieldnamelist = []

lucenegeneralfieldslist = [
                           ["id", "stored", "no", "no" ],
                           ["article-id", "indexed", "no", "no" ],
                           ["fullarticle-id", "stored", "no", "no" ],
                           ["content-type", "indexed", "no", "no" ],
                           ["publication-id", "indexed", "no", "no" ],
                           ["publication-thesaurus", "indexed", "no", "no" ],
                           ["publication-yyyy", "indexed", "no", "no" ],
                           ["publication-mm", "indexed", "no", "no" ],
                           ["publication-dd", "indexed", "no", "no" ],
                           ["by-date", "indexed", "no", "no" ],
                           ["by-pub" "indexed", "no", "no" ]
                           ]

lucenelocationfieldlist = [
                           ["place", "indexed", "yes", "no"]
                           ]

luceneinstitutionfieldlist = [
                           ["institution", "indexed", "yes", "no"]
                           ]

lucenenamefieldlist = [
                           ["name", "indexed", "yes", "no"],
                           ["first-name", "indexed", "no", "no"],
                           ["last-name", "indexed", "no", "no"],
                           ["title", "indexed", "no", "no"]
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

def writeToMySqlTable(tname, fnlist, fvlist, con):
    # print tname, fnlist, fvlist
    insobj = SqlInsert(con=dbcon, 
                       table=tname, 
                       fieldnames=fnlist, 
                       fieldvalues=fvlist)
    # print insobj.getInsertString()
    tid = insobj.getLastRowId()
    del insobj

def processTabDelimited(fi, pinpath, tname, longfnlist, con):
    infilepath = os.path.join(pinpath, fi)
    if not os.path.exists(infilepath):
        print
        print "File '%s' does not exist!" % (infilepath, )
        print
        sys.exit(2)
    elif not os.path.isfile(infilepath):
        print
        print "Input path '%s' exists, but is not a file!" % (infilepath, )
        print
        sys.exit(2)
    infileobj = file(infilepath, "r")
    prevline = ""
    print "Processing %s ..." % (tname, )
    for (linecounter, line) in enumerate(infileobj):
        line = line.rstrip()
        if line.find("\tDoc ID:") < 0:
            prevline = line
            linecounter -= 1
        else:
            
            tmpfvlist = []
            line = prevline + line
            prevline = ""
            fieldvaldic = {}
            # if linecounter % 1000 == 0:
            #     print str(linecounter) + ", ",
            (l, r) = line.split("\tDoc ID:")
            l = MySQLEscape(l)
            # tmpfvlist.append(l)
            # tmpfvlist.append(r)
            # tmpfvlist.append(0)
            tmpfvlist = [l, l, r, 0]
            # print l, r
            # print fnlist, fvlist

            fnlist = []
            fvlist = []
            # print longfnlist
            n = 0
            for (tfn, s) in longfnlist:
                fnlist.append(tfn)
                fvlist.append(s + str(tmpfvlist[n]) + s)
                n += 1
            
            writeToMySqlTable(tname, fnlist, fvlist, con)
    infileobj.close()
    # print 
    # prepare log messages
    entrycounter = linecounter
    outlogmsg = infilepath
    if outlogmsg not in logmsgdic:
        logmsgdic[outlogmsg] = entrycounter
    else:
        logmsgdic[outlogmsg] += entrycounter


def processXmlFile(fi, pinpath, tname, longfnlist, con):
    infilepath = os.path.join(pinpath, fi)
    if not os.path.exists(infilepath):
        print
        print "File '%s' does not exist!" % (infilepath, )
        print
        sys.exit(2)
    elif not os.path.isfile(infilepath):
        print
        print "Input path '%s' exists, but is not a file!" % (infilepath, )
        print
        sys.exit(2)
    infileobj = file(infilepath, "r")

    namesHandler = GateNeeNamesHandler(tname, longfnlist, con)
    parse(infilepath, namesHandler)

    # p = xml.parsers.expat.ParserCreate()
    # p.StartElementHandler = start_element
    # p.EndElementHandler = end_element
    # p.CharacterDataHandler = char_data
    # p.ParseFile(infileobj)
    
    # prepare log messages
    entrycounter = namesHandler.personcounter
    outlogmsg = infilepath
    if outlogmsg not in logmsgdic:
        logmsgdic[outlogmsg] = entrycounter
    else:
        logmsgdic[outlogmsg] += entrycounter
    

def processFullArtId(faid, con):
#                           ["id", "stored", "no", "no" ],
#                           ["article-id", "indexed", "no", "no" ],
#                           ["fullarticle-id", "stored", "no", "no" ],
#                           ["content-type", "indexed", "no", "no" ],
#                           ["publication-id", "indexed", "no", "no" ],
#                           ["publication-thesaurus", "indexed", "no", "no" ],
#                           ["publication-yyyy", "indexed", "no", "no" ],
#                           ["publication-mm", "indexed", "no", "no" ],
#                           ["publication-dd", "indexed", "no", "no" ],
#                           ["by-date", "indexed", "no", "no" ],
#                           ["by-pub" "indexed", "no", "no" ]
#                           ]
    (publ, year, month, day, artid) = faid.split("-")
    actperiodicaltitle = getActualPeriodicalTitle(faid)
    faiddic = {}
    faiddic["article-id"] = artid
    faiddic["fullarticle-id"] = faid
    faiddic["content-type"] = contenttype
    faiddic["publication-id"]  = publ
    faiddic["publication-thesaurus"]  = publ
    faiddic["publication-yyyy"]  = year
    faiddic["publication-mm"] = month
    faiddic["publication-dd"]   = day
    faiddic["by-date"]   = year + month + day
    faiddic["by-pub"]   = day
    # print fullartidsfieldnamelist
    # print faiddic
    # lastinsertid = writeRecord("fullartids", fullartidsfieldnamelist, faiddic, con)
    # fullartididsdic[faid] = lastinsertid
    return faiddic

def getFullartidIds(artpath, tname, con):
    sql = "SELECT id FROM %s WHERE fullartid LIKE '%s%%'" % (tname, artpath)
    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    # print rc
    # print rl
    faididlist = [e[0] for e in rl]
    return faididlist
    
def processSingleArticle(tname, faidid, con):
    sql = "SELECT id FROM %s WHERE fullartid LIKE '%s%%'" % (tname, artpath)
    # print sql
    # selobj = SqlResultList(con=con, sql=sql)
    # rl = selobj.getRowTuple()
    # rc = selobj.getRowCount()
    # del selobj
    
def processLocations(lopath, artpath, con):
    tablename = "locations"
    # fieldnamelist = [ "location", "fullartid", "frequency" ]
    # processTabDelimited(infile, pinpath, tablename, locationsfieldnamelist, con)
    fullartididslist = getFullartidIds(artpath, tablename, con)
    # print fullartididslist
    for fullartidid in fullartididslist:
        processSingleArticle(tablename, fullartidid, con)
    
    # prepare log messages
    entrycounter = 1
    outlogmsg = artpath
    if outlogmsg not in logmsgdic:
        logmsgdic[outlogmsg] = entrycounter
    else:
        logmsgdic[outlogmsg] += entrycounter

def processInstitutions(pinpath, con):
    infile = "Organization.txt"
    tablename = "institutions"
    # fieldnamelist = [ "institution", "fullartid", "frequency" ]
    processTabDelimited(infile, pinpath, tablename, institutionsfieldnamelist, con)

def processNames(pinpath, con):
    infile = "Person.lst.xml"
    tablename = "names"
    processXmlFile(infile, pinpath, tablename, namesfieldnamelist, con)
    

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
    parser.add_option("-o", "--outdir", dest="luceneoutpath",
                      help="write output to directory DIR - no default", metavar="DIR")
    parser.add_option("-l", "--logdir", dest="logdir",
                      help="write log file to directory DIR - no default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be extracted ('LDR', 'LDR-1859', or 'LDR-1859-09-24-Ar02417') - no default", metavar="PATH")
    parser.add_option("-t", "--type", dest="neetype",
                      type="choice", choices=["locations", "institutions", "names", "all"],
                      help="type of NEE information to be processed (locations, institutions, names, all) - default: %default", metavar="HIER")
    (options, args) = parser.parse_args()
    # if ((options.semtaginpath == None) or (options.semtagoutpath == None) or (options.articlepath == None)):
    #     printUsage()
    if ((options.luceneoutpath == None) or (options.dbname == None) or (options.articlepath == None) or (options.logdir == None) or (options.neetype == None)):
        printUsage()
    dbcon = setupMySQL(options)
    # print locationsfieldnamelist
    # print institutionsfieldnamelist
    # print namesfieldnamelist
    # sys.exit()

    neetype = options.neetype
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
    neeshorttype =neetype.lower()[0] 
    if neeshorttype not in ("l", "i", "n", "a"):
        print
        print "Wrong NEE output type '%s'. Should be one of '(l)ocations', '(i)nstitutions', '(n)ames', '(a)ll'." % (neetype, )
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
        
    repf = getRepfileObject(logpath, luceneoutpath, "gatenee")
    logmsgdic = {}
    errorlogdic = {}

    # write command line to report file before anything else happens
    # so we have the commandline as reference in case a crash happens
    writeReportCommandLine(repf)
    
    articlefilepath = articlepath.replace("-", "/")
    # processArticles(neeshorttype, articlepath, dbcon)
    if neeshorttype == "l":
        processLocations(luceneoutpath, articlepath, dbcon)
    elif neeshorttype == "i":
        processInstitutions(luceneoutpath, articlepath, dbcon)
    elif neeshorttype == "n":
        processNames(luceneoutpath, articlepath, dbcon)
    elif neeshorttype == "a":
        processLocations(luceneoutpath, articlepath, dbcon)
        processInstitutions(luceneoutpath, articlepath, dbcon)
        processNames(luceneoutpath, articlepath, dbcon)


    writeReport(repf, logmsgdic, luceneoutpath, "no. of records")

    print "--== FINISHED ==--"
