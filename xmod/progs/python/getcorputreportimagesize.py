#!/usr/bin/env python

# Time-stamp: <Mon 09.07.2007 09:49:53 BST gb>

# recurse into directory and print the total size
# of all image files with extension ".png"

import sys
import string
import os, os.path

if __name__ == '__main__':
    pngtotalsize = 0
    currdir = os.getcwd()
    print currdir
    for walkroot, walkdirs, walkfiles in os.walk(currdir):
        if len(walkfiles) > 0:
            for wf in walkfiles:
                currfpath = os.path.join(walkroot, wf)
                (p, e) = os.path.splitext(currfpath)
                if e == ".png":
                    currsize = os.path.getsize(currfpath)
                    pngtotalsize += currsize
    print "Total size of images:", (pngtotalsize/1024)/1024, "MB"
    print "--== FINISHED ==--"
