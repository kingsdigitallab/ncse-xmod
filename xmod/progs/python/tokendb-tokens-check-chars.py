#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Wed 05.03.2008 18:20:22 GMT gb>

# ATTENTION - TO BE CHECKED!!!
#   introduced into the XML output for GATE:
#   filtering of invalid XML characters "&", "<", ">"
#   CHECK IN GATE if it still finds organisations like
#      "Bradford & Bingley"
#   or if the rules have to be adapted to use "&amp;"
#  
# TODO: fix character encoding
# TODO: if "minchars" or "minlines" is used, include in LOG file a
#       count of number of articles/files actually written

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

charcntdic = {}
charorddic = {}

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-d' and '-a'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)

def printOutformat():
    #                       help="format of output files: 'TXT' (plain text), 'TXTHDR (plain text with artid header)', 'TXTSEMTAG' (plain text with WMatrix header and escapes), 'XMLFAID' (XML <DOC>, <ARTID>, <TEXT> header, XML escapes), 'XMLFTOKENID', 'XMLSTOKENID', 'CLUTO', 'TMSK') - default: %default", metavar="FORMAT")
    print
    print "Format of output files:"
    print
    print "   TXT         - plain text"
    print "                 no escapes"
    print
    print "   TXTHDR      - plain text"
    print "                 no escapes"
    print "                 header: <artid>XXX</artid>"
    print
    print "   TXTSEMTAG   - plain text"
    print "                 WMatrix escapes (&amp;, &pound;, &eacute;, &lt;, &gt;"
    print "                                  &lsqb;, &rsqb;, &bquo;, &equo;"
    print "                 text enclosed in: <wmtext>XXX</wmtext>"
    print
    print "   all XML based output has the following in common:"
    print "                 text enclosed in:"
    print "                    <DOC>"
    print "                    <ARTID>XXX</ARTID>"
    print "                    <TEXT>"
    print "                    XXX"
    print "                    </TEXT>"
    print "                 escaped:"
    print "                    &amp;, &lt;, &gt;"
    print
    print "   XMLFAID     - plain text"
    print
    print "   XMLFTOKENID - plain text"
    print '                 each token enclosed in: <ftoken ftokenid="XXX">XXX</ftokenid>'
    print '                 ftokenid = full article id ("LDR-1859-09-24-Ar02417")'
    print
    print "   XMLSTOKENID - plain text"
    print '                 each token enclosed in: <stoken stokenid="XXX">XXX</stokenid>'
    print '                 stokenid = full article id ("Ar02417")'
    print
    print "   CLUTO       - plain text"
    print "                 output for CLUTO clusterer"
    print "                 one big file containing all the documents, each one"
    print "                 preceded by full article id"
    print
    print "   TMSK        - plain text"
    print "                 output for TMSK program"
    print "                 output identical to XMLFAID, but text not escaped"
    print
    sys.exit(2)

def getRepfileObject(cop, ap):
    repfiledir = cop
    repfilefile = "CHECK-CHARS-"
    repfilefile += ap
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

def escapeInvalidXmlChars(t):
    t = t.replace("&", "&amp;")
    # t = t.replace(chr(163), "&pound;")
    # t = t.replace(chr(233), "&eacute;")
    t = t.replace("<", "&lt;")
    t = t.replace(">", "&gt;")
    # t = t.replace("[", "&lsqb;")
    # t = t.replace("]", "&rsqb;")
    # t = t.replace("`", "&bquo;")
    # t = t.replace("'", "&equo;")
    return t


def getFullArtIds(con, artpath, whconstr):
    # print "Getting list of articles ..."
    # sqlartids = "SELECT DISTINCT(artid) FROM tokens WHERE "
    sqlfullartids = "SELECT id, fullartid, tokencount, charcount, charnscount, linecount FROM fullartids WHERE "
    sqlwhere = "fullartid LIKE '%s%%'" % (artpath, )
    sqlwhere += whconstr
    # sqlorder = " ORDER BY publ, year, month, day, artid, arttokenno"
    sqlorder = " ORDER BY fullartid"
    
    # sqlartids += sqlwhere
    # sqlarts += sqlwhere + sqlorder
    sqlfullartids += sqlwhere + sqlorder
    
    # print sqlartids
    # print sqlarts
    # print sqlfullartids
    selobj = SqlResultList(con=con, sql=sqlfullartids)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    # print rl
    # print rc
    # fullartidslist = [r[0] for r in rl]
    # print fullartidslist
    # return fullartidslist
    return rl

