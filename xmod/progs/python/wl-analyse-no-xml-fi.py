#!/usr/bin/env python
# -*- coding: latin-1 -*-

# Time-stamp: <Thu 15.03.2007 19:31:51 GMT Standard Time gb>

# TODO:
# check field lengths
# analyse special characters: \222 and \346 for example
# analyse entities: &quot;, &lt;, &gt;, &amp; versus "&"
# analyse use of HTML tags within attributes: <i> for example

# ATTENTION!!!
# in "PeopleTypes" attribute "PeopleType" can appear multiple times
# max: 26 times

import sys
import string

import re
import socket
import platform

from elementtree.ElementTree import parse

goodchars = string.ascii_letters + string.digits + " ,;.:-_()[]"
# print string.letters
# print string.ascii_letters
# print string.punctuation
# print goodchars
# print string.whitespace

resxml = re.compile(r"^<.*? ")
reexml = re.compile(r"/?>(</.*?>)?$")
repety = re.compile(r"/?><PeopleTypes ")

infiletuple = (
    "counties",
    "issuingbodies",
    "people",
    "subjects",
    "titles",
    "towns"
)

tinfiletuple = (
    "counties",
    "towns",
)

elemdic = {
    "counties" : ["CountyNames",
                  ["id",
                   "Name"]
                  ],
    "issuingbodies" : ["issuingbodynames",
                  ["id",
                   "Name"]
                  ],
    "people" : ["PeopleNames",
                  ["id",
                   "ProperName",
                   "GivenName",
                   "ExtraInfo",
                   "IsCompany",
                   "OrderBy",
                   "PeopleType"]
                  ],
    "subjects" : ["subject",
                  ["id",
                   "name"]
                  ],
    "titles" : ["title",
                  ["id",
                   "recordID",
                   "laterTitleID",
                   "title",
                   "SeeRefRecordTitle",
                   "referenceType",
                   "StartDate",
                   "EndDate"]
                  ],
    "towns" : ["TownNames",
                  ["id",
                   "Name"]
                  ],
    }

multiatts = {}

#    "people" : ["PeopleNames",
#                  ["id",
#                   "ProperName",
#                   "GivenName",
#                   "ExtraInfo",
#                   "IsCompany",
#                   "OrderBy",
#                   ""],
#                "PeopleTypes",
#                  ["PeopleType"
#                  ]
#                  ],

naughtycharsdic = {}
fieldlendic = {}
fieldlencontdic = {}

# infileprefpath = "../../waterloo/sample/use/"
# infileext      = "AC.xml"

infileprefpath = "../../waterloo/full/use/"
infileext      = ".xml"

wlanalogfile = "logs/WL_CHAR_ANALYSIS_FI.LOG"
logf = file(wlanalogfile, "w")

attribnamesdic = {}



# get full list of attributes for each element
# only once to define DB
def GetInitialAttribs(byinfile, byelem):
    currattribslist = []
    for e in byelem.getiterator():
        for att in e.keys():
            if att not in currattribslist:
                currattribslist.append(att)
    attribnamesdic[byinfile] = currattribslist

# print full list of attributes for each element
# only once to define DB
def PrintInitialAttribs():
    for i in attribnamesdic.keys():
        print i, attribnamesdic[i]

def CountAttNameOccurances(l):
    # ---
    # count occurances of attributes
    for attname in elemdic[infile][1]:
        ptcount = l.count(attname+"=")
        makey = infile + ":" + attname
        if multiatts.has_key(makey):
            if multiatts[makey] < ptcount:
                multiatts[makey] = ptcount
        else:
            multiatts[makey] = ptcount
        if ptcount > 10:
            print "-" * 40
            print ptcount
            print l
    # ---

def GetAttribPositions(ifile):
    for attname in elemdic[ifile][1]:
        attnameexp = attname + '="'

        if ifile == "people":
            spos = 0
            while line.find(attnameexp, spos) > -1:
                attvalspos = line.find(attnameexp, spos) + len(attnameexp)
                spos = attvalspos + 1
        else:
            attvalspos = line.find(attnameexp) + len(attnameexp)
            print attvalspos

def LStripMarkup(l):
    s = re.sub(resxml, "", l)
    s = s.strip()
    return s

def RStripMarkup(l):
    s = re.sub(reexml, "", l)
    s = s.strip()
    return s

def StripPeopleTypes(l):
    s = re.sub(repety, " ", l)
    return s

