#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Wed 26.03.2008 12:45:34 GMT gb>

# DONE: check this error message
#   after: /projects/cch/ncse/semtagprocessed/txt/EWJ/1858/06  ???
# /projects/cch/ncse/progs/python/bymysqlmap.py:162:
#       Warning: Out of range value adjusted for column 'llh' at row 1
#       self.srlcursor.execute(self.inssql)
#  ---- caused by llh values of "-0.00", "-0.01", etc.
# 
# DONE: quick fix to this was to replace "-0" by "10"
#       revert this fix - according to Paul Rayson this values
#          are produced by rounding errors and mistakenly given
#          such a high ranking
#       "-0.00", "-0.01", etc. should really be "0" and not displayed
#          at all
#       adapt rank of following values accordingly
#       to be on the safe side I will leave them in the DB and
#          give them ranks starting at "9000"
# 
# TODO: semtags with following "---+++" is a glitch
#       don't display, work out a fix, like for example balancing out
#       plus and minus signs
# 
# TODO: keep "+" and "-" signs in separate table in DB ??
#       i. e. decompose semantic tags in base form + modifiers
#       (see usas_guide.pdf - "Introduction to the USAS category
#       system" - "The tagset" p. 1 f.)
# 
# -------------------------------------------------------
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
rekeydomains = re.compile(r"""^(?P<semtag>.+)\s+(?P<freqtxt>\d+)\s+(?P<freqtxtrel>\d+\.?\d*)\s+(?P<freqbnc>\d+)\s+(?P<freqbncrel>\d+\.?\d*)\s+(?P<overuse>\++)\s+(?P<llh>(\+|\-)?\d+\.?\d*)\s+(?P<semtaglong>.*)$""")
# repropernames = re.compile(r"""^(?P<name>.+)\s+(?P<semtag>Z+\d)\s+(?P<freq>\d+) *$""")
# made condition for semtag less strict to accommodate for errors in semantic tagger output
#    ideally the semtag column for names should only ever contain "Z1", "Z2", "Z3"
#    but sometimes other combinations seem to creep in
#    for example: "Z99", "ZZ2", "Z2+++"
# repropernames = re.compile(r"""^(?P<name>.+)\s+(?P<semtag>.+)\s+(?P<freq>\d+) *$""")
# or should it be changed to :                            [A-Za-z]+[0-9]+
repropernames = re.compile(r"""^(?P<name>.+)\s+(?P<semtag>[A-Za-z]+[0-9]+)\s+(?P<freq>\d+) *$""")
# or should it be changed to :                            \S+
# as the "name" column never contains whitespace (whitespace is represented as "_")
repropernames = re.compile(r"""^(?P<name>.+)\s+(?P<semtag>\S+)\s+(?P<freq>\d+) *$""")

semtagsfieldnamelist = []
semtagnamesfieldnamelist = []
fullartidsfieldnamelist = []
llhvfieldnamelist = []
semtagsalfieldnamelist = []

llhvdic = {}

fullartididsdic = {}

zsemtagdic = {
              "Z1" : "Personal names",
              "Z2" : "Geographical names",
              "Z3" : "Other proper names",
              }

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

def printUsageForLoadFormatOutput():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-i', '-o' and '-a'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)

def getRepfileObject(slp, ap):
    repfiledir = slp
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
    # print "STFL", semtagsfieldnamelist
    #    sql = "SHOW COLUMNS FROM semtags"
    #    selobj = SqlResultList(con=con, sql=sql)
    #    rl = selobj.getRowTuple()
    #    rc = selobj.getRowCount()
    #    del selobj
    #    for r in rl:
    #        # print r
    #        # print r[0], r[1], r[3]
    #        fn = r[0]
    #        ft = r[1].lower()
    #        fi = r[3]
    #        if fi != "PRI":
    #            if ((ft.startswith("varchar")) or (ft.startswith("char")) or (ft.startswith("textchar"))):
    #                semtagsfieldnamelist.append([fn, "'"])
    #            else:
    #                semtagsfieldnamelist.append([fn, ""])
    #    sql = "SHOW COLUMNS FROM semtagnames"
    #    selobj = SqlResultList(con=con, sql=sql)
    #    rl = selobj.getRowTuple()
    #    rc = selobj.getRowCount()
    #    del selobj
    #    for r in rl:
    #        # print r
    #        # print r[0], r[1], r[3]
    #        fn = r[0]
    #        ft = r[1].lower()
    #        fi = r[3]
    #        if fi != "PRI":
    #            if ((ft.startswith("varchar")) or (ft.startswith("char")) or (ft.startswith("textchar"))):
    #                semtagnamesfieldnamelist.append([fn, "'"])
    #            else:
    #                semtagnamesfieldnamelist.append([fn, ""])

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

