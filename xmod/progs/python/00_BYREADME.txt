.. -*- mode: rst -*-

==========
 Programs
==========

prxml-to-tokenDB.py - OBSOLETE!!! - see immediately below
=========================================================

traverse an Olive repository and extract from its respective TOC.xml
and ZIP file tokens and write them with various other information to a
MySQL DB

options are in *.conf files

prxml-to-tokenDB-tokfaid-loadfmt.py
===================================

traverse an Olive repository and extract from its respective TOC.xml
and ZIP file tokens and write them with various other information to
text files in MySQL load format (i. e. TAB delimited file)

options are in *.conf files

this change was necessary as writing directly into a MySQL DB was far
to slow

the above program generates, alongside the TAB-delimited files, a
shell script that reads the TAB-delimited file into a MySQL DB (it
turns of indexing, loads the data, and turns indexing on again)

textmining/db/sql/mysql/ncsetoks_create_myisam.sql
--------------------------------------------------

contains SQL CREATE statements to create the DB structure into which
prxml-to-tokenDB-tokfaid-loadfmt.py will write


check-olive-repository.py
=========================

traverse an Olive repository and check for existence of the required
PDF, ZIP and TOC.xml file

report any extraneous files

report corrupt ZIP files



tokendb-to-corpus.py
====================

extract data (tokens) from token DB and write text files containing
articles in various formats (depending on command line options)

(tokenDB-extract.py is an early experimental version)

accept the minimum command line options of

-d DB name
-o top level output directory (will be created if it doesn't exist)
-a articlepath, i. e. a string like: 'LDR-1859-09-24-Ar02417' or
   'LDR-1859'

tokendb-to-corpus.py -d ncsetoks_ewj -o /ncsecorpustxt -l year -a EWJ-1859 -c 100

full list of command line options:

Usage: tokendb-to-corpus.py [options]

Options:
  -h, --help            show this help message and exit
  -d DB, --dbname=DB    DB name - default: none
  -s HOST, --dbserver=HOST
                        DB host - default: localhost
  -P PORT, --port=PORT  DB port - default: 51524
  -u USER, --user=USER  DB user - default: gbrey
  -p PW, --password=PW  DB password - default: ***
  -o DIR, --outdir=DIR  write output to toplevel directory DIR - default: none
  -a PATH, --articlepath=PATH
                        Path of article to be extracted
                        ('LDR-1859-09-24-Ar02417') - default: none
  -f FORMAT, --format=FORMAT
                        format of output files: 'TXT', 'TXTHDR', 'TXTSEMTAG',
                        'XMLFAID', 'XMLFTOKENID', 'XMLSTOKENID', 'CLUTO',
                        'TMSK') - type '-f HELP' or '-f ?' for an explanation
                        of the options - default: HELP
  -l HIER, --outhier=HIER
                        how deeply nested output directories should be created
                        ('publ', 'year', 'month', 'day') - default: publ
  -c CHARS, --minchars=CHARS
                        only extract articles with a minimum length of CHARS
                        characters - default: 0
  -m LINES, --minlines=LINES
                        only extract articles with a minimum number of LINES
                        lines - default: 0


Currently included formats (output "-f HELP"):

