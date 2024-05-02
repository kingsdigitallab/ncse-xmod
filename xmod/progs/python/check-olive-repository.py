#!/usr/bin/env python
# -*- coding: utf-8 -*-

# recursively walk through a Olive repository directory hierarchy
# and check both for completeness of files (1 PDF, 1 ZIP, 1 TOC.xml file)
# and integrity of ZIP file

import sys
import string
import os, os.path
from optparse import OptionParser
import byzipfile

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), "requires exactly 2 arguments"
    print
    print "      ", "get help with:"
    print "      ", os.path.basename(sys.argv[0]), "-h"
    print
    sys.exit(2)

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

def checkIfInReposDir(wf):
    extset = set(["xml", "zip", "pdf"])
    fset = set()
    if len(wf) != 3:
        return False
    else:
        for f in wf:
            (b, ext) = os.path.splitext(f)
            if not ext.startswith("."):
                return False
            else:
                fset.add(ext[1:].lower())
    if extset == fset:
        return True
    else:
        return False

def checkFilesInDir(wf):
    nrf = []
    rfext  = [".xml", ".zip", ".pdf"]
    for f in wf:
        (n, e) = os.path.splitext(f)
        e = e.lower()
        if e not in rfext:
            nrf.append(f)
    return nrf

def checkForMissingReposFiles(wf):
    rfext = [".xml", ".zip", ".pdf"]
    wfext = [ os.path.splitext(f)[1].lower() for f in wf]
    mrf = []
    for e in rfext:
        if e not in wfext:
            mrf.append(e[1:].upper())
    return mrf

def checkForCorruptZipFiles(wr, wf, cip):
    czf = []
    currzip = byzipfile.ByZipFile(wr, wf, cip)
    if currzip.errzipfilepath == "":
        # currzip.closeZipFile()
        del currzip
    else:
        czf.append(currzip.errzipfilepath)
        del currzip
    return czf

def walkRepository(cip, r):
    totalnonreposfiles = []
    totalmissingreposfiles = []
    totalcorruptzipfiles = []
    for walkroot, walkdirs, walkfiles in os.walk(cip):
        if len(walkfiles) > 0:
            nonreposfiles = []
            # print walkroot, walkdirs, walkfiles
            nonreposfiles = checkFilesInDir(walkfiles)
            if len(nonreposfiles) > 0:
                for nf in nonreposfiles:
                    nrfpath = os.path.join(walkroot, nf)
                    totalnonreposfiles.append(nrfpath)
            # 
            # check for missing files
            missingreposfiles = checkForMissingReposFiles(walkfiles)
            if len(missingreposfiles) > 0:
                for mf in missingreposfiles:
                    pathfiletypelist = [mf, walkroot]
                    totalmissingreposfiles.append(pathfiletypelist)
            # 
            # check for corrupt ZIP files
            corruptzipfiles = checkForCorruptZipFiles(walkroot, walkfiles, cip)
            if len(corruptzipfiles) > 0:
                for cf in corruptzipfiles:
                    totalcorruptzipfiles.append(cf)
            # 
    return totalnonreposfiles, totalmissingreposfiles, totalcorruptzipfiles
            

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-c", "--corpus", dest="corpusinpath",
                      help="check corpus directory DIR", metavar="DIR")
    parser.add_option("-l", "--log", dest="repfilepath",
                      help="write report to log file FILE", metavar="FILE")
    (options, args) = parser.parse_args()
    if ((options.corpusinpath == None) or (options.repfilepath == None)):
        printUsage()
    corpusinpath = options.corpusinpath
    repfilepath = options.repfilepath
    
    if not os.path.isdir(corpusinpath):
        print
        print "Value for corpus directory is not a directory:"
        print corpusinpath
        print
        sys.exit(2)
       
    (logdir, logfile) = os.path.split(repfilepath)
    if not os.path.isdir(logdir):
        print
        print "Directory component of log file name is not a directory:"
        print logdir
        print
        sys.exit(2)
       
    repf = file(repfilepath, "w")
    (totnonreposfiles, totmissingreposfiles, totcorruptzipfiles) = walkRepository(corpusinpath, repf)

    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "Corpus directory:")
    PrintCF(repf, 1, "=================")
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, corpusinpath)
    PrintCF(repf, 1, "")
    PrintCF(repf, 1, "")

    if len(totnonreposfiles) > 0:
        PrintCF(repf, 1, "Non-repository files in the repository:")
        PrintCF(repf, 1, "=======================================")
        PrintCF(repf, 1, "")
        for n in totnonreposfiles:
            PrintCF(repf, 1, n)
        PrintCF(repf, 1, "")
        PrintCF(repf, 1, "")

    if len(totmissingreposfiles) > 0:
        PrintCF(repf, 1, "Missing repository files:")
        PrintCF(repf, 1, "=========================")
        PrintCF(repf, 1, "")
        for n in totmissingreposfiles:
            PrintCF(repf, 1, n[0] + ": " + n[1])
        PrintCF(repf, 1, "")
        PrintCF(repf, 1, "")

    if len(totcorruptzipfiles) > 0:
        PrintCF(repf, 1, "Corrupt ZIP files:")
        PrintCF(repf, 1, "==================")
        PrintCF(repf, 1, "")
        for n in totcorruptzipfiles:
            PrintCF(repf, 1, n)
        PrintCF(repf, 1, "")
        PrintCF(repf, 1, "")

    print "--== FINISHED ==--"
