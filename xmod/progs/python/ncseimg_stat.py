#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import string

import re
import socket
import platform
import time
import types
import os, os.path
from byutil import *
from bymysqlmap import *
# from xml.etree import ElementTree as ET
# from lxml import etree as ET
from optparse import OptionParser

def setupMySQL(dbhost, dbuser, dbpasswd, dbport, dbname):
    # for the time being we don't do any checking and just assume
    # that dbhost, etc. exist
    # dbhost = o.dbhost
    # dbname = o.dbname
    # dbport = o.dbport
    # dbuser = o.dbuser
    # dbpasswd = o.dbpass
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
    # initFieldNames(mycon)
    return mycon

def getSqlQuery(sql, con):
    selobj = SqlResultList(con=con, sql=sql)
    rl = selobj.getRowTuple()
    rc = selobj.getRowCount()
    del selobj
    reslist = [r[0] for r in rl]
    return rc, rl

if __name__ == '__main__':
    # con = setupMySQL("localhost", "ncse", "J0urnal", 51524, "ncsemetadata")
    con = setupMySQL("ncse-text.cch.kcl.ac.uk", "ncse", "J0urnal", 51524, "ncsemetadata")
    rowcount = 0
    # sql = "select c_toc_meta_fullartid, o_ent_meta_embedded_after from allmetadata where o_ent_meta_embedded_after != ''"
    ##### fullartid field:
    # c_toc_meta_fullartid
    ##### image related fields:
    # n_toc_appd_kc_imgdesc
    # n_ent_appd_kc_imgdesc            <----
    # o_ent_meta_embedded_after        <----
    # o_toc_enty_embedded_after
    # o_ent_meta_embedded_into         <----
    # o_toc_enty_embedded_into
    # 
    sql = "select c_toc_meta_fullartid, n_toc_appd_kc_imgdesc from allmetadata where n_toc_appd_kc_imgdesc != ''"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "%30s: % 10d records" % ("n_toc_appd_kc_imgdesc", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, n_ent_appd_kc_imgdesc from allmetadata where n_ent_appd_kc_imgdesc != ''"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "%30s: % 10d records" % ("n_ent_appd_kc_imgdesc", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, o_ent_meta_embedded_after from allmetadata where o_ent_meta_embedded_after != ''"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "%30s: % 10d records" % ("o_ent_meta_embedded_after", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, o_toc_enty_embedded_after from allmetadata where o_toc_enty_embedded_after != ''"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "%30s: % 10d records" % ("o_toc_enty_embedded_after", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, o_ent_meta_embedded_into from allmetadata where o_ent_meta_embedded_into != ''"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "%30s: % 10d records" % ("o_ent_meta_embedded_into", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, o_toc_enty_embedded_into from allmetadata where o_toc_enty_embedded_into != ''"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "%30s: % 10d records" % ("o_toc_enty_embedded_into", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, o_ent_meta_embedded_after from allmetadata where o_ent_meta_embedded_after != '' and (o_ent_meta_embedded_after = o_toc_enty_embedded_after)"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "o_ent_meta_embedded_after != '' and (o_ent_meta_embedded_after = o_toc_enty_embedded_after)"
    print "%30s: % 10d records" % ("", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, o_ent_meta_embedded_into from allmetadata where o_ent_meta_embedded_into != '' and (o_ent_meta_embedded_into = o_toc_enty_embedded_into)"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "o_ent_meta_embedded_into != '' and (o_ent_meta_embedded_into = o_toc_enty_embedded_into)"
    print "%30s: % 10d records" % ("", rowcount)

    # as "o_ent_meta_embedded_after" and "o_toc_enty_embedded_after"
    # seem to have identical content, we only use "o_ent_meta_embedded_after"
    # from now on 
    # as "o_ent_meta_embedded_into" and "o_toc_enty_embedded_into"
    # seem to have identical content, we only use "o_ent_meta_embedded_into"
    # from now on
    
    # 
    sql = "select c_toc_meta_fullartid, o_ent_meta_embedded_after, o_ent_meta_embedded_into from allmetadata where (o_ent_meta_embedded_after != '') and (o_ent_meta_embedded_into != '')"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "(o_ent_meta_embedded_after != '') and (o_ent_meta_embedded_into != '')"
    print "%30s: % 10d records" % ("", rowcount)
    # sql = "select c_toc_meta_fullartid, o_ent_meta_embedded_after, o_ent_meta_embedded_into from allmetadata where (o_ent_meta_embedded_after != '') and (o_ent_meta_embedded_into != '') limit 10"
    # (rowcount, rowlist) = getSqlQuery(sql, con)
    # for row in rowlist:
    #     print row
    
    # 
    sql = "select c_toc_meta_fullartid, o_ent_meta_embedded_after, o_ent_meta_embedded_into from allmetadata where (o_ent_meta_embedded_after != '') and (o_ent_meta_embedded_into = '')"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "(o_ent_meta_embedded_after != '') and (o_ent_meta_embedded_into = '')"
    print "%30s: % 10d records" % ("", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, o_ent_meta_embedded_after, o_ent_meta_embedded_into from allmetadata where (o_ent_meta_embedded_into != '') and (o_ent_meta_embedded_after = '')"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "(o_ent_meta_embedded_into != '') and (o_ent_meta_embedded_after = '')"
    print "%30s: % 10d records" % ("", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, n_ent_appd_kc_imgdesc, o_ent_meta_embedded_after from allmetadata where (o_ent_meta_embedded_after != '') and (n_ent_appd_kc_imgdesc = '')"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "(o_ent_meta_embedded_after != '') and (n_ent_appd_kc_imgdesc = '')"
    print "%30s: % 10d records" % ("", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, n_ent_appd_kc_imgdesc, o_ent_meta_embedded_into from allmetadata where (o_ent_meta_embedded_into != '') and (n_ent_appd_kc_imgdesc = '')"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "(o_ent_meta_embedded_into != '') and (n_ent_appd_kc_imgdesc = '')"
    print "%30s: % 10d records" % ("", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, n_ent_appd_kc_imgdesc, o_ent_meta_embedded_after from allmetadata where (n_ent_appd_kc_imgdesc != '') and (o_ent_meta_embedded_after = '')"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "(n_ent_appd_kc_imgdesc != '') and (o_ent_meta_embedded_after = '')"
    print "%30s: % 10d records" % ("", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, n_ent_appd_kc_imgdesc, o_ent_meta_embedded_into from allmetadata where (n_ent_appd_kc_imgdesc != '') and (o_ent_meta_embedded_into = '')"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "(n_ent_appd_kc_imgdesc != '') and (o_ent_meta_embedded_into = '')"
    print "%30s: % 10d records" % ("", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, n_ent_appd_kc_imgdesc, o_ent_meta_embedded_after from allmetadata where (n_ent_appd_kc_imgdesc != '') and (o_ent_meta_embedded_after != '')"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "(n_ent_appd_kc_imgdesc != '') and (o_ent_meta_embedded_after != '')"
    print "%30s: % 10d records" % ("", rowcount)
    # 
    sql = "select c_toc_meta_fullartid, n_ent_appd_kc_imgdesc, o_ent_meta_embedded_into from allmetadata where (n_ent_appd_kc_imgdesc != '') and (o_ent_meta_embedded_into != '')"
    (rowcount, rowlist) = getSqlQuery(sql, con)
    print "(n_ent_appd_kc_imgdesc != '') and (o_ent_meta_embedded_into != '')"
    print "%30s: % 10d records" % ("", rowcount)
    

    # print rowlist
    print "--== FINISHED ==--"
