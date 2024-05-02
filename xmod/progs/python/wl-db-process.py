#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Sat 26.05.2007 01:47:28 BST gb>

# TODO: change &328; to Oslash
# TODO: reduce umlauts and accented chars to basic vowels
# TODO: try porter and lancaster stemmers

# DONE: change "&" to "and"
# DONE: deal with genitive singulars
# DONE: lowercase words

import sys
import string

import re
import socket
import platform
import time
from nltk import tokenize
from nltk.stem.porter import *
from nltk.stem.lancaster import *
from bymysqlmap import *

db_host = "localhost"

prog_host = socket.gethostname()

dbname = "waterloo_full_tokens_yew"

rexmlent = re.compile(r"""&[^ ].*?;""")
#reetc = re.compile(r"""(&c.)""")
reetc = re.compile(r"""&(c|C)""")
reltgt = re.compile(r"""(<.*?>)""")
# reskwsatend = re.compile(r""",\s\w;$""")
reskwsatend = re.compile(r""",\s*(\w*?)\s*;\s*$""")
rekommawordatend = re.compile(r""",\s*(\w*?)\s*$""")

# regular expression to match tokens, including
# currency amounts and abbreviations
# s. NLTK, 3.3.1 Tokenization with Regular Expressions
# usage: list(tokenize.regexp(text, retoken))
retoken = re.compile(r'''
    \w+               # sequences of 'word' characters
  | \$?\d+(\.\d+)?    # currency amounts, e.g. $12.50
  | ([\A\.])+         # abbreviations, e.g. U.S.A.
  | [^\w\s]+          # sequences of punctuation
''', re.VERBOSE)

#a = "text, the;"
#b = "space text,  the;"
#c = "space text,  the; "
#d = "space text ,  the; "
#
#skmo = re.findall(reskwsatend, a)
#print skmo
#skmo = re.findall(reskwsatend, b)
#print skmo
#skmo = re.findall(reskwsatend, c)
#print skmo
#skmo = re.findall(reskwsatend, d)
#print skmo
#sys.exit()

repfilename = "logs/WL_DB_ANALYSIS_NO_ENTS"
repfilename += "-"
repfilename += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
repfilename += ".LOG"

repf = file(repfilename, "w")

# Ugly hack to make MySQLDb work on Linux and Windows
# The LINUX version doesn't recognise the "charset" attribute
# Look into it more closely:
# - are the MySQLDb versions slightly different?
# - do the different platform versions handle UNICODE differently?
if prog_host.startswith("fir") == True:
    by_use_unicode = True
    # by_use_unicode = False
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



xtabledic = {
    "countynames" :
                  ["id",
                   "wlid",
                   "Name"]
                  ,
    "issuingbodynames" :
                  ["id",
                   "wlid",
                   "Name"]
                  ,
    "subject" :
                  ["id",
                   "wlid",
                   "name"]
                  ,
    "townnames" :
                  ["id",
                   "wlid",
                   "Name"]
                  }

tabledic = {
    "countynames" :
                  ["id",
                   "wlid",
                   "Name"]
                  ,
    "issuingbodynames" :
                  ["id",
                   "wlid",
                   "Name"]
                  ,
    "peoplenames" :
                  ["id",
                   "wlid",
                   "ProperName",
                   "GivenName",
                   "ExtraInfo",
                   "IsCompany",
                   "OrderBy",
                   "PeopleType"]
                  ,
    "subject" :
                  ["id",
                   "wlid",
                   "name"]
                  ,
    "title" :
                  ["id",
                   "wlid",
                   "recordID",
                   "laterTitleID",
                   "title",
                   "SeeRefRecordTitle",
                   "referenceType",
                   "StartDate",
                   "EndDate"]
                  ,
    "townnames" :
                  ["id",
                   "wlid",
                   "Name"]
    }

xcategorydic = {
               "countynames": "county",
               "townnames"  : "town",
               "issuingbodynames" : "issuingbody",
               "subject" : "subject",
               "title" : "pubtitle"
               }