def formatArticleAsCluto(rl, faid):
    arttext = ""
    faid = faid.replace("-", "")
    arttext += "%s " % (faid, )
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (tokenid, token, spaceaftertoken, artlineno, specialtype) = r
        arttext += token + spaceaftertoken
    return arttext

def formatArticleAsTmsk(rl, faid):
    arttext = ""
    arttext += "<DOC>\n"
    arttext += "<ARTID>%s</ARTID>\n" % (faid, )
    arttext += "<TEXT>\n"
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (tokenid, token, spaceaftertoken, artlineno, specialtype) = r
        if artlineno == prevartlineno:
            arttext += token + spaceaftertoken
        else:
            if prevartlineno == 0:
                arttext += token + spaceaftertoken
            else:
                arttext += "\n" + token + spaceaftertoken
        prevartlineno = artlineno
    arttext += "\n"
    arttext += "</TEXT>\n"
    arttext += "</DOC>"
    return arttext

def formatArticleAsTxt(rl, faid, fmt):
    arttext = ""
    if fmt == "TXTHDR":
        arttext += "<artid>%s</artid>\n" % (faid, )
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (tokenid, token, spaceaftertoken, artlineno, specialtype) = r
	# token = token.encode("utf-8")
	# ----------------
	# BY: check if this really works
	# ----------------
	# token = token.encode("latin1")
	# spaceaftertoken = spaceaftertoken.encode("latin1")
	# token = token.encode("utf-8")
	# spaceaftertoken = spaceaftertoken.encode("utf-8")
	# ----------------
        if artlineno == prevartlineno:
            arttext += token + spaceaftertoken
        else:
            if prevartlineno == 0:
                arttext += token + spaceaftertoken
            else:
                arttext += "\n" + token + spaceaftertoken
        prevartlineno = artlineno
    if fmt == "TXTSEMTAG":
        arttext = arttext.replace("&", "&amp;")
        arttext = arttext.replace(chr(163), "&pound;")
        arttext = arttext.replace(chr(233), "&eacute;")
        arttext = arttext.replace("<", "&lt;")
        arttext = arttext.replace(">", "&gt;")
        arttext = arttext.replace("[", "&lsqb;")
        arttext = arttext.replace("]", "&rsqb;")
        arttext = arttext.replace("`", "&bquo;")
        arttext = arttext.replace("'", "&equo;")
        arttext = "<wmtext>\n" + arttext
        if arttext.endswith("\n"):
            arttext = arttext + "</wmtext>\n"
        else:
            arttext = arttext + "\n</wmtext>\n"
    return arttext

def formatArticleAsXmlGate(rl, faid):
    arttext = ""
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (tokenid, token, spaceaftertoken, artlineno, specialtype) = r
        if artlineno == prevartlineno:
            arttext += '<token tokenid="' + tokenid + '">' + token + '</token>' + spaceaftertoken
        else:
            if prevartlineno == 0:
                arttext += '<token tokenid="' + tokenid + '">' + token + '</token>' + spaceaftertoken
            else:
                arttext += "\n" + '<token tokenid="' + tokenid + '">' + token + '</token>' + spaceaftertoken
        prevartlineno = artlineno
    return arttext

def formatArticleAsXml(rl, faid, fmt):
    # "XMLFAID", "XMLFTOKENID", "XMLSTOKENID"
    arttext = ""
    arttext += "<DOC>\n"
    arttext += "<ARTID>%s</ARTID>\n" % (faid, )
    arttext += "<TEXT>\n"
    # arttext += "<artid>%s</artid>\n" % (faid, )
        
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (ftokenid, token, spaceaftertoken, artlineno, specialtype) = r
        # print "-" * 30
        # print type(token), token
        # token = token.decode("cp1252")
        # print type(token)
        token = escapeInvalidXmlChars(token)
        # token = token.encode("cp1252")
        # print type(token), token
        stokenid = ftokenid[-7:]
        if fmt == "XMLFTOKENID":
            pretokenstr = '<ftoken ftokenid="' + ftokenid + '">'
            posttokenstr = '</ftoken>'
        elif fmt == "XMLSTOKENID":
            pretokenstr = '<stoken stokenid="' + stokenid + '">'
            posttokenstr = '</stoken>'
        else:
            pretokenstr = ''
            posttokenstr = ''
        if artlineno == prevartlineno:
            arttext += pretokenstr + token + posttokenstr + spaceaftertoken
        else:
            if prevartlineno == 0:
                arttext += pretokenstr + token + posttokenstr + spaceaftertoken
            else:
                arttext += "\n" + pretokenstr + token + posttokenstr + spaceaftertoken
        prevartlineno = artlineno
    arttext += "\n"
    arttext += "</TEXT>\n"
    arttext += "</DOC>"
    return arttext