def writeToSemtagsalTable(con, semtag, semtaglong, freqtxt):
    fieldvaldic = {}
    fieldvaldic["semtag"] = semtag
    fieldvaldic["semtaglong"] = semtaglong
    fieldvaldic["totalfreq"] = freqtxt
    freqtxt = int(freqtxt)
    sql = "SELECT id, totalfreq FROM semtagsal WHERE semtag = '%s'" % (semtag, )
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    if rc != 0:
        tid = rl[0][0]
        totalfreq = rl[0][1]
        totalfreq += freqtxt
        updfnfv = "totalfreq=%d" % (totalfreq, )
        sql = "UPDATE semtagsal SET %s where %s=%d" % (updfnfv, "id", tid)
        updobj = SqlResultList(con=con, sql=sql)
        rl = updobj.getRowTuple()
        del updobj
    else:
        # fv = "'%s'" % (semtag, )
        # freq = freqtxt
        # insobj = SqlInsert(con=con,
        #                        table="semtagsal",
        #                        fieldnames=[field, "frequency"],
        #                        fieldvalues=[fv, str(freq)])
        # tid = insobj.getLastRowId()
        # del insobj

        # ------------------------------
        fnlist = []
        fvlist = []
        for (tfn, s) in semtagsalfieldnamelist:
            fnlist.append(tfn)
            fvlist.append(s + str(fieldvaldic[tfn]) + s)
        # print fnlist
        # print fvlist
        insobj = SqlInsert(con=dbcon, 
                           table="semtagsal", 
                           fieldnames=fnlist, 
                           fieldvalues=fvlist)
        tid = insobj.getLastRowId()
        del insobj
        # tid = 0
    return tid

def writeRecord(table, fieldnamelist, fieldvaldic, dbcon):
    fnlist = []
    fvlist = []
    for (tfn, s) in fieldnamelist:
        fnlist.append(tfn)
        fvlist.append(s + str(fieldvaldic[tfn]) + s)
    # print fnlist
    # print fvlist
    insobj = SqlInsert(con=dbcon, 
                       table=table, 
                       fieldnames=fnlist, 
                       fieldvalues=fvlist)
    tid = insobj.getLastRowId()
    del insobj
    # tid = 0
    return tid

def processFullArtId(faid, con):
    (publ, year, month, day, artid) = faid.split("-")
    faiddic = {}
    faiddic["fullartid"] = faid
    faiddic["publ"]  = publ
    faiddic["year"]  = year
    faiddic["month"] = month
    faiddic["day"]   = day
    faiddic["artid"] = artid
    # print fullartidsfieldnamelist
    # print faiddic
    lastinsertid = writeRecord("fullartids", fullartidsfieldnamelist, faiddic, con)
    fullartididsdic[faid] = lastinsertid
    return lastinsertid