categorydic = {
               "countynames": { "Name" : "county" },
               "townnames"  : { "Name" : "town" },
               "issuingbodynames" : { "Name" : "issuingbody" },
               "subject" : { "name" : "subject" },
               "title" : {
                          "title" : "pubtitle",
                          "SeeRefRecordTitle" : "pubtitle",
                          "StartDate" : "startdate",
                          "EndDate" : "enddate"
                           },
               "peoplenames" : {
                          "ProperName" : "lastname",
                          "GivenName"  : "firstname",
                          "ExtraInfo"  : "extrainfo"
                           }
               }


totalentdic = {}
totalentrefdic = {}
totalrealampdic = {}
totalrealamprefdic = {}
totalltgtdic = {}
kommaskdic = {}
kommawordatenddic = {}

realentlist = (
               ("amp", "&"),
               ("apos", "'"),
               ("quot", '"'),
               ("lt", '<'),
               ("gt", '>')
               )

# generated by CheckForSemiColonAtEnd
# this was just produced for checking, as these are
# expressions that follow the pattern ", XXX;$"
kommaskgenreportlist = [
    "Cheriton",
    "Middlesex",
    "Oxfordshire",
    "Directory",
    "Midwifery",
    "Ireland",
    "Truro",
    "Hants",
    "Leeds",
    "London",
    "Worthing",
    "Calcutta",
    "Bolton",
    "Cornets",
    "England",
    "Radley",
    "Birmingham",
    "Illustrated",
    "Sunderland",
    "Manchester"
]

# etc

# generated by CheckForSemiColonAtEnd
# these (mostly articles) have to go to the beginning of the field
# in all other cases the semicolon at the end can simply be removed
kommaskbringtofrontlist = [
    "A",
    "An",
    "Der",
    "Die",
    "El",
    "Il",
    "La",
    "Le",
    "Les",
    "Lo",
    "O",
    "The",
    "Y",
    "Ye",
    "Yr"
    ]

kommagenreportlist = [
    "Aux",
    "Aintab",
    "Co",
    "DD",
    "Dos",
    "Inc",
    "Mother",
    "P",
    "Peter",
    "William",
    "arranger",
    "colonial",
    "jour",
    "journal",
    "late",
    "of",
    "proc",
    "rep",
    "tract",
    "trans",
    "transactions",
    "x"
]


kommabringtofrontlist = [
    "A",
    "An",
    "ancient",
    "Aux",
    "Contagious",
    "Das",
    "De",
    "Den",
    "Der",
    "Di",
    "Die",
    "Dos",
    "East",
    "El",
    "L",
    "La",
    "Le",
    "Les",
    "Los",
    "Messeirs",
    "Messrs",
    "Political",
    "Primary",
    "Queen",
    "St",
    "Te",
    "The",
    "West",
    "Y",
    "Ye",
    "Yr",
    "the",
    "un"
    ]


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
    s = s.replace('"', '\\"')
    s = s.replace("'", "\\'")
    return s

def LogError(s):
    s = str(s)
    sl = []
    sl.append("#" * 65)
    sl.append(s)
    sl.append("#" * 65)
    for l in sl:
        print l
        logf.write(l + "\n")
    print
    logf.write("\n")
    
def BuildSqlFieldString(l):
    fieldstring = ""
    for f in l:
        if fieldstring == "":
            fieldstring += f
        else:
            fieldstring += ", " + f
    return fieldstring

