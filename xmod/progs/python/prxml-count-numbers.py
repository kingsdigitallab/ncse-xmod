#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Tue 22.05.2007 01:55:50 BST gb>

# Count the number of publication numbers in corpus,
# i. e. the number of ZIP files

# as a side effect test segmentation fault with prxml-to-tokenDB.py
# on Debian systems by importing the same modules as for prxml-to-tokenDB.py

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
from StringIO import StringIO
# from byutil import *
import sqlite3
from bymysqlmap import *


# db_host = "localhost"

# prog_host = socket.gethostname()

# dbname = "ncse_tokens"

# rexmlent = re.compile(r"""&[^ ].*?;""")
remysqlcomm1 = re.compile(r"""^--.*$""")

# corpusinpath = "/projects/cch/ncse/olive/samples_2007/Drive_E_OliveInternal_2007/"
# corpusinpath = "/projects/cch/ncse/olive/skua/Drive_E_OliveInternal/2007samples"


repfilename = "logs/PRXML-COUNT-NUMBERS"
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
    dbcf = varsdic["db_create_file"]
    # ATTENTION! "isolation_level=None" turns on autocommit
    con = sqlite3.connect(dbfp, isolation_level=None)
    # con = sqlite3.connect(confobj.confvarsdic["db_filepath"])
    slcrfobj = file(dbcf, "r")
    slcreatestr = slcrfobj.read()
    slcrfobj.close()
    slcur = con.cursor()
    slcur.executescript(slcreatestr)
    del slcur
    return con

def setupMySQL(varsdic):
    dbhost = varsdic["db_host"]
    dbname = varsdic["db_name"]
    dbcf = varsdic["db_create_file"]
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
    #print dbhost
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
                # print "-" * 30
                # print mycreateline
                # print "-" * 30
                mycur = mycon.cursor()
                mycur.execute(mycreateline)
                del mycur
                mycreateline = ""
            else:
                mycreateline += mc
    # mycur = mycon.cursor()
    # mycur.executemany(mycreatestr)
    # del mycur
    # sys.exit()
    return mycon

def getOutFileName(dir):
    partslist = dir.split("/")
    fn = "-".join(partslist[-4:-2]) + ".sql"
    return fn



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
                    "db_passwd" : "DB"
                    }
    confobj = bygetconfig.ByGetConfig(confvarsdic)
    
    numbercount = 0
    zipfilecount = 0
    tocfilecount = 0
    
    # Go one directory level down and walk on "real" path, as normally publication
    # directories in the corpus directory are symbolic links to their real places
    # and "os.walk" does not follow symbolic links
    for corpussubdir in os.listdir(confobj.confvarsdic["corpusinpath"]):
        corpusfullsubdir = os.path.join(confobj.confvarsdic["corpusinpath"], corpussubdir)
        corpussubpath = os.path.realpath(corpusfullsubdir)
        # print corpussubpath
        # for walkroot, walkdirs, walkfiles in os.walk(confobj.confvarsdic["corpusinpath"]):
        for walkroot, walkdirs, walkfiles in os.walk(corpussubpath):
            # print walkroot, walkdirs, walkfiles
            # if len(walkfiles) != 3:
            #     print "Not exactly 3 files in dir"
            #     sys.exit()
            if len(walkfiles) > 0:
                numbercount += 1
                # print walkroot, walkdirs, walkfiles
                # print "WALKROOT: ", walkroot
                # print "WALKDIRS: ", walkdirs
                # print "WALKFILES:", walkfiles
                PrintCF(repf, 1, "%s" % (walkroot, ))
                for f in walkfiles:
                    if f.endswith(".zip"):
                        zipfilecount += 1
                        PrintCF(repf, 1, "   ZIP file: %s -- no.: % 7d." % (f, zipfilecount))
                    elif f == "TOC.xml":
                        tocfilecount += 1
                        PrintCF(repf, 1, "   TOC file exists -- no.: % 7d." % (tocfilecount, ))


    PrintCF(repf, 1, "%s" % ("", ))
    if ((numbercount != zipfilecount) or (numbercount != tocfilecount) or (zipfilecount != tocfilecount)):
        PrintCF(repf, 1, "!" * 30)
        PrintCF(repf, 1, "Mismatch in numbers!")
        PrintCF(repf, 1, "!" * 30)
        PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Numbers:   % 8d" % (numbercount, ))
    PrintCF(repf, 1, "ZIP files: % 8d" % (zipfilecount, ))
    PrintCF(repf, 1, "TOC files: % 8d" % (tocfilecount, ))
    
    print "--== FINISHED ==--"
