#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Tue 22.05.2007 01:55:50 BST gb>

# TODO: read in directory hierarchy beforehand
#       sort dir list and use this list to walk the dirs
#       use my own recursive dir walking routine, that stores
#       dirs in list

import sys
import string

import re
import socket
import platform
import time
import types
import os, os.path
import bygetconfig
# from xml.etree import ElementTree as ET
from lxml import etree as ET
from bymysqlmap import *

# import of SQLite module depends on Python version
# from Python 2.5 onwards - sqlite3 support is in included
pythonversiontuple = platform.python_version_tuple()
if pythonversiontuple[0] != "2":
    print
    print "Wrong Python version! Need at least version 2!"
    print
    sys.exit(2)
else:
    if pythonversiontuple[1] == "4":
        from pysqlite2 import dbapi2 as sqlite
    elif pythonversiontuple[1] == "5":
        import sqlite3 as sqlite
    else:
        print
        print "Don't know about SQLite support under"
        print "Python version %s.%s" % (pythonversiontuple[0], pythonversiontuple[1])
        print
        sys.exit(2)

confvarsdic = {}
# confvarsdic["db_host"] = "localhost"
confvarsdic["db_host"] = "ncse-text.cch.kcl.ac.uk"
confvarsdic["db_type"] = "MySQL"
confvarsdic["db_path"] = "/projects/cch/ncse/textmining/db/sql/sqlite"
confvarsdic["db_name"] = "ncsetoks_myisam_"
confvarsdic["db_port"] = "51524"
confvarsdic["db_user"] = "gbrey"
confvarsdic["db_passwd"] = "Ujs92ila"
confvarsdic["corpusoutpath"] = "/projects/cch/ncse/gate/corpus/"
confvarsdic["limit_offset"] = 0
confvarsdic["limit_step"] = 100

publlist = [
            "LDR",
            "EWJ",
            "TEC",
            "TTW",
            "MRP",
            "NSS"
            ]

# LDR-1857-10-17-Ar02311
# follow this pattern to determine the kind of output required
# for example:
#    "LDR":                    output all of the Leader
#    "LDR-1857":               output Leader all of 1857
#    "LDR-1857-10-17"          output Leader all of 1857/10/17
#    "LDR-1857-10-17-Ar02311": output this one specific article from Leader
# articlepath = "LDR-1860-11-24-Ar01500"

# rexmlent = re.compile(r"""&[^ ].*?;""")
remysqlcomm1 = re.compile(r"""^--.*$""")
# reartid = re.compile(r"""^((LDR)|(EWJ)|(TEC)|(TTW)|(MRP)|(NSS))-?(18\d\d)?-?((0|1)\d)?-?((0|1|2|3)\d)?-?(Ar\d{5,8})?$""")
reartid = re.compile(r"""^(?P<publ>(LDR)|(EWJ)|(FEWJ)|(TEC)|(FTEC)|(TTEC)|(TTW)|(MRP)|(NSS))-?(?P<year>18\d\d)?-?(?P<month>(0|1)\d)?-?(?P<day>(0|1|2|3)\d)?-?(?P<artid>Ar\d{5,8})?$""")


repfilename = "logs/CORPUS-WRITE"
repfilename += "-"
repfilename += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
repfilename += ".LOG"

repf = file(repfilename, "w")


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
    s = s.replace("\t", "\\t")
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

def setupSQLite(varsdic):
    dbfp = varsdic["db_filepath"]
    # ATTENTION! "isolation_level=None" turns on autocommit
    con = sqlite3.connect(dbfp, isolation_level=None)
    # con = sqlite3.connect(confobj.confvarsdic["db_filepath"])
    # Do _not_ create new DB structure, as we don't want to
    # delete data inserted in a previous run
    # createStrucSQLite(con, varsdic)
    return con

def getDbName(dbprefix, ap):
    if ap[:3] not in publlist:
        print
        print "Article path must start with a 3-letter publication abbreviation."
        print
        sys.exit()
    else:
        dbsuffix = ap[:3].lower()
        dbn = dbprefix + dbsuffix
        return dbn