# get those records from PeopleNames that have multiple
#    PeopleTypes
def CheckMultiplePeopleTypes():
    distinct = 1
    fields = ("peoplenames_id", )
    tables = ("peoplenames_peopletypes", )
    where = None
    # where = "peoplenames_id < 20"
    order = ("peoplenames_id", )
    selobj = SqlSelectList(con=con,
                           distinct=distinct,
                           fields=fields,
                           tables=tables,
                           where=where,
                           order=order)
    print selobj.getSqlString()
    distlist = selobj.getRowList()
    # print "RC:", selobj.getRowCount()
    del selobj

    mdistlist = map(lambda x: x[0], distlist)
    # distset = set(mdistlist)

    distinct = None
    fields = ("peoplenames_id", )
    tables = ("peoplenames_peopletypes", )
    where = None
    order = ("peoplenames_id", )
    selobj = SqlSelectList(con=con,
                           distinct=distinct,
                           fields=fields,
                           tables=tables,
                           where=where,
                           order=order)
    # print selobj.getSqlString()
    nodistlist =  selobj.getRowList()
    # print "RC:", selobj.getRowCount()
    del selobj

    mnodistlist = map(lambda x: x[0], nodistlist)
    # nodistset = set(mnodistlist)

    # diffset = mnodistlist.difference(mdistlist)
    
    print len(mdistlist)
    print len(mnodistlist)
    
    pnptdic = {}
    for n in mnodistlist:
        if pnptdic.has_key(n):
            pnptdic[n] += 1
        else:
            pnptdic[n] = 1

    distlist = pnptdic.keys()
    distlist.sort()
    print len(distlist)
    print len(mnodistlist) - len(distlist)
    
    for e in distlist:
        if pnptdic[e] > 1:
            print e, "::", pnptdic[e]


# Title table
# there is a field "SeeRefRecordTitle" that contains
# the text of the title of the "title" field of another
# record; "seeref" in the "referenceType" field indicates
# this entry refers to another one; all records that are
# linked in this way have the same "recordID"
# there can also be a reference to a change in the title
# at a later date; "referenceType" field contains "latertitle";
# "laterTitleID" contains "recordID" of the other title
def CheckRelationshipsInTitle():
    pass


# generate a list of all entities ("&xxx;") used
# do not include "& abcdef"
def CheckForEntities(t, table, af):
    etclist = re.findall(reetc, t)
    if etclist:
        for et in etclist:
            print table, af, et, t
    entlist = re.findall(rexmlent, t)
    if entlist:
        # print table, af, entlist, t
        for e in entlist:
            if e == "&#328;":
                PrintCF(repf, 1, "%s: %s, %s: %s" % (e, table, af, t))
            # print table, af, entlist
            # if entdic.has_key(e):
            #     entdic[e] += 1
            # else:
            #     entdic[e] = 1
            if totalentdic.has_key(e):
                totalentdic[e] += 1
            else:
                totalentdic[e] = 1
    for ral in realentlist:
        ee = "&" + ral[0] + ";"
        t = t.replace(ee, "�")
    for ral in realentlist:
        realamplist = re.findall(ral[1], t)
        realamplistlen = len(realamplist)
        noofrealents = t.count(ral[1])
        if realamplistlen != noofrealents:
            print "*" * 50
            print "*" * 50
            print "LEN and COUNT give different results"
            print "*" * 50
            print "*" * 50
        if noofrealents != 0:
            # if realampdic.has_key(ral[0]):
            #     realampdic[ral[0]] += noofrealents
            # else:
            #     realampdic[ral[0]] = noofrealents
            if totalrealampdic.has_key(ral[0]):
                totalrealampdic[ral[0]] += noofrealents
            else:
                totalrealampdic[ral[0]] = noofrealents


# normalise all "&c" to "etc"
def ProcessEtc(t, table, af):
    etc = re.search(reetc, t)
    if etc:
        t = re.sub(reetc, "etc", t)
    t = t.replace("etc.", "etc")
    return t

# normalise all "&" to "and"
def ProcessAmpersand(t, table, af):
    tf = t.find("&")
    if tf != -1:
        t = t.replace("&", " and ")
    return t

# remove all markup enclosed in "<" and ">"
def ProcessLtGt(t, table, af):
    ltgt = re.search(reltgt, t)
    if ltgt:
        t = re.sub(reltgt, "", t)
    return t