def SplitAtts(l, ifile):
    attlist = elemdic[ifile][1]
    attdic = {}
    for attname in attlist:
        attfrom = '" ' + attname + '="'
        attto = '"§§§' + attname + '="'
        l = l.replace(attfrom, attto)
    attpairlist = l.split("§§§")
    for attpair in attpairlist:
        (attn, attv) = attpair.split("=", 1)
        if attn not in attlist:
            logf.write("%s not a attribute name\n" % attn)
        attv = attv.strip('"')
        if attdic.has_key(attn):
            attdic[attn].append(attv)
        else:
            attdic[attn] = [attv]
        # print attn, attv
    # print attpairlist
    # print attdic
    for a in attlist:
        if len(attdic[a]) > 1:
            # print "-" * 40
            # print attdic[a]
            attdicset = set(attdic[a])
            attdic[a] = list(attdicset)
            # print attdic[a]
            # print attdic
    return attdic


def TestForEntitiesRe(c, fv, fvll):
    pass


def TestForEntitiesPerChar(c, fv, fvll):
    if c == "&":
        cposinfv = fv.find(c)
        if cposinfv < fvll-1:
            semicolonpos = fv.find(";")
            if semicolonpos != -1:
                pass


for infile in infiletuple:
    print "Processing", infile
    infilepath = infileprefpath + infile + infileext
    # infile = "../../waterloo/sample/use/peopleAC.xml"
    infileobj = file(infilepath, "r")
    tmpdic = {}
    tmpfldic = {}
    tmpflcdic = {}
    # tmppat = r""
    # for attname in elemdic[infile][1]:
    #     tmppat += ')" (' + attname + ')="(.*'
    # tmppat = tmppat[3:] + ')"'
    # reattpat = re.compile(tmppat)
    attlist = elemdic[infile][1]
    while True:
        line = infileobj.readline()
        if not line:
            break
        if (line.startswith("<?xml")) or \
               (line.startswith("<!DOC")) or \
               (line.startswith("<root>")) or \
               (line.startswith("</root>")):
            continue
        line = line.strip()
        # CountAttNameOccurances(l)
        # GetAttribPositions(infile)

        line = LStripMarkup(line)
        line = RStripMarkup(line)
        if infile == "people":
            line = StripPeopleTypes(line)
        attvaldic = SplitAtts(line, infile)
        # print line
        # print attvallist
        
        for att in attlist:
            fname = att
            # fval = attvaldic[att]
            for fval in attvaldic[att]:
                fvallen = len(fval)
                if fieldlendic.has_key(fname):
                    if fvallen > fieldlendic[fname]:
                        tmpfldic[fname] = fvallen
                        tmpflcdic[fname] = fval
                else:
                    tmpfldic[fname] = fvallen
                    tmpflcdic[fname] = fval
                if not tmpdic.has_key(fname):
                    tmpdic[fname] = {}
                for c in fval:
                    if c not in goodchars:
                        TestForEntitiesPerChar(c, fval, fvallen)
                        anr = ord(c)
                        if not tmpdic[fname].has_key(anr):
                            tmpdic[fname][anr] = 1
                        else:
                            tmpdic[fname][anr] += 1
        
    naughtycharsdic[infile] = tmpdic
    fieldlendic[infile] = tmpfldic
    fieldlencontdic[infile] = tmpflcdic
    infileobj.close()

for k in naughtycharsdic.keys():
    logf.write("=" * 40 + "\n")
    logf.write(k + "\n")
    logf.write("=" * 40 + "\n")
    for l in naughtycharsdic[k]:
        logf.write("Field: %s \n" % (l, ))
        logf.write("Longest entry (%d):\n" % (fieldlendic[k][l], ))
        if  fieldlendic[k][l] > 250:
            print "field len greater than 250", fieldlendic[k][l]
        logf.write("-" * 40 + "\n")
        logf.write("%s\n" % (fieldlencontdic[k][l], ))
        logf.write("-" * 40 + "\n")
        mlist = naughtycharsdic[k][l].keys()
        mlist.sort()
        if len(mlist) < 1:
            logf.write("                       None\n")
        else:
            for m in mlist:
                logf.write("                     %5d  %0#5o %#5x  =  %s : %7d\n" % (m, m, m, chr(m), naughtycharsdic[k][l][m]))
        

# for k in multiatts.keys():
#     print k, multiatts[k]

print "--== FINISHED ==--"
