#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Fri 03.10.2008 15:25:43 BST gb>

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

# good example for bad OCR filter testing:
#    NSS-1840-02-01-Ad00216
#    NSS-1840-02-01-Ad00217
#    NSS-1837-12-02-Ad00105
#    NSS-1837-12-02-Ad00106 (now ha™ the)
#    LDR-1852-03-06-Ar00100
#    LDR-1852-03-06-Ar00101
#    LDR-1852-03-06-Ar00102


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

#print "ascii_letters"
#print string.ascii_letters
#print "letters"
#print string.letters
#print "printable"
#print string.printable
#print string.digits + string.letters + string.punctuation
#print "punct"
#print string.punctuation
#sys.exit()

reartid = re.compile(r"""^(?P<publ>(EWJ)|(LDR)|(MRP)|(NSS)|(TEC)|(TTW)|(FEWJ)|(FLDR)|(CLD)|(EMRP)|(FMRP)|(SMRP)|(SNSS)|(NS2)|(NS3)|(NS4)|(NS5)|(NS6)|(NS7)|(NS8)|(NS9)|(FTEC)|(TTEC)|(ATTW)|(ETTW)|(FTTW)|(SCLD)|(SLDR)|(SXLDR))-?(?P<year>18\d\d)?-?(?P<month>(0|1)\d)?-?(?P<day>(0|1|2|3)\d)?-?(?P<artid>(Ar|Ad)\d{5,8})?$""")

ldavocablist = []
validchars = string.ascii_letters + string.digits + ",.-/&'"

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
    print "   LDA         - output files needed for processing with LDA (XML format)"
    print
    print "   LUCFAID     - plain text, surrounded by lucene header and footer"
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

def filterBadOcr(tok, fbadocr):
    newtok = ""
    for t in tok:
        # if t in string.printable:
        if t in validchars:
            # print t
            newtok += t
        else:
            newtok += fbadocr
    # if tok != newtok:
    #     print "-" * 30
    #     print tok
    #     print newtok
    return newtok
    # return tok

def filterTokensForTypesList(token):
    typlist = []
    # if fdoit == True:
    for token in toklist:
        # ftoken = filterBadOcr(token, fbadocr)
        # token = re.sub("[0-9]", "", token)
        token = re.sub("[^A-Za-z]", "", token)
        token = token.strip(string.punctuation)
        # if dtoken != token:
        #     print ">%20s< >%20s<" % (token, dtoken)
        if len(token) > 0:
            typlist.append(token)
    return typlist
    

def formatArticleAsCluto(rl, faid, fdoit, fbadocr):
    arttext = ""
    faid = faid.replace("-", "")
    arttext += "%s " % (faid, )
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (tokenid, token, spaceaftertoken, artlineno, specialtype) = r
        if fdoit == True:
            token = filterBadOcr(token, fbadocr)
        arttext += token + spaceaftertoken
    return arttext

def formatArticleAsTmsk(rl, faid, fdoit, fbadocr):
    arttext = ""
    arttext += "<DOC>\n"
    arttext += "<ARTID>%s</ARTID>\n" % (faid, )
    arttext += "<TEXT>\n"
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (tokenid, token, spaceaftertoken, artlineno, specialtype) = r
        if fdoit == True:
            token = filterBadOcr(token, fbadocr)
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

def formatArticleAsTxt(rl, faid, fmt, fdoit, fbadocr):
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
        if fdoit == True:
            token = filterBadOcr(token, fbadocr)
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

def formatArticleAsXmlGate(rl, faid, fdoit, fbadocr):
    arttext = ""
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (tokenid, token, spaceaftertoken, artlineno, specialtype) = r
        if fdoit == True:
            token = filterBadOcr(token, fbadocr)
        if artlineno == prevartlineno:
            arttext += '<token tokenid="' + tokenid + '">' + token + '</token>' + spaceaftertoken
        else:
            if prevartlineno == 0:
                arttext += '<token tokenid="' + tokenid + '">' + token + '</token>' + spaceaftertoken
            else:
                arttext += "\n" + '<token tokenid="' + tokenid + '">' + token + '</token>' + spaceaftertoken
        prevartlineno = artlineno
    return arttext

def formatArticleAsXml(rl, faid, fmt, fdoit, fbadocr):
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
        if fdoit == True:
            token = filterBadOcr(token, fbadocr)
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