Format of output files:

   TXT         - plain text
                 no escapes

   TXTHDR      - plain text
                 no escapes
                 header: <artid>XXX</artid>

   TXTSEMTAG   - plain text
                 WMatrix escapes (&amp;, &pound;, &eacute;, &lt;, &gt;
                                  &lsqb;, &rsqb;, &bquo;, &equo;
                 text enclosed in: <wmtext>XXX</wmtext>

   all XML based output has the following in common:
                 text enclosed in:
                    <DOC>
                    <ARTID>XXX</ARTID>
                    <TEXT>
                    XXX
                    </TEXT>
                 escaped:
                    &amp;, &lt;, &gt;

   XMLFAID     - plain text

   XMLFTOKENID - plain text
                 each token enclosed in: <ftoken ftokenid="XXX">XXX</ftokenid>
                 ftokenid = full article id ("LDR-1859-09-24-Ar02417")

   XMLSTOKENID - plain text
                 each token enclosed in: <stoken stokenid="XXX">XXX</stokenid>
                 stokenid = full article id ("Ar02417")

   CLUTO       - plain text
                 output for CLUTO clusterer
                 one big file containing all the documents, each one
                 preceded by full article id

   TMSK        - plain text
                 output for TMSK program
                 output identical to XMLFAID, but text not escaped




Example call for Wmatrix2 / Semantic tagger:
-------------------------------

nohup ./tokendb-to-corpus.py -d ncsetoks_ewj -s 137.73.122.85 -o /projects/cch/ncse/corpussemtag -l year -a EWJ -c 200 -f TXTSEMTAG &

nohup ./tokendb-to-corpus.py -d ncsetoks_ldr -s 137.73.122.85 -o /projects/cch/ncse/corpussemtag -l year -a LDR-1850 -c 200 -f TXTSEMTAG &


semtag-to-mysql.py
==================

read output of semantic tagger and write information into a MySQL DB

Usage: semtag-to-mysql.py [options]

Options:
  -h, --help            show this help message and exit
  -d DB, --dbname=DB    DB name - no default
  -s HOST, --dbserver=HOST
                        DB host - default: localhost
  -P PORT, --port=PORT  DB port - default: 51524
  -u USER, --user=USER  DB user - default: gbrey
  -p PW, --password=PW  DB password - default: XXX
  -i DIR, --indir=DIR   read from directory DIR, containing semtag output
                        files in further subdirectories - no default
  -a PATH, --articlepath=PATH
                        Path of article to be extracted
                        ('LDR', 'LDR-1859', or 'LDR-1859-09-24-Ar02417') - no default



textmining/db/sql/mysql/semtags_create.sql
------------------------------------------

contains SQL CREATE statements to create the DB structure into which
semtag-to-mysql.py will write

semtag-mysql-to-eval.py
=======================

extract data from semtags DB and write into HTML files for evaluation

Usage: semtag-mysql-to-eval.py [options]

Options:
  -h, --help            show this help message and exit
  -d DB, --dbname=DB    DB name - no default
  -s HOST, --dbserver=HOST
                        DB host - default: localhost
  -P PORT, --port=PORT  DB port - default: 51524
  -u USER, --user=USER  DB user - default: gbrey
  -p PW, --password=PW  DB password - default: XXX
  -o DIR, --outdir=DIR  write output to toplevel directory DIR - no default
  -i DIR, --indir=DIR   read from directory DIR, containing semtag output
                        files in further subdirectories - no default
  -a PATH, --articlepath=PATH
                        Path of article to be extracted ('LDR', 'LDR-1859', or
                        'LDR-1859-09-24-Ar02417') - no default


prxml-extract-metadata-create-sql.py
====================================

read in prxml_extract_metadata_fields.py and write an SQL file with
create statements for the metadata DB into which
prxml-extract-metadata.py will write metadata from the Olive
repository


prxml-extract-metadata.py
=========================

extract metadata from TOC.xml and Document.zip file from the Olive
repository and write to a metadata DB with tables "fullartids" and
"allmetadata"

Usage: prxml-extract-metadata.py [options]

Options:
  -h, --help            show this help message and exit
  -d DB, --dbname=DB    DB name - no default
  -s HOST, --dbserver=HOST
                        DB host - default: localhost
  -P PORT, --port=PORT  DB port - default: 51524
  -u USER, --user=USER  DB user - default: gbrey
  -p PW, --password=PW  DB password - default: XXX
  -i DIR, --indir=DIR   read repository from directory DIR, containing
                        subdirectories of the form 'LDR', etc. - no default
  -l DIR, --logdir=DIR  write log file to directory DIR - no default
  -a PATH, --articlepath=PATH
                        Path of article to be extracted
                        ('LDR-1859-09-24-Ar02417') - no default


ncseall-to-lucene.py
====================

Extract all relevant metadata information for each article from DBs 'ncsemetadata',
'ncsegatenee', and 'semtags' and write it to a lucene conform XML
file. Only if an article contains NEE data, semtag data, or image
description data is an XML file generated.

For NEE generated data the minimum length of an entry to be output is
hardcoded to "2" (minneelen = 2).

To filter out bad OCR characters, give option "-r" followed by the
character that should replace these characters (usually an "_"). This
replacement character will only be shown within tokens.

Usage: ncseall-to-lucene.py [options]

Options:
  -h, --help            show this help message and exit
  -s HOST, --dbserver=HOST
                        DB host - default: localhost
  -P PORT, --port=PORT  DB port - default: 51524
  -u USER, --user=USER  DB user - default: gbrey
  -p PW, --password=PW  DB password - default: XXX
  -o DIR, --outdir=DIR  write output to directory DIR - no default
  -l DIR, --logdir=DIR  write log file to directory DIR - no default
  -a PATH, --articlepath=PATH
                        Path of article to be extracted ('LDR', 'LDR-1859', or
                        'LDR-1859-09-24-Ar02417') - no default
  -r FILTERCHAR, --filter-bad-ocr=FILTERCHAR
                        do not output 'unprintable' characters, if they are
                        part of a word, replace with character given as
                        argument - default: none


Problems with Python and lxml on Mac OSX:
=========================================

import of lxml complains about missing ...schematron... symbol in
...etree.so

to fix set dynamic library path ot Fink location:
export DYLD_LIBRARY_PATH=/sw/lib


