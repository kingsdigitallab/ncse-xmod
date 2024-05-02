#!/usr/bin/env python

import sys
import os
import os.path
import platform
import keyword


if __name__ == '__main__':     
    print "MODULE: platform"
    print "================"
    print "architecture:", platform.architecture()
    print "machine:", platform.machine()
    print "node:", platform.node()
    print "platform:", platform.platform()
    print "processor:", platform.processor()
    print "system:", platform.system()
    print "release:", platform.release()
    print "version:", platform.version()
    print "system_alias:", platform.system_alias(platform.system(), platform.release(), platform.version())
    print "uname:", platform.uname()
    print "dist (LINUX):", platform.dist()
    print "libc_ver (LINUX):", platform.libc_ver()
    print
    print "MODULE: sys"
    print "==========="
    print "exec_prefix:", sys.exec_prefix
    print "executable:", sys.executable
    print "getdefaultencoding:", sys.getdefaultencoding()
    print "getfilesystemencoding:", sys.getfilesystemencoding()
    if platform.system() == "Windows":
        print "getwindowsversion:", sys.getwindowsversion()
    print "hexversion:", sys.hexversion
    print "maxint:", sys.maxint
    print "maxunicode:", sys.maxunicode
    print "modules:", sys.modules
    print "path:", sys.path
    print "platform:", sys.platform
    print "prefix:", sys.prefix
    print "version:", sys.version
    print "api_version:", sys.api_version
    print "version_info:", sys.version_info
    print
    print "MODULE: keyword"
    print "kwlist:", keyword.kwlist
    print
    print "--== FINISHED ==--"
