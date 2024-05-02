#!/usr/bin/env python
# -*- coding: utf-8 -*-

# FMRP-1822-12-02: free standing image
# TTW-1867-06-01: free standing image on p. 43 (olive page no. 5)
# TEC-1889-12-16 p. 20: image embedded within article
# NSS-1837-12-16 p. 2: image embedded within article

# TODO: change the way image metadata are read
#       to account for cases like TEC-1889-12-16 p. 1
#          image metadata in Ar00100.xml (image in title page)
#          but no embedding information, i. e. no corresponding
#          Pc file exists
#          

import sys
import string

import re
import socket
import platform
import time
import types
import os, os.path
import bygetconfig
import bytocfile
import byzipfile
import byarttext
from bymysqlmap import *

from prxml_extract_metadata_fields import *

# from zipfile import *
# from xml.etree import ElementTree as ET
from lxml import etree as ET
# from StringIO import StringIO
# from byutil import *
# from bymysqlmap import *
from optparse import OptionParser

reartid = re.compile(r"""^(?P<publ>(EWJ)|(LDR)|(MRP)|(NSS)|(TEC)|(TTW)|(FEWJ)|(FLDR)|(CLD)|(EMRP)|(FMRP)|(SMRP)|(SNSS)|(NS2)|(NS3)|(NS4)|(NS5)|(NS6)|(NS7)|(NS8)|(NS9)|(FTEC)|(TTEC)|(ATTW)|(ETTW)|(FTTW)|(SCLD)|(SLDR)|(SXLDR))-?(?P<year>18\d\d)?-?(?P<month>(0|1)\d)?-?(?P<day>(0|1|2|3)\d)?-?(?P<artid>(Ar|Ad)\d{5,8})?$""")

imgmetadatafieldnamelist = []

entvaljoinstr = '::'



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

def getRepfileObject(slp, ap):
    repfiledir = slp
    repfilefile = ap + "-metadata"
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

# escape MySQL control characters
def MySQLEscape(s):
    s = s.replace("\\", "\\\\")
    s = s.replace("\t", "\\t")
    s = s.replace('"', '\\"')
    s = s.replace("'", "\\'")
    return s

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
    # initFieldNames(mycon)
    return mycon

def normaliseMetaDataKey(k):
    # pageentattlist
    # artmetadatalist
    if k[0] in string.ascii_uppercase:
        k = k.lower()
        k = "o_" + k
    elif k[2] == ":":
        k = k.replace(":", "_")
        k = "n_" + k
    return k

def writeToFullartidsTable(dbcon, aemddic):
    fnlist = []
    fvlist = []
    faid = aemddic.get("c_toc_meta_fullartid", '')
    # siblingids = aemddic.get("c_toc_enty_siblingids", '')
    # print faid, siblingids
    (publ, year, month, day, xartid) = faid.split("-")
    fnlist.append("fullartid")
    faid = MySQLEscape(faid)
    fvlist.append(faid)
    fnlist.append("publ")
    publ = MySQLEscape(publ)
    fvlist.append(publ)
    fnlist.append("year")
    year = MySQLEscape(year)
    fvlist.append(year)
    fnlist.append("month")
    month = MySQLEscape(month)
    fvlist.append(month)
    fnlist.append("day")
    day = MySQLEscape(day)
    fvlist.append(day)
    fnlist.append("artid")
    xartid = MySQLEscape(xartid)
    fvlist.append(xartid)
    for k in fullartidfieldslist:
        l = aemddic.get(k, '')
        if type(l) == types.ListType:
            l = entvaljoinstr.join(l)
        fnlist.append(k)
        l = MySQLEscape(l)
        fvlist.append(l)
    # print fnlist
    # print fvlist
    fvlist = ["'" + f + "'" for f in fvlist]
    # print faid
    # print fvlist
    insobj = SqlInsert(con=dbcon, 
                       table="fullartids", 
                       fieldnames=fnlist, 
                       fieldvalues=fvlist)
    # print insobj.getInsertString()
    tid = insobj.getLastRowId()
    del insobj

def normaliseImgDesc(l):
    s = entvaljoinstr.join(l)
    return s

