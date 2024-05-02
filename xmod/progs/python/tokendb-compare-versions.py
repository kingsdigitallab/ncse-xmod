#!/usr/bin/env python

# compare versions of the NCSE repository
# i. e. the launch version from Feb. 2008 with
#       the final version from Aug. 2008

import sys
import string
import re
import socket
import platform
import time
import types
import csv
import os, os.path
from optparse import OptionParser
from bymysqlmap import *

# (EWJ)|(LDR)|(MRP)|(NSS)|(TEC)|(TTW)|(FEWJ)|(FLDR)|(CLD)|(EMRP)|(FMRP)|(SMRP)|(SNSS)|(NS2)|(NS3)|(NS4)|(NS5)|(NS6)|(NS7)|(NS8)|(NS9)|(FTEC)|(TTEC)|(ATTW)|(ETTW)|(FTTW)|(SCLD)|(SLDR)|(SXLDR)

csvheaderwritten = 0

publlist = (
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
    )

def printUsage():
    print
    print "ATTENTION:"
    print
    # print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-d', '-o' and '-a'"
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-o' and '-a'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)

def setupMySQL(dbhost, dbport, dbname, dbuser, dbpasswd):
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
    return mycon

def getRepfileObject(cop, ap, op):
    repfiledir = cop
    repfilefile = "TOKENDB-COMPARISON"
    repfilefile += "-"
    if op.minchars > 0:
        repfilefile += "MIN%dCHARS" % (op.minchars, )
        repfilefile += "-"
    if op.minlines > 0:
        repfilefile += "MIN%dLINES" % (op.minlines, )
        repfilefile += "-"
    repfilefile += ap
    repfilefile += "-"
    # repfilefile += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
    repfilefile += time.strftime("%Y%m%d%H%M", time.localtime())
    repfilefile += ".LOG"
    repfilepath = os.path.join(repfiledir, repfilefile)
    repf = file(repfilepath, "w")
    return repf

def getCsvWriterObject(cop, ap, op):
    csvfiledir = cop
    csvfilefile = "TOKENDB-COMPARISON"
    csvfilefile += "-"
    if op.minchars > 0:
        csvfilefile += "MIN%dCHARS" % (op.minchars, )
        csvfilefile += "-"
    if op.minlines > 0:
        csvfilefile += "MIN%dLINES" % (op.minlines, )
        csvfilefile += "-"
    csvfilefile += ap
    csvfilefile += "-"
    # csvfilefile += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
    csvfilefile += time.strftime("%Y%m%d%H%M", time.localtime())
    csvfilefile += ".csv"
    csvfilepath = os.path.join(csvfiledir, csvfilefile)
    csvf = file(csvfilepath, "w")
    # csvf = csv.writer(open(csvfilepath, "wb"), dialect=csv.excel)
    csvf = csv.writer(open(csvfilepath, "wb"), dialect='excel', lineterminator='\n')
    return csvf


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

def getMinWhereExpr():
    pass

def getIssues(con, pub, apa, whp):
    if whp == True:
        where = ""
    else:
        # where = " WHERE tokenid LIKE '%s%%'" % (apa, )
        where = " WHERE fullartid LIKE '%s%%'" % (apa, )
    # sql = "SELECT count(id) FROM tokens" + where
    # sql = "SELECT sum(tokencount) FROM fullartids" + where
    sql = "SELECT DISTINCT year, month, day FROM fullartids" + where
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    # print rl[0][0]
    # print rc
    # return rl[0][0]
    # return rl[0]
    return rc

