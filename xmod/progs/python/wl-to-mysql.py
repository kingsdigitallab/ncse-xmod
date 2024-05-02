#!/usr/bin/env python

# Time-stamp: <Tue 13.03.2007 23:34:30 GMT Standard Time gb>

import sys
import string

from bymysqlmap import *
import socket
import platform

from elementtree.ElementTree import parse

db_host = "localhost"
db_name = "waterloo"

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


def GetMySQLConn(dbname, dbhost):
    prog_host = socket.gethostname()
    if prog_host.startswith("owl") == True:
        # MySQL on OWL doesn't accept charset attribute
        bcon = MySQLdb.connect(
                                       host=dbhost,
                                       port=51524,
                                       user="gbrey",
                                       passwd="Ujs92ila",
                                       db=dbname
                                       )
    elif prog_host.startswith("fir") == True:
        print "FIRFIR"
        # MySQL on OWL doesn't accept charset attribute
        bcon = MySQLdb.connect(
                                       host=dbhost,
                                       port=3306,
                                       user="gbrey",
                                       passwd="Ujs92ila",
                                       db=dbname
                                       )
    else:
        bcon = MySQLdb.connect(
                                       use_unicode=by_use_unicode,
                                       charset=by_charset,
                                       host=db_host,
                                       port=51524,
                                       user="gbrey",
                                       passwd="Ujs92ila",
                                       db=dbname
                                       )
    return bcon

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

# escape MySQL control characters
def MySQLEscape(s):
    s = s.replace("\\", "\\\\")
    s = s.replace('"', '\\"')
    s = s.replace("'", "\\'")
    s = s.replace("&apos;", "\\'")
    return s


bycon = GetMySQLConn(db_name, db_host)


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