def processKeyDomainsFileBlock(p, fl, con):
    for f in fl:
        fullsemtaginpath = os.path.join(p, f)
        fullartid = f[:-15]
        fullartidid = processFullArtId(fullartid, con)
        # print fullsemtaginpath
        # print fullartid
        kdinfileobj = file(fullsemtaginpath, "r")
        linelist = kdinfileobj.readlines()
        kdinfileobj.close()
        rank = 0
        zerovaluesrank = 8999
        testprevlinellh = ""
        for line in linelist:
            line = line.rstrip("\n")
            rank += 1
            # print fullartid, line
            r = re.search(rekeydomains, line)
            keydomainsdic = r.groupdict()
            keydomainsdic["semtag"] = keydomainsdic["semtag"].strip()
            keydomainsdic["semtaglong"] = keydomainsdic["semtaglong"].strip()
            semtagsalid = writeToSemtagsalTable(con, keydomainsdic["semtag"], keydomainsdic["semtaglong"], keydomainsdic["freqtxt"])
            keydomainsdic["semtagsalid"] = str(semtagsalid)
            keydomainsdic["fullartid"] = fullartid
            keydomainsdic["fullartidid"] = fullartidid
            keydomainsdic["rank"] = rank
            llhvdic[fullartid] = [testprevlinellh, keydomainsdic["llh"]]
            # print llhvdic[fullartid]
            # BY hack
            # to account for possible bug in semantic tagger
            # displays "10.00" etc. as "-0.00" etc. ?
            # ATTENTION!!!
            # reverse this hack - "-0.00", "-0.01" is really "0" and should not
            #    be displayed at all
            #    don't forget to also change rank
            #    I leave these values in the DB (without the leading "-")
            #    and give them ranks
            #    starting at "9000"
            if keydomainsdic["llh"].startswith("-"):
                keydomainsdic["llh"] = keydomainsdic["llh"][1:]
                zerovaluesrank += 1
                rank -= 1
                keydomainsdic["rank"] = zerovaluesrank
                # print "MINUS", fullartid, testprevlinellh,  keydomainsdic["llh"]
            testprevlinellh = keydomainsdic["llh"]
            # print keydomainsdic
            lastinsertid = writeRecord("semtags", semtagsfieldnamelist, keydomainsdic, con)

def processProperNamesFileBlock(p, fl, con):
    for f in fl:
        fullpropnamesinpath = os.path.join(p, f)
        fullartid = f[:-16]
        pninfileobj = file(fullpropnamesinpath, "r")
        linelist = pninfileobj.readlines()
        pninfileobj.close()
        for line in linelist:
            line = line.rstrip("\n")
            # print fullartid, line
            r = re.search(repropernames, line)
            # propernamesdic = r.groupdict()
            
            try:
                propernamesdic = r.groupdict()
            except AttributeError:
                print
                print 'Error in format of proper names line id: "%s"' % (fullartid, )
                print 'Line: "%s"' % (line, )
                print
                sys.exit(2)
            
            # print propernamesdic
            propernamesdic["semtag"] = propernamesdic["semtag"].strip()
            if zsemtagdic.has_key(propernamesdic["semtag"]):
                propernamesdic["semtaglong"] = zsemtagdic[propernamesdic["semtag"]]
            else:
                propernamesdic["semtaglong"] = propernamesdic["semtag"]
            propernamesdic["name"] = propernamesdic["name"].strip()
            propernamesdic["fullartid"] = fullartid
            propernamesdic["fullartidid"] = fullartididsdic[fullartid]
            # print propernamesdic
            lastinsertid = writeRecord("semtagnames", semtagnamesfieldnamelist, propernamesdic, con)


def processSemtagOutput(seminpath, artpath, con):
    seminbasepath = os.path.join(seminpath, artpath)
    for walkroot, walkdirs, walkfiles in os.walk(seminbasepath):
        # print "WR", walkroot
        # print "WD", walkdirs
        # print "WF", walkfiles
        nooffiles = 0
        corpusfilelist = []
        semtagsfilelist = []
        propernamesfilelist = []
        if walkfiles != []:
            for wf in walkfiles:
                if wf.endswith("_keydomains.txt"):
                    semtagsfilelist.append(wf)
                    nooffiles += 1
                elif wf.endswith("_propernames.txt"):
                    propernamesfilelist.append(wf)
                elif wf.endswith(".txt"):
                    corpusfilelist.append(wf)
            # TODO: test if same number: original corpus files,
            #       semtagsfiles, propernamesfiles 
            # print len(semtagsfilelist)
            # print len(propernamesfilelist)
            # print len(corpusfilelist)
            processKeyDomainsFileBlock(walkroot, semtagsfilelist, con)
            processProperNamesFileBlock(walkroot, propernamesfilelist, con)
            

        # FROM tokendb-to-corpus.py
        outlogmsg = os.path.join(walkroot)
        if outlogmsg not in logmsgdic:
            logmsgdic[outlogmsg] = nooffiles
        else:
            logmsgdic[outlogmsg] += nooffiles
        print walkroot
        # END FROM tokendb-to-corpus.py