def getArticleStats(con, pub, apa, whp, minwh):
    # select count(id) from fullartids group by year, month, day
    # result is issuecount rows of article numbers per issue
    # use pythont to calculate max, min, etc.
    if whp == True:
        where = ""
        if minwh != "":
            where = " WHERE" + minwh
    else:
        # where = " WHERE tokenid LIKE '%s%%'" % (apa, )
        where = " WHERE fullartid LIKE '%s%%'" % (apa, )
        if minwh != "":
            where += " AND" + minwh
    # sql = "SELECT count(id) FROM tokens" + where
    # sql = "SELECT sum(tokencount) FROM fullartids" + where
    sql = "SELECT count(id) FROM fullartids" + where + " GROUP BY year, month, day"
    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    rlx = [x[0] for x in rl]
    tmpdic = {
              "numberofarticles" : sum(rlx),
              "max" : max(rlx),
              "min" : min(rlx),
              "avg" : sum(rlx)/rc
              }
    # print rl
    # print max(rlx), min(rlx), sum(rlx)/rc, sum(rlx), rlx
    # print rc
    # print rl[0][0]
    # print rc
    # return rl[0][0]
    # return rl[0]
    return tmpdic

def getNumbers(con, pub, apa, whp, minwh):
    if whp == True:
        where = ""
        if minwh != "":
            where = " WHERE" + minwh
    else:
        # where = " WHERE tokenid LIKE '%s%%'" % (apa, )
        where = " WHERE fullartid LIKE '%s%%'" % (apa, )
        if minwh != "":
            where += " AND" + minwh
    # sql = "SELECT count(id) FROM tokens" + where
    # sql = "SELECT sum(tokencount) FROM fullartids" + where
    sql = "SELECT count(id), sum(tokencount), sum(charcount), sum(linecount) FROM fullartids" + where
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    # print rl[0][0]
    # print rc
    tmpdic = {
              "numberofarticles" : rl[0][0],
              "numberoftokens" : rl[0][1],
              "numberofchars" : rl[0][2],
              "numberoflines" : rl[0][3]
              }
    # return rl[0][0]
    # return rl[0]
    return tmpdic

def getStats(con, pub, apa, whp, unit, minwh):
    if whp == True:
        where = ""
        if minwh != "":
            where = " WHERE" + minwh
    else:
        # where = " WHERE tokenid LIKE '%s%%'" % (apa, )
        where = " WHERE fullartid LIKE '%s%%'" % (apa, )
        if minwh != "":
            where += " AND" + minwh
    # sql = "SELECT count(id) FROM tokens" + where
    # sql = "SELECT sum(tokencount) FROM fullartids" + where
    sql = "SELECT "
    sql += "max(%scount), "
    sql += "min(%scount), "
    sql += "avg(%scount), "
    sql += "std(%scount) "
    sql += "FROM fullartids"
    sql = sql % (unit, unit, unit, unit)
    sql += where
    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    # print rl[0][0]
    # print rc
    tmpdic = {
              "max" : rl[0][0],
              "min" : rl[0][1],
              "avg" : rl[0][2],
              "stddev" : rl[0][3]
              }
    # return rl[0][0]
    # return rl[0]
    return tmpdic

def printStats(repf, publ, ap, icnt, tcldic, tsdic, csdic, lsdic, asdic, mininf):
    repstr = "Report for publication: %s - article path: %s" % (publ, ap)
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, repstr)
    PrintCF(repf, 1, "-" * len(repstr))
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, mininf)
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "NUMBER OF          % 15s % 15s % 15s % 15s % 15s" % ("TOTAL", "MAX", "MIN", "AVG", "STDDEV"))
    PrintCF(repf, 1, "           ISSUES: % 15d" % (icnt, ))
    PrintCF(repf, 1, "    ARTICLES/ISS.: % 15d % 15d % 15d % 15d % 15d" % (tcldic["numberofarticles"], asdic["max"], asdic["min"], asdic["avg"], 0))
    PrintCF(repf, 1, "       LINES/ART.: % 15d % 15d % 15d % 15d % 15d" % (tcldic["numberoflines"], lsdic["max"], lsdic["min"], lsdic["avg"], lsdic["stddev"]))
    PrintCF(repf, 1, "      TOKENS/ART.: % 15d % 15d % 15d % 15d % 15d" % (tcldic["numberoftokens"], tsdic["max"], tsdic["min"], tsdic["avg"], tsdic["stddev"]))
    PrintCF(repf, 1, "  CHARACTERS/ART.: % 15d % 15d % 15d % 15d % 15d" % (tcldic["numberofchars"], csdic["max"], csdic["min"], csdic["avg"], csdic["stddev"]))

