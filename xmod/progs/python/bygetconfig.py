
import sys
import re
import time
import os, os.path, shutil

class ByGetConfig:
    """Get configuration variables from a config file."""
    def __init__(self, confvarsdic = {}):
        if len(confvarsdic.keys()) == 0:
            print
            print "In the program define the list of configuration variables used."
            print
            sys.exit(2)
        else:
            # self.confvarslist = confvarslist
            self.confvarsdic = confvarsdic
        if (len(sys.argv) < 2) or (len(sys.argv) > 2):
            self.printUsage()
        self.configfile = sys.argv[1]
        self.getRepfileObject()
        self.dbtypelist = ["SQLite", "MySQL"]
        self.dboutlist = ["DB", "File"]
        self.confdic = {}
        self.readConfigFile(self.configfile)
        # print self.configfile

    def printUsage(self):
        print
        print "Usage:"
        print
        print "      ", os.path.basename(sys.argv[0]), "<config file>"
        print
        sys.exit(2)

    def testConfVars(self, v):
        if ((v not in globals()) and (v != "repf")):
            print
            print "ERROR: Variable '" + v + "' is not set in config file."
            print
            sys.exit(2)

    def getRepfileObject(self):
        repfiledir = "logs"
        (fn, ex) = os.path.splitext(self.configfile)
        repfilefile = fn.upper()
        repfilefile += "-"
        repfilefile += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
        repfilefile += ".LOG"
        repfilepath = os.path.join(repfiledir, repfilefile)
        repf = file(repfilepath, "w")
        self.confvarsdic["repf"] = repf
        
    def readConfigFile(self, f):
        if os.path.isfile(f):
            execfile(f, globals())
            for tc in self.confvarsdic.keys():
                self.testConfVars(tc)
                if self.confvarsdic[tc] == "DIR":
                    tpath = eval(tc)
                    if not os.path.exists(tpath):
                        print
                        print "ERROR: directory '" + tpath + "' does not exist."
                        sys.exit(2)
                    elif not os.path.isdir(tpath):
                        print
                        print "ERROR: '" + tpath + "' is not a directory."
                        sys.exit(2)
                    else:
                        self.confvarsdic[tc] = tpath
                elif self.confvarsdic[tc] == "FILE":
                    tpath = eval(tc)
                    if not os.path.exists(tpath):
                        print
                        print "ERROR: directory '" + tpath + "' does not exist."
                        sys.exit(2)
                    elif not os.path.isfile(tpath):
                        print
                        print "ERROR: '" + tpath + "' is not a file."
                        sys.exit(2)
                    else:
                        self.confvarsdic[tc] = tpath
                elif self.confvarsdic[tc] == "TYPE":
                    ttype = eval(tc)
                    if ttype not in self.dbtypelist:
                        print
                        print "ERROR: db_type value '" + ttype + "' not allowed."
                        print "       valid types: 'SQLite', 'MySQL' or 'SQLFile'."
                        print
                        sys.exit(2)
                    else:
                        self.confvarsdic[tc] = ttype
                elif self.confvarsdic[tc] == "OUT":
                    tout = eval(tc)
                    if tout not in self.dboutlist:
                        print
                        print "ERROR: db_output value '" + tout + "' not allowed."
                        print "       valid types: 'DB' or 'File'."
                        print
                        sys.exit(2)
                    else:
                        self.confvarsdic[tc] = tout
                elif self.confvarsdic[tc] == "DB":
                    tdb = eval(tc)
                    self.confvarsdic[tc] = tdb
                elif self.confvarsdic[tc] == "HOST":
                    thost = eval(tc)
                    self.confvarsdic[tc] = thost
                elif self.confvarsdic[tc] == "BOOL":
                    tbool = eval(tc)
                    self.confvarsdic[tc] = tbool
            if self.confvarsdic["db_mysql_data_path"] == "":
                print
                print "ERROR: 'db_mysql_data__path' variable (location of MySQL data dir not set."
                print "       this is the directory where MySQL keeps its DBs, for example"
                print "       '/var/lib/mysql' or '/usr/local/mysql/data'."       
                print
                sys.exit(2)
            if self.confvarsdic["db_load_path"] == "":
                print
                print "ERROR: 'db_load_path' variable (location for TAB-delimited files) not set."
                print
                sys.exit(2)
            if self.confvarsdic["db_path"] == "":
                print
                print "ERROR: 'db_path' variable (database directory) not set."
                print
                sys.exit(2)
            else:
                self.confvarsdic["db_filepath"] = \
                         os.path.join(self.confvarsdic["db_path"], self.confvarsdic["db_name"])
                self.confvarsdic["db_filepath"] += ".db"
        else:
            print
            print "ERROR: Config file '" + f + "' does not exist."
            print
            sys.exit(2)

if __name__ == '__main__':
    confvarsdic = {
                    "corpusinpath" : "DIR",
                    "corpusimagebasedir" : "DIR",
                    "db_type" : "TYPE",
                    "db_output" : "OUT",
                    "db_path" : "DIR",
                    "db_load_path" : "DIR",
                    "db_mysql_data_path" : "DIR",
                    "db_create_file" : "FILE",
                    "db_name" : "DB",
                    "db_host" : "HOST",
                    "db_port" : "DB",
                    "db_user" : "DB",
                    "db_passwd" : "DB",
                    "generatecorpusimages" : "BOOL",
                    "generatearttext" : "BOOL"
                    }
    confobj = ByGetConfig(confvarsdic)
    for k in confobj.confvarsdic.keys():
        print k, confobj.confvarsdic[k]

    

