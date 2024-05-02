#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Wed 26.03.2008 12:50:01 GMT gb>

# TODO: sort year, month, day lists

import sys
import string
import re
import socket
import platform
import time
import types
import os, os.path
import shutil

from optparse import OptionParser

# import bygetconfigparse
# from xml.etree import ElementTree as ET
# from lxml import etree as ET
from bymysqlmap import *

reartid = re.compile(r"""^(?P<publ>(EWJ)|(LDR)|(MRP)|(NSS)|(TEC)|(TTW)|(FEWJ)|(FLDR)|(CLD)|(EMRP)|(FMRP)|(SMRP)|(SNSS)|(NS2)|(NS3)|(NS4)|(NS5)|(NS6)|(NS7)|(NS8)|(NS9)|(FTEC)|(TTEC)|(ATTW)|(ETTW)|(FTTW))-?(?P<year>18\d\d)?-?(?P<month>(0|1)\d)?-?(?P<day>(0|1|2|3)\d)?-?(?P<artid>(Ar|Ad)\d{5,8})?$""")

semtagsfieldnamelist = []
semtagnamesfieldnamelist = []
fullartidsfieldnamelist = []
llhvfieldnamelist = []
semtagsalfieldnamelist = []

htmlleafindexlist = []

llhvdic = {}

fullartididsdic = {}

# URL API
# arguments:
# 1: publ
# 2: year
# 3: month
# 4: day
# 5: article id
# to use in format string use ":::" instead of original "%"
urlapitempl = 'http://137.73.123.44/KingsCollege/Default.htm?href=%s%%2F%s%%2F%s%%2F%s&entityid=%s&view=entity'

htmlheader = """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="generator" content="NCSE" />
<link rel="stylesheet" href="%scss/semtags.css" type="text/css" />
<title>%s</title>
</head>
<body>
"""
htmlfooter = """
</body>
</html>
"""
semtagscss = """body {
  margin: 1em 5% 1em 5%;
}

a {
  color: navy;
  text-decoration: underline;
}
a:visited {
  color: purple;
}

em {
  font-style: italic;
}

strong {
  font-weight: bold;
}

tt {
  color: #29694a;
}

h1, h2, h3, h4, h5, h6 {
  color: #29694a;
  font-family: sans-serif;
/*  font-family: serif; */
  margin-top: 1.2em;
  margin-bottom: 0.5em;
  line-height: 1.3;
}

/*
h1, h2, h3 {
  border-bottom: 2px solid silver;
}
h2 {
  padding-top: 0.5em;
}
h3 {
  float: left;
}
h3 + * {
  clear: left;
}
*/

h1, h2, h3, h4, h5, h6 {
  border-top: 2px solid silver;
  border-bottom: 2px solid silver;
  border-left: 2px solid silver;
  border-right: 2px solid silver;
  padding-top: 0.5em;
  padding-bottom: 0.4em;
  padding-left: 0.4em;
  padding-right: 0.4em;
/*  background-color: #eeeee4; */
  background: #d4e2b5;
}
/*
h2 {
  padding-top: 0.5em;
}
*/
/*
h3 {
  float: left;
}
h3 + * {
  clear: left;
}
*/
h1 {
  font-size: 26px;
}

h2 {
  font-size: 22px;
}

h3 {
  font-size: 18px;
}

h4 {
  font-size: 16px;
}

h5 {
  font-size: 14px;
}

h5 {
  font-size: 12px;
}

body {
  font-family: sans-serif;
/*  font-family: serif; */
/*  margin-left: 0; */
}

div.sectionbody {
  font-family: sans-serif;
/*  font-family: serif; */
  margin-left: 0;
}

hr {
  border: 1px solid silver;
}

li {
  margin-top: 0.5em;
  margin-bottom: 0.5em;
}

p {
  margin-top: 0.5em;
  margin-bottom: 0.5em;
}

pre {
  padding: 0;
  margin: 0;


faid {
  font-family: monospace, sans-serif;
}

vplink {
  background-color:olive;
}

stlink {
  background-color:navy;
}

oclink {
  background-color:red;
}

td {
  padding-left:3em;
  padding-right:3em;
}
"""

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-i', '-o', '-d' and '-a'"
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

def prepLogs(cop, pu):
    """Prepare log file directories."""
    logdir = os.path.join(cop, "00_LOGS", pu)
    # if not os.path.exists(logdir):
    #     os.makedirs(logdir, 0755)
    print logdir