def getHeaderRows():
    hrow1list = []
    hrow2list = []
    hrow1list.append("'PUBL'")
    for n in range(0,5):
        hrow1list.append("'TOTAL'")
    for n in range(0,4):
        hrow1list.append("'MAX'")
        hrow1list.append("'MIN'")
        hrow1list.append("'AVG'")
        hrow1list.append("'STDDEV'")
    hrow2list.append("''")
    hrow2list.append("'ISSUES'")
    hrow2list.append("'ARTICLES'")
    hrow2list.append("'LINES'")
    hrow2list.append("'TOKENS'")
    hrow2list.append("'CHARS'")
    # for n in range(0,5):
    #     hrow2list.append("'ISSUES'")
    for n in range(0,4):
        hrow2list.append("'ARTICLES'")
    for n in range(0,4):
        hrow2list.append("'LINES'")
    for n in range(0,4):
        hrow2list.append("'TOKENS'")
    for n in range(0,4):
        hrow2list.append("'CHARS'")
    return hrow1list, hrow2list

def printStatsCsv(csvf, publ, ap, icnt, tcldic, tsdic, csdic, lsdic, asdic, mininf):
    global csvheaderwritten
    headerrow1list, headerrow2list = getHeaderRows()
    valrowlist = []
    # print tcldic.items()
    # csvf.writerow(tcldic.keys())
    # csvf.writerow(tcldic.items())
    if csvheaderwritten == 0:
        csvf.writerow(headerrow1list)
        csvf.writerow(headerrow2list)
        csvheaderwritten = 1
    # csvf.writerow(("'" + publ + "'",    icnt, tcldic["numberofarticles"], tcldic["numberoflines"], tcldic["numberoftokens"], tcldic["numberofchars"]))
    valrowlist.append("'" + publ + "'")
    valrowlist.append(icnt)
    valrowlist.append(tcldic["numberofarticles"])
    valrowlist.append(tcldic["numberoflines"])
    valrowlist.append(tcldic["numberoftokens"])
    valrowlist.append(tcldic["numberofchars"])
    valrowlist.append(asdic["max"])
    valrowlist.append(asdic["min"])
    valrowlist.append(asdic["avg"])
    valrowlist.append(0)
    valrowlist.append(lsdic["max"])
    valrowlist.append(lsdic["min"])
    valrowlist.append(lsdic["avg"])
    valrowlist.append(lsdic["stddev"])
    valrowlist.append(tsdic["max"])
    valrowlist.append(tsdic["min"])
    valrowlist.append(tsdic["avg"])
    valrowlist.append(tsdic["stddev"])
    valrowlist.append(csdic["max"])
    valrowlist.append(csdic["min"])
    valrowlist.append(csdic["avg"])
    valrowlist.append(csdic["stddev"])
    csvf.writerow(valrowlist)

def getFaidArtList(con, pub, apa, whp, minwh):
    # select count(id) from fullartids group by year, month, day
    # result is issuecount rows of article numbers per issue
    # use pythont to calculate max, min, etc.
    if whp == True:
        where = ""
        if minwh != "":
            where = " WHERE" + minwh
    else:
        # where = " WHERE tokenid LIKE '%s%%'" % (apa, )
        where = " WHERE fullartid LIKE '%s%%'" % (apa, )
        if minwh != "":
            where += " AND" + minwh
    # sql = "SELECT count(id) FROM tokens" + where
    # sql = "SELECT sum(tokencount) FROM fullartids" + where
    sql = "SELECT fullartid FROM fullartids" + where
    # print sql
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    rlx = [x[0] for x in rl]
    # tmpdic = {
    #           "numberofarticles" : sum(rlx),
    #           "max" : max(rlx),
    #           "min" : min(rlx),
    #           "avg" : sum(rlx)/rc
    #           }
    # print rl
    # print max(rlx), min(rlx), sum(rlx)/rc, sum(rlx), rlx
    # print rc
    # print rl[0][0]
    # print rc
    # return rl[0][0]
    # return rl[0]
    # return tmpdic
    return rlx

