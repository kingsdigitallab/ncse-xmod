#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import string

import re
# import socket
# import platform
# import time
import types
import os, os.path
from byutil import *
from bymysqlmap import *

# from xml.etree import ElementTree as ET
# from lxml import etree as ET

# from xml.sax import make_parser
# from xml.sax.handler import ContentHandler
# import xml.parsers.expat

from xml.sax import saxutils, parse, handler

# class GateNeeNamesHandler(saxutils.DefaultHandler):
class GateNeeNamesHandler(handler.ContentHandler):
    def __init__(self, tablename, dbfilenamelist, con):
        self.tablename = tablename
        self.dbfilenamelist = dbfilenamelist
        self.con = con
        self.persondic = {}
        self.persondic.setdefault("fullname", "")
        self.persondic.setdefault("lastname", "")
        self.persondic.setdefault("firstname", "")
        self.persondic.setdefault("title", "")
        self.persondic.setdefault("fullartid", "")
        self.persondic.setdefault("ofullname", "")
        self.persondic.setdefault("olastname", "")
        self.persondic.setdefault("ofirstname", "")
        self.persondic.setdefault("otitle", "")
        self.persondic.setdefault("rule", "")
        self.persondic.setdefault("rule1", "")
        self.persondic.setdefault("frequency", 0)
        self.chars = []
        self.joinstr = ""
        self.fieldstonormalise = ['fullname', 'lastname', 'firstname', 'title']
        self.personcounter = 0
        
    def resetPersonDic(self):
        self.persondic = {}
        self.persondic.setdefault("fullname", "")
        self.persondic.setdefault("lastname", "")
        self.persondic.setdefault("firstname", "")
        self.persondic.setdefault("title", "")
        self.persondic.setdefault("fullartid", "")
        self.persondic.setdefault("ofullname", "")
        self.persondic.setdefault("olastname", "")
        self.persondic.setdefault("ofirstname", "")
        self.persondic.setdefault("otitle", "")
        self.persondic.setdefault("rule", "")
        self.persondic.setdefault("rule1", "")
        self.persondic.setdefault("frequency", 0)
        
    def characters(self, content):
        self.chars.append(content)
        # print content.decode("iso8859-15")
        # self.chars.append(content.encode("iso8859-15"))
        
    def startElement(self, name, atts):
        self.chars = []
        if name == "Person":
            self.resetPersonDic()
            self.personcounter += 1
            # if self.personcounter % 1000 == 0:
            #     print str(self.personcounter) + ", ",
        elif name == "PERSONDATA":
            print "Processing %s ..." % (self.tablename, )
        
    
    def endElement(self, name):
        if name == "Person":
            self.persondic["frequency"] = 0
            # print "-" * 30
            for k in self.persondic.keys():
                # print k, self.persondic[k]
                if type(self.persondic[k]) in types.StringTypes:
                    # ----------------- 
                    # print type(self.persondic[k])
                    # print k
                    # print self.persondic[k].encode("utf8")
                    # print self.persondic[k]
                    # ----------------- 
                    # self.persondic[k] = self.persondic[k].decode("iso8859-15")
                    self.persondic[k] = self.persondic[k].encode("utf8")
                    self.persondic[k] = self.persondic[k].replace('\n', '')
                    # We don't normalise capitalisation here after all
                    # JMV said that that could be done in Lucene
                    # if k in self.fieldstonormalise:
                    #     self.persondic[k] = self.normaliseName(self.persondic[k])
                    self.persondic[k] = MySQLEscape(self.persondic[k])
                    # print k, self.persondic[k]
            self.writeToMySql()
        elif name == "FullName":
            self.persondic["fullname"] = self.joinstr.join(self.chars).lower()
            self.persondic["ofullname"] = self.joinstr.join(self.chars)
            # self.persondic["fullname"] = self.persondic["fullname"].encode("utf8")
            # self.persondic["ofullname"] = self.persondic["ofullname"].encode("utf8") 
        elif name == "LastName":
            self.persondic["lastname"] = self.joinstr.join(self.chars).lower()
            self.persondic["olastname"] = self.joinstr.join(self.chars)
            # self.persondic["lastname"] = self.persondic["lastname"].encode("utf8")
            # self.persondic["olastname"] = self.persondic["olastname"].encode("utf8") 
        elif name == "FirstName":
            self.persondic["firstname"] = self.joinstr.join(self.chars).lower()
            self.persondic["ofirstname"] = self.joinstr.join(self.chars)
            # self.persondic["firstname"] = self.persondic["firstname"].encode("utf8")
            # self.persondic["ofirstname"] = self.persondic["ofirstname"].encode("utf8") 
        elif name == "Title":
            self.persondic["title"] = self.joinstr.join(self.chars).lower()
            self.persondic["otitle"] = self.joinstr.join(self.chars)
            # self.persondic["title"] = self.persondic["title"].encode("utf8")
            # self.persondic["otitle"] = self.persondic["otitle"].encode("utf8") 
        elif name == "Doc":
            self.persondic["fullartid"] = self.joinstr.join(self.chars)
        elif name == "Rule":
            self.persondic["rule"] = self.joinstr.join(self.chars)
        elif name == "Rule1":
            self.persondic["rule1"] = self.joinstr.join(self.chars)
        # elif name == "PERSONDATA":
        #     print 

                # print k, self.persondic[k]
            # for k in personfields:
            #     print k, self.persondic[k]

    def normaliseName(self, f):
        # test first for a number of conditions, like Scottish names, etc.
        f = string.capwords(f)
        return f

    def writeToMySql(self):
        # ------------------------------
        fnlist = []
        fvlist = []
        # print self.dbfilenamelist
        for (tfn, s) in self.dbfilenamelist:
            fnlist.append(tfn)
            fvlist.append(s + str(self.persondic[tfn]) + s)
            # fvlist.append(s + unicode(self.persondic[tfn]) + s)
        # print fnlist
        # print fvlist
        insobj = SqlInsert(con=self.con, 
                           table=self.tablename, 
                           fieldnames=fnlist, 
                           fieldvalues=fvlist)
        # print insobj.getInsertString()
        tid = insobj.getLastRowId()
        del insobj
        
        
if __name__ == '__main__':
    xmlinfile = "/projects/cch/ncse/gate_nee_out/EWJ/Person.lst.xml"
    namesHandler = GateNeeNamesHandler("mytable", ["field1", "field2"], "con")
    parse(xmlinfile, namesHandler)
    print "--== FINISHED ==--"
