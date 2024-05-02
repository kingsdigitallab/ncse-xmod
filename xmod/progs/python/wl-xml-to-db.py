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

from bymysqlmap import *

db_host = "localhost"

prog_host = socket.gethostname()

dbname = "waterloo_full"

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
elif prog_host.startswith("numb") == True:
    # by_use_unicode = True
    by_use_unicode = False
    by_charset = "latin1"
else:
    by_use_unicode = True
    by_charset = "latin1"
# print by_use_unicode
# print by_charset
#print db_host
# sys.exit()

if prog_host.startswith("owl") == True:
    # MySQL on OWL doesn't accept charset attribute
    con        = MySQLdb.connect(
                                   host=db_host,
                                   port=51524,
                                   user="gbrey",
                                   passwd="Ujs92ila",
                                   db=dbname
                                   )
else:
    con        = MySQLdb.connect(
                                   use_unicode=by_use_unicode,
                                   charset=by_charset,
                                   host=db_host,
                                   port=51524,
                                   user="gbrey",
                                   passwd="Ujs92ila",
                                   db=dbname
                                   )


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
# dictionary holding maximum field lengths for each field
fieldlendic = {}
# dictionary holding content of field with maximum field length
#    for each field
fieldlencontdic = {}

# infileprefpath = "../../waterloo/sample/use/"
# infileext      = "AC.xml"

infileprefpath = "../../waterloo/full/use/"
infileext      = ".xml"

wlanalogfile = "logs/WL_DB_WRITE.LOG"
logf = file(wlanalogfile, "w")

attribnamesdic = {}

# escape MySQL control characters
def MySQLEscape(s):
    s = s.replace("\\", "\\\\")
    s = s.replace('"', '\\"')
    s = s.replace("'", "\\'")
    return s


def BuildSqlFieldString(l):
    fieldstring = ""
    for f in l:
        if fieldstring == "":
            fieldstring += f
        else:
            fieldstring += ", " + f
    return fieldstring

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
    valtmpdic = {}
    tmpfldic = {}
    tmpflcdic = {}
    # tmppat = r""
    # for attname in elemdic[infile][1]:
    #     tmppat += ')" (' + attname + ')="(.*'
    # tmppat = tmppat[3:] + ')"'
    # reattpat = re.compile(tmppat)
    attlist = elemdic[infile][1]
    tablename = elemdic[infile][0]
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
        # print "-" * 40
        # print attvaldic
        
        sqlinsfnlist = []
        sqlinsfvlist = []
        sqlinsptfnlist = []
        sqlinsptfvlist = []
        for att in attlist:
            fname = att
            # print attvaldic[att]
            # fval = attvaldic[att]
            for fval in attvaldic[att]:
                vallist = attvaldic[att]
                # print type(vallist), vallist
                # if len(vallist) > 1:
                #     print fname, "::",  fval
                fvallen = len(fval)
                if fieldlendic.has_key(fname):
                    if fvallen > fieldlendic[fname]:
                        tmpfldic[fname] = fvallen
                        tmpflcdic[fname] = fval
                else:
                    tmpfldic[fname] = fvallen
                    tmpflcdic[fname] = fval
                insfval = "'" + MySQLEscape(fval) + "'"
                if fname == "id":
                    insfname = "wlid"
                else:
                    insfname = fname
                if fname != "PeopleType":
                    sqlinsfnlist.append(insfname)
                    sqlinsfvlist.append(insfval)
                else:
                    # handle PeopleType
                    sqlinsptfnlist.append(insfname)
                    sqlinsptfvlist.append(insfval)

                
                
                # if not valtmpdic.has_key(fname):
                #     valtmpdic[fname] = {}
                
                # if (len(vallist) > 1) and (fname != "PeopleType"):
                #     print infile, fname, "::", len(fval), "::", fval, vallist

                # for c in fval:
                #     if c not in goodchars:
                #         TestForEntitiesPerChar(c, fval, fvallen)
                #         anr = ord(c)
                #         if not tmpdic[fname].has_key(anr):
                #             tmpdic[fname][anr] = 1
                #        else:
                #            tmpdic[fname][anr] += 1
                # print tmpflcdic

        # print "-" * 40
        # print sqlinsfnlist
        # print sqlinsfvlist
        fns = BuildSqlFieldString(sqlinsfnlist)
        fvs = BuildSqlFieldString(sqlinsfvlist)
        # ptfns = BuildSqlFieldString(sqlinsptfnlist)
        # ptfvs = BuildSqlFieldString(sqlinsptfvlist)
        # fvs = "'" + MySQLEscape(fvs) + "'"
        # print fns
        # print fvs
        # sql = u"INSERT INTO `%s` (%s) VALUES (%s)" % (tablename, fns, fvs.decode("latin1"))
        # # print sql
        # insobj = SqlResultList(con=con, sql=sql)
        # rl = insobj.getRowTuple()
        # lk = insobj.getLastAutoIncId()
        # del insobj

        sql = u"INSERT INTO `%s` (%s) VALUES (%s)" % (tablename, fns, fvs.decode("latin1"))
        # print sql
        insobj = SqlResultList(con=con, sql=sql)
        rl = insobj.getRowTuple()
        lk = insobj.getLastAutoIncId()
        del insobj
        
        # sql = "SELECT id FROM PeopleTypes WHERE PeopleType = '%s'" % (ptfvs)
        # print len(ptfvs), sql
        # print sqlinsptfnlist, sqlinsptfvlist
        for ptfvs in sqlinsptfvlist:
            sql = "SELECT id FROM PeopleTypes WHERE PeopleType = %s" % (ptfvs, )
            # print sql
            selobj = SqlResultList(con=con, sql=sql)
            pttuple = selobj.getRowTuple()
            ptcount = selobj.getRowCount()
            del selobj
            if ptcount == 0:
                sql = u"INSERT INTO `PeopleTypes` (PeopleType) VALUES (%s)" % (ptfvs, )
                # print sql
                insobj = SqlResultList(con=con, sql=sql)
                ptrl = insobj.getRowTuple()
                ptlk = insobj.getLastAutoIncId()
                del insobj
            else:
                ptlk = pttuple[0][0]
            # INS
            sql = u"INSERT INTO `PeopleNames_PeopleTypes` (peoplenames_id, peopletypes_id) VALUES (%s, %s)" % (lk, ptlk)
            # print sql
            insobj = SqlResultList(con=con, sql=sql)
            pnptrl = insobj.getRowTuple()
            pnptlk = insobj.getLastAutoIncId()
            del insobj
                
        
    # naughtycharsdic[infile] = tmpdic
    fieldlendic[infile] = tmpfldic
    fieldlencontdic[infile] = tmpflcdic
    infileobj.close()

print "--== FINISHED ==--"