def writeBadPublIndexReportAndExit(posstr, type, h, semop, pubrp, pubrplist):
    PrintCF(repf, 1, "INDEX ERROR IN PUBLRELPATHLIST - NO INDEX '%s'" % (posstr, ))
    PrintCF(repf, 1, "  trying to get '%s' from 'publrelpathlist'" % (type, ))
    PrintCF(repf, 1, "HTMLLEAFINDEXFILE: %s" % (h, ))
    PrintCF(repf, 1, "SEMTAGOUTPATH: %s" % (semop, ))
    PrintCF(repf, 1, "PUBLRELPATH: %s" % (pubrp, ))
    PrintCF(repf, 1, "PUBLRELPATHLIST: %s" % (pubrplist, ))
    PrintCF(repf, 1, "")
    sys.exit()

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

def makeHtmlDir(indir, outdir, wroot):
    htmloutdir = wroot.replace(indir, outdir)
    # print "HTML", htmloutdir
    if not os.path.exists(htmloutdir):
        os.makedirs(htmloutdir, 0755)
    return htmloutdir

def writeNodeIndexHtml(flist, htdir):
    currpos = htdir.replace(semtagoutpath, "")
    csspos = currpos.count("/")
    currpos = currpos[1:]
    currpos = currpos.replace("/", " ")
    outfile = os.path.join(htdir, "index.html")
    outfileobj = file(outfile, "w")
    header = htmlheader % ("../" * csspos, "NCSE semantic tagger evaluation")
    print >> outfileobj, header
    print >> outfileobj, "<h1>%s</h1>" % (currpos, )
    print >> outfileobj, '<p>'
    print >> outfileobj, '<a href="../index.html">UP</a>'
    print >> outfileobj, '</p>'
    print >> outfileobj, '<p>'
    print >> outfileobj, "<ul>"
    for f in flist:
        # print "FLIST", flist
        # print >> outfileobj, "<li>%s</li>" % (faid, )
        # urlapi = urlapitempl % tuple(faid.split("-"))
        # print "<li>" + urlapi + "</li>"
        # print >> outfileobj, '<li>%s <a href="%s">ViewPoint</a></li>' % (faid, urlapi)
        ipath = os.path.join(f, "index.html")
        # disppath = "%s %s" % (currpos, f[0]) 
        disppath = "%s" % (f, ) 
        print >> outfileobj, '<li><a href="%s">%s</a></li>' % (ipath, disppath) 
    print >> outfileobj, "</ul>"
    print >> outfileobj, '</p>'
    print >> outfileobj, htmlfooter
    outfileobj.close()
    htmlleafindexlist.append(outfile)
    PrintCF(repf, 1, outfile)

def writeOcrTextHtml(flist, htdir):
    for faid in flist:
        ocrfile = faid + ".html"
        ocrfilepath = os.path.join(htdir, ocrfile)
        ocrfileobj = file(ocrfilepath, "w")
        ocrfileobj.close()

def getSemTagsFromDb(faid, con):
    # sql = " select rank, semtag, semtaglong, llh from semtags where fullartid = 'EWJ-1860-08-01-Ar01802' order by rank;"
    fnamelist = ("rank", "semtag", "semtaglong", "llh")
    tablelist = ("semtags", )
    where     = "fullartid = '%s'" % (faid, )
    orderlist = ("rank", )
    selobj = SqlSelectList(con=con,
                           fields=fnamelist,
                           tables=tablelist,
                           where=where,
                           order=orderlist)
    # print selobj.getSqlString()
    rl = selobj.getRowList()
    # print rl
    # print "RC:", selobj.getRowCount()
    del selobj
    return rl

