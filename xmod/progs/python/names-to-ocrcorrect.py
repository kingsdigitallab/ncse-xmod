#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Tue 22.05.2007 01:55:50 BST gb>

# convert output from diverse DBs as authoritative lookup lists
# with last names only for OCR correct

import sys
import string
import re
import os, os.path


def printUsage():
    print
    print "Usage:"
    print
    print "      ", os.path.basename(sys.argv[0]), "<infile> <outfile>"
    print
    sys.exit(2)

def getLineList():
    if (len(sys.argv) != 3):
        printUsage()
    
    infile = sys.argv[1]
    outfile = sys.argv[2]
    
    if infile == "":
        printUsage()
    
    if outfile == "":
        printUsage()
    
    if infile == outfile:
        print
        print "infile and outfile are the same file!"
        print
        print "INFILE: ", infile
        print "OUTFILE:", outfile
        sys.exit(2)
    
    if not os.path.isfile(infile):
        print
        print "ERROR: '" + infile + "' is not a file."
        print
        sys.exit(2)
    
    if not os.path.exists(infile):
        print
        print "ERROR: '" + infile + "' does not exist."
        print
        sys.exit(2)
    
    if os.path.dirname(infile) == os.path.dirname(outfile):
        print
        print "Directory of infile and outfile are the same!"
        print
        sys.exit(2)
        
    infileobj = file(infile, "r")
    outfileobj = file(outfile, "w")
    ll = infileobj.readlines()
    infileobj.close()
    th = ll.pop(0)
    return th, ll, outfileobj

if __name__ == '__main__':
    (tableheader, linelist, ofo) = getLineList()
    # print tableheader
    linecounter = 0
    for line in linelist:
        linecounter += 1
        line = line.rstrip()
        if linecounter < 10:
            print line

    ofo.close()
    print "--== FINISHED ==--"
