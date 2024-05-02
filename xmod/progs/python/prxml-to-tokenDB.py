#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Tue 22.05.2007 01:55:50 BST gb>

# TODO: read in directory hierarchy beforehand
#       sort dir list and use this list to walk the dirs
#       use my own recursive dir walking routine, that stores
#       dirs in list
# TODO: ZIP files can also be called Documents.zip
# publ, year, month, day --> fullartid
# add token count and Olive word count to fullartid
# add charcount, charnscount, linecount to fullartid
# TODO: fix case insensitivity in types and lctypes
# DONE: add frequency count to types
# DONE: new table lctypes for lower case version
# 

import sys
import string

import re
import socket
import platform
import time
import types
import os, os.path
import bygetconfig
import bytocfile
import byzipfile
import byarttext
# from zipfile import *
# from xml.etree import ElementTree as ET
from lxml import etree as ET
# from StringIO import StringIO
# from byutil import *

# from bymysqlmap import *
# from bysqlite3map import *

# import cProfile

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


# db_host = "localhost"

# prog_host = socket.gethostname()

# dbname = "ncse_tokens"

# rexmlent = re.compile(r"""&[^ ].*?;""")
remysqlcomm1 = re.compile(r"""^--.*$""")

# corpusinpath = "/projects/cch/ncse/olive/samples_2007/Drive_E_OliveInternal_2007/"
# corpusinpath = "/projects/cch/ncse/olive/skua/Drive_E_OliveInternal/2007samples"


# repfilename = "logs/PRXML-READ"
# repfilename += "-"
# repfilename += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
# repfilename += ".LOG"
# repf = file(repfilename, "w")


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
    
def prepareCorpusImgBaseDir(cvd):
    # change this - i. e. get publication directory from config file
    # (x, publ) = os.path.split(cvd["corpusinpath"])
    cibdir = cvd["corpusimagebasedir"]
    # cipdir = os.path.join(cibdir, publ)
    # cipdir = cvd["corpusimgpubldir"]
    if os.path.exists(cibdir):
        # print "Please remove directory %s manually and try again." % (cipdir, )
        PrintCF(repf, 1, "Image base directory %s exists." % (cibdir, ))
        # sys.exit()
    else:
        os.makedirs(cibdir)
        PrintCF(repf, 1, "Corpus image directory %s created." % (cibdir, ))
    # return cipdir

def BuildSqlFieldString(l):
    fieldstring = ""
    for f in l:
        if fieldstring == "":
            fieldstring += f
        else:
            fieldstring += ", " + f
    return fieldstring

def createStrucSQLite(con, varsdic):
    dbcf = varsdic["db_create_file"]
    slcrfobj = file(dbcf, "r")
    slcreatestr = slcrfobj.read()
    slcrfobj.close()
    slcur = con.cursor()
    slcur.executescript(slcreatestr)
    del slcur

def setupSQLite(varsdic):
    # dbfp = varsdic["db_filepath"]
    # ATTENTION! "isolation_level=None" turns on autocommit
    # con = sqlite3.connect(dbfp, isolation_level=None)
    con = sqlite3.connect(confobj.confvarsdic["db_filepath"], isolation_level=None)
    # Do _not_ create new DB structure, as we don't want to
    # delete data inserted in a previous run
    # createStrucSQLite(con, varsdic)
    return con

def createStrucMySQL(con, varsdic):
    dbcf = varsdic["db_create_file"]
    mycrfobj = file(dbcf, "r")
    mycreatelist = mycrfobj.readlines()
    mycrfobj.close()
    mycreateline = ""
    for mc in mycreatelist:
        mc = mc.strip()
        if mc.startswith("--"):
            continue
        else:
            if mc.endswith(";"):
                mc = mc.rstrip(";")
                mycreateline += mc
                mycur = con.cursor()
                mycur.execute(mycreateline)
                del mycur
                mycreateline = ""
            else:
                mycreateline += mc

def setupMySQL(varsdic):
    dbhost = varsdic["db_host"]
    dbname = varsdic["db_name"]
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
    elif prog_host.startswith("yew") == True:
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
    # print prog_host
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