def writeToAllmetadataTable(dbcon, aemddic):
    fnlist = []
    fvlist = []
    for k in mdfieldlist3:
        l = aemddic.get(k, '')
        # if k in listformatfields:
        #     l = normaliseImgDesc(l)
        if type(l) == types.ListType:
            l = entvaljoinstr.join(l)
        # print k, ":", l
        fnlist.append(k)
        l = MySQLEscape(l)
        fvlist.append(l)
    fvlist = ["'" + f + "'" for f in fvlist]
    # print fvlist
    insobj = SqlInsert(con=dbcon, 
                       table="allmetadata", 
                       fieldnames=fnlist, 
                       fieldvalues=fvlist)
    # print insobj.getInsertString()
    tid = insobj.getLastRowId()
    del insobj

def processReposFiles(reposinpath, artpath, con):
    reposinbasepath = os.path.join(reposinpath, artpath)
    for walkroot, walkdirs, walkfiles in os.walk(reposinbasepath):
        # print "WR", walkroot
        # print "WD", walkdirs
        # print "WF", walkfiles
        nooffiles = 0
        corpusfilelist = []
        semtagsfilelist = []
        propernamesfilelist = []
        if walkfiles != []:
            # for wf in walkfiles:
            PrintCF(repf, 1, "%s" % (walkroot, ))
            currzip = byzipfile.ByZipFile(walkroot, walkfiles)
            if currzip.errzipfilepath != "":
                PrintCF(repf, 1, "!" * 40)
                PrintCF(repf, 1, "   ZIP file %s corrupt." % (currzip.errzipfilepath, ))
                PrintCF(repf, 1, "!" * 40)
                PrintCF(repf, 1, "-" * 40)
                del currzip
                continue
            if currzip.nonreposfile != "":
                continue
            PrintCF(repf, 1, "   ZIP file %s opened." % (currzip.getZipFileName(), ))
            currtoc = bytocfile.ByTocFile(walkroot)
            numberolivepublname = currtoc.getTocFileMetaPublName()
            numberolivemetadatadic = currtoc.getTocFileHeadMetaData()
            numberncsemetadatadic = currtoc.getTocFileApplicationDataMetaData()
            currtoc.getEntityRefsForExtractMetaData()
            # print "NUMBER - OLIVE PUBL NAME:", numberolivepublname
            # print "NUMBER - OLIVE METADATA:  ", numberolivemetadatadic
            # print "NUMBER - NCSE METADATA:  ", numberncsemetadatadic
            PrintCF(repf, 1, "   TOC file read.")
            PrintCF(repf, 1, "   Processing article:")
            (artrefslist, artrefsdic) = currtoc.getArticleRefs()
            # print artrefsdic
            # 
            # code
            for artid in artrefslist:
                # print artid, artrefsdic[artid]
                for eid in artrefsdic[artid]:
                    allentitymetadatadic = {}
                    picart = byarttext.ByArticleText(eid, artrefsdic, currtoc, currzip, confvarsdic)
                    # picart.processArticleMetaData()
                    # fullartid = newart.buildFullArticleId(artid)
                    fullartid = picart.fullarticleid
                    allentitymetadatadic["c_toc_meta_fullartid"] = picart.fullarticleid
                    allentitymetadatadic["c_toc_enty_entityid"] = eid
                    allentitymetadatadic["c_toc_enty_articleid"] = artid
                    allentitymetadatadic["c_toc_enty_siblingids"] = entvaljoinstr.join(artrefsdic[artid])
                    # allentitymetadatadic["c_toc_meta_publname"] = numberolivepublname.encode("utf-8")
                    allentitymetadatadic["c_toc_meta_publname"] = numberolivepublname
                    # allentitymetadatadic["o_wordcnt"] = picart.artolivewordcount
                    for nom in numberolivemetadatadic.keys():
                        entvalstr = numberolivemetadatadic[nom]
                        entvalstr = entvalstr.encode("utf-8")
                        # bykey = normaliseMetaDataKey(nom)
                        allentitymetadatadic[nom] = entvalstr
                    for nnm in numberncsemetadatadic.keys():
                        entvalstr = entvaljoinstr.join(numberncsemetadatadic[nnm])
                        # entvalstr = entvalstr.encode("utf-8")
                        # bykey = normaliseMetaDataKey(nnm)
                        allentitymetadatadic[nnm] = entvalstr
                    if len(currtoc.entityrefsmetadic[eid]) != 0:
                        # print currtoc.entityrefsmetadic[eid]
                        for aom in currtoc.entityrefsmetadic[eid].keys():
                            entvalstr = currtoc.entityrefsmetadic[eid][aom]
                            # print "------------------ %30s" % (aom, ), type(entvalstr)
                            # entvalstr = entvalstr.encode("utf-8")
                            # bykey = normaliseMetaDataKey(aom)
                            allentitymetadatadic[aom] = entvalstr
                    artncsemetadatadic = picart.getArtFileApplicationDataMetaData(eid)
                    if len(artncsemetadatadic) != 0:
                        for anm in artncsemetadatadic.keys():
                            # entvalstr = entvaljoinstr.join(artncsemetadatadic[anm])
                            entvalstr = artncsemetadatadic[anm]
                            #entvalstr = entvalstr.encode("utf-8")
                            # bykey = normaliseMetaDataKey(anm)
                            allentitymetadatadic[anm] = entvalstr
                            
                    # print "=" * 70
                    # allentitymetadatalistsorted = allentitymetadatadic.keys()
                    # allentitymetadatalistsorted.sort()
                    # for k in allentitymetadatalistsorted:
                    
                    # for k in mdfieldlist1:
                        # print "       %-40s : %s" % (k, allentitymetadatadic[k])
                        # print "       %-40s : %s" % (k, allentitymetadatadic.get(k, ''))
                    #     if k not in allentitymetadatalist:
                    #         print k
                    # 
