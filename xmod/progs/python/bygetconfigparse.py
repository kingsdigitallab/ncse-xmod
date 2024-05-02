import sys
import re
import os
import os.path
import shutil
import ConfigParser

class ByGetConfig:
    """Get configuration variables from a config file using
    the ConfigParser module."""
    def __init__(self):
        if (len(sys.argv) < 2) or (len(sys.argv) > 2):
            self.printUsage()
        self.configfile = sys.argv[1]
        if not os.path.exists(self.configfile):
            print
            print "Config file '%s' does not exist." % (self.configfile, )
            print 
            sys.exit(2)
        if not os.path.isfile(self.configfile):
            print
            print "'%s' is not a file." % (self.configfile, )
            print 
            sys.exit(2)
        config = SafeConfigParser.ConfigParser()
        config.readfp(open(self.configfile))

    def printUsage(self):
        print
        print "Usage:"
        print
        print "      ", os.path.basename(sys.argv[0]), "<config file>"
        print
        sys.exit(2)

if __name__ == '__main__':
    # config = ConfigParser.ConfigParser()
    # config.readfp(open('defaults.cfg'))
    # config.read(['site.cfg', os.path.expanduser('~/.myapp.cfg')])

    print "--== FINISHED ==--"

