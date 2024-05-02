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
# from yahoo.search.web import WebSearch

# f = urllib2.urlopen('http://www.python.org/')
# print f.read()

# params = urllib.urlencode({'spam': 1, 'eggs': 2, 'bacon': 0})
# f = urllib.urlopen("http://www.musi-cal.com/cgi-bin/query?%s" % params)
# print f.read()

nameslistbasedir = "/projects/cch/ncse/textmining/gate"

# nameslistfile = "google-billington-0.45.txt"
# nameslistfile = "google-billington-0.6.txt"
# nameslistfile = "google-billington-utftest.txt"
# nameslistfile = "google-palmerston-0.25.txt"
# nameslistfile = "google-palmerston-0.35.txt"
# nameslistfile = "google-palmerston-0.45.txt"
nameslistfile = "google-mixture-1133-entries.txt"

b, e = os.path.splitext(nameslistfile)
nameslistfileout = b + "-out" + e
nameslistfileoutpath = os.path.join(nameslistbasedir, nameslistfileout)

nameslist = []

nameslistfilepath = os.path.join(nameslistbasedir, nameslistfile)
ninfobj = file(nameslistfilepath, "r")
noutfobj = file(nameslistfileoutpath, "w")

print time.strftime("%Y-%m-%d-%H-%M", time.localtime())
print >> noutfobj, time.strftime("%Y-%m-%d-%H-%M", time.localtime())

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

# nameslist = ["billinqton"]
# nameslist = ["bruat"]

gparamsdic = {
    'v' : '1.0',
    'q' : 'palmerston'
    }

yparamsdic = {
    'appid' : 'YahooDemo',
    'query' : 'palmerston',
    'region' : 'us',
    'type'   : 'phrase',
    'output'   : 'json',
    'results'   : '1'
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
        erc = "0"
    return erc
    
def lookupYahooRest(pdic):
    params = urllib.urlencode(pdic)
    yahoourl = "http://search.yahooapis.com/WebSearchService/V1/webSearch?%s" % params
    
    try:
        f = urllib.urlopen(yahoourl)
        jsonstr = f.read()
    except:
        print "Yahoo web services request failed"
        sys.exit()

    # print jsonstr
    jsonpy = simplejson.loads(jsonstr)
    #print jsonpy
    #for k in jsonpy.keys():
    #    print k
    #    print jsonpy[k]
    f.close()
    if jsonpy["ResultSet"].has_key("totalResultsAvailable"):
        erc = jsonpy["ResultSet"]["totalResultsAvailable"]
    else:
        erc = "0"
    return erc
    
def lookupYahooApi(name):
    app_id = "YahooDemo"
    srch = WebSearch(app_id)
    # type: "all", "any", or "phrase"
    srch.type = "phrase"
    srch.query = name
    srch.results = 1
    # similar_ok: no value or 1
    # srch.similar_ok = 1
    # output: "xml", "json", "php"
    srch.output = "xml"
    dom = srch.get_results()
    results = srch.parse_results(dom)
    totav = results.totalResultsAvailable
    del srch
    return totav
    
# print "responseDetails:", jsonpy["responseDetails"]
# print "responseStatus: ", jsonpy["responseStatus"]
# print jsonpy["responseData"]
# print "responseData :: cursor: ", jsonpy["responseData"]["cursor"]
# print "responseData :: results:", jsonpy["responseData"]["results"]
# print "responseData :: cursor :: estimatedResultCount:", jsonpy["responseData"]["cursor"]["estimatedResultCount"]

if __name__ == '__main__':
    for n in nameslist:
        gparamsdic["q"] = n
        yparamsdic["query"] = n
        grescount = lookupGoogle(gparamsdic)
        yrescountr = lookupYahooRest(yparamsdic)
        # yrescounta = lookupYahooApi(n)
        # 
        # print "%-30s: G %10s   Y %10s" % (n, grescount, yrescount)
        # print "%-30s: G %10s   Y %10s   Y %10s" % (n, grescount, yrescounta, yrescountr)
        print "%-30s: G %10s   Y %10s" % (n, grescount, yrescountr)
        print >> noutfobj, "%-30s: G %10s   Y %10s" % (n, grescount, yrescountr)
        noutfobj.flush()
        # print "%-30s: G %10s   Y %10s  %i  %i" % (n, grescount, yrescount, int(yrescount)/(int(grescount)+0.0001), int(yrescount)-int(grescount))

    print time.strftime("%Y-%m-%d-%H-%M", time.localtime())
    print >> noutfobj, time.strftime("%Y-%m-%d-%H-%M", time.localtime())
    noutfobj.close()
    print "--== FINISHED ==--"
