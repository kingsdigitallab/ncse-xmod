#!/usr/bin/env python

# Time-stamp: <Wed 14.03.2007 00:15:08 GMT gb>

import sys
import string

infiletuple = (
#    "counties",
     "issuingbodies",
#     "people",
#     "subjects",
#     "titles",
#     "towns"
)

# infileprefpath = "../../waterloo/sample/use/"
# infileext      = "AC.xml"

infileprefpath = "../../waterloo/full/ori/"
infileext      = ".txt"

for infile in infiletuple:
    infilepath = infileprefpath + infile + infileext
    # infile = "../../waterloo/sample/use/peopleAC.xml"
    infileobj = file(infilepath, "r")

    while True:
        chunk = infileobj.read(65535)
        if not chunk:
            break
        mpos = chunk.find("\n")
        if mpos != -1:
            print mpos
        # print chunk
        
