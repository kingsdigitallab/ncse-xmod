#!/usr/bin/env python
# -*- coding: latin-1 -*-

# Time-stamp: <Thu 10.05.2007 19:49:01 GMT Standard Time gb>

import sys
import string

import re
import socket
import platform
import time

from bymysqlmap import *

db_host = "localhost"

prog_host = socket.gethostname()

dbname = "waterloo_full_no_ents"

rexmlent = re.compile(r"""&[^ ].*?;""")
reetc    = re.compile(r"""&(c|C)""")

repfilename = "logs/WL_DB_CONV_ENTS_to_CHARS"
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

tabledic = {
    "CountyNames" :
                  ["id",
                   "wlid",
                   "Name"]
                  ,
    "issuingbodynames" :
                  ["id",
                   "wlid",
                   "Name"]
                  ,
    "PeopleNames" :
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
    "TownNames" :
                  ["id",
                   "wlid",
                   "Name"]
    }


totalentdic = {}
totalentrefdic = {}
totalrealampdic = {}
totalrealamprefdic = {}

realentlist = (
               ("amp", "&"),
               ("apos", "'"),
               ("quot", '"'),
               ("lt", '<'),
               ("gt", '>')
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

def DoUpdate(table, fnfv, idno):
    sql = u"UPDATE %s SET %s where id=%d" % (table, fnfv, idno)
    updobj = SqlResultList(con=con, sql=sql)
    rc = updobj.getRowCount()
    del updobj

# convert XML entities to characters
def ConvertEntitiesToChars():
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
            fnfvstr = ""
            fcount = 0
            for af in allfields:
                if af == "id":
                    idval = rt[fcount]
                if af in textfields:
                    fieldchanged = 0
                    t = rt[fcount]
                    for ral in realentlist:
                        ent = "&" + ral[0] + ";"
                        cha = ral[1]
                        if t.find(ent) > -1:
                            PrintCF(repf, 1,  "-"* 50)
                            PrintCF(repf, 1, "REPLACED in %s : %s -- %s" % (table, af, ent))
                            PrintCF(repf, 1, t)
                            t = t.replace(ent, cha)
                            PrintCF(repf, 1, t)
                            t = MySQLEscape(t)
                            t = t.decode("latin1")
                            fieldchanged = 1
                    if fieldchanged == 1:
                        if fnfvstr == "":
                                fnfvstr = "%s='%s'" % (af, t)
                        else:
                                fnfvstr += ", %s='%s'" % (af, t)
                fcount += 1
            if fnfvstr != "":
                DoUpdate(table, fnfvstr, idval)
           
            


if __name__ == '__main__':
    ConvertEntitiesToChars()
    print "--== FINISHED ==--"