def getOutFileName(dir):
    partslist = dir.split("/")
    fn = "-".join(partslist[-4:-2]) + ".tab"
    return fn

def writeToTypesTable(con, tok, table, field):
    if table == "lctypes":
        tok = tok.lower()
        sql = "SELECT id, %s, frequency FROM %s WHERE %s = '%s'" % (field, table, field, tok)
    else:
        if confobj.confvarsdic["db_type"] == "MySQL":
            # If using MySQL
            # we have to declare on of the comparisan terms in the where clause with a collating
            # sequence that is case sensitive, otherwise the case of the type entry will not
            # be differentiated
            sql = "SELECT id, %s, frequency FROM %s WHERE %s = '%s' COLLATE latin1_bin" % (field, table, field, tok)
        elif confobj.confvarsdic["db_type"] == "SQLite":
            sql = "SELECT id, %s, frequency FROM %s WHERE %s = '%s'" % (field, table, field, tok)
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    if rc != 0:
        tid = rl[0][0]
        freq = rl[0][2]
        freq += 1
        updfnfv = "frequency=%d" % (freq, )
        sql = "UPDATE %s SET %s where %s=%d" % (table, updfnfv, "id", tid)
        updobj = SqlResultList(con=con, sql=sql)
        rl = updobj.getRowTuple()
        del updobj
    else:
        fv = "'%s'" % (tok, )
        freq = 1
        # insobj = SqlInsert(con=con,
        #                        table=table,
        #                        fieldnames=["id", field, "frequency"],
        #                        fieldvalues=["0", fv, str(freq)])
        insobj = SqlInsert(con=con,
                               table=table,
                               fieldnames=[field, "frequency"],
                               fieldvalues=[fv, str(freq)])
        tid = insobj.getLastRowId()
        del insobj
    return tid

def writeToFullArtIdsTable(con, faid, artobj):
    (publ, year, month, day, aid) = faid.split("-")
    sql = "SELECT id, fullartid FROM fullartids WHERE fullartid = '%s'" % (faid, )
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    # print "TOK:", tok
    # print "SQL:", sql
    # print "RC: ", rc
    # print "RL: ", rl
    if rc != 0:
        fid = rl[0][0]
    else:
        fv = "'%s'" % (faid, )
        publ = "'%s'" % (publ, )
        aid = "'%s'" % (aid, )
#        insobj = SqlInsert(con=con,
#                               table="fullartids",
#                               fieldnames=[
#                                           "id",
#                                           "fullartid",
#                                           "tokencount",
#                                           "olivewordcount",
#                                           "charcount",
#                                           "charnscount",
#                                           "linecount",
#                                           "publ",
#                                           "year",
#                                           "month",
#                                           "day",
#                                           "artid"
#                                           ],
#                               fieldvalues=[
#                                            "0",
#                                            fv,
#                                            str(artobj.arttokencount),
#                                            str(artobj.artolivewordcount),
#                                            str(artobj.charcount),
#                                            str(artobj.charnscount),
#                                            str(artobj.artlineno),
#                                            publ,
#                                            str(year),
#                                            str(month),
#                                            str(day),
#                                            aid
#                                            ])
        insobj = SqlInsert(con=con,
                               table="fullartids",
                               fieldnames=[
                                           "fullartid",
                                           "tokencount",
                                           "olivewordcount",
                                           "charcount",
                                           "charnscount",
                                           "linecount",
                                           "publ",
                                           "year",
                                           "month",
                                           "day",
                                           "artid"
                                           ],
                               fieldvalues=[
                                            fv,
                                            str(artobj.arttokencount),
                                            str(artobj.artolivewordcount),
                                            str(artobj.charcount),
                                            str(artobj.charnscount),
                                            str(artobj.artlineno),
                                            publ,
                                            str(year),
                                            str(month),
                                            str(day),
                                            aid
                                            ])
        # print
        # print insobj.getInsertString()
        # print
        # print insobj.getLastRowId()
        # print insobj.getLastAutoIncId()
        fid = insobj.getLastRowId()
        del insobj
    return fid