def formatArticleAsLucene(rl, faid, fmt, fdoit, fbadocr):
    # "XMLFAID", "XMLFTOKENID", "XMLSTOKENID"
    lucheader = """<?xml version="1.0" encoding="UTF-8"?>
<lucene-document xmlns="http://www.cch.kcl.ac.uk/xmlns/ereuna" id="%s">
  <header>
     <tei/>
  </header>
  <fields>
     <field indexed="un-tokenized" name="id" stored="yes" vector="no">%s</field>
     <field indexed="tokenized" name="text" stored="yes" vector="no">
"""
    lucfooter = """</field>
  </fields>
</lucene-document>
"""
    arttext = lucheader % (faid, faid)
    # arttext += "<DOC>\n"
    # arttext += "<ARTID>%s</ARTID>\n" % (faid, )
    # arttext += "<TEXT>\n"
    # arttext += "<artid>%s</artid>\n" % (faid, )
        
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (ftokenid, token, spaceaftertoken, artlineno, specialtype) = r
        # print "-" * 30
        # print type(token), token
        # token = token.decode("cp1252")
        # print type(token)
        if fdoit == True:
            token = filterBadOcr(token, fbadocr)
        token = escapeInvalidXmlChars(token)
        # token = token.encode("cp1252")
        # print type(token), token
        if artlineno == prevartlineno:
            arttext += token + spaceaftertoken
        else:
            if prevartlineno == 0:
                arttext += token + spaceaftertoken
            else:
                arttext += "\n" + token + spaceaftertoken
        prevartlineno = artlineno
    arttext += "\n"
    # arttext += "</TEXT>\n"
    # arttext += "</DOC>"
    arttext += lucfooter
    return arttext

def formatArticleAsLda(rl, faid, fmt, fdoit, fbadocr, stwlist):
    global ldavocablist
    (publ, year, month, day, aid) = faid.split("-")
    outlogmsg = os.path.join(publ)
    if outlogmsg not in logmsgdic:
        logmsgdic[outlogmsg] = 1
    else:
        logmsgdic[outlogmsg] += 1
    # "XMLFAID", "XMLFTOKENID", "XMLSTOKENID"
    arttext = ""
    arttext += "<DOC>\n"
    arttext += "<ARTID>%s</ARTID>\n" % (faid, )
    arttext += "<TEXT>\n"
    # arttext += "<artid>%s</artid>\n" % (faid, )
    artdat = ""
    
    typerdoclist = []
    typerdocdic = {}    
    artlineno = 0
    prevartlineno = 0
    for r in rl:
        (ftokenid, token, spaceaftertoken, artlineno, specialtype) = r
        # print "-" * 30
        # print type(token), token
        # token = token.decode("cp1252")
        # print type(token)
        if fdoit == True:
            token = filterBadOcr(token, fbadocr)
        # token = escapeInvalidXmlChars(token)
        # token = token.encode("cp1252")
        # print type(token), token
        if artlineno == prevartlineno:
            arttext += token + spaceaftertoken
        else:
            if prevartlineno == 0:
                arttext += token + spaceaftertoken
            else:
                arttext += "\n" + token + spaceaftertoken
        # handle types list
        token = re.sub("[^A-Za-z]", "", token)
        token = token.strip(string.punctuation)
        token = token.lower()
        # if dtoken != token:
        #     print ">%20s< >%20s<" % (token, dtoken)
        if len(token) > 0:
            if not token in stwlist:
                if not token in ldavocablist:
                    ldavocablist.append(token)
                if not token in typerdoclist:
                    typerdoclist.append(token)
                    # typerdocdic.setdefault(token, 0)
                    # typerdocdic[token] += 1
                if typerdocdic.has_key(token):
                    typerdocdic[token] += 1
                else:
                    typerdocdic[token] = 1
        # tylist = filterTokensForTypesList(token)
        prevartlineno = artlineno
    # print typerdocdic
    arttext += "\n"
    arttext += "</TEXT>\n"
    arttext += "</DOC>"
    artdat += "%d" % (len(typerdoclist))
    for ty in typerdoclist:
        tyvocabpos = ldavocablist.index(ty)
        tytermfreq = typerdocdic[ty]
        artdat += " %d:%d" % (tyvocabpos, tytermfreq)
    # print artdat 
    return arttext, artdat

def getStopWordList(swfp):
    stwlist = []
    swfobj = file(swfp, "r")
    for sw in swfobj:
        sw = sw.strip()
        stwlist.append(sw)
    return stwlist