def processCharStats(rl, faid):
    # "XMLFAID", "XMLFTOKENID", "XMLSTOKENID"
    # arttext = ""
    # arttext += "<DOC>\n"
    # arttext += "<ARTID>%s</ARTID>\n" % (faid, )
    # arttext += "<TEXT>\n"
    # arttext += "<artid>%s</artid>\n" % (faid, )
    
    # print string.punctuation
    # print string.printable
    
    outlogmsg = "XXX"
    if outlogmsg not in logmsgdic:
        logmsgdic[outlogmsg] = 1
    else:
        logmsgdic[outlogmsg] += 1

    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (ftokenid, token, spaceaftertoken, artlineno, specialtype) = r
        # print token
        for ch in token:
            if ch not in string.printable:
                chord = ord(ch)
                if charcntdic.has_key(chord):
                    charcntdic[chord] += 1
                else:
                    charcntdic[chord] = 1
                    charorddic[chord] = ch 
                # print "XXXXXXXXXXXXXXXXXXXX >>" + ch + "<<"
                # print ord(ch)
    # return arttext

def getArticle(con, faidid, faid):
    # arttext = ""
    fnamelist = ("tokenid", "token", "spaceaftertoken", "artlineno", "specialtype")
    tablelist = ("tokens", )
    where     = "fullartidid = %d" % (faidid, )
    orderlist = ("arttokenno", )
    selobj = SqlSelectList(con=con,
                           fields=fnamelist,
                           tables=tablelist,
                           where=where,
                           order=orderlist)
    # print selobj.getSqlString()
    rl = selobj.getRowList()
    # print tokenlist
    # print "RC:", selobj.getRowCount()
    del selobj
#    artlineno = 0
#    prevartlineno = 0
#    for r in rl:
#        (tokenid, token, spaceaftertoken, artlineno, specialtype) = r
#
#        if artlineno == prevartlineno:
#            arttext += token + spaceaftertoken
#        else:
#            if prevartlineno == 0:
#                arttext += token + spaceaftertoken
#            else:
#                arttext += "\n" + token + spaceaftertoken
#        prevartlineno = artlineno

    arttext = processCharStats(rl, faid)
    # fullartid = tokenid[:tokenid.rindex("-")]
    # print tokenid, token
    # print fullartid

    return arttext
    

def writeArticle(text, cop, faid, hier, fmt):
    outdir = ""
    fileoutpath = ""
    if fmt.startswith("TXT"):
        ext = ".txt"
    elif fmt.startswith("XML"):
        ext = ".xml"
    elif fmt.startswith("CLUTO"):
        ext = ".raw"
    elif fmt.startswith("TMSK"):
        ext = ".xml"
    fileoutname = faid + ext
    (publ, year, month, day, aid) = faid.split("-")
    if hier == "publ":
        outdir = os.path.join(cop, publ)
        outlogmsg = os.path.join(publ)
    elif hier == "year":
        outdir = os.path.join(cop, publ, year)
        outlogmsg = os.path.join(publ, year)
    elif hier == "month":
        outdir = os.path.join(cop, publ, year, month)
        outlogmsg = os.path.join(publ, year, month)
    elif hier == "day":
        outdir = os.path.join(cop, publ, year, month, day)
        outlogmsg = os.path.join(publ, year, month, day)
    if not os.path.exists(outdir):
        os.makedirs(outdir, 0755)
    elif not os.path.isdir(outdir):
        print
        print "Corpus output path '%s' exists, but is not a directory!" % (outdir, )
        print
        sys.exit(2)
    fileoutpath = os.path.join(outdir, fileoutname)
    if outlogmsg not in logmsgdic:
        logmsgdic[outlogmsg] = 1
    else:
        logmsgdic[outlogmsg] += 1
    # print "Writing article to:", fileoutpath
    outfileobj = file(fileoutpath, "w")
    # print >> outfileobj, text
    # print >> outfileobj, text.encode("utf-8")
    print >> outfileobj, text
    # print >> outfileobj, text.encode("cp1252")
    # print >> outfileobj, text.encode("latin1")
    # print >> outfileobj, text.decode("utf-8")
    # outfileobj.write(text + "\n")
    outfileobj.close()
    # print publ, year, month, day, aid
    # print cop
    # print hier
    # print outdir
    # print fileoutpath


