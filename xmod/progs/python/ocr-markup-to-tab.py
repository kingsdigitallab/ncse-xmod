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
# from byutil import *
# from bymysqlmap import *
# from xml.etree import ElementTree as ET
# from lxml import etree as ET
# from optparse import OptionParser

inbasedir = "/projects/cch/ncse/textmining/ocr-correct/eval_vicky/OCR-mark-up/checked"
suffixlist = [" checked", " checked.txt"]

outbasedir = "/projects/cch/ncse/textmining/ocr-correct"
outfilename = "ocr-correct.tab"

reats = re.compile(r"""@+(.*?)@+(.*?)@+""")

filelist = os.listdir(inbasedir)

def scanString(fistr):
    pos = 0
    fistrlen = len(fistr)
    # print fistr[fistrlen-1]
    wrong = ""
    right = ""
    errstr = ""
    while pos < fistrlen:
        if fistr[pos] == "@":
            pos += 1
            while (pos < fistrlen) and (fistr[pos] == "@"):
                pos += 1
            # pos += 1
            while (pos < fistrlen) and (fistr[pos] != "@"):
              wrong += fistr[pos]
              pos += 1
            wlen = len(wrong)
            # pos += 1
            while (pos < fistrlen) and (fistr[pos] == "@"):
                pos += 1
            # pos += 1
            # print fistrlen, pos
            while (pos < fistrlen) and (fistr[pos] != "@"):
              right += fistr[pos]
              pos += 1
              if len(right) > wlen + 5:
                  errstr = "<" + "-" * 19
                  continue
            # pos += 1
            print "%-30s %-30s %-20s" % (wrong, right, errstr)
            wrong = ""
            right = ""
            errstr = ""
            
        pos += 1

for fi in filelist:
    fipath = os.path.join(inbasedir, fi)
    faid = fi[:fi.index("_checked")]
    fiobj = file(fipath, "r")
    at1counterrors = 0
    at3counterrors = 0
    for (lineno, line) in enumerate(fiobj):
        lineno += 1
        line = line.strip()
        if line.find("@@@") != -1:
            at1count = line.count("@")
            at3count = line.count("@@@")
            if at1count % 3 != 0:
                at1counterrors += 1
                print "NOT 3 @@@     : %s, line % 4i" % (faid, lineno)
            if at3count % 3 != 0:
                at3counterrors += 1
                print "MISALIGNED @@@: %s, line % 4i" % (faid, lineno)
    # if (at1counterrors != 0) or (at3counterrors != 0):
    #     print faid, at1counterrors, at3counterrors
    fiobj.close()

print "-" * 50
print "Markup OK"
print "-" * 50

fopath = os.path.join(outbasedir, outfilename)
foobj = file(fopath, "w")

for fi in filelist:
    fipath = os.path.join(inbasedir, fi)
    faid = fi[:fi.index("_checked")]
    fiobj = file(fipath, "r")
    # fistr = fiobj.read()
    filist = fiobj.readlines()
    fistr = "".join(filist)
    fistr = fistr.replace("@\n", "@ ")
    fistr = fistr.replace("\n", "")
    # print fistr
#    if fistr.find("@@@") != -1:
#        at1count = fistr.count("@")
#        at3count = fistr.count("@@@")
#        # print fistr
#        if at1count % 3 != 0:
#            at1counterrors += 1
#            print "NOT 3 @@@     : %s" % (faid, )
#        if at3count % 3 != 0:
#            at3counterrors += 1
#            print "MISALIGNED @@@: %s" % (faid, )
    # print "-" * 50
    # print faid
    for wrong, right in re.findall(reats, fistr):
        wlen = len(wrong)
        rlen = len(right)
        errstr = ""
        # if rlen > wlen + 5:
        #     right = right[:wlen]
        #     errstr = "<" + "-" * 19
        # print "%-30s %-30s %-20s" % (wrong, right, errstr)
        print "%s\t%s\t%s" % (wrong, right, faid)
        print >> foobj, "%s\t%s\t%s" % (wrong, right, faid)
# 
#    pos = 0
#    fistrlen = len(fistr)
#    # print fistr[fistrlen-1]
#    pair = {}
#    pair.setdefault("wrong", "")
#    pair.setdefault("right", "")
#    errstr = ""
#    pkey = None
#    while pos < fistrlen:
#        if (fistr[pos] == "@") and (pkey == None):
#            pkey = "wrong"
#            
#
#            print "%-30s %-30s %-20s" % (wrong, right, errstr)
#            wrong = ""
#            right = ""
#            errstr = ""
#            
#        pos += 1
    fiobj.close()
foobj.close()
print "--== FINISHED ==--"
