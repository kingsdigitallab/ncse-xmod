#!/usr/bin/env python

# Time-stamp: <Wed 14.03.2007 19:02:28 GMT Standard Time gb>

# TODO:
# check field lengths
# analyse special characters: \222 and \346 for example
# analyse entities: &quot;, &lt;, &gt;, &amp; versus "&"
# analyse use of HTML tags within attributes: <i> for example

import sys
import string

import socket
import platform

from elementtree.ElementTree import parse


infiletuple = (
    "counties",
    "issuingbodies",
    "people",
    "subjects",
    "titles",
    "towns"
)

# infileprefpath = "../../waterloo/sample/use/"
# infileext      = "AC.xml"

infileprefpath = "../../waterloo/full/use/"
infileext      = ".xml"

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


for infile in infiletuple:
    infilepath = infileprefpath + infile + infileext
    # infile = "../../waterloo/sample/use/peopleAC.xml"
    infileobj = file(infilepath, "r")

    tree = parse(infileobj)
    elem = tree.getroot()
    # print elem
    # print elem.getchildren()
    # print elem.getiterator()
    # for e in elem.getiterator():
    #     print e, e.text, e.items()
    #     print e.attrib

    for e in elem.getiterator():
        tmpattribdic = e.attrib
        fnames = "id"
        fvalues = "'0'"
        for k in tmpattribdic.keys():
            # print k, tmpattribdic[k]
#             if fnames == "":
#                 fnames = k
#             else:
#                 fnames += ", " + k
#             if fvalues == "":
#                 fvalues = "'%s'" % tmpattribdic[k]
#             else:
#                 fvalues += ", '%s'" % tmpattribdic[k]
            if k == "id":
                colname = "wlid"
            else:
                colname = k
            fnames += ", " + colname
            colval = tmpattribdic[k]
            colval = MySQLEscape(colval)
            fvalues += ", '%s'" % colval
        sql = "INSERT INTO %s (%s) VALUES (%s)" % (infile, fnames, fvalues)
        selobj = SqlResultList(con=bycon, sql=sql)
        del selobj
        print sql
    


   
    # GetInitialAttribs(infile, elem)
# PrintInitialAttribs()