#                    for (k, f) in allentitymetadatalist:
#                        if k in allentitymetadatadic:
#                            print "       %50s : %s" % (k, allentitymetadatadic[k])
#                        else:
#                            print "       %50s : %s" % (k, "")
#                            pass
                    #     if k not in allentitymetadatadic:
                    #         print k

                    ### FULLARTIDS
                    if eid == artid:
                        writeToFullartidsTable(con, allentitymetadatadic) 
                    writeToAllmetadataTable(con, allentitymetadatadic)
            # 
            del currzip
            del currtoc

    
        # prepare log messages
        outlogmsg = os.path.join(walkroot)
        if outlogmsg not in logmsgdic:
            logmsgdic[outlogmsg] = nooffiles
        else:
            logmsgdic[outlogmsg] += nooffiles
        # print walkroot

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
    confvarsdic = {}
    confvarsdic["corpusimagebasedir"] = "/projects/cch/ncse/olive/corpusimg/TEST"
    # confvarsdic["generatecorpusimages"] = True
    confvarsdic["generatecorpusimages"] = False
    confvarsdic["generatearttext"] = True
    # 
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
    parser.add_option("-i", "--indir", dest="reposinpath",
                      help="read repository from directory DIR, containing subdirectories of the form 'LDR', etc. - no default", metavar="DIR")
    parser.add_option("-l", "--logdir", dest="logdir",
                      help="write log file to directory DIR - no default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be extracted ('LDR-1859-09-24-Ar02417') - no default", metavar="PATH")
    (options, args) = parser.parse_args()
    # if ((options.semtaginpath == None) or (options.semtagoutpath == None) or (options.articlepath == None)):
    #     printUsage()
    if ((options.reposinpath == None) or (options.dbname == None) or (options.articlepath == None) or (options.logdir == None)):
        printUsage()
    dbcon = setupMySQL(options)
    # dbcon = None # for testing without DB
    reposinpath = options.reposinpath
    logpath = options.logdir
    if not os.path.exists(reposinpath):
        print
        print "Repository input path '%s' does not exist!" % (reposinpath, )
        print
        sys.exit(2)
    elif not os.path.isdir(reposinpath):
        print
        print "Repository input path '%s' exists, but is not a directory!" % (reposinpath, )
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
    repf = getRepfileObject(logpath, articlepath)
    logmsgdic = {}
    errorlogdic = {}

    # write command line to report file before anything else happens
    # so we have the commandline as reference in case a crash happens
    writeReportCommandLine()
    
    articlefilepath = articlepath.replace("-", "/")
    processReposFiles(reposinpath, articlefilepath, dbcon)

    writeReport(articlepath)

    print "--== FINISHED ==--"
