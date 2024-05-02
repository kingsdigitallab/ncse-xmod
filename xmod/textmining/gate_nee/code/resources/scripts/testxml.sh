#!/bin/bash
BINDIR="`dirname $0`"
LIBDIR="`dirname $BINDIR`"/lib
java -Xmx1536m -cp @GATECP@:$LIBDIR/cch.jar:$LIBDIR/commons-lang-2.3.jar -Dgate.home=@GATEHOME@ mining.ReadXMLFile