def writeLeafHtmlFiles(flist, htdir, indir, con):
    currpos = htdir.replace(semtagoutpath, "")
    csspos = currpos.count("/")
    currpos = currpos[1:]
    currpos = currpos.replace("/", " ")
    outfile = os.path.join(htdir, "index.html")
    outfileobj = file(outfile, "w")
    header = htmlheader % ("../" * csspos, "NCSE semantic tagger evaluation")
    upstr = '<a href="../index.html">&nbsp;UP&nbsp;</a>'
    helptagsetstr = '<a href="%sdoc/semtags.html" target="_blank">&nbsp;TAGSET&nbsp;</a>' % ("../" * csspos, )
    helptagsetpdfstr = '<a href="%sdoc/USASSemanticTagset.pdf" target="_blank">&nbsp;TAGSET (PDF)&nbsp;</a>' % ("../" * csspos, )
    helptagsetguidestr = '<a href="%sdoc/usas_guide.pdf" target="_blank">&nbsp;TAGSET GUIDE (PDF)&nbsp;</a>' % ("../" * csspos, )
    print >> outfileobj, header
    print >> outfileobj, "<h1>%s</h1>" % (flist[0][:-11], )
    print >> outfileobj, '<p>'
    # print >> outfileobj, upstr
    uplinenav = '<h4>%s &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; %s / %s / %s</h4>' % (upstr, helptagsetstr, helptagsetpdfstr, helptagsetguidestr)
    print >> outfileobj, uplinenav
    print >> outfileobj, '</p>'
    print >> outfileobj, '<p>'
    # print >> outfileobj, "<ul>"
    print >> outfileobj, '<table>'
    print >> outfileobj, '<tr>'
    print >> outfileobj, '<th>Article ID</th><th>ViewPoint</th><th>Semantic tags</th><th>OCR text</th><th>no. of chars</th>'
    print >> outfileobj, '</tr>'
    for faid in flist:
        ocrinfile = faid + ".txt"
        ocrinfilepath = os.path.join(indir, ocrinfile)
        ocrinfileobj = file(ocrinfilepath, "r")
        ocrinfilecontent = ocrinfileobj.read()
        ocrinfileobj.close()
        ocrfilesize = len(ocrinfilecontent)
        urlapi = urlapitempl % tuple(faid.split("-"))
        faidstr         = '%s' % (faid, )
        viewpointstr    = '<a href="%s" target="_blank">ViewPoint</a>' % (urlapi, )
        semtagtextstr   = '<a href="%s-SemTag.html" target="_blank">Semantic tags</a>' % (faid, )
        ocrtextstr      = '<a href="%s.html" target="_blank">OCR text</a>' % (faid, )
        ocrsizestr      = '%s' % (ocrfilesize, )
        # print >> outfileobj, '<li>%s %s %s %s</li>' % (viewpointstr, semtagtextstr, ocrtextstr, ocrfilesize) 
        print >> outfileobj, '<tr>'
        print >> outfileobj, '<td class="faid">%s</td><td class="vplink">%s</td><td class="stlink">%s</td><td class="oclink">%s</td><td class="ocsize">%s</td>' % (faidstr, viewpointstr, semtagtextstr, ocrtextstr, ocrfilesize) 
        print >> outfileobj, '</tr>'
        ocroutfile = faid + ".html"
        ocroutfilepath = os.path.join(htdir, ocroutfile)
        ocroutfileobj = file(ocroutfilepath, "w")
        semtaghtmloutfile = faid + "-SemTag.html"
        semtaghtmloutfilepath = os.path.join(htdir, semtaghtmloutfile)
        semtaghtmloutfileobj = file(semtaghtmloutfilepath, "w")
        print >> ocroutfileobj, header
        print >> ocroutfileobj, "<h1>%s</h1>" % (faid, )
        print >> ocroutfileobj, '<p>'
        upline = '<h4>%s / %s / %s</h4>' % (upstr, viewpointstr, semtagtextstr)
        print >> ocroutfileobj, upline
        print >> ocroutfileobj, '</p>'
        print >> ocroutfileobj, '<pre>'
        print >> ocroutfileobj, ocrinfilecontent
        print >> ocroutfileobj, '</pre>'
        print >> ocroutfileobj, htmlfooter
        ocroutfileobj.close()
        print >> semtaghtmloutfileobj, header
        print >> semtaghtmloutfileobj, "<h1>%s</h1>" % (faid, )
        upstr = '<a href="index.html">UP</a>'
        # upline = '<h4>%s / %s / %s</h4>' % (upstr, viewpointstr, ocrtextstr)
        upline = '<h4>%s / %s / %s &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; %s / %s / %s</h4>' % (upstr, viewpointstr, ocrtextstr, helptagsetstr, helptagsetpdfstr, helptagsetguidestr)
        print >> semtaghtmloutfileobj, upline
        print >> semtaghtmloutfileobj, '<p>'
        print >> semtaghtmloutfileobj, '<table>'
        print >> semtaghtmloutfileobj, '<tr>'
        print >> semtaghtmloutfileobj, '<th>Rank</th><th align="left">SemTag</th><th align="left">SemTag Label</th><th>LLH</th><th>Significance level</th>'
        print >> semtaghtmloutfileobj, '</tr>'
        semtagslist = getSemTagsFromDb(faid, con)
        oddevencounter = 0
        for semtags in semtagslist:
            oddevencounter += 1
            (rank, semtag, semtaglong, llh) = semtags
            if llh >= 15.13:
                degofconf = "ninenineninenine"
                percentile = "99.99"
            elif llh >= 10.83:
                degofconf = "nineninenine"
                percentile = "99.9&nbsp;"
            elif llh >= 6.63:
                degofconf = "ninenine"
                percentile = "99&nbsp;&nbsp;&nbsp;"
            elif llh >= 3.84:
                degofconf = "ninefive"
                percentile = "95&nbsp;&nbsp;&nbsp;"
            else:
                degofconf = "underninefive"
                percentile = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
            rowstr = '<td class="rank">%i</td><td>%s</td><td>%s</td><td class="llh">%5.2f</td><td class="%s">%s</td>'
            rowstr = rowstr % (rank, semtag, semtaglong, llh, degofconf, percentile)
            if oddevencounter % 2 == 0:
                print >> semtaghtmloutfileobj, '<tr class="treven">'
            else:
                print >> semtaghtmloutfileobj, '<tr class="trodd">'
            print >> semtaghtmloutfileobj, rowstr
            print >> semtaghtmloutfileobj, '</tr>'
            
        print >> semtaghtmloutfileobj, '</table>'
        print >> semtaghtmloutfileobj, '</p>'
        print >> semtaghtmloutfileobj, htmlfooter
        semtaghtmloutfileobj.close()
        # urlapi = urlapitempl % tuple(faid.split("-"))
        # viewpointstr    = '%s <a href="%s" target="_blank">ViewPoint</a>' % (faid, urlapi)
        # semtagtextstr   = '<a href="%s-SemTag.html" target="_blank">Semantic tags</a>' % (faid, )
        # ocrtextstr      = '<a href="%s.html" target="_blank">OCR text</a>' % (faid, )
        # print >> outfileobj, '<li>%s %s %s</li>' % (viewpointstr, semtagtextstr, ocrtextstr) 
    print >> outfileobj, '</table>'
    # print >> outfileobj, "</ul>"
    print >> outfileobj, '</p>'
    print >> outfileobj, '<p>'
    # print >> outfileobj, '<a href="../index.html">UP</a>'
    print >> outfileobj, uplinenav
    print >> outfileobj, '</p>'
    print >> outfileobj, htmlfooter
    outfileobj.close()
    htmlleafindexlist.append(outfile)

