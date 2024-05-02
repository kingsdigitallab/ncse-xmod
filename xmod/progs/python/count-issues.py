#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Tue 22.05.2007 01:55:50 BST gb>

import sys
import string

import os, os.path
# from xml.etree import ElementTree as ET
# from lxml import etree as ET

def printUsage():
    print
    print "Usage:"
    print
    print "      ", os.path.basename(sys.argv[0]), "<config file>"
    print
    sys.exit(2)


if __name__ == '__main__':
    if (len(sys.argv) != 2):
        printUsage()
    corpusinpath = sys.argv[1]
    if not os.path.exists(corpusinpath):
        print
        print "ERROR: directory '" + corpusinpath + "' does not exist."
        sys.exit(2)
    elif not os.path.isdir(corpusinpath):
        print
        print "ERROR: '" + corpusinpath + "' is not a directory."
        sys.exit(2)
    numbercount = 0
    zipsize = 0
    for walkroot, walkdirs, walkfiles in os.walk(corpusinpath):
        # if len(walkfiles) != 3:
        #     print "Not exactly 3 files in dir"
        #     sys.exit()
        if len(walkfiles) > 0:
            numbercount += 1
            # print walkroot, walkdirs, walkfiles
            for f in walkfiles:
                if f.endswith(".zip"):
                    zipfilepath = os.path.join(walkroot, f)
                    currzipsize = os.path.getsize(zipfilepath)
            zipsize += currzipsize
            zipsizemb = (zipsize/1024)/1024
            zipsizegb = zipsizemb/1024.0
            print "%s   number: % 6d   zipsize: % 10d  % 10d" % (walkroot, numbercount, zipsize, zipsizemb)

    print
    print "Total numbers:", numbercount
    print "ZIP size:    : % 15d bytes = % 9d MB = % 6.2F GB" % (zipsize, zipsizemb, zipsizegb)
    print