if __name__ == '__main__':
    confvarsdic = {
                    "corpusinpath" : "DIR",
                    "corpusimagebasedir" : "DIR",
                    "db_type" : "TYPE",
                    "db_output" : "OUT",
                    "db_path" : "DIR",
                    "db_create_file" : "FILE",
                    "db_name" : "DB",
                    "db_host" : "HOST",
                    "db_port" : "DB",
                    "db_user" : "DB",
                    "db_passwd" : "DB",
                    "generatecorpusimages" : "BOOL",
                    "generatearttext" : "BOOL"
                    }
    confobj = bygetconfig.ByGetConfig(confvarsdic)
    repf = confvarsdic["repf"]
    # corpusimgpubldir = prepareCorpusImgBaseDir(confvarsdic)
    # confobj.confvarsdic["corpusimgpubldir"] = prepareCorpusImgBaseDir(confvarsdic)
    prepareCorpusImgBaseDir(confvarsdic)
    # print corpusimagebasedir
    # print confobj.confvarsdic["corpusimgbasedir"]
    # sys.exit()
    print "DB:", confvarsdic["db_name"]
    if confobj.confvarsdic["db_output"] == "DB":
        if confobj.confvarsdic["db_type"] == "SQLite":
            from bysqlite3map import *
            # Get SQLite connection object
            # dbcon = setupSQLite(confobj.confvarsdic["db_filepath"], confobj.confvarsdic["db_create_file"])
            dbcon = setupSQLite(confobj.confvarsdic)
        elif confobj.confvarsdic["db_type"] == "MySQL":
            from bymysqlmap import *
            # dbcon = setupMySQL(confobj.confvarsdic["db_host"], confobj.confvarsdic["db_name"], confobj.confvarsdic["db_create_file"])
            dbcon = setupMySQL(confobj.confvarsdic)
    curroutfilename = ""
    # sqlskel = "INSERT INTO tokens (artid, fullartidid, arttokenno, tokenid, entityid, token, typeid, lctypeid, spaceaftertoken, olivepageno, publpageno, entlineno, artlineno, coordbox) VALUES (%s)"
    sqlskel = "INSERT INTO tokens (tokenid, token, spaceaftertoken, olivepageno, publpageno, entlineno, artlineno, arttokenno, fullartidid, entityid, typeid, lctypeid, coordbox, apfs, specialtype) VALUES (%s)"
    tokensfieldnamelist = [
                           ["tokenid", "'"],
                           ["token", "'"],
                           ["spaceaftertoken", "'"],
                           ["olivepageno", ""],
                           ["publpageno", "'"],
                           ["entlineno", ""],
                           ["artlineno", ""],
                           ["arttokenno", ""],
                           ["fullartidid", "'"],
                           ["entityid", "'"],
                           ["typeid", ""],
                           ["lctypeid", ""],
                           ["coordbox", "'"],
                           ["apfs", "'"],
                           ["specialtype", "'"]
                           ]

    tokensfieldvaldic = {}
    for (tfn, s) in tokensfieldnamelist:
        tokensfieldvaldic[tfn] = ""
    
    # print confobj.confvarsdic["corpusinpath"]
    # print confobj.confvarsdic["corpusimagebasedir"]
    # print confobj.confvarsdic["db_name"]
    # print confobj.confvarsdic["db_host"]
    # sys.exit()
    
    maxlenlist = [
                  "tokenid",
                  "entityid",
                  "token",
                  "publpageno",
                  "coordbox"
                  ]
    
    maxlendic = {}
    maxlenstrdic = {}
    for m in maxlenlist:
        maxlendic[m] = 0
        maxlenstrdic[m] = ""