def processCorpusFileBlock(p, htmldir, fl, con):
    faidlist = []
    for f in fl:
        fullsemtaginpath = os.path.join(p, f)
        fullartid = f[:-4]
        faidlist.append(fullartid)
        print fullartid
    writeLeafHtmlFiles(faidlist, htmldir, p, con)

def processSemtagOutput(seminpath, semoutpath, artpath, con):
    seminbasepath = os.path.join(seminpath, artpath)
    for walkroot, walkdirs, walkfiles in os.walk(seminbasepath):
        # print "WR", walkroot
        # print "WD", walkdirs
        # print "WF", walkfiles
        nooffiles = 0
        corpusfilelist = []
        # semtagsfilelist = []
        # propernamesfilelist = []
        if walkfiles != []:
            # print "WALKROOT:", walkroot
            currhtmldir = makeHtmlDir(seminpath, semoutpath, walkroot)
            for wf in walkfiles:
                if wf.endswith("_keydomains.txt"):
                    # semtagsfilelist.append(wf)
                    # nooffiles += 1
                    pass
                elif wf.endswith("_propernames.txt"):
                    # propernamesfilelist.append(wf)
                    pass
                elif wf.endswith(".txt"):
                    corpusfilelist.append(wf)
                    # copysrc = os.path.join(walkroot, wf)
                    # copytarget = os.path.join(currhtmldir, wf)
                    # shutil.copy(copysrc, currhtmldir)
                    # os.chmod(copytarget, 0644)
                    nooffiles += 1
            # TODO: test if same number: original corpus files,
            #       semtagsfiles, propernamesfiles 
            # print len(semtagsfilelist)
            # print len(propernamesfilelist)
            # print len(corpusfilelist)
            # processKeyDomainsFileBlock(walkroot, semtagsfilelist, con)
            # processProperNamesFileBlock(walkroot, propernamesfilelist, con)
            corpusfilelist.sort()
            processCorpusFileBlock(walkroot, currhtmldir, corpusfilelist, con)

        outlogmsg = os.path.join(walkroot)
        if outlogmsg not in logmsgdic:
            logmsgdic[outlogmsg] = nooffiles
        else:
            logmsgdic[outlogmsg] += nooffiles
            

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
    parser.add_option("-o", "--outdir", dest="semtagoutpath",
                      help="write output to toplevel directory DIR - no default", metavar="DIR")
    parser.add_option("-i", "--indir", dest="semtaginpath",
                      help="read from directory DIR, containing semtag output files in further subdirectories - no default", metavar="DIR")
    parser.add_option("-a", "--articlepath", dest="articlepath",
                      help="Path of article to be extracted ('LDR', 'LDR-1859', or 'LDR-1859-09-24-Ar02417') - no default", metavar="PATH")
    (options, args) = parser.parse_args()
    # if ((options.semtaginpath == None) or (options.semtagoutpath == None) or (options.articlepath == None)):
    #     printUsage()
    if ((options.semtaginpath == None) or (options.semtagoutpath == None) or (options.dbname == None) or (options.articlepath == None)):
        printUsage()
    dbcon = setupMySQL(options)
    semtaginpath = options.semtaginpath
    semtagoutpath = options.semtagoutpath
    semtagcsspath = os.path.join(semtagoutpath, "css")
    # semtaglogpath = os.path.join(semtagoutpath, "log")
    semtaglogpath = semtagoutpath + "/../log"
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
    if not os.path.exists(semtagoutpath):
        print
        print "Semtag output path '%s' does not exist!" % (semtagoutpath, )
        print
        sys.exit(2)
    elif not os.path.isdir(semtagoutpath):
        print
        print "Semtag output path '%s' exists, but is not a directory!" % (semtagoutpath, )
        print
        sys.exit(2)
    if not os.path.exists(semtaglogpath):
        print
        print "Creating semtag log path '%s'." % (semtaglogpath, )
        print
        os.makedirs(semtaglogpath, 0755)
    elif not os.path.isdir(semtaglogpath):
        print
        print "Semtag log path '%s' exists, but is not a directory!" % (semtaglogpath, )
        print
        sys.exit(2)
    # if not os.path.exists(semtagcsspath):
    #     print
    #     print "Creating semtag css path '%s'." % (semtagcsspath, )
    #     print
    #     os.makedirs(semtagcsspath, 0755)
    # elif not os.path.isdir(semtagcsspath):
    #     print
    #     print "Semtag css path '%s' exists, but is not a directory!" % (semtagcsspath, )
    #     print
    #     sys.exit(2)
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

    # cssfilepath = os.path.join(semtagcsspath, "semtags.css")
    # cssfileobj = file(cssfilepath, "w")
    # print >> cssfileobj, semtagscss
    # cssfileobj.close()
    
    # write command line to report file before anything else happens
    # so we have the commandline as reference in case a crash happens
    writeReportCommandLine()
    
    articlefilepath = articlepath.replace("-", "/")
    processSemtagOutput(semtaginpath, semtagoutpath, articlefilepath, dbcon)

    writeReport(articlepath)

    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Write node index files")
    PrintCF(repf, 1, "----------------------")
    PrintCF(repf, 1, "")

    # for k in llhvdic.keys():
    #     (prev, curr) = llhvdic[k]
    #     if curr.startswith("-"):
    #         print k, prev, curr
    htmlleafindexlist.sort()
    monthdic = {}
    yearlist = []
    for h in htmlleafindexlist:
        # print h
        publrelpath = h.replace(semtagoutpath, "")
        publrelpath = publrelpath[1:]
        publrelpathlist = publrelpath.split("/")
        try:
            year = publrelpathlist[-3]
        except IndexError:
            writeBadPublIndexReportAndExit("-3", "year", h, semtagoutpath, publrelpath, publrelpathlist)
        try:
            publ = publrelpathlist[-4]
        except IndexError:
            writeBadPublIndexReportAndExit("-4", "publ", h, semtagoutpath, publrelpath, publrelpathlist)
            
        if monthdic.has_key(year):
            try:
                # monthdic[year].append(publrelpathlist[-2:])
                monthdic[year].append(publrelpathlist[-2])
            except IndexError:
                writeBadPublIndexReportAndExit("-2", "month", h, semtagoutpath, publrelpath, publrelpathlist)
        else:
            try:
                # monthdic[year] = [publrelpathlist[-2:]]
                monthdic[year] = [publrelpathlist[-2]]
            except IndexError:
                writeBadPublIndexReportAndExit("-2", "month", h, semtagoutpath, publrelpath, publrelpathlist)
    yearlist = monthdic.keys()
    yearlist.sort()
    # for y in monthdic.keys():
    for y in yearlist:
        # yearlist.append(y)
        # print y
        htdir = os.path.join(semtagoutpath, publ, y)
        writeNodeIndexHtml(monthdic[y], htdir)
        # for m in monthdic[y]:
        #     print m
        # print monthdic
    htdir = os.path.join(semtagoutpath, publ)
    writeNodeIndexHtml(yearlist, htdir)
    # for y in yearlist:
    #     print y
        
    # print semtagoutpath
    print "--== FINISHED ==--"