# generate a list of all markup enclosed in "<" and ">" used
def CheckForLtGt(t, table, af):
    ltgtlist = re.findall(reltgt, t)
    if ltgtlist:
        for ltgt in ltgtlist:
            # PrintCF(repf, 1, "%s | %s | %s | %s" % (table, af, ltgt, t))
            if totalltgtdic.has_key(ltgt):
                totalltgtdic[ltgt] += 1
            else:
                totalltgtdic[ltgt] = 1
            if ltgt == "<sp?>":
                PrintCF(repf, 1, "%s | %s | %s | %s" % (table, af, ltgt, t))
            if ltgt == "<qv>":
                PrintCF(repf, 1, "%s | %s | %s | %s" % (table, af, ltgt, t))
            if ltgt == "<?>":
                PrintCF(repf, 1, "%s | %s | %s | %s" % (table, af, ltgt, t))


# replace expressions like "XXX, The;" with "The XXX"
# remove all trailing semi-colons
def ProcessSemiColonAtEnd(t, table, af):
    t = t.strip()
    if t.endswith(";"):
        skmo = re.search(reskwsatend, t)
        if skmo:
            skword = skmo.group(1)
            if skword in kommaskbringtofrontlist:
                t = re.sub(reskwsatend, "", t)
                t = skword + " " + t
                # print t
            else:
                t = t.rstrip(";")
        else:
            t = t.rstrip(";")
    return t


# replace expressions like "XXX, The" with "The XXX"
def ProcessEndWordsBringToFront(t, table, af):
    t = t.strip()
    kwe = re.search(rekommawordatend, t)
    if kwe:
        kword = kwe.group(1)
        if kword in kommabringtofrontlist:
            t = re.sub(rekommawordatend, "", t)
            t = kword + " " + t
            # print t
    return t


# generate a list of all words at end of field that are followed by
# semicolon
def CheckForArticleAtEnd(t, table, af):
    t = t.strip()
    if not t.endswith(";"):
        kwe = re.search(rekommawordatend, t)
        if kwe:
            kword = kwe.group(1)
            if kommawordatenddic.has_key(kword):
                kommawordatenddic[kword] += 1
            else:
                kommawordatenddic[kword] = 1
            if kword in kommagenreportlist:
                PrintCF(repf, 1, "%s | %s | %s" % (table, af, t))
            # if kword in kommabringtofrontlist:
            #     PrintCF(repf, 1, "%s | %s | %s" % (table, af, t))


# generate a list of all words at end of field that are followed by
# semicolon
def CheckForSemiColonAtEnd(t, table, af):
    t = t.strip()
    # if (t.endswith(";")) and (not t.endswith(", The;")):
    if t.endswith(";"):
        # print table, af, t
        # sklist = re.findall(reskwsatend, t)
        # if len(sklist) != 0:
            # print sklist
            # for sk in sklist:
            #     print sk
            # print table, af, t
        skmo = re.search(reskwsatend, t)
        if skmo:
            skword = skmo.group(1)
            if kommaskdic.has_key(skword):
                kommaskdic[skword] += 1
            else:
                kommaskdic[skword] = 1
            if skword in kommaskgenreportlist:
                PrintCF(repf, 1, "%s | %s | %s" % (table, af, t))

# Tokenize field using NLTK
def TokenizeText(text):
    toklist = list(tokenize.regexp(text, retoken))
    toklistl = [li.lower() for li in toklist]
    return toklist, toklistl

def StripTrailingGenitive(w):
    if w.endswith("'s"):
        w = w[:-2]
    return w

# Tokenize field using my own primitive algorithm
def ByTokenizeText(text):
    toklist = text.split()
    # strip leading and trailing white space from each token
    toklist = list(x.strip() for x in toklist)
	# strip leading and trailing puntuation from each token
    toklist = list(x.strip(string.punctuation) for x in toklist)
    # strip trailing apostrophe and s in genitive singular tokens
    # the following line using list comprehension doesn't work - why?
    # toklist = list(x[:-2] for x in toklist if x.endswith("'s"))
    toklist = map(StripTrailingGenitive, toklist)
    # change token to lower case
    toklist = list(x.lower() for x in toklist)
    return toklist

def StemText(l):
    # stemmer = stem.Porter()
    stemmer = Porter()
    stems = []
    for word in l:
        stemmed_token = stemmer.stem(word)
        if stemmed_token not in stems:
            stems.append(stemmed_token)
    return stems
  
