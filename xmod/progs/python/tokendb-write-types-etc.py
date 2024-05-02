#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Tue 22.05.2007 01:55:50 BST gb>

# TODO: fix character encoding

import sys
import string

import re
import socket
import platform
import time
import types
import os, os.path

from optparse import OptionParser

# import bygetconfigparse
# from xml.etree import ElementTree as ET
# from lxml import etree as ET
from bymysqlmap import *
def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "- you have to at least supply options '-d' and '-l'"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)

# escape MySQL control characters
def MySQLEscape(s):
    s = s.replace("\\", "\\\\")
    s = s.replace("\t", "\\t")
    s = s.replace('"', '\\"')
    s = s.replace("'", "\\'")
    return s

def getRepfileObject(cop, ap):
    repfiledir = cop
    repfilefile = ap
    repfilefile += "-"
    # repfilefile += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
    repfilefile += time.strftime("%Y%m%d%H%M", time.localtime())
    repfilefile += ".LOG"
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

def setupMySQL(o):
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
    elif prog_host.startswith("ncse-text") == True:
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
    # print dbhost
    # print dbname
    # sys.exit()
    try:
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
    except MySQLdb.OperationalError:
        print
        print "ATTENTION:"
        print
        print "      ", "DB '%s' does not exist or can't be read." % (dbname, )
        print
        sys.exit(2)
        
    # Do _not_ create new DB structure, as we don't want to
    # delete data inserted in a previous run
    # createStrucMySQL(mycon, varsdic)
    return mycon

def TestForNonEmptyDb(con, dbn):
    sql = "SELECT count(*), max(id) FROM tokens"
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    noofrecords = rl[0][0]
    maxid       = rl[0][1]
    if noofrecords < 1:
        print
        print "ATTENTION:"
        print
        print "      ", "DB '%s' is empty." % (dbn, )
        print
        sys.exit(2)
    else:
        return maxid

def prepLogs(cop, pu):
    """Prepare log file directories."""
    logdir = os.path.join(cop, "00_LOGS", pu)
    # if not os.path.exists(logdir):
    #     os.makedirs(logdir, 0755)
    print logdir

def writeToTypesTable(con, tok, table, field):
    if table == "lctypes":
        tok = tok.lower()
        sql = "SELECT id, %s, frequency FROM %s WHERE %s = '%s'" % (field, table, field, tok)
    else:
        # If using MySQL
        # we have to declare on of the comparisan terms in the where clause with a collating
        # sequence that is case sensitive, otherwise the case of the type entry will not
        # be differentiated
        sql = "SELECT id, %s, frequency FROM %s WHERE %s = '%s' COLLATE latin1_bin" % (field, table, field, tok)
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

def ProcessTokens(con, maxid):
    for i in range(1, maxid):
        sql = "SELECT id, token FROM tokens WHERE id = %d" % (i, )
        selobj = SqlResultList(con=con, sql=sql)
        rl = selobj.getRowTuple()
        rc = selobj.getRowCount()
        del selobj
        if (i % 1000) == 0:
            PrintCF(repf, 1, "tokenid: % 9d of % 9d" % (i, maxid))
        if rc > 0:
            token = rl[0][1]
            # print sql, token, rc
            token = MySQLEscape(token)
            # token = token.encode("utf-8")
            typeid = writeToTypesTable(con, token, "types", "type")
            lctypeid = writeToTypesTable(con, token, "lctypes", "lctype")
            updfnfv = "typeid=%d, lctypeid=%d" % (typeid, lctypeid)
            sql = "UPDATE tokens SET %s where %s=%d" % (updfnfv, "id", i)
            updobj = SqlResultList(con=con, sql=sql)
            rc = updobj.getRowCount()
            del updobj
            # print i, token, typeid, lctypeid


if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-d", "--dbname", dest="dbname",
                      help="DB name - no default", metavar="DB")
    parser.add_option("-s", "--dbserver", dest="dbhost", default="localhost",
                      help="DB host - default: localhost", metavar="HOST")
    parser.add_option("-P", "--port", dest="dbport", default=51524, type="int",
                      help="DB port - default: 51524", metavar="PORT")
    parser.add_option("-u", "--user", dest="dbuser", default="gbrey",
                      help="DB user - default: gbrey", metavar="USER")
    parser.add_option("-p", "--password", dest="dbpass", default="Ujs92ila",
                      help="DB password - default: XXX", metavar="PW")
    parser.add_option("-l", "--logdir", dest="logdir",
                      help="write log file to directory DIR - no default", metavar="DIR")
    # parser.add_option("-t", "--types", dest="writetypes", default=True,
    #                   help="populate types table")
    # parser.add_option("-l", "--lctypes", dest="writelctypes", default=True,
    #                   help="populate lctypes table")
    (options, args) = parser.parse_args()
    if ((options.dbname == None) or (options.logdir == None)):
        printUsage()
    dbcon = setupMySQL(options)
    maxtokensid = TestForNonEmptyDb(dbcon, options.dbname)
    repf = getRepfileObject(options.logdir, "TDBWT")
    # logmsgdic = {}

    ProcessTokens(dbcon, maxtokensid)
    
    # logmsglist = logmsgdic.keys()
    # logmsglist.sort()
    repf.close()
    print "--== FINISHED ==--"
