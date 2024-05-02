# TODO: make handling of extraneaous non-repository files (for example
#       MAC .DS_Store) more intelligent

import os, os.path
from zipfile import *

class ByZipFile:
    """Provide several methods to access a PrXML ZIP file
    and get various information out of it.
    """
 
    def __init__(self, path, filelist, corpusinpath=""):
        self.path = path
        self.filelist = filelist
        self.corpusinpath = corpusinpath
        self.zipfilename = ""
        self.errzipfilepath = ""
        self.nonreposfile = ""
        # print "PP", self.path, self.filelist
        for f in self.filelist:
            flc = f.lower()
            if flc.endswith(".zip"):
                self.zipfilename = f
                self.zipfilepath = os.path.join(self.path, self.zipfilename)
                try:
                    self.zipfileobj = ZipFile(self.zipfilepath, "r")
                except BadZipfile:
                    self.errzipfilepath = self.zipfilepath.replace(self.corpusinpath, "")
                    # print "BY: bad zip file: %s" % (errzipfilepath, )
        if self.zipfilename == "":
            self.nonreposfile = f
 
    def closeZipFile(self):
        self.zipfileobj.close()
 
    def getZipFileName(self):
        return self.zipfilename
    
    def getZipFilePath(self):
        return self.zipfilepath
    
    def getNameList(self):
        self.namelist = self.zipfileobj.namelist()
        return self.namelist

    def getInfoList(self):
        self.infolist = self.zipfileobj.infolist()
        return self.infolist
    
    def getInfo(self, name):
        self.info = self.zipfileobj.getinfo(name)
        return self.info
    
    def zipRead(self, name):
        self.zipbytes = self.zipfileobj.read(name)
        return self.zipbytes


# --------------------------------------------------------------------
# TESTING
# --------------------------------------------------------------------

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

def testOne(cip):
    for walkroot, walkdirs, walkfiles in os.walk(cip):
        if len(walkfiles) > 0:
            if walkroot.endswith("/LDR/1852/03/27"):
                # print walkroot, walkdirs, walkfiles
                currzip = ByZipFile(walkroot, walkfiles, cip)
                # print currzip.getNameList()
                # print currzip.getInfoList()
                print currzip.zipRead('6/Ar00601.xml')
                print currzip.getInfo('6/Ar00601.xml').filename
                print currzip.getInfo('6/Ar00601.xml').file_size
                print type(currzip.zipRead('6/Ar00601.xml'))
                currzip.closeZipFile()
    
def testTwo(cip):
    for walkroot, walkdirs, walkfiles in os.walk(cip):
        if len(walkfiles) > 0:
            # print walkroot, walkdirs, walkfiles
            if checkIfInReposDir(walkfiles):
                currzip = ByZipFile(walkroot, walkfiles, cip)
                if currzip.errzipfilepath == "":
                    print "GOOD"
                    currzip.closeZipFile()
                    del currzip
                else:
                    print "BAD", currzip.errzipfilepath
                    del currzip
        
if __name__ == '__main__':
    corpusinpath = "/projects/cch/ncse/olive/skua/Drive_E_OliveInternal/2007samples"
    testOne(corpusinpath)
    # testTwo(corpusinpath)
    print "--== FINISHED ==--"
