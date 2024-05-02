
import sys
import os, os.path

indir = "/projects/cch/ncse/gate/corpus"
outdir = "/Applications/textmining/cluto/doc2mat-1.0"
outfile = "LDR1859.txt"
outfilepath = os.path.join(outdir, outfile)
outobj = file(outfilepath, "w")

infilelist = os.listdir(indir)

for infile in infilelist:
    infilepath = os.path.join(indir, infile)
    if os.path.isfile(infilepath):
        (filelabel, fileextension) = os.path.splitext(infile)
        print filelabel
        infileobj = file(infilepath, "r")
        infilestr = infileobj.read()
        outtextstr = infilestr.replace("\n", " ")
        outtextstr = filelabel + " " + outtextstr
        print >> outobj, outtextstr
        infileobj.close()
outobj.close()
    
print "--== FINISHED ==--"
