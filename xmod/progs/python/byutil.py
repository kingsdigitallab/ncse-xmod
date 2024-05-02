# -*- coding: utf-8 -*-

# Time-stamp: <Tue 22.05.2007 01:55:50 BST gb>

import os, os.path

import socket
import platform
import time
from bymysqlmap import *

# --------------------------------------------------------------------
# helper functions
# --------------------------------------------------------------------

def getRepfileObject(slp, ap, suffix):
    # repfiledir = slp
    # repfilefile = ap + "-" + suffix
    repfiledir = slp
    repfilefile = suffix + "-" + ap
    repfilefile += "-"
    # repfilefile += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
    repfilefile += time.strftime("%Y%m%d%H%M", time.localtime())
    repfilefile += ".log"
    repfilepath = os.path.join(repfiledir, repfilefile)
    repf = file(repfilepath, "w")
    return repf

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

def initFieldNamesFieldNameList(table, con):
    fnlist = []
    sql = "SHOW COLUMNS FROM " + table
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    for r in rl:
        fn = r[0]
        ft = r[1].lower()
        fi = r[3]
        if fi != "PRI":
            if ((ft.startswith("varchar")) or (ft.startswith("char")) or (ft.startswith("textchar"))):
                fnlist.append([fn, "'"])
            else:
                fnlist.append([fn, ""])
    return fnlist

def ORIinitFieldNames(con):
    global semtagsfieldnamelist, semtagnamesfieldnamelist, fullartidsfieldnamelist, llhvfieldnamelist, semtagsalfieldnamelist
    semtagsfieldnamelist     = initFieldNamesFieldNameList("semtags", con)
    semtagnamesfieldnamelist = initFieldNamesFieldNameList("semtagnames", con)
    fullartidsfieldnamelist  = initFieldNamesFieldNameList("fullartids", con)
    llhvfieldnamelist        = initFieldNamesFieldNameList("llhv", con)
    semtagsalfieldnamelist   = initFieldNamesFieldNameList("semtagsal", con)

def ORIsetupMySQL(o):
    # for the time being we don't do any checking and just assume
    # that dbhost, etc. exist
    dbhost = o.dbhost
    dbname = o.dbname
    dbport = o.dbport
    dbuser = o.dbuser
    dbpasswd = o.dbpass
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
        # changed: BY 08.02.12
        # by_use_unicode = True
        # by_charset = "latin1"
        by_use_unicode = False
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
        # mycon        = MySQLdb.connect(
        #                                use_unicode=by_use_unicode,
        #                                charset=by_charset,
        #                                host=dbhost,
        #                                port=dbport,
        #                                user=dbuser,
        #                                passwd=dbpasswd,
        #                                db=dbname
        #                                )
        # changed: BY 08.02.12
        # TODO: work out how "use_unicode" and "charset" are really
        #       handled by the MySQLDB driver
        mycon        = MySQLdb.connect(
                                       host=dbhost,
                                       port=dbport,
                                       user=dbuser,
                                       passwd=dbpasswd,
                                       db=dbname
                                       )
    # Do _not_ create new DB structure, as we don't want to
    # delete data inserted in a previous run
    # createStrucMySQL(mycon, varsdic)
    initFieldNames(mycon)
    return mycon

def writeReportCommandLine(r):
    (ddir, commandline) = os.path.split(sys.argv[0])
    commandline += " "
    commandline += " ".join(sys.argv[1:])
    PrintCF(r, 1, "")
    PrintCF(r, 1, "Command line used:")
    PrintCF(r, 1, commandline)
    PrintCF(r, 1, "")

def writeReport(r, lmsgdic, ap, counterstr):
    # (ddir, commandline) = os.path.split(sys.argv[0])
    # commandline += " "
    # commandline += " ".join(sys.argv[1:])
    
    logmsglist = lmsgdic.keys()
    logmsglist.sort()

    # PrintCF(r, 1, "")
    # PrintCF(r, 1, "Command line used:")
    # PrintCF(r, 1, commandline)
    # PrintCF(r, 1, "")
    PrintCF(r, 1, "Article path extracted: %s" % (ap, ))
    PrintCF(r, 1, "")
    PrintCF(r, 1, "Directory / %s" % (counterstr, ))
    PrintCF(r, 1, "-" * 60)
    dirlen = len(logmsglist[0])
    tabspace = " " * (6 + (14 - dirlen))
    totfilecount = 0
    for k in logmsglist:
        PrintCF(r, 1, "%s%s% 7d" % (k, tabspace, lmsgdic[k]))
        totfilecount += lmsgdic[k]
    PrintCF(r, 1, "-" * 60)
    dirlen = len("Total")
    tabspace = " " * (6 + (14 - dirlen))
    PrintCF(r, 1, "%s%s% 7d" % ("Total", tabspace, totfilecount))
    PrintCF(r, 1, "")


if __name__ == '__main__':

    print "--== FINISHED ==--"
