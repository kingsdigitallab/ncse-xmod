#!/usr/bin/env python

import sys
import os, os.path
import string
import nltk

inpath = "/projects/cch/ncse/corpustxt/EWJ/1859/04/EWJ-1859-04-01-Ar02303.txt"
inpath = "/Users/gb/Dropbox/cch/teaching/avmtls2009/python/texts/bettybotter.txt"

tokpattern = r'''(?x)
    \w+               # sequences of 'word' characters
  | \$?\d+(\.\d+)?    # currency amounts, e.g. $12.50
  | ([A-Z]\.)+        # abbreviations, e.g. U.S.A.
  | [^\w\s]+          # sequences of punctuation
'''

def collocations(words):
    from operator import itemgetter

    # Count the words and bigrams
    wfd = nltk.FreqDist(words)
    print type(wfd)
    pfd = nltk.FreqDist(tuple(words[i:i+2]) for i in range(len(words)-1))
    print type(pfd)
    #
    scored = [((w1,w2), score(w1, w2, wfd, pfd)) for w1, w2 in pfd]
    scored.sort(key=itemgetter(1), reverse=True)
    return map(itemgetter(0), scored)

def score(word1, word2, wfd, pfd, power=3):
    freq1 = wfd[word1]
    freq2 = wfd[word2]
    freq12 = pfd[(word1, word2)]
    return freq12 ** power / float(freq1 * freq2)

def byFreqDist(words):
    wfd = nltk.FreqDist(words)
    return wfd

def main(args):
    print "-= STARTED =-"
    ifobj = file(inpath, "r")
    # linelist = ifobj.readlines()
    text = ifobj.read()
    ifobj.close()
    # for line in linelist:
    #     line = line.rstrip()
    #     print line
    #     # fd = nltk.FreqDist(sec_a)
    #     tokline = nltk.tokenize.regexp_tokenize(line, tokpattern)
    #     print tokline
    text = text.replace(os.linesep, " ")
    toklist = nltk.tokenize.regexp_tokenize(text, tokpattern)
    toklist = [word.lower() for word in toklist]
    # print toklist
    print len(toklist)
    # Collocations
    # colloclist = [w1+' '+w2 for w1, w2 in collocations(toklist)[:15]] 
    # print colloclist
    fdi = byFreqDist(toklist)
    a = "butter"
    print "Count = abs. freq.:", a, fdi[a]
    print "Frequency = rel. freq.:", a, fdi.freq(a)
    print "No. of samples:", fdi.N()
    print "No. of Types:", len(list(fdi))
    print "Types:", list(fdi)
    print fdi.max()
    print "-= FINISHED =-"


if __name__ == "__main__":
    main(sys.argv[1:])

