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
# import urllib2
import urllib
import simplejson

# f = urllib2.urlopen('http://www.python.org/')
# print f.read()

# params = urllib.urlencode({'spam': 1, 'eggs': 2, 'bacon': 0})
# f = urllib.urlopen("http://www.musi-cal.com/cgi-bin/query?%s" % params)
# print f.read()

nameslistbasedir = "/projects/cch/ncse/textmining/gate"

nameslistfile = "google-billington-0.45.txt"
# nameslistfile = "google-billington-0.6.txt"
# nameslistfile = "google-billington-utftest.txt"
# nameslistfile = "google-palmerston-0.25.txt"
# nameslistfile = "google-palmerston-0.35.txt"
# nameslistfile = "google-palmerston-0.45.txt"

nameslist = []

nameslistfilepath = os.path.join(nameslistbasedir, nameslistfile)
ninfobj = file(nameslistfilepath, "r")
for n in ninfobj:
    n = n.strip()
    # print "LIST:", type(n)
    # n = n.decode("utf8")
    # print "LIST:", type(n)
    # print type(u)
    # print n
    # for x in n:
    #     print ord(x)
    nameslist.append(n)
ninfobj.close()

#paramsdic = {
#    'v' : '1.0',
#    'q' : 'Paris Hilton'
#    }

paramsdic = {
    'v' : '1.0',
    'q' : 'palmerston'
    }

def lookupGoogle(pdic):
    params = urllib.urlencode(pdic)
    # googleparis = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=Paris%20Hilton'
    googleurl = 'http://ajax.googleapis.com/ajax/services/search/web?%s' % params
    
    try:
        f = urllib.urlopen(googleurl)
        jsonstr = f.read()
    except:
        print "Google web services request failed"
        sys.exit()

    # print jsonstr
    jsonpy = simplejson.loads(jsonstr)
    #print jsonpy
    #for k in jsonpy.keys():
    #    print k
    #    print jsonpy[k]
    # 
    # responseDetails  = jsonpy["responseDetails"]
    # responseStatus   = jsonpy["responseStatus"]
    # responseDataCursor = jsonpy["responseData"]["cursor"]
    # responseDataResults = jsonpy["responseData"]["results"]
    f.close()
    if jsonpy["responseData"]["cursor"].has_key("estimatedResultCount"):
        erc = jsonpy["responseData"]["cursor"]["estimatedResultCount"]
    else:
        erc = "-1"
    return erc
    
# print "responseDetails:", jsonpy["responseDetails"]
# print "responseStatus: ", jsonpy["responseStatus"]
# print jsonpy["responseData"]
# print "responseData :: cursor: ", jsonpy["responseData"]["cursor"]
# print "responseData :: results:", jsonpy["responseData"]["results"]
# print "responseData :: cursor :: estimatedResultCount:", jsonpy["responseData"]["cursor"]["estimatedResultCount"]

if __name__ == '__main__':
    for n in nameslist:
        paramsdic["q"] = n
        estResCount = lookupGoogle(paramsdic)
        print "%-30s: %10s" % (paramsdic["q"], estResCount)

    print "--== FINISHED ==--"