def setupMySQL(varsdic, artpath):
    dbhost = varsdic["db_host"]
    dbname = getDbName(varsdic["db_name"], artpath)
    dbport = int(varsdic["db_port"])
    dbuser = varsdic["db_user"]
    dbpasswd = varsdic["db_passwd"]
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
        by_use_unicode = True
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
        mycon        = MySQLdb.connect(
                                       use_unicode=by_use_unicode,
                                       charset=by_charset,
                                       host=dbhost,
                                       port=dbport,
                                       user=dbuser,
                                       passwd=dbpasswd,
                                       db=dbname
                                       )
    # Do _not_ create new DB structure, as we don't want to
    # delete data inserted in a previous run
    # createStrucMySQL(mycon, varsdic)
    return mycon

def getYearList(con, pu):
    sql = "SELECT distinct(year) FROM tokens WHERE publ = '%s'" % (pu, )
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    print rl
    sys.exit()

def getArticleSearchList(con, artiddic):
    if artiddic["year"] != None:
        sqlwhere += " AND year = %s" % (artiddic["year"])
        if artiddic["month"] != None:
            sqlwhere += " AND month = %s" % (artiddic["month"])
            if artiddic["day"] != None:
                sqlwhere += " AND day = %s" % (artiddic["day"])
                if artiddic["artid"] != None:
                    sqlwhere += " AND artid = '%s'" % (artiddic["artid"])
                    # sql = "SELECT DISTINCT(artid) FROM tokens WHERE "
                    sql = "SELECT tokenid, token, spaceaftertoken, artlineno, artid FROM tokens WHERE"
                    sql += sqlwhere
                    sql += " ORDER BY publ, year, month, day, artid, arttokenno"
                    selobj = SqlResultList(con=con, sql=sql)
                    rl = selobj.getRowTuple()
                    rc = selobj.getRowCount()
                    del selobj
                    # process tokens for article
                else:
                    # GET artid
                    sql = "SELECT DISTINCT(artid) FROM tokens WHERE "
                    sql += sqlwhere
                    sql += " ORDER BY publ, year, month, day, artid, arttokenno"
                    selobj = SqlResultList(con=con, sql=sql)
                    rl = selobj.getRowTuple()
                    rc = selobj.getRowCount()
                    del selobj
                    # SELECT article   
            else:
                pass
                # GET days
                # for day in days:
                #    GET artid
                #    SELECT article   
        else:
            pass
            # for month in months:
            # GET months
            #    GET days
            #    for day in days:
            #       GET artid
            #       SELECT article   
    else:
        # GET years
        # for year in years:
        #    GET months
        #    for month in months:
        #       GET days
        #       for day in days:
        #          GET artid
        #          SELECT article   
        if artiddic["month"] != None:
            sqlwhere += " AND month = %s" % (artiddic["month"])
            if artiddic["day"] != None:
                sqlwhere += " AND day = %s" % (artiddic["day"])
                if artiddic["artid"] != None:
                    sqlwhere += " AND artid = '%s'" % (artiddic["artid"])

def getDistinctArtIds(con, artiddic):
    allwlist = []
    tmplist = []
    sqlartids = "SELECT DISTINCT(artid) FROM tokens WHERE "
    sqlwhere = ""
    if artiddic["publ"] == None:
        print
        print "At least the 3-letter abbreviation for the publication"
        print "must be given!"
        print
        sys.exit()
    sqlwhere += "publ = '%s'" % (artiddic["publ"])
    if artiddic["artid"] != None:
        sqlwhere += " AND year = %s" % (artiddic["year"])
        sqlwhere += " AND month = %s" % (artiddic["month"])
        sqlwhere += " AND day = %s" % (artiddic["day"])
        sqlwhere += " AND artid = '%s'" % (artiddic["artid"])
        tmplist.append(artiddic["publ"])
        tmplist.append(artiddic["year"])
        tmplist.append(artiddic["month"])
        tmplist.append(artiddic["day"])
        tmplist.append(artiddic["artid"])
        allwlist.append(tmplist)
        return allwlist
    elif artiddic["artid"] == None:
        sqlwhere += " AND year = %s" % (artiddic["year"])
        sqlwhere += " AND month = %s" % (artiddic["month"])
        sqlwhere += " AND day = %s" % (artiddic["day"])
        sql = sqlartids + sqlwhere
        selobj = SqlResultList(con=con, sql=sql)
        rl = selobj.getRowTuple()
        rc = selobj.getRowCount()
        del selobj
        for r in rl:
            tmplist.append(artiddic["publ"])
            tmplist.append(artiddic["year"])
            tmplist.append(artiddic["month"])
            tmplist.append(artiddic["day"])
            tmplist.append(r[0])
            allwlist.append(tmplist)
            tmplist = []
        return allwlist

