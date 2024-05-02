#!/usr/bin/env python

import sys
import os, os.path

indir = "/projects/cch/ncse/textmining/ocr-correct/approx-name-match"
outdir = "/projects/cch/ncse/textmining/lucene/people-LDR"
infile = "people-LDR-070712"
outfiletmpl = "LDR"

xmlheadertmpl = """<?xml version="1.0" encoding="UTF-8"?>
<lucene-document xmlns="http://www.cch.kcl.ac.uk/xmlns/ereuna" id="%s">
   <header>
      <tei>
      </tei>
   </header>
<fields>"""

xmlfooter = """</fields>
</lucene-document>"""

fieldlinetmpl = '<field indexed="tokenized" name="ncsename" stored="yes" vector="no">%s</field>'

infilepath = os.path.join(indir, infile)
infileobj = file(infilepath, "r")

filecounter = 0

for line in infileobj:
    filecounter += 1
    id = "%07d" % (filecounter, )
    outfilename = "ncse-ldr-%s.xml" % (id, )
    xmlheader = xmlheadertmpl % (id, )
    outfilepath = os.path.join(outdir, outfilename)
    outfileobj = file(outfilepath, "w")
    line = line.strip()
    (name, ncseid) = line.split("\t")
    fieldline = fieldlinetmpl % (name, )
    print outfilename
    print >> outfileobj, xmlheader
    print >> outfileobj, fieldline
    print >> outfileobj, xmlfooter
    outfileobj.close()

infileobj.close()



