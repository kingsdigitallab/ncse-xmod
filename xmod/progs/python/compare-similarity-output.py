#!/usr/bin/env python
# -*- coding: utf-8 -*-

# compare the output of two different similarity processes
#   show overlaps, differences

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

# BOX
simresbasepath = "/projects/cch/ncse/textmining/lucene-similarity"
simres1 = "sim-keywords"
simres2 = "sim-texts"
# -----------------------
# NCSE-TEXT.CCH.KCL.AC.UK
# simresbasepath = "/home/ncseoutput/www/lucene-similarity"
# simres1 = "keywords-20081015"
# simres2 = "text-20081015"

simres1basepath = os.path.join(simresbasepath, simres1) 
simres2basepath = os.path.join(simresbasepath, simres2) 

retitle = re.compile(r"""^.*<title>(?P<title>.+?)</title>.*$""")
resimdocs = re.compile(r"""<span class="id">(?P<simdoc>.+?)</span>""")

totalsdic = {
             "kw" : 0,
             "kwtext" : 0,
             "inboth" : 0,
             "in1notin2" : 0,
             "in2notin1" : 0
             }

totalsdiffdic = {
             "kw" : 0,
             "kwtext" : 0,
             "inboth" : 0,
             "in1notin2" : 0,
             "in2notin1" : 0
             }

def checkSimResBasePaths():
    if not os.path.exists(simres1basepath):
        print
        print "Base path of similarity results ('%s') does not exist!" % (simres1basepath, )
        print
        sys.exit(2)
    if not os.path.isdir(simres1basepath):
        print
        print "Base path of similarity results ('%s') exists, but is not a directory!" % (simres1basepath, )
        print
        sys.exit(2)
    if not os.path.exists(simres2basepath):
        print
        print "Base path of similarity results ('%s') does not exist!" % (simres2basepath, )
        print
        sys.exit(2)
    if not os.path.isdir(simres2basepath):
        print
        print "Base path of similarity results ('%s') exists, but is not a directory!" % (simres2basepath, )
        print
        sys.exit(2)

def parseSimResFile(st):
    # r = re.search(retitle, st)
    # title = r.group('title')
    # r = re.search(resimdocs, st)
    simfoundlist = re.findall(resimdocs, st)
    # print "TITLE:", title
    # print len(simfoundlist)
    # return title, simfoundlist
    return simfoundlist

def compareSimLists(sl1, sl2):
    slresdic = {}
    sl1set = set(sl1)
    sl2set = set(sl2)
    slresdic["inboth"] = list(sl1set.intersection(sl2set))
    slresdic["in1notin2"] = list(sl1set.difference(sl2set))
    slresdic["in2notin1"] = list(sl2set.difference(sl1set))
    # print sl1set
    # print sl2set
    return slresdic


def main(args):
    checkSimResBasePaths()
    for walkroot, walkdirs, walkfiles in os.walk(simres1basepath):
        print "WR", walkroot
        print "WD", walkdirs
        # print "WF", walkfiles
        nooffiles = 0
        if walkfiles != []:
            for wf in walkfiles:
                # print "WF", wf
                simres1filepath = os.path.join(walkroot, wf)
                simres2filepath = simres1filepath.replace(simres1, simres2)
                if not os.path.exists(simres2filepath):
                    print
                    print "Corresponding file: ('%s') does not exist!" % (simres2filepath, )
                    print
                else:
                    simres1fileobj = file(simres1filepath, "r")
                    simres2fileobj = file(simres2filepath, "r")
                    simres1cont = simres1fileobj.read()
                    simres2cont = simres2fileobj.read()
                    
                    (simsource, eee) = os.path.splitext(wf)
                    sim1list = parseSimResFile(simres1cont)
                    sim2list = parseSimResFile(simres2cont)
                    
                    simlistdic = compareSimLists(sim1list, sim2list)
                    # print "-" * 60
                    # print "% 30s  % 14s  % 14s  % 14s  % 14s  % 14s" % ("", "keywords", "kw and texts", "in both", "in 1 not in 2", "in 2 not in 1")
                    # print "% -30s  % 14d  % 14d  % 14d  % 14d  % 14d" % (simsource, len(sim1list), len(sim2list), len(simlistdic["inboth"]), len(simlistdic["in1notin2"]), len(simlistdic["in2notin1"]))                     
                    # print "IN BOTH:      ", simlistdic["inboth"]
                    # print "IN 1 NOT IN 2:", simlistdic["in1notin2"]
                    # print "IN 2 NOT IN 1:", simlistdic["in2notin1"]

                    sim1listlen = len(sim1list)
                    sim2listlen = len(sim2list)
                    siminbothlen = len(simlistdic["inboth"])
                    simin1notin2len = len(simlistdic["in1notin2"])
                    simin2notin1len = len(simlistdic["in2notin1"])
                    totalsdic["kw"] += sim1listlen
                    totalsdic["kwtext"] += sim2listlen
                    totalsdic["inboth"] += siminbothlen
                    totalsdic["in1notin2"] += simin1notin2len
                    totalsdic["in2notin1"] += simin2notin1len
                    if not ((simlistdic["in1notin2"] == []) and (simlistdic["in2notin1"] == [])):
                        totalsdiffdic["kw"] += sim1listlen
                        totalsdiffdic["kwtext"] += sim2listlen
                        totalsdiffdic["inboth"] += siminbothlen
                        totalsdiffdic["in1notin2"] += simin1notin2len
                        totalsdiffdic["in2notin1"] += simin2notin1len
                        print "-" * 60
                        print "% 30s  % 14s  % 14s  % 14s  % 14s  % 14s" % ("", "keywords", "kw and texts", "in both", "in 1 not in 2", "in 2 not in 1")
                        print "% -30s  % 14d  % 14d  % 14d  % 14d  % 14d" % (simsource, sim1listlen, sim2listlen, siminbothlen, simin1notin2len, simin2notin1len)                     
                        print "IN BOTH:      ", simlistdic["inboth"]
                        print "IN 1 NOT IN 2:", simlistdic["in1notin2"]
                        print "IN 2 NOT IN 1:", simlistdic["in2notin1"]
                    
                    simres1fileobj.close()
                    simres2fileobj.close()
    print
    print "=" * 60
    print "TOTALS"
    print "% 30s  % 14s  % 14s  % 14s  % 14s  % 14s" % ("", "keywords", "kw and texts", "in both", "in 1 not in 2", "in 2 not in 1")
    print "% -30s  % 14d  % 14d  % 14d  % 14d  % 14d" % ("", totalsdic["kw"], totalsdic["kwtext"], totalsdic["inboth"], totalsdic["in1notin2"], totalsdic["in2notin1"])                     
    print
    print "=" * 60
    print "TOTALS for cases where keyword and keyword+text found different docs"
    print "% 30s  % 14s  % 14s  % 14s  % 14s  % 14s" % ("", "keywords", "kw and texts", "in both", "in 1 not in 2", "in 2 not in 1")
    print "% -30s  % 14d  % 14d  % 14d  % 14d  % 14d" % ("", totalsdiffdic["kw"], totalsdiffdic["kwtext"], totalsdiffdic["inboth"], totalsdiffdic["in1notin2"], totalsdiffdic["in2notin1"])                     

if __name__ == "__main__":
    main(sys.argv[1:])