#    tokenidlen = 0
#    tokenidlenstr = ""
#    entityidlen = 0
#    entitiyidlenstr = ""
#    tokenlen = 0
#    tokenlenstr = ""
#    publpagenolen = 0
#    publpagenolenstr = ""
    
    # Go one directory level down and walk on "real" path, as normally publication
    # directories in the corpus directory are symbolic links to their real places
    # and "os.walk" does not follow symbolic links
    for corpussubdir in os.listdir(confobj.confvarsdic["corpusinpath"]):
        corpusfullsubdir = os.path.join(confobj.confvarsdic["corpusinpath"], corpussubdir)
        corpussubpath = os.path.realpath(corpusfullsubdir)
        # print corpussubpath
        # for walkroot, walkdirs, walkfiles in os.walk(confobj.confvarsdic["corpusinpath"]):
        for walkroot, walkdirs, walkfiles in os.walk(corpussubpath):
            shortpath = walkroot.replace(os.path.realpath(confvarsdic["corpusinpath"]), "")
            if shortpath.startswith("/"):
                shortpath = shortpath[1:]
            # print "WWW:", walkroot, walkdirs, walkfiles
            # if len(walkfiles) != 3:
            #     print "Not exactly 3 files in dir"
            #     sys.exit()
            if len(walkfiles) > 0:
                if confobj.confvarsdic["db_output"] == "File":
                    outfilename = getOutFileName(walkroot)
                    if curroutfilename != outfilename:
                        # on the first iteration "curroutfilename" is still the empty string
                        # as I have assigned the empty string
                        if curroutfilename != "":
                            outfileobj.close()
                        curroutfilename = outfilename
                        outfilepath = os.path.join(confobj.confvarsdic["db_path"], curroutfilename)
                        outfileobj = file(outfilepath, "w")
                # print walkroot, walkdirs, walkfiles
                # print "WALKROOT: ", walkroot
                # print "WALKDIRS: ", walkdirs
                # print "WALKFILES:", walkfiles
                PrintCF(repf, 1, "%s" % (walkroot, ))
                currzip = byzipfile.ByZipFile(walkroot, walkfiles)
                if currzip.errzipfilepath != "":
                    PrintCF(repf, 1, "!" * 40)
                    PrintCF(repf, 1, "   ZIP file %s corrupt." % (currzip.errzipfilepath, ))
                    PrintCF(repf, 1, "!" * 40)
                    PrintCF(repf, 1, "-" * 40)
                    del currzip
                    continue
                if currzip.nonreposfile != "":
                    continue
                PrintCF(repf, 1, "   ZIP file %s opened." % (currzip.getZipFileName(), ))
                currtoc = bytocfile.ByTocFile(walkroot)
                PrintCF(repf, 1, "   TOC file read.")
                PrintCF(repf, 1, "   Processing article:")
                (artrefslist, artrefsdic) = currtoc.getArticleRefs()
                # print currtoc.entityrefsdic
                for artid in artrefslist:
                    # PrintCF(repf, 0, "%s, " % (artid, ))
                    PrintCF(repf, 1, "      %s: %s" % (shortpath, artid, ))
                    newart = byarttext.ByArticleText(artid, artrefsdic, currtoc, currzip, confobj.confvarsdic)
                    newart.processArticle()
                    # fullartid = newart.buildFullArticleId(artid)
                    fullartid = newart.fullarticleid
                    fullartidid = writeToFullArtIdsTable(dbcon, fullartid, newart)
                    # print "TOKENIDBASE:", newart.tokenidbase
                    for tokenl in newart.tokenlist:
                        # pass
                        # print tokenl
                        (
                         publ,
                         year,
                         month,
                         day,
                         artid,
                         arttokenno,
                         tokenid,
                         entityid,
                         token,
                         spaceaftertoken,
                         olivepageno,
                         publpageno,
                         entlineno,
                         artlineno,
                         coordbox,
                         apfs,
                         specialtype
                        ) = tokenl
                        # print tokenid
                        # print token, type(token)
                        for m in maxlenlist:
                            mstr = eval(m)
                            mstrlen = len(mstr)
                            if mstrlen > maxlendic[m]:
                                maxlendic[m] = mstrlen
                                maxlenstrdic[m] = mstr
                        # ESCAPE single quotes
                        if confobj.confvarsdic["db_type"] == "SQLite":
                            token = SQLiteEscape(token)
                            publpageno = SQLiteEscape(publpageno)
                            coordbox = SQLiteEscape(coordbox)
                        elif confobj.confvarsdic["db_type"] == "MySQL":
                            token = MySQLEscape(token)
                            # we don't have to do it anymore, as it is already
                            # non-unicode
                            # token = token.encode("utf-8")
                            publpageno = MySQLEscape(publpageno)
                            coordbox = MySQLEscape(coordbox)
                        if confobj.confvarsdic["db_output"] == "DB":
                            # cProfile.run('writeToTypesTable(dbcon, token, "types", "type")', 'prxmltotokendb.prof')
                            typeid = writeToTypesTable(dbcon, token, "types", "type")
                            lctypeid = writeToTypesTable(dbcon, token, "lctypes", "lctype")
                            tokensfieldvaldic["tokenid"] = tokenid
                            if confobj.confvarsdic["db_type"] == "SQLite":
                                tokensfieldvaldic["token"] = token.encode("utf-8")
                            else:
                                tokensfieldvaldic["token"] = token
                            tokensfieldvaldic["spaceaftertoken"] = spaceaftertoken
                            tokensfieldvaldic["olivepageno"] = olivepageno
                            tokensfieldvaldic["publpageno"] = publpageno
                            tokensfieldvaldic["entlineno"] = entlineno
                            tokensfieldvaldic["artlineno"] = artlineno
                            tokensfieldvaldic["arttokenno"] = arttokenno
                            tokensfieldvaldic["fullartidid"] = fullartidid
                            tokensfieldvaldic["entityid"] = entityid
                            tokensfieldvaldic["typeid"] = typeid
                            tokensfieldvaldic["lctypeid"] = lctypeid
                            tokensfieldvaldic["coordbox"] = coordbox
                            tokensfieldvaldic["apfs"] = apfs
                            tokensfieldvaldic["specialtype"] = specialtype
                            fnlist = []
                            fvlist = []
                            for (tfn, s) in tokensfieldnamelist:
                                fnlist.append(tfn)
                                fvlist.append(s + str(tokensfieldvaldic[tfn]) + s)
                            # print fnlist
                            # print fvlist
                            insobj = SqlInsert(con=dbcon, 
                                               table="tokens", 
                                               fieldnames=fnlist, 
                                               fieldvalues=fvlist)
                            tid = insobj.getLastRowId()
                            del insobj
                        else:
                            ################# write to file
                            ################# not maintained any more as data
                            ################# has to be written to DB
                            ################# -------------------------
                            ################# DELETE eventually
                            # (publ, year, month, day, artid, arttokenno)
                            vals = "0\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t" % (
                                                            artid,
                                                            fullartidid,
                                                            arttokenno,
                                                            tokenid,
                                                            entityid,
                                                            token,
                                                            typeid,
                                                            lctypeid,
                                                            spaceaftertoken)
                            vals += "%s\t" % (olivepageno, )
                            vals += "%s\t" % (publpageno, )
                            vals += "%s\t%s\t" % (entlineno, artlineno)
                            vals += "%s" % (coordbox, )
                            vals += "\n"
                            # print vals
                            outfileobj.write(vals)
                            outfileobj.flush()
                    del newart

                PrintCF(repf, 1, "")
                currzip.closeZipFile()
                del currzip
                PrintCF(repf, 1, "   ZIP file closed.")
                del currtoc
                PrintCF(repf, 1, "   TOC file closed.")
                PrintCF(repf, 1, "-" * 40)

    if confobj.confvarsdic["db_output"] == "File":
        outfileobj.close
            
    if confobj.confvarsdic["db_output"] == "DB":
        dbcon.close()

    PrintCF(repf, 1, "%s" % ("", ))
    for m in maxlenlist:
        PrintCF(repf, 1, "max. length of % 20s: %d" % (m, maxlendic[m]))
        PrintCF(repf, 1, "-" * 50)
        PrintCF(repf, 1, maxlenstrdic[m])
        PrintCF(repf, 1, "-" * 50)
    
    print "--== FINISHED ==--"