def compareFaidListSet(fl0802, fl0808):
    fresdic = {}
    fs0802 = set(fl0802)
    fs0808 = set(fl0808)
    fresdic["inboth"] = list(fs0802.intersection(fs0808))
    fresdic["in1notin2"] = list(fs0802.difference(fs0808))
    fresdic["in2notin1"] = list(fs0808.difference(fs0802))
    return fresdic

def compareFaidsInBoth(flist):
    for faid in flist:
        sql = "SELECT fullartid FROM fullartids" + where
        # print sql
        selobj = SqlResultList(con=con, sql=sql)
        rl = selobj.getRowTuple()
        rc = selobj.getRowCount()
        del selobj


def processOneArticlePath(ap, repf, csvf, opt, minwh, mininf):
    if '-' in ap:
        # hiercount = ap.count('-') + 1
        publ = ap.split('-')[0]
        wholepubl = False
    else:
        publ = ap
        wholepubl = True
        
    if publ not in publlist:
        print
        print "Publication name '%s' is not valid!" % (publ, )
        print
        sys.exit(2)

    dbpubl = publ.lower()
    dbname0802 = opt.dbpref + "0802_" + dbpubl
    dbname0808 = opt.dbpref + dbpubl
#    dbcon = setupMySQL(opt.dbhost, opt.dbport, dbname, opt.dbuser, opt.dbpass)
    inst = (0, "")
    try:
        dbcon0802 = setupMySQL(opt.dbhost, opt.dbport, dbname0802, opt.dbuser, opt.dbpass)
        dbcon0808 = setupMySQL(opt.dbhost, opt.dbport, dbname0808, opt.dbuser, opt.dbpass)

        faidlist0802 = getFaidArtList(dbcon0802, publ, ap, wholepubl, minwh)
        faidlist0808 = getFaidArtList(dbcon0808, publ, ap, wholepubl, minwh)
        print len(faidlist0802)
        print len(faidlist0808)
        cfldic = compareFaidListSet(faidlist0802, faidlist0808)

        print "IN BOTH:      ", len(cfldic["inboth"])
        print "IN 1 NOT IN 2:", len(cfldic["in1notin2"])
        # print "IN 1 NOT IN 2:", cfldic["in1notin2"]
        print "IN 2 NOT IN 1:", len(cfldic["in2notin1"])
        # print "IN 2 NOT IN 1:", cfldic["in2notin1"]

        compareFaidsInBoth(cfldic["inboth"])
        
        # for faid in faidlist0802:
        #     print faid
        # issuecount = getIssues(dbcon, publ, ap, wholepubl)
        # artstatdic = getArticleStats(dbcon, publ, ap, wholepubl, minwh)
        # tokcharlinedic = getNumbers(dbcon, publ, ap, wholepubl, minwh)
        # tokstatdic = getStats(dbcon, publ, ap, wholepubl, "token", minwh)
        # charstatdic = getStats(dbcon, publ, ap, wholepubl, "char", minwh)
        # linestatdic = getStats(dbcon, publ, ap, wholepubl, "line", minwh)
        #    print "AP:    ", ap
        #    print "PUBL:  ", publ
        #    print "DBNAME:", dbname
        #    print "ISSUES:", issuecount
        #    print "NO OF TOKENS:", tokcharlinedic
        #    print "TOKSTATS:", tokstatdic
        #    print "CHARSTATS:", charstatdic
        #    print "LINESTATS:", linestatdic
        # print "ARTSTATS:", artstatdic
        # print dbcon
