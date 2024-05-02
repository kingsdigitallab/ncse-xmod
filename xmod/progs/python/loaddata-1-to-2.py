#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Time-stamp: <Tue 22.05.2007 01:55:50 BST gb>

# Convert load data format 1 to load data format 2
#         format 1: LDR-1852-01-03-Ar00100-0000197
#         format 2: LDR \t 1852 \t 01 \t 03 \t Ar00100 \t 0000197

import sys
import string
import os, os.path

indir = "/projects/cch/ncse/textmining/db/sql/mysql"
outdir = "/projects/cch/ncse/textmining/db/sql/mysql"

processext = ".sql"
# for testing:
# processext = ".sql.short"
publpreflist = [
                "EWJ",
                "LDR",
                "TEC",
                "TTW",
                "MRP",
                "NSS"
                ]
ctl = [
              "",
              "'",
              "",
              "",
              "",
              "'",
              "",
              "'",
              "'",
              "'",
              "",
              "'",
              "",
              "'",
              "",
              "",
              "'"
              ]

if __name__ == '__main__':
    for infile in os.listdir(indir):
        (r, e) = os.path.splitext(infile)
        if ((infile.endswith(processext)) and (infile[0:3] in publpreflist)):
            infilepath = os.path.join(indir, infile)
            outfile = r + "-f2.tab"
            outfilepath = os.path.join(outdir, outfile)
            outfileobj = file(outfilepath, "w")
            infileobj = file(infilepath, "r")
            for line in infileobj:
                line = line.rstrip()
                linelist = line.split("\t")
                # print linelist
                tokenidstr = linelist[1]
                # print tokenidstr
                # LDR-1852-01-03-Ar00100-0000173
                # (publ, year, month, day, artid, arttokenno)
                tokenidlist = tokenidstr.split("-")
                # print tokenidlist
                tokenidlist.reverse()
                for tl in tokenidlist:
                    linelist.insert(1, tl)
                linelist.insert(10, '0')
                lllen = len(linelist)
                dbline = ""
                for i in range(0,lllen):
                    if i == 0:
                        dbline += ctl[i] + linelist[i] + ctl[i]
                    else:
                        dbline += "\t" + ctl[i] + linelist[i] + ctl[i]
                        
                print >> outfileobj, dbline
                # print dbline
                outfileobj.flush()
                
            infileobj.close()
            outfileobj.close()
            