def getArticle(con, faidid, faid, format, fdoit, fbadocr, stwlist):
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
    if format.startswith("TXT"):
        arttext = formatArticleAsTxt(rl, faid, format, fdoit, fbadocr)
        newtylist = []
    elif format.startswith("XML"):
        arttext = formatArticleAsXml(rl, faid, format, fdoit, fbadocr)
        newtylist = []
    elif format.startswith("LUC"):
        arttext = formatArticleAsLucene(rl, faid, format, fdoit, fbadocr)
        newtylist = []
    elif format == "CLUTO":
        arttext = formatArticleAsCluto(rl, faid, fdoit, fbadocr)
        newtylist = []
    elif format == "TMSK":
        arttext = formatArticleAsTmsk(rl, faid, fdoit, fbadocr)
        newtylist = []
    elif format == "LDA":
        arttext, artdat = formatArticleAsLda(rl, faid, format, fdoit, fbadocr, stwlist)
        # print uniqueperdoc
    # for nt in newtylist:
    #     print ">" + nt + "<"
        
    # print len(newtylist)    
    # fullartid = tokenid[:tokenid.rindex("-")]
    # print tokenid, token
    # print fullartid

    return arttext, artdat
    
def getTypesFromTokenDb(con, ap, fdoit, fbadocr):
    # fnamelist = ("token", )
    # tablelist = ("tokens", )
    # where     = "tokenid like '%s%%'" % (ap, )
    # # orderlist = ("arttokenno", )
    # selobj = SqlSelectList(con=con,
    #                        distinct=True,
    #                        fields=fnamelist,
    #                        tables=tablelist,
    #                        where=where)
    # print selobj.getSqlString()
    # rl = selobj.getRowList()
    # rc = selobj.getRowCount()
    # # print tokenlist
    # print "RC:", rc
    # del selobj

    sql = "SELECT DISTINCT lower(token) FROM tokens WHERE tokenid like '%s%%'" % (ap, )
    selobj = SqlResultList(con=con,sql=sql)
    print selobj.getSqlString()
    rl = selobj.getRowList()
    rc = selobj.getRowCount()
    print "RC:", rc
    del selobj
    
    tokenlist = []
    # if fdoit == True:
    for tokenl in rl:
        token = tokenl[0]
        # ftoken = filterBadOcr(token, fbadocr)
        # token = re.sub("[0-9]", "", token)
        token = re.sub("[^A-Za-z]", "", token)
        token = token.strip(string.punctuation)
        # if dtoken != token:
        #     print ">%20s< >%20s<" % (token, dtoken)
        if len(token) > 0:
            tokenlist.append(token)
    return tokenlist


def writeArticle(text, cop, faid, hier, fmt):
    outdir = ""
    fileoutpath = ""
    if fmt.startswith("TXT"):
        ext = ".txt"
    elif fmt.startswith("XML"):
        ext = ".xml"
    elif fmt.startswith("LUC"):
        ext = ".xml"
    elif fmt.startswith("CLUTO"):
        ext = ".raw"
    elif fmt.startswith("TMSK"):
        ext = ".xml"
    elif fmt.startswith("LDA"):
        ext = ".txt"
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

def writeLdaArticles(text, cop, faid, hier, fmt, ap):
    outdir = ""
    fileoutpath = ""
    ext = ".txt"
    # fileoutname = faid + ext
    fileoutname = ap + ext
    (publ, year, month, day, aid) = faid.split("-")
    outdir = os.path.join(cop, publ)
    # outlogmsg = os.path.join(publ)
    if not os.path.exists(outdir):
        os.makedirs(outdir, 0755)
    elif not os.path.isdir(outdir):
        print
        print "Corpus output path '%s' exists, but is not a directory!" % (outdir, )
        print
        sys.exit(2)
    fileoutpath = os.path.join(outdir, fileoutname)
    # if outlogmsg not in logmsgdic:
    #     logmsgdic[outlogmsg] = 1
    # else:
    #     logmsgdic[outlogmsg] += 1
    # print "Writing article to:", fileoutpath
    outfileobj = file(fileoutpath, "w")
    # print >> outfileobj, text
    # print >> outfileobj, text.encode("utf-8")
    print >> outfileobj, text,
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
    