def prepLogs(cop, pu):
    """Prepare log file directories."""
    logdir = os.path.join(cop, "00_LOGS", pu)
    # if not os.path.exists(logdir):
    #     os.makedirs(logdir, 0755)
    print logdir

def writeReportCommandLine():
    (ddir, commandline) = os.path.split(sys.argv[0])
    commandline += " "
    commandline += " ".join(sys.argv[1:])
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Command line used:")
    PrintCF(repf, 1, commandline)
    PrintCF(repf, 1, "")

def writeReport(ap):
    # (ddir, commandline) = os.path.split(sys.argv[0])
    # commandline += " "
    # commandline += " ".join(sys.argv[1:])
    
    logmsglist = logmsgdic.keys()
    logmsglist.sort()

    # PrintCF(repf, 1, "")
    # PrintCF(repf, 1, "Command line used:")
    # PrintCF(repf, 1, commandline)
    # PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Article path extracted: %s" % (ap, ))
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Directory           No. of files")
    PrintCF(repf, 1, "-" * 32)
    dirlen = len(logmsglist[0])
    tabspace = " " * (6 + (14 - dirlen))
    totfilecount = 0
    for k in logmsglist:
        PrintCF(repf, 1, "%s%s% 7d" % (k, tabspace, logmsgdic[k]))
        totfilecount += logmsgdic[k]
    PrintCF(repf, 1, "-" * 32)
    dirlen = len("Total")
    tabspace = " " * (6 + (14 - dirlen))
    PrintCF(repf, 1, "%s%s% 7d" % ("Total", tabspace, totfilecount))
    PrintCF(repf, 1, "")

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
    parser.add_option("-i", "--indir", dest="semtaginpath",
                      help="read from directory DIR, containing semtag output files in further subdirectories - no default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be extracted ('LDR', 'LDR-1859', or 'LDR-1859-09-24-Ar02417') - no default", metavar="PATH")
    (options, args) = parser.parse_args()
    # if ((options.semtaginpath == None) or (options.semtagoutpath == None) or (options.articlepath == None)):
    #     printUsage()
    if ((options.semtaginpath == None) or (options.dbname == None) or (options.articlepath == None)):
        printUsage()
    dbcon = setupMySQL(options)
    semtaginpath = options.semtaginpath
    semtaglogpath = semtaginpath + "/../log"
    semtaglogpath = os.path.normpath(semtaglogpath)
    if not os.path.exists(semtaginpath):
        print
        print "Semtag input path '%s' does not exist!" % (semtaginpath, )
        print
        sys.exit(2)
    elif not os.path.isdir(semtaginpath):
        print
        print "Semtag input path '%s' exists, but is not a directory!" % (semtaginpath, )
        print
        sys.exit(2)
    if not os.path.exists(semtaglogpath):
        print
        print "Semtag log path '%s' does not exist!" % (semtaglogpath, )
        print
        sys.exit(2)
    elif not os.path.isdir(semtaglogpath):
        print
        print "Semtag log path '%s' exists, but is not a directory!" % (semtaglogpath, )
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
    repf = getRepfileObject(semtaglogpath, articlepath)
    logmsgdic = {}
    errorlogdic = {}

    # write command line to report file before anything else happens
    # so we have the commandline as reference in case a crash happens
    writeReportCommandLine()
    
    articlefilepath = articlepath.replace("-", "/")
    processSemtagOutput(semtaginpath, articlefilepath, dbcon)

    writeReport(articlepath)

    # for k in llhvdic.keys():
    #     (prev, curr) = llhvdic[k]
    #     if curr.startswith("-"):
    #         print k, prev, curr 
        
    print "--== FINISHED ==--"
