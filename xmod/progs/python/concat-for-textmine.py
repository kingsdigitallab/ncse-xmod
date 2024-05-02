
import sys
import os, os.path

indir = "/projects/cch/ncse/gate/corpus"
# outdir = "/Applications/textmining/cluto/doc2mat-1.0"
outdir = "/opt/textmining/textmine/t"
outfile = "LDR1859.txt"
outfilepath = os.path.join(outdir, outfile)
outobj = file(outfilepath, "w")

infilelist = os.listdir(indir)

doccount = 0
# 1: sugar: -- Document Separator -- reut2-021.sgm
for infile in infilelist:
    infilepath = os.path.join(indir, infile)
    if os.path.isfile(infilepath):
        doccount += 1
        (filelabel, fileextension) = os.path.splitext(infile)
        print filelabel
        infileobj = file(infilepath, "r")
        infilestr = infileobj.read()
        # outtextstr = infilestr.replace("\n", " ")
        outtextstr = infilestr
        outtextstr = str(doccount) + ": XXX: -- Document Separator -- " + filelabel + "\n" + outtextstr
        print >> outobj, outtextstr
        infileobj.close()
outobj.close()
    
print "--== FINISHED ==--"