if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-d", "--dbname", dest="dbname",
                      help="DB name - default: %default", metavar="DB")
    parser.add_option("-s", "--dbserver", dest="dbhost", default="localhost",
                      help="DB host - default: %default", metavar="HOST")
    parser.add_option("-P", "--port", dest="dbport", default=51524, type="int",
                      help="DB port - default: %default", metavar="PORT")
    parser.add_option("-u", "--user", dest="dbuser", default="gbrey",
                      help="DB user - default: %default", metavar="USER")
    parser.add_option("-p", "--password", dest="dbpass", default="Ujs92ila",
                      help="DB password - default: ***", metavar="PW")
    # parser.add_option("-o", "--outdir", dest="corpusoutpath",
    #                   help="write output to toplevel directory DIR - default: %default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be extracted ('LDR-1859-09-24-Ar02417') - default: %default", metavar="PATH")
    # parser.add_option("-f", "--format", dest="outformat",
    #                   type="choice", choices=["TXT", "TXTHDR", "TXTSEMTAG", "XMLFAID", "XMLFTOKENID", "XMLSTOKENID", "CLUTO", "TMSK", "HELP", "help", "?"], default="HELP",
    #                   help="format of output files: 'TXT', 'TXTHDR', 'TXTSEMTAG', 'XMLFAID', 'XMLFTOKENID', 'XMLSTOKENID', 'CLUTO', 'TMSK') - type '-f HELP' or '-f ?' for an explanation of the options - default: %default", metavar="FORMAT")
    # parser.add_option("-l", "--outhier", dest="outhier",
    #                   type="choice", choices=["publ", "year", "month", "day"], default="publ",
    #                   help="how deeply nested output directories should be created ('publ', 'year', 'month', 'day') - default: %default", metavar="HIER")
    # parser.add_option("-c", "--minchars", dest="minchars", default=0, type="int",
    #                   help="only extract articles with a minimum length of CHARS characters - default: %default", metavar="CHARS")
    # parser.add_option("-m", "--minlines", dest="minlines", default=0, type="int",
    #                   help="only extract articles with a minimum number of LINES lines - default: %default", metavar="LINES")
    (options, args) = parser.parse_args()
    if ((options.dbname == None) or (options.articlepath == None)):
        printUsage()
    dbcon = setupMySQL(options)
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
    repf = getRepfileObject("./logs", articlepath)
    logmsgdic = {}
    
    (ddir, commandline) = os.path.split(sys.argv[0])
    commandline += " "
    commandline += " ".join(sys.argv[1:])
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Command line used:")
    PrintCF(repf, 1, commandline)
    PrintCF(repf, 1, "")
    
    print "Getting list of articles ..."
    whereconstraint = ""
    fullartidslist = getFullArtIds(dbcon, articlepath, whereconstraint)
    # print "Extracting and writing articles ..."
    print "Counting non-printable characters ..."
    for (id, fullartid, tokencount, charcount, charnscount, linecount) in fullartidslist:
        getArticle(dbcon, id, fullartid)
        # writeArticle(articletext, corpusoutpath, fullartid, outhier, outformat)

    logmsglist = logmsgdic.keys()
    logmsglist.sort()

    # if outhier == "publ":
    #     outhiertmpl = "PUBL/"
    # elif outhier == "year":
    #     outhiertmpl = "PUBL/YEAR/"
    # elif outhier == "month":
    #     outhiertmpl = "PUBL/YEAR/MONTH/"
    # elif outhier == "day":
    #     outhiertmpl = "PUBL/YEAR/MONTH/DAY/"

    # PrintCF(repf, 1, "")
    # PrintCF(repf, 1, "Command line used:")
    # PrintCF(repf, 1, commandline)
    # PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Article path extracted: %s" % (articlepath, ))
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
    PrintCF(repf, 1, "  Ord   Char     Frequency")
    PrintCF(repf, 1, "-" * 26)
    # print charorddic
    # print charcntdic
    charordlist = charorddic.keys()
    charordlist.sort()
    for chord in charordlist:
        # print chord, charorddic[chord], charcntdic[chord]
        PrintCF(repf, 1, "% 5i %5s      % 8i" % (chord, charorddic[chord], charcntdic[chord]))
    
    print "--== FINISHED ==--"