#        printStats(repf,
#                   publ,
#                   ap,
#                   issuecount,
#                   tokcharlinedic,
#                   tokstatdic,
#                   charstatdic,
#                   linestatdic,
#                   artstatdic,
#                   mininf)
#        printStatsCsv(csvf,
#                   publ,
#                   ap,
#                   issuecount,
#                   tokcharlinedic,
#                   tokstatdic,
#                   charstatdic,
#                   linestatdic,
#                   artstatdic,
#                   mininf)

    except MySQLdb.OperationalError, inst:
        # print "error"
        # print type(inst)
        # print inst.args
        # print inst
        # print inst[0], type(inst[0]) 
        # sys.exit()
        repstr = "Report for publication: %s - article path: %s" % (publ, ap)
        PrintCF(repf, 1, "")
        PrintCF(repf, 1, repstr)
        PrintCF(repf, 1, "-" * len(repstr))
        PrintCF(repf, 1, "DB not found")
    # print "XXX", inst[0], type(inst[0])


def main(args):
    parser = OptionParser()
    parser.add_option("-d", "--dbpref", dest="dbpref", default = "ncsetoks_",
                      help="DB preface (DB name before publication name) - default: %default", metavar="DB")
    parser.add_option("-s", "--dbserver", dest="dbhost", default="localhost",
                      help="DB host - default: %default", metavar="HOST")
    parser.add_option("-P", "--port", dest="dbport", default=51524, type="int",
                      help="DB port - default: %default", metavar="PORT")
    parser.add_option("-u", "--user", dest="dbuser", default="ncse",
                      help="DB user - default: %default", metavar="USER")
    parser.add_option("-p", "--password", dest="dbpass", default="J0urnal",
                      help="DB password - default: ***", metavar="PW")
    parser.add_option("-o", "--outdir", dest="reportoutpath",
                      help="write report to toplevel directory DIR - default: %default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be processed (eg: 'LDR-1859-09-24-Ar02417') or 'ALL' for all publications - default: %default", metavar="PATH")
    parser.add_option("-c", "--minchars", dest="minchars", default=0, type="int",
                      help="only extract articles with a minimum length of CHARS characters - default: %default", metavar="CHARS")
    parser.add_option("-m", "--minlines", dest="minlines", default=0, type="int",
                      help="only extract articles with a minimum number of LINES lines - default: %default", metavar="LINES")
    (options, args) = parser.parse_args()
    if ((options.reportoutpath == None) or (options.articlepath == None)):
    # if ((options.dbname == None) or (options.reportoutpath == None) or (options.articlepath == None)):
        printUsage()
    if ((options.minchars > 0) and (options.minlines > 0)):
        print
        print "Options '-c (--minchars)'  and '-m (--minlines)' are mutually exclusive."
        print "        Use only one of these options."
        print
        sys.exit(2)
    reportoutpath = options.reportoutpath
    if not os.path.exists(reportoutpath):
        os.makedirs(reportoutpath, 0755)
    elif not os.path.isdir(reportoutpath):
        print
        print "Report output path '%s' exists, but is not a directory!" % (reportoutpath, )
        print
        sys.exit(2)
    articlepath = options.articlepath
    
    # minchars = options.minchars
    # minlines = options.minlines
    if options.minchars > 0:
        minwhereconstraint = " charcount > %d" % (options.minchars, )
        mininfo = "Information about articles of a minimum length of %d characters." % (options.minchars, )
    elif options.minlines > 0:
        minwhereconstraint = " linecount > %d" % (options.minlines, )
        mininfo = "Information about articles of a minimum length of %d lines." % (options.minlines, )
    else:
        minwhereconstraint = ""
        mininfo = "Information about articles without a minimum length restriction."

    repf = getRepfileObject(reportoutpath, articlepath, options)
    csvf = getCsvWriterObject(reportoutpath, articlepath, options)

    # option for ALL articles
    if articlepath.lower() == "all":
        for currarticlepath in publlist:
            processOneArticlePath(currarticlepath, repf, csvf, options, minwhereconstraint, mininfo)
    else:
        processOneArticlePath(articlepath, repf, csvf, options, minwhereconstraint, mininfo)


    repf.close()
    # csvf.close()

        


if __name__ == "__main__":
    main(sys.argv[1:])