def GetCategoryId(table, field):
    # print table, field
    category = categorydic[table][field]
    sql = u"SELECT id FROM categories WHERE category = '%s'" % category
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    del selobj
    catid = rl[0][0]
    return catid
    
def WriteToTokenTable(wlentry, toklist, sid, tbl, fld):
    # print tbl, fld, wlentry.encode("latin1")
    tokpos = 0
    categoryid = GetCategoryId(tbl, fld)
    # print tbl, fld, categoryid
    wlentry = MySQLEscape(wlentry)
    wtable = "wlentries"
    toktable = "tokens"
    tokwlenttable = "tokens_wlentries"
    wlentfields = "id, wlentry, categoryid, wlid"
    ######### print wlentry.encode("latin1")
    # insfields = u"%d, '%s', %d, %d" % (0, wlentry.encode("latin1"), categoryid, sid)
    insfields = "%d, '%s', %d, %d" % (0, wlentry.encode("latin1"), categoryid, sid)
    # sql = u"INSERT INTO `%s` (%s) VALUES (%s)" % (wtable, wlentfields, insfields)
    sql = "INSERT INTO `%s` (%s) VALUES (%s)" % (wtable, wlentfields, insfields)
    insobj = SqlResultList(con=con, sql=sql)
    rl = insobj.getRowTuple()
    wlentryid = insobj.getLastAutoIncId()
    del insobj
    tokfields = "id, token"
    tokwlentfields = "id, tokenid, wlentryid, tokenpos, categoryid"
    for tok in toklist:
        #print tok, tokpos, sid, tbl
        tok = MySQLEscape(tok)
        # sql = u"SELECT id FROM tokens WHERE token = '%s'" % (tok.decode("latin1"), )
        sql = "SELECT id FROM tokens WHERE token = '%s'" % (tok.encode("latin1"), )
        selobj = SqlResultList(con=con, sql=sql)
        rl = selobj.getRowTuple()
        rc = selobj.getRowCount()
        del selobj
        if rc > 0:
            tokenid = rl[0][0]
        else:
            # insfields = "%d, '%s'" % (0, tok.decode("latin1"))
            insfields = "%d, '%s'" % (0, tok.encode("latin1"))
            # sql = u"INSERT INTO `%s` (%s) VALUES (%s)" % (toktable, tokfields, insfields)
            sql = "INSERT INTO `%s` (%s) VALUES (%s)" % (toktable, tokfields, insfields)
            insobj = SqlResultList(con=con, sql=sql)
            rl = insobj.getRowTuple()
            tokenid = insobj.getLastAutoIncId()
            del insobj
        insfields = "%d, %d, %d, %d, %d" % (0, tokenid, wlentryid, tokpos, categoryid)
        sql = u"INSERT INTO `%s` (%s) VALUES (%s)" % (tokwlenttable, tokwlentfields, insfields)
        insobj = SqlResultList(con=con, sql=sql)
        rl = insobj.getRowTuple()
        del insobj
        # print tbl, sid, tok
        tokpos += 1


