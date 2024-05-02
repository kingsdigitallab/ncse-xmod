#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Read the output of a GATE run, i. e. the files "Locations.txt",
#    Organizations.txt" and "Persons.lst.xml" and write them to
#    MySQL database
 
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

persondic = {}
personfields = [
                "fullname",
                "lastname",
                "firstname",
                "title",
                "fullartid",
                "rule",
                "rule1",
                "frequency"              
                ]
pdkey = "NULL"

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-i', '-d', '-a' and '-l'"
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
            # convert one field to lowercase
            # leave other field in original spelling
            # l = l.encode("utf8")
            # print "#######################", type(l)
            llower = l.lower()
            l = MySQLEscape(l)
            llower = MySQLEscape(llower)
            # tmpfvlist.append(l)
            # tmpfvlist.append(r)
            # tmpfvlist.append(0)
            tmpfvlist = [llower, l, r, 0]
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

#def start_element(name, attrs):
#    global pdkey, persondic
#    # print 'Start element:', name, attrs
#    if name == "PERSONDATA":
#        pdkey = "NULL"
#        persondic.clear()
#        persondic["frequency"] = 0
#    elif name == "Person":
#        pdkey = "NULL"
#        persondic.clear()
#    elif name == "FullName":
#        pdkey = "fullname"
#        persondic[pdkey] = ""
#    elif name == "FirstName":
#        pdkey = "firstname"
#        persondic[pdkey] = ""
#    elif name == "LastName":
#        pdkey = "lastname"
#        persondic[pdkey] = ""
#    elif name == "Title":
#        pdkey = "title"
#        persondic[pdkey] = ""
#    elif name == "Rule":
#        pdkey = "rule"
#        persondic[pdkey] = ""
#    elif name == "Rule1":
#        pdkey = "rule1"
#        persondic[pdkey] = ""
#    elif name == "Doc":
#        pdkey = "fullartid"
#        persondic[pdkey] = ""
#
#
#def end_element(name):
#    global pdkey, persondic
#    # print 'End element:', name
#    if name == "Person":
#        print "-" * 30
#        for k in persondic.keys():
#            persondic[k] = persondic[k].replace('\n', '')
#            persondic[k] = MySQLEscape(persondic[k])
#            # print k, persondic[k]
#        for k in personfields:
#            print k, persondic[k]
#            
#
#def char_data(data):
#    global pdkey, persondic
#    # print 'Character data:', repr(data)
#    if not pdkey == "NULL":
#        # persondic[pdkey] += repr(data)
#        persondic[pdkey] += data.encode('utf8')

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
    

def processLocations(pinpath, con):
    infile = "Location.txt"
    tablename = "locations"
    # fieldnamelist = [ "location", "fullartid", "frequency" ]
    processTabDelimited(infile, pinpath, tablename, locationsfieldnamelist, con)

def processOrganizations(pinpath, con):
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
    # parser.add_option("-o", "--outdir", dest="semtagoutpath",
    #                   help="write output to toplevel directory DIR - no default", metavar="DIR")
    parser.add_option("-i", "--indir", dest="gateneeinpath",
                      help="read output of GATE from directory DIR, containing subdirectories of the form 'LDR', etc. - no default", metavar="DIR")
    parser.add_option("-l", "--logdir", dest="logdir",
                      help="write log file to directory DIR - no default", metavar="DIR")
    parser.add_option("-a", "--publsiglum", dest="publsiglum",
                      help="Path / publication to be extracted ('LDR' or 'NSS') - no default", metavar="PATH")
    (options, args) = parser.parse_args()
    # if ((options.semtaginpath == None) or (options.semtagoutpath == None) or (options.articlepath == None)):
    #     printUsage()
    if ((options.gateneeinpath == None) or (options.dbname == None) or (options.publsiglum == None) or (options.logdir == None)):
        printUsage()
    dbcon = setupMySQL(options)
    # print locationsfieldnamelist
    # print institutionsfieldnamelist
    # print namesfieldnamelist
    # sys.exit()

    gateneeinpath = options.gateneeinpath
    logpath = options.logdir
    publsiglum = options.publsiglum
    if publsiglum in publtuple:
        publinpath = os.path.join(gateneeinpath, publsiglum)
    else:
        print
        print 'Publication "%s" not valid.' % (publsiglum, )
        print
        sys.exit(2)
    if not os.path.exists(publinpath):
        print
        print "GATE NEE input path '%s' does not exist!" % (publinpath, )
        print
        sys.exit(2)
    elif not os.path.isdir(publinpath):
        print
        print "GATE NEE input path '%s' exists, but is not a directory!" % (publinpath, )
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
    repf = getRepfileObject(logpath, publsiglum, "gate-nee-to-mysql")
    logmsgdic = {}
    errorlogdic = {}

    # write command line to report file before anything else happens
    # so we have the commandline as reference in case a crash happens
    writeReportCommandLine(repf)
    
    publfilepath = publsiglum.replace("-", "/")
    processLocations(publinpath, dbcon)
    processOrganizations(publinpath, dbcon)
    processNames(publinpath, dbcon)
    print 

    writeReport(repf, logmsgdic, publinpath, "no. of records")

    print "--== FINISHED ==--"
