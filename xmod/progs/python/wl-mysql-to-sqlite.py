#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Sat 26.05.2007 01:47:28 BST gb>

import sys
import string

import re
import socket
import platform
from types import *
import time
import sqlite3
from bymysqlmap import *

db_host = "localhost"

prog_host = socket.gethostname()

slcreatefile = "/projects/cch/ncse/waterloo/db/sql/sqlite/waterloo_full_tokens_create.sql"
slcrfobj = file(slcreatefile, "r")
slcreatestr = slcrfobj.read()
slcrfobj.close()
slinspos = slcreatestr.index("INSERT")
slcreatestr = slcreatestr[:slinspos-1]

sldbname = "/projects/cch/ncse/waterloo/db/sql/sqlite/waterloo_full_tokens.db"

slcon = sqlite3.connect(sldbname)
slcur = slcon.cursor()
slcur.executescript(slcreatestr)
del slcur

msdbname = "waterloo_full_tokens"

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
                                   db=msdbname
                                   )
else:
    con        = MySQLdb.connect(
                                   use_unicode=by_use_unicode,
                                   charset=by_charset,
                                   host=db_host,
                                   port=51524,
                                   user="gbrey",
                                   passwd="Ujs92ila",
                                   db=msdbname
                                   )



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

# escape SQLite control characters
def SQLiteEscape(s):
    s = s.replace("'", "''")
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
 
def GetTables():
    sql = "SHOW TABLES"
    selobj = SqlResultList(con=con, sql=sql)
    tablelist = selobj.getRowTuple()
    nooftables = selobj.getRowCount()
    del selobj
    tablelist = [ti[0] for ti in tablelist]
    return tablelist

def GetFields(t):
    sql = "SHOW COLUMNS FROM %s" % t
    selobj = SqlResultList(con=con, sql=sql)
    fieldlist = selobj.getRowTuple()
    nooffields = selobj.getRowCount()
    del selobj
    fieldlist = [fi[0] for fi in fieldlist]
    return fieldlist

def GetNoOfRows(t):
    sql = "select count(*) from %s" % t
    selobj = SqlResultList(con=con, sql=sql)
    noofrows = selobj.getRowTuple()
    del selobj
    noofrows = noofrows[0][0]
    return noofrows
    

if __name__ == '__main__':
    tables = GetTables()
    tables = ["categories", ]
    for table in tables:
        fields = GetFields(table)
        print table, fields
        # noofrows = GetNoOfRows(table)
        # print noofrows
        selfieldstr = ", ".join(fields)
        sql = "SELECT %s FROM %s" % (selfieldstr, table)
        print sql
        selobj = SqlResultList(con=con, sql=sql)
        restuple = selobj.getRowTuple()
        rescount = selobj.getRowCount()
        del selobj
        print rescount
        for resrowtuple in restuple:
            print resrowtuple

    print "--== FINISHED ==--"
