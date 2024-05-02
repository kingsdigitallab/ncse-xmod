#!/usr/bin/env python

import sys
import os
import os.path
import platform
import textwrap
import cElementTree as ET

xmlortxt = "txt"

if platform.system() == "Windows":
    olivebasedir = "D:/NCSE/skua/OlivePublish/"
    corpusoutdir = "C:/projects/cch/ncse/conc/corpus/src" + xmlortxt + "/"
else:
    olivebasedir = "/media/34GIG/NCSE/skua/OlivePublish/"
    corpusoutdir = "/projects/cch/ncse/conc/corpus/src" + xmlortxt + "/"

publcount = {}

if __name__ == '__main__':     

    publbasedir = olivebasedir + xmlortxt + "/"

    publlist = [
                "EWJ",
                "LDR",
                "MRP",
                "NSS",
                "TEC",
                "TTW"
                ]

    publcount["ALL"] = 0
    bywrapper = textwrap.TextWrapper(width=70, replace_whitespace=True, break_long_words=False)
    for pu in publlist:
        publoutfilepath = corpusoutdir + pu + ".txt"
        pout = file(publoutfilepath, "w")
        publcount[pu] = 0
        specpublbasedir = publbasedir + pu + "/"
        publvollist = os.listdir(specpublbasedir)
        publvollist.sort()
        publvolcount = len(publvollist)
        publcount[pu] = publvolcount
        publcount["ALL"] += publvolcount
        for publvol in publvollist:
            # print publvol
            publvolbasedir = specpublbasedir + publvol + "/"
            # print publvolbasedir
            publvolcontlist = os.listdir(publvolbasedir)
            arcount = 0
            for xf in publvolcontlist:
                if xf.startswith("Ar"):
                    arcount += 1
                    xffilepath = publvolbasedir + xf
                    print xffilepath
                    pin = file(xffilepath, "r")
                    tf = pin.read()
                    textposstart = tf.find("<TEXT>")
                    textposstart += 6
                    textposend   = tf.rfind("</TEXT>")
                    tf = tf[textposstart:textposend]
                    tf = bywrapper.fill(tf)
                    # print tf
                    pout.write(tf + "\n")
                    # print "-" * 60
#                    for event, elem in ET.iterparse(xffilepath):
#                        if elem.tag == "Primitive":
#                            etext = elem.text
#                            # etextout = etext.decode('windows-1252')
#                            etextout = etext.encode('windows-1252')
#                            pout.write(etextout + "\n")
#                            # ... process record element ...
#                            elem.clear()
            if arcount > 1:
                print
                print "More than two Ar files in ", publvolbasedir
                print
            

    print "Number of volumes:"
    print "------------------"
    for pu in publlist:
        s = "%s:     %7d" % (pu, publcount[pu])
        print s
    print "-" * 16
    s = "%s:     %7d" % ("ALL", publcount["ALL"])
    print s
    
    
        
    print "--== FINISHED ==--"




