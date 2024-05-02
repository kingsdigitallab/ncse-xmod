#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import string

import re
import socket
import platform
import time
import types
import os, os.path
from byutil import *
# from bymysqlmap import *
# from xml.etree import ElementTree as ET
# from lxml import etree as ET
from optparse import OptionParser

indir = "/projects/cch/ncse/lucene-similarity/similarity"
outdir = "/projects/cch/ncse/lucene-similarity/simluceval"
# for OCR text use text files generated for semtag
semtagindir = "/projects/cch/ncse/semtagprocessed/txt"

htmlleafindexlist = []

retotal = re.compile(r"""found (\d+) similar documents""")
totallinestart = "found"
rescoremin = re.compile(r"""only displaying the ones with score >= (.+)""")
scoreminlinestart = "only"

# depth of HTML directory hierarchy
#   2 = publ, year
htmldepth = 2

urlapitempl = 'http://137.73.123.44/KingsCollege/Default.htm?href=%s%%2F%s%%2F%s%%2F%s&entityid=%s&view=entity'

validpublidlist = [
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
                   ]

htmlheader = """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="generator" content="NCSE" />
<link rel="stylesheet" href="%scss/simeval.css" type="text/css" />
<title>%s</title>
</head>
<body>
"""
htmlfooter = """
</body>
</html>
"""
simevalcss = """body {
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

def makeHtmlDir(aic, hd):
    # htmloutdir = wroot.replace(indir, outdir)
    # print "HHHHHHHHHHHHHHHHHHHHHHH", aic
    reldir = ""
    for n in range(hd+1):
        # print "NNNNNNNNNNNNNNNNNN", n
        # print aic, n, aic[n]
        reldir = os.path.join(reldir, aic[n])
    htmloutdir = os.path.join(outdir, reldir) 
    print "HTML", htmloutdir
    if not os.path.exists(htmloutdir):
        os.makedirs(htmloutdir, 0755)
    return htmloutdir


def writeLeafHtmlFiles(faid, flist, htdir, indir):
    # currpos = htdir.replace(semtagoutpath, "")
    currpos = htdir.replace(outdir, "")
    csspos = currpos.count("/")
    currpos = currpos[1:]
    currpos = currpos.replace("/", " ")
    outfile = os.path.join(htdir, "index.html")
    outfileobj = file(outfile, "w")
    header = htmlheader % ("../" * csspos, "NCSE semantic tagger evaluation")
    upstr = '<a href="../index.html">&nbsp;UP&nbsp;</a>'
    # helptagsetstr = '<a href="%sdoc/semtags.html" target="_blank">&nbsp;TAGSET&nbsp;</a>' % ("../" * csspos, )
    # helptagsetpdfstr = '<a href="%sdoc/USASSemanticTagset.pdf" target="_blank">&nbsp;TAGSET (PDF)&nbsp;</a>' % ("../" * csspos, )
    # helptagsetguidestr = '<a href="%sdoc/usas_guide.pdf" target="_blank">&nbsp;TAGSET GUIDE (PDF)&nbsp;</a>' % ("../" * csspos, )
    print >> outfileobj, header
    print >> outfileobj, "<h1>%s</h1>" % (faid, )
    # print "XXXXXXXXXXXXXXXXXXXXXXX <h1>%s</h1>" % (faid, )
    print >> outfileobj, '<p>'
    # print >> outfileobj, upstr
    uplinenav = '<h4>%s &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h4>' % (upstr, )
    print >> outfileobj, uplinenav
    print >> outfileobj, '</p>'
    print >> outfileobj, '<p>'
    # print >> outfileobj, "<ul>"
    print >> outfileobj, '<table>'
    print >> outfileobj, '<tr>'
    print >> outfileobj, '<th>Article ID</th><th>ViewPoint</th><th>Semantic tags</th><th>OCR text</th><th>no. of chars</th>'
    print >> outfileobj, '</tr>'
    for simfaid, simscore in flist:
        ocrinfile = simfaid + ".txt"
        ocrinfilepath = os.path.join(indir, ocrinfile)
        # ##############################################
        # FOR TESTING !!!!!!!!!!!!
        ocrinfilepath = "/projects/cch/ncse/semtagprocessed/txt/EWJ/1859/02/EWJ-1859-02-01-Ar05400.txt"
        # ##############################################
        ocrinfileobj = file(ocrinfilepath, "r")
        ocrinfilecontent = ocrinfileobj.read()
        ocrinfileobj.close()
        ocrfilesize = len(ocrinfilecontent)
        urlapi = urlapitempl % tuple(simfaid.split("-"))
        simfaidstr         = '%s' % (simfaid, )
        viewpointstr    = '<a href="%s" target="_blank">ViewPoint</a>' % (urlapi, )
        semtagtextstr   = '<a href="%s-SemTag.html" target="_blank">Semantic tags</a>' % (simfaid, )
        ocrtextstr      = '<a href="%s.html" target="_blank">OCR text</a>' % (simfaid, )
        ocrsizestr      = '%s' % (ocrfilesize, )
        # print >> outfileobj, '<li>%s %s %s %s</li>' % (viewpointstr, semtagtextstr, ocrtextstr, ocrfilesize) 
        print >> outfileobj, '<tr>'
        print >> outfileobj, '<td class="faid">%s</td><td class="vplink">%s</td><td class="stlink">%s</td><td class="oclink">%s</td><td class="ocsize">%s</td>' % (simfaidstr, viewpointstr, semtagtextstr, ocrtextstr, ocrfilesize) 
        print >> outfileobj, '</tr>'
        ocroutfile = simfaid + ".html"
        ocroutfilepath = os.path.join(htdir, ocroutfile)
        ocroutfileobj = file(ocroutfilepath, "w")
        semtaghtmloutfile = simfaid + "-SemTag.html"
        semtaghtmloutfilepath = os.path.join(htdir, semtaghtmloutfile)
        semtaghtmloutfileobj = file(semtaghtmloutfilepath, "w")
        print >> ocroutfileobj, header
        print >> ocroutfileobj, "<h1>%s</h1>" % (simfaid, )
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
        print >> semtaghtmloutfileobj, "<h1>%s</h1>" % (simfaid, )
        upstr = '<a href="index.html">UP</a>'
        # upline = '<h4>%s / %s / %s</h4>' % (upstr, viewpointstr, ocrtextstr)
        upline = '<h4>%s / %s / %s &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h4>' % (upstr, viewpointstr, ocrtextstr)
        print >> semtaghtmloutfileobj, upline
        print >> semtaghtmloutfileobj, '<p>'
        print >> semtaghtmloutfileobj, '<table>'
        print >> semtaghtmloutfileobj, '<tr>'
        print >> semtaghtmloutfileobj, '<th>Rank</th><th align="left">SemTag</th><th align="left">SemTag Label</th><th>LLH</th><th>Significance level</th>'
        print >> semtaghtmloutfileobj, '</tr>'
#        semtagslist = getSemTagsFromDb(faid, con)
#        oddevencounter = 0
#        for semtags in semtagslist:
#            oddevencounter += 1
#            (rank, semtag, semtaglong, llh) = semtags
#            if llh >= 15.13:
#                degofconf = "ninenineninenine"
#                percentile = "99.99"
#            elif llh >= 10.83:
#                degofconf = "nineninenine"
#                percentile = "99.9&nbsp;"
#            elif llh >= 6.63:
#                degofconf = "ninenine"
#                percentile = "99&nbsp;&nbsp;&nbsp;"
#            elif llh >= 3.84:
#                degofconf = "ninefive"
#                percentile = "95&nbsp;&nbsp;&nbsp;"
#            else:
#                degofconf = "underninefive"
#                percentile = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
#            rowstr = '<td class="rank">%i</td><td>%s</td><td>%s</td><td class="llh">%5.2f</td><td class="%s">%s</td>'
#            rowstr = rowstr % (rank, semtag, semtaglong, llh, degofconf, percentile)
#            if oddevencounter % 2 == 0:
#                print >> semtaghtmloutfileobj, '<tr class="treven">'
#            else:
#                print >> semtaghtmloutfileobj, '<tr class="trodd">'
#            print >> semtaghtmloutfileobj, rowstr
#            print >> semtaghtmloutfileobj, '</tr>'
#            
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



if __name__ == '__main__':

    # repf = getRepfileObject(semtaglogpath, articlepath)
    # logmsgdic = {}

    infilelist = os.listdir(indir)
    for infile in infilelist:
        faid, ext = os.path.splitext(infile)
        artidcomponents = faid.split("-")
        (publ, year, month, day, artid) = artidcomponents 
        # if ((ext == ".txt") and (artidcomponents[0] in validpublidlist)):
        if ((ext == ".txt") and (publ in validpublidlist)):
            totalsimdocs = "NO TOTAL"
            scoremin = ""
            infilepath = os.path.join(indir, infile)
            infileobj = file(infilepath, "r")
            linelist = infileobj.readlines()
            infileobj.close()
            print faid
            currhtmldir = makeHtmlDir(artidcomponents, htmldepth)
            doccounter = 0
            simfaidlist = []
            for line in linelist:
                line = line.strip()
                if line.startswith(totallinestart):
                    totalsimdocs = re.search(retotal, line).group(1)
                if line.startswith(scoreminlinestart):
                    scoremin = re.search(rescoremin, line).group(1)
                if ((line.find("-") != -1) and (line.find(" : ") != -1)):
                    simfaid, score = line.split(" : ")
                    simfaidlist.append([simfaid, score])
            urlapi = urlapitempl % tuple(artidcomponents)
            viewpointstr    = '<a href="%s" target="_blank">ViewPoint</a>' % (urlapi, )
            ocrtextstr      = '<a href="%s.html" target="_blank">OCR text</a>' % (faid, )
            print viewpointstr
            print ocrtextstr
            print score
            writeLeafHtmlFiles(faid, simfaidlist, currhtmldir, semtagindir)
                    
            print "*** TOTAL SIMDOCS:", totalsimdocs, scoremin
            print "*** No of entries:", len(simfaidlist)

    print "--== FINISHED ==--"