# iterate through all tables and fields
# only process text fields
def IterateThroughFields():
    ltgtdic = {}
    for table in tabledic.keys():
        allfields = []
        textfields = []
        sql = "SHOW COLUMNS FROM %s" % table
        selobj = SqlResultList(con=con, sql=sql)
        fieldlist = selobj.getRowTuple()
        nooffields = selobj.getRowCount()
        del selobj
        for f in fieldlist:
            allfields.append(f[0])
            if not f[1].startswith("int"):
                textfields.append(f[0])
        textfields.remove("referenceType")
        print table
        # print table, allfields, textfields
        # relevfieldlist = tabledic[table]
        # relevfieldlist.remove("id")
        # relevfieldlist.remove("wlid")
        # relevfieldstr = ", ".join(relevfieldlist)
        selfieldstr = ", ".join(allfields)
        sql = "SELECT %s FROM %s" % (selfieldstr, table)
        # print sql
        selobj = SqlResultList(con=con, sql=sql)
        restuple = selobj.getRowTuple()
        rescount = selobj.getRowCount()
        del selobj
        for rt in restuple:
            fcount = 0
            entdic = {}
            realampdic = {}
            for af in allfields:
            	if af == "id":
					srcid = rt[fcount]
                if ((af in textfields) and (af != "")):
                    t = rt[fcount]
                    # CheckForEntities(t, table, af)
                    # CheckForLtGt(t, table, af)
                    # CheckForSemiColonAtEnd(t, table, af)
                    # CheckForArticleAtEnd(t, table, af)
                    t = ProcessLtGt(t, table, af)
                    t = ProcessSemiColonAtEnd(t, table, af)
                    t = ProcessEndWordsBringToFront(t, table, af)
                    t = ProcessEtc(t, table, af)
                    t = ProcessAmpersand(t, table, af)
                    # PrintCF(repf, 1, "%s - %s: %s" % (table, af, t))
                    # -------------------------------
                    # print "-" * 40
                    # print t.encode("latin1")
                    # Tokenize using NLTK
                    (toklist, toklistl) = TokenizeText(t)
                    # print toklist
                    # print toklistl
                    # stemlist = StemText(toklist)
                    # print stemlist
                    # print "SS:", stemlist
                    # bytoklist = ByTokenizeText(t)
                    # print bytoklist
                    
                    # print table, af, textfields, allfields
                    # WriteToTokenTable(t, bytoklist, srcid, table)
                    WriteToTokenTable(t, toklistl, srcid, table, af)
                    
                    # for i in bytoklist:
                    # 	print i, srcid
                    # 	if i.endswith("s'"):
                    # 		print "-" * 50
                    # 		print i
                    # 		# print t
					# print t
					# print "TT:", toklist
                    # print "BB:", bytoklist
                    # if t.find("Scourge") != -1:
                    # 	print t
                    
                fcount += 1
    if len(totalentdic.keys()) > 0:
        PrintCF(repf, 1, "")
        PrintCF(repf, 1,  "-"* 50)
        PrintCF(repf, 1, " TOTALS Ampersand entities")
        PrintCF(repf, 1,  "-"* 50)
        for e in totalentdic.keys():
            PrintCF(repf, 1, "%s : %s" % (e, totalentdic[e]))
    if len(totalrealampdic.keys()) > 0:
        PrintCF(repf, 1, "")
        PrintCF(repf, 1,  "-"* 50)
        PrintCF(repf, 1, " TOTALS 'real' ampersands")
        PrintCF(repf, 1,  "-"* 50)
        for e in totalrealampdic.keys():
            PrintCF(repf, 1, "real %s : %s" % (e, totalrealampdic[e]))
    if len(totalltgtdic.keys()) > 0:
        PrintCF(repf, 1, "")
        PrintCF(repf, 1,  "-"* 50)
        PrintCF(repf, 1, " TOTALS 'real' ampersands")
        PrintCF(repf, 1,  "-"* 50)
        for e in totalltgtdic.keys():
            PrintCF(repf, 1, "%s : %s" % (e, totalltgtdic[e]))
    if len(kommaskdic.keys()) > 0:
        PrintCF(repf, 1, "")
        PrintCF(repf, 1,  "-"* 50)
        PrintCF(repf, 1, " ', XXX;' expressions:")
        PrintCF(repf, 1,  "-"* 50)
        for e in kommaskdic.keys():
            PrintCF(repf, 1, "%s : %s" % (e, kommaskdic[e]))
    if len(kommawordatenddic.keys()) > 0:
        PrintCF(repf, 1, "")
        PrintCF(repf, 1,  "-"* 50)
        PrintCF(repf, 1, " ', XXX' expressions:")
        PrintCF(repf, 1,  "-"* 50)
        kommawordatendlist = kommawordatenddic.keys()
        kommawordatendlist.sort()
        for e in kommawordatendlist:
            PrintCF(repf, 1, "%s : %s" % (e, kommawordatenddic[e]))


if __name__ == '__main__':
    # CheckMultiplePeopleTypes()
    # CheckRelationshipsInTitle()
    # CheckForEntities()
    # CheckForLtGt()
    IterateThroughFields()
    print "--== FINISHED ==--"
