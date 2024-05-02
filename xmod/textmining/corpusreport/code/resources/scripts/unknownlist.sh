#!/bin/bash
BINDIR="`dirname $0`"
LIBDIR="`dirname $BINDIR`"/lib
java -cp $LIBDIR/cch.jar uk.ac.kcl.cch.ncse.frequency.FrequencyListGenerator $* unknown