#    if artiddic["year"] != None:
#        sqlwhere += " AND year = %s" % (artiddic["year"])
#        if artiddic["month"] != None:
#            sqlwhere += " AND month = %s" % (artiddic["month"])
#            if artiddic["day"] != None:
#                sqlwhere += " AND day = %s" % (artiddic["day"])
#                if artiddic["artid"] != None:
#                    sqlwhere += " AND artid = '%s'" % (artiddic["artid"])


def getOutFileName(dir):
    partslist = dir.split("/")
    fn = "-".join(partslist[-4:-2]) + ".tab"
    return fn

if __name__ == '__main__':
    # articlepath = "LDR-1850-07-27-Ar00200"
    # articlepath = "LDR-1850-07-27-Ar00400"
    # articlepath = "LDR-1850-07-27-Ar00502"
    # articlepath = "LDR-1850-07-27"
    # articlepath = "LDR-1850-07"
    # articlepath = "LDR-1850"
    # articlepath = "LDR"
    # articlepath = "LDR-1860-11-24"
    # articlepath = "LDR-1860-11-24"
    # articlepath = "LDR-1860-11"
    # articlepath = "LDR-1860"
    # articlepath = "LDR"
    articlepath = "LDR-1859-09-24-Ar02417"
    articlepath = "LDR-1859-09-24"
    articlepath = "LDR-1859"
    if confvarsdic["db_type"] == "SQLite":
        # Get SQLite connection object
        # dbcon = setupSQLite(confobj.confvarsdic["db_filepath"], confobj.confvarsdic["db_create_file"])
        dbcon = setupSQLite(confvarsdic["db_path"])
    elif confvarsdic["db_type"] == "MySQL":
        # dbcon = setupMySQL(confobj.confvarsdic["db_host"], confobj.confvarsdic["db_name"], confobj.confvarsdic["db_create_file"])
        dbcon = setupMySQL(confvarsdic, articlepath)

    # ^((LDR)|(EWJ)|(TEC)|(TTW)|(MRP)|(NSS))-?(18\d\d)?-?((0|1)\d)?-?((0|1|2|3)\d)?-?(Ar\d{5,8})?$
    r = re.search(reartid, articlepath)
    try:
        artiddic = r.groupdict()
    except AttributeError:
        print 'Error in format of article id: "%s"' % (articlepath, )
        sys.exit()
    # print artiddic
    # pymdaidlist = getDistinctArtIds(dbcon, artiddic)
    # print pymdaidlist

    # if artiddic["year"] == None:
    #     yearlist = getYearList(dbcon, artiddic["publ"])
    #     for year in yearlist:
    #         print year
    # sys.exit()
    
    #  select tokenid, token, spaceaftertoken from tokens where publ = 'LDR' and year = 1860 and month = 11 and day = 24 and artid = 'Ar01500' order by arttokenno 
    sqlartids = "SELECT DISTINCT(artid) FROM tokens WHERE "
    sqlarts = "SELECT tokenid, token, spaceaftertoken, artlineno, artid FROM tokens WHERE "
    sqlfullartids = "SELECT id, fullartid FROM fullartids WHERE "
    # sql = "select publ, year, month, day, artid from tokens where "
    # sql = "SELECT DISTINCT(SUBSTRING_INDEX(tokenid, '-', 5)) from tokens where "
    sqlwhere = ""
    sqlwhere += "publ = '%s'" % (artiddic["publ"])
    if artiddic["year"] != None:
        sqlwhere += " AND year = %s" % (artiddic["year"])
        if artiddic["month"] != None:
            sqlwhere += " AND month = %s" % (artiddic["month"])
            if artiddic["day"] != None:
                sqlwhere += " AND day = %s" % (artiddic["day"])
                if artiddic["artid"] != None:
                    sqlwhere += " AND artid = '%s'" % (artiddic["artid"])
    sqlwhere = "fullartid LIKE '%s%%'" % (articlepath, )
    # sqlorder = " ORDER BY publ, year, month, day, artid, arttokenno"
    sqlorder = " ORDER BY fullartid"
    
    sqlartids += sqlwhere
    sqlarts += sqlwhere + sqlorder
    sqlfullartids += sqlwhere + sqlorder
    
    # print sqlartids
    # print sqlarts
    print sqlfullartids
    # sys.exit()

    selobj = SqlResultList(con=dbcon, sql=sqlfullartids)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    fullartidslist = [r[0] for r in rl]
    # print rl
    # print fullartidslist
    # print rc

    arttext = ""
    
    sqlarts = "SELECT tokenid, token, spaceaftertoken, artlineno, artid FROM tokens WHERE "
    sqlwhere = "fullartidid = %d"
    sqlorder = " ORDER BY arttokenno"
    sqlarts += sqlwhere + sqlorder
    for faid in fullartidslist:
        sql = sqlarts % (faid, )
        # print sql
        selobj = SqlResultList(con=dbcon, sql=sql)
        rl = selobj.getRowTuple()
        rc = selobj.getRowCount()
        del selobj
        # print "#" * 30
        # print rl
        # print rc
        artlineno = 0
        prevartlineno = 0
        for r in rl:
            (tokenid, token, spaceaftertoken, artlineno, artid) = r

            if artlineno == prevartlineno:
                arttext += token + spaceaftertoken
            else:
                if prevartlineno == 0:
                    arttext += token + spaceaftertoken
                else:
                    arttext += "\n" + token + spaceaftertoken
            prevartlineno = artlineno

        fullartid = tokenid[:tokenid.rindex("-")]
        # print tokenid, token
        print fullartid
        fullartidfn = fullartid + ".txt"
        outfilepath = os.path.join(confvarsdic["corpusoutpath"], fullartidfn)
        outfileobj = file(outfilepath, "w")
        print >> outfileobj, arttext
        outfileobj.close()
        arttext = ""


    sys.exit()

    rc = 1
    offset = confvarsdic["limit_offset"]
    limitstep = confvarsdic["limit_step"]
    arttext = ""
    artlineno = 0
    prevartlineno = 0
    prevartid = ""
    while rc != 0:
        sqllimit = sql + " LIMIT %d, %d" % (offset, limitstep)
        # print sqllimit
        print offset, 
        offset = offset + limitstep
        selobj = SqlResultList(con=dbcon, sql=sqllimit)
        rl = selobj.getRowTuple()
        rc = selobj.getRowCount()
        for r in rl:
            # print r
            artlineno = r[3]
            currartid = r[4]
            if currartid != prevartid:
                currtokenid = r[0]
                fullartid = currtokenid[:currtokenid.rindex("-")]
                print
                print "-" * 30
                print fullartid
                print "-" * 30
                fullartidfn = fullartid + ".txt"
                outfilepath = os.path.join(confvarsdic["corpusoutpath"], fullartidfn)
                outfileobj = file(outfilepath, "w")
                print >> outfileobj, arttext
                outfileobj.close()
                arttext = ""
                prevartid = currartid
            if artlineno == prevartlineno:
                arttext += r[1] + r[2]
            else:
                arttext += "\n" + r[1] + r[2]
            prevartlineno = artlineno
        del selobj
    # print
    # print arttext
    
    print "--== FINISHED ==--"