def writeLdaDat(dat, cop, faid, hier, fmt, ap):
    outdir = ""
    fileoutpath = ""
    ext = ".dat"
    # fileoutname = faid + ext
    fileoutname = ap + ext
    (publ, year, month, day, aid) = faid.split("-")
    outdir = os.path.join(cop, publ)
    # outlogmsg = os.path.join(publ)
    if not os.path.exists(outdir):
        os.makedirs(outdir, 0755)
    elif not os.path.isdir(outdir):
        print
        print "Corpus output path '%s' exists, but is not a directory!" % (outdir, )
        print
        sys.exit(2)
    fileoutpath = os.path.join(outdir, fileoutname)
    # if outlogmsg not in logmsgdic:
    #     logmsgdic[outlogmsg] = 1
    # else:
    #     logmsgdic[outlogmsg] += 1
    outfileobj = file(fileoutpath, "w")
    # print >> outfileobj, text
    # print >> outfileobj, text.encode("utf-8")
    print >> outfileobj, dat,
    # print >> outfileobj, text.encode("cp1252")
    # print >> outfileobj, text.encode("latin1")
    # print >> outfileobj, text.decode("utf-8")
    # outfileobj.write(text + "\n")
    outfileobj.close()


def writeLdaVocab(cop, faid, ap):
    global ldavocablist
    outdir = ""
    fileoutpath = ""
    ext = ".txt"
    # fileoutname = faid + ext
    fileoutname = ap + "_vocab" + ext
    (publ, year, month, day, aid) = faid.split("-")
    outdir = os.path.join(cop, publ)
    # outlogmsg = os.path.join(publ)
    if not os.path.exists(outdir):
        os.makedirs(outdir, 0755)
    elif not os.path.isdir(outdir):
        print
        print "Corpus output path '%s' exists, but is not a directory!" % (outdir, )
        print
        sys.exit(2)
    fileoutpath = os.path.join(outdir, fileoutname)
    # if outlogmsg not in logmsgdic:
    #     logmsgdic[outlogmsg] = 1
    # else:
    #     logmsgdic[outlogmsg] += 1
    outfileobj = file(fileoutpath, "w")
    # print >> outfileobj, text
    # print >> outfileobj, text.encode("utf-8")
    for ty in ldavocablist:
        print >> outfileobj, ty
    # print >> outfileobj, text.encode("cp1252")
    # print >> outfileobj, text.encode("latin1")
    # print >> outfileobj, text.decode("utf-8")
    # outfileobj.write(text + "\n")
    outfileobj.close()


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
    parser.add_option("-o", "--outdir", dest="corpusoutpath",
                      help="write output to toplevel directory DIR - default: %default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be extracted ('LDR-1859-09-24-Ar02417') - default: %default", metavar="PATH")
    parser.add_option("-f", "--format", dest="outformat",
                      type="choice", choices=["TXT", "TXTHDR", "TXTSEMTAG", "XMLFAID", "XMLFTOKENID", "XMLSTOKENID", "LDA", "LUCFAID", "CLUTO", "TMSK", "HELP", "help", "?"], default="HELP",
                      help="format of output files: 'TXT', 'TXTHDR', 'TXTSEMTAG', 'XMLFAID', 'XMLFTOKENID', 'XMLSTOKENID', 'LDA', 'LUCFAID', 'CLUTO', 'TMSK') - type '-f HELP' or '-f ?' for an explanation of the options - default: %default", metavar="FORMAT")
    parser.add_option("-l", "--outhier", dest="outhier",
                      type="choice", choices=["publ", "year", "month", "day"], default="publ",
                      help="how deeply nested output directories should be created ('publ', 'year', 'month', 'day') - default: %default", metavar="HIER")
    parser.add_option("-c", "--minchars", dest="minchars", default=0, type="int",
                      help="only extract articles with a minimum length of CHARS characters - default: %default", metavar="CHARS")
    parser.add_option("-m", "--minlines", dest="minlines", default=0, type="int",
                      help="only extract articles with a minimum number of LINES lines - default: %default", metavar="LINES")
    parser.add_option("-r", "--filter-bad-ocr", dest="filterbadocr", type="string",
                      help="do not output 'unprintable' characters, if they are part of a word, replace with character given as argument - default: %default", metavar="FILTERCHAR")
    (options, args) = parser.parse_args()
    if ((options.dbname == None) or (options.corpusoutpath == None) or (options.articlepath == None)):
        if ((options.outformat == "?") or (options.outformat.lower() == "help")):
            printOutformat()
        else:
            printUsage()
    if ((options.minchars > 0) and (options.minlines > 0)):
        print
        print "Options '-c (--minchars)'  and '-m (--minlines)' are mutually exclusive."
        print "        Use only one of these options."
        print
        sys.exit(2)
    dbcon = setupMySQL(options)
    corpusoutpath = options.corpusoutpath
    if not os.path.exists(corpusoutpath):
        os.makedirs(corpusoutpath, 0755)
    elif not os.path.isdir(corpusoutpath):
        print
        print "Corpus output path '%s' exists, but is not a directory!" % (corpusoutpath, )
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
    filterbadocr = options.filterbadocr
    # if (filterbadocr == "") and (filterbadocr != None):
    #     print
    #     print 'Option "filter-bad-ocr", but no replacement character provided.'
    #     print
    #     sys.exit(2)
    if filterbadocr == None:
        filterdoit = False
    else:
        filterdoit = True
        
    repf = getRepfileObject(corpusoutpath, articlepath)
    logmsgdic = {}
    
    (ddir, commandline) = os.path.split(sys.argv[0])
    commandline += " "
    commandline += " ".join(sys.argv[1:])
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Command line used:")
    PrintCF(repf, 1, commandline)
    PrintCF(repf, 1, "")
    
    if minchars > 0:
        whereconstraint = " AND charcount > %d" % (minchars, )
        outminimum = "Articles extracted have a minimum length of %d characters." % (minchars, )
    elif minlines > 0:
        whereconstraint = " AND linecount > %d" % (minlines, )
        outminimum = "Articles extracted have a minimum length of %d lines." % (minlines, )
    else:
        whereconstraint = ""
        outminimum = "Articles extracted with no minimum length restriction."
    print "Getting list of articles ..."
    fullartidslist = getFullArtIds(dbcon, articlepath, whereconstraint)
    print "Extracting and writing articles ..."
    ldaarticles = ""
    ldadat = ""
    typeslist = []
    if outformat == "LDA":
        stopwordfilepath = "/local/nltk//data/corpora/stopwords/english"
        stopwordlist = getStopWordList(stopwordfilepath)
    for (id, fullartid, tokencount, charcount, charnscount, linecount) in fullartidslist:
        articletext, articledat = getArticle(dbcon, id, fullartid, outformat, filterdoit, filterbadocr, stopwordlist)
        if outformat == "LDA":
            ldaarticles += articletext + "\n"
            ldadat += articledat + "\n"
        else:
            writeArticle(articletext, corpusoutpath, fullartid, outhier, outformat)
    if outformat == "LDA":
        writeLdaArticles(ldaarticles, corpusoutpath, fullartid, outhier, outformat, articlepath)
        writeLdaDat(ldadat, corpusoutpath, fullartid, outhier, outformat, articlepath)
        writeLdaVocab(corpusoutpath, fullartid, articlepath)
        # typeslist = getTypesFromTokenDb(dbcon, articlepath, filterdoit, filterbadocr)

    logmsglist = logmsgdic.keys()
    logmsglist.sort()

    if outhier == "publ":
        outhiertmpl = "PUBL/"
    elif outhier == "year":
        outhiertmpl = "PUBL/YEAR/"
    elif outhier == "month":
        outhiertmpl = "PUBL/YEAR/MONTH/"
    elif outhier == "day":
        outhiertmpl = "PUBL/YEAR/MONTH/DAY/"

    # PrintCF(repf, 1, "")
    # PrintCF(repf, 1, "Command line used:")
    # PrintCF(repf, 1, commandline)
    # PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Article path extracted: %s" % (articlepath, ))
    PrintCF(repf, 1, "Output format type:     %s" % (outformat, ))
    PrintCF(repf, 1, outminimum)
    PrintCF(repf, 1, "Template of output directory structure: %s" % (outhiertmpl, ))
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
    # PrintCF(repf, 1, "STRING.PRINTABLE:")
    # PrintCF(repf, 1, string.printable)
    # PrintCF(repf, 1, "STRING.PUNCT:")
    # PrintCF(repf, 1, string.punctuation)
    # PrintCF(repf, 1, "STRING.A_LETTERS:")
    # PrintCF(repf, 1, string.ascii_letters)
    # PrintCF(repf, 1, "STRING.DIGITS:")
    # PrintCF(repf, 1, string.digits)
    
    print "--== FINISHED ==--"

