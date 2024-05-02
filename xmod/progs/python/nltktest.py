#!/usr/bin/env python

import time
print "-= IMPORT MODULES =-"
importtime = time.time()

import sys
import os, os.path
import string
import nltk.tokenize
# from nltk import pos_tag, word_tokenize
import nltk.tag
import nltk.tokenize
from nltk.corpus import brown
# import matplotlib

# inpath = "/projects/cch/ncse/corpustxt-20090224/EWJ/1859/04/EWJ-1859-04-01-Ar02303.txt"
# inpath = "/Users/gb/Dropbox/cch/teaching/avmtls2009/python/texts/bettybotter.txt"
# inpath = "/Users/gb/Dropbox/cch/teaching/avmtls2009/python/texts/smg.txt"
inpath = "/Users/gb/Dropbox/cch/teaching/avmtls2009/python/texts/smb.txt"
# inpath = "/Users/gb/Dropbox/cch/teaching/avmtls2009/python/texts/austen1.txt"

outpath = "/projects/cch/ncse/progs/python/report/NLTKTEST.txt"

relevant_penn_tags = [
                      "FW",
                      "NN",
                      "NNP",
                      "NNPS",
                      "NNS"
                      ]

#tokpattern = r'''(?x)
#    \w+               # sequences of 'word' characters
#  | \$?\d+(\.\d+)?    # currency amounts, e.g. $12.50
#  | ([A-Z]\.)+        # abbreviations, e.g. U.S.A.
#  | [^\w\s]+          # sequences of punctuation
#'''

tokpattern = r'''(?x)
    \w+               # sequences of 'word' characters
  | \$?\d+(\.\d+)?    # currency amounts, e.g. $12.50
  | ([A-Z]\.)+        # abbreviations, e.g. U.S.A.
'''

def printBoth(fobj, s):
    print s
    print >> fobj, s
    fobj.flush()

def printBothSep(fobj, s, title):
    print "-" * 50
    print title
    print "-" * 50
    print s
    print >> fobj, "-" * 50
    print >> fobj, title
    print >> fobj, "-" * 50
    print >> fobj, s
    fobj.flush()

def collocations(words):
    from operator import itemgetter

    # Count the words and bigrams
    wfd = nltk.FreqDist(words)
    # print type(wfd)
    pfd = nltk.FreqDist(tuple(words[i:i+2]) for i in range(len(words)-1))
    # print type(pfd)
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

def byTagger(tokl):
    # BY: uses Penn tagset (HOWTO - tag.html, Overview)
    # taggedlist = nltk.tag.pos_tag(nltk.tokenize.word_tokenize(text))
    taggedlist = nltk.tag.pos_tag(tokl)
    return taggedlist

def byUnigramTagger(tokl, brown_train):
    # brown_news_tagged = brown.tagged_sents(categories='news')
    # brown_train = brown_news_tagged[100:]
    # brown_test = brown_news_tagged[:100]
    # print nltk.tag.untag(brown_test[0])
    unigram_tagger = nltk.UnigramTagger(brown_train)
    # taggedlist = unigram_tagger.tag(nltk.tokenize.word_tokenize(text))
    taggedlist = unigram_tagger.tag(tokl)
    return taggedlist

def byBigramTagger(tokl, brown_train):
    # brown_news_tagged = brown.tagged_sents(categories='news')
    # brown_train = brown_news_tagged[100:]
    # brown_test = brown_news_tagged[:100]
    # print nltk.tag.untag(brown_test[0])
    unigram_tagger = nltk.UnigramTagger(brown_train)
    bigram_tagger = nltk.BigramTagger(brown_train, backoff=unigram_tagger)
    # taggedlist = bigram_tagger.tag(nltk.tokenize.word_tokenize(ext))
    taggedlist = bigram_tagger.tag(tokl)
    return taggedlist

def byTrigramTagger(tokl, brown_train):
    # brown_news_tagged = brown.tagged_sents(categories='news')
    # brown_train = brown_news_tagged[100:]
    unigram_tagger = nltk.UnigramTagger(brown_train)
    bigram_tagger = nltk.BigramTagger(brown_train, backoff=unigram_tagger)
    trigram_tagger = nltk.TrigramTagger(brown_train, backoff=bigram_tagger)
    taggedlist = trigram_tagger.tag(tokl)
    return taggedlist

def byBrillTagger(tokl, brown_train):
    # brown_news_tagged = brown.tagged_sents(categories='news')
    # brown_train = brown_news_tagged[100:]
    unigram_tagger = nltk.UnigramTagger(brown_train)
    templates = [
                 nltk.tag.brill.SymmetricProximateTokensTemplate(nltk.tag.brill.ProximateTagsRule, (1, 1)),
                 nltk.tag.brill.SymmetricProximateTokensTemplate(nltk.tag.brill.ProximateTagsRule, (2, 2)),
                 nltk.tag.brill.SymmetricProximateTokensTemplate(nltk.tag.brill.ProximateTagsRule, (1, 2)),
                 nltk.tag.brill.SymmetricProximateTokensTemplate(nltk.tag.brill.ProximateTagsRule, (1, 3)),
                 nltk.tag.brill.SymmetricProximateTokensTemplate(nltk.tag.brill.ProximateWordsRule, (1, 1)),
                 nltk.tag.brill.SymmetricProximateTokensTemplate(nltk.tag.brill.ProximateWordsRule, (2, 2)),
                 nltk.tag.brill.SymmetricProximateTokensTemplate(nltk.tag.brill.ProximateWordsRule, (1, 2)),
                 nltk.tag.brill.SymmetricProximateTokensTemplate(nltk.tag.brill.ProximateWordsRule, (1, 3)),
                 nltk.tag.brill.ProximateTokensTemplate(nltk.tag.brill.ProximateTagsRule, (-1, -1), (1, 1)),
                 nltk.tag.brill.ProximateTokensTemplate(nltk.tag.brill.ProximateWordsRule, (-1, -1), (1, 1)),
                 ]
    trainer = nltk.tag.brill.FastBrillTaggerTrainer(initial_tagger=unigram_tagger,
                                     templates=templates, trace=3,
                                     deterministic=True)
    brill_tagger = trainer.train(brown_train, max_rules=10)
    taggedlist = brill_tagger.tag(tokl)
    return taggedlist

def callAllTaggersForComparison(oj, tlist):
    brown_news_tagged = brown.tagged_sents(categories='news')
    # brown_train = brown_news_tagged[100:]
    brown_train = brown_news_tagged
    taggedl = byTagger(tlist)
    # printBothSep(ofobj, str(taggedl), "BYTAGGER pos_tag")
    printBothSep(oj, len(taggedl), "BYTAGGER pos_tag")
    # ------------------------------------------
    taggedul = byUnigramTagger(tlist, brown_train)
    # printBothSep(ofobj, str(taggedul), "UNIGRAM TAGGER")
    printBothSep(oj, len(taggedul), "UNIGRAM TAGGER")
    # ------------------------------------------
    taggedbl = byBigramTagger(tlist, brown_train)
    # printBothSep(ofobj, str(taggedbl), "BIGRAM TAGGER")
    printBothSep(oj, len(taggedbl), "BIGRAM TAGGER")
    # ------------------------------------------
    taggedtl = byTrigramTagger(tlist, brown_train)
    # printBothSep(ofobj, str(taggedtl), "TRIGRAM TAGGER")
    printBothSep(oj, len(taggedtl), "TRIGRAM TAGGER")
    # ------------------------------------------
    taggedbrl = byBrillTagger(tlist, brown_train)
    # printBothSep(ofobj, str(taggedtl), "TRIGRAM TAGGER")
    printBothSep(oj, len(taggedbrl), "BRILL TAGGER")
    # ------------------------------------------
    lcount = 0
    for (w, c) in taggedl:
        printBoth(oj, "%30s %5s %5s %5s %5s %5s" % (w, c,
            taggedul[lcount][1],
            taggedbl[lcount][1],
            taggedtl[lcount][1],
            taggedbrl[lcount][1]))
        lcount += 1

def callAllTaggersForComparisonRelevant(oj, tlist):
    # same as callAllTaggersForComparison, but only output
    # relevant tags as listed in relevant_penn_tags
    brown_news_tagged = brown.tagged_sents(categories='news')
    # brown_train = brown_news_tagged[100:]
    brown_train = brown_news_tagged
    taggedl = byTagger(tlist)
    # printBothSep(ofobj, str(taggedl), "BYTAGGER pos_tag")
    printBothSep(oj, len(taggedl), "BYTAGGER pos_tag")
    # ------------------------------------------
    taggedul = byUnigramTagger(tlist, brown_train)
    # printBothSep(ofobj, str(taggedul), "UNIGRAM TAGGER")
    printBothSep(oj, len(taggedul), "UNIGRAM TAGGER")
    # ------------------------------------------
    taggedbl = byBigramTagger(tlist, brown_train)
    # printBothSep(ofobj, str(taggedbl), "BIGRAM TAGGER")
    printBothSep(oj, len(taggedbl), "BIGRAM TAGGER")
    # ------------------------------------------
    taggedtl = byTrigramTagger(tlist, brown_train)
    # printBothSep(ofobj, str(taggedtl), "TRIGRAM TAGGER")
    printBothSep(oj, len(taggedtl), "TRIGRAM TAGGER")
    # ------------------------------------------
    taggedbrl = byBrillTagger(tlist, brown_train)
    # printBothSep(ofobj, str(taggedtl), "TRIGRAM TAGGER")
    printBothSep(oj, len(taggedbrl), "BRILL TAGGER")
    # ------------------------------------------
    lcount = 0
    for (w, c) in taggedl:
        if c in relevant_penn_tags:
            printBoth(oj, "%30s %5s %5s %5s %5s %5s" % (w, c,
                taggedul[lcount][1],
                taggedbl[lcount][1],
                taggedtl[lcount][1],
                taggedbrl[lcount][1]))
            lcount += 1

def callByTagger(oj, tlist):
    # relevant tags as listed in relevant_penn_tags
    taggedl = byTagger(tlist)
    # printBothSep(ofobj, str(taggedl), "BYTAGGER pos_tag")
    printBothSep(oj, len(taggedl), "BYTAGGER pos_tag")
    # ------------------------------------------
    lcount = 0
    for (w, c) in taggedl:
        if c in relevant_penn_tags:
            printBoth(oj, "%30s %5s %5d" % (w, c, lcount))
            lcount += 1
    

def testText(tokl,oj):
    text = nltk.Text(tokl)
    # a = "butter"
    # a = "blew"
    a = "sister"
    # b = ["blew", "it"]
    b = ["sister", "sisters"]
    c = "by"
    # print text[10:12]
    
    # printBothSep(oj, text, "TEXT")
    # printBothSep(oj, text.collocations(), "COLLOCATIONS")
    # text.collocations()
    # printBothSep(oj, text.concordance(a), "CONCORDANCE")
    printBothSep(oj, text.index(a), "INDEX")
    printBothSep(oj, text.count(a), "COUNT: %s" % a)
    # printBothSep(oj, text.generate(), "GENERATE")
    # printBothSep(oj, text.similar(c), "SIMILAR: %s" % c)
    # printBothSep(oj, text.common_contexts(b), "COMMON CONTEXTS: " + str(b))
    # printBothSep(oj, text.vocab(), "VOCAB")
    # print text.dispersion_plot(b)
    # text.plot()
    return

def testFrequency(tl, a):
    fdi = byFreqDist(tl)
    # a = "butter"
    print "Count = abs. freq.:", a, fdi[a]
    print "Frequency = rel. freq.:", a, fdi.freq(a)
    print "No. of samples:", fdi.N()
    print "Tot. no. of sample values (= types):", fdi.B()
    print "No. of Types:", len(list(fdi))
    print "Types:", list(fdi)
    print "Samples (= types):", fdi.samples()
    print "No. of samples with count", 5, ":", fdi.Nr(5)
    print "Max samples:", fdi.max()
    # print "Sorted samples:", fdi.sorted_samples()
    print "Sorted samples:", fdi.keys()

def testCollocations(tl,noofcol):
    # Collocations
    collist = collocations(tl)
    collistlen = len(collist)
    if noofcol > collistlen:
        noofcol = collistlen
    if noofcol <= 0:
        noofcol = collistlen
    # print collist
    # print collistlen
    colloclist = [w1+' '+w2 for w1, w2 in collist[:noofcol]] 
    return colloclist

def byPunktSentenceTokenize(text):
    sent_detector = nltk.data.load('tokenizers/punkt/english.pickle')
    tslist = sent_detector.tokenize(text.strip())
    # print '\n-----\n'.join(tslist)
    # print tslist
    return tslist
    
def main(args):
    starttime = time.time()
    print "-= STARTED =-"
    ifobj = file(inpath, "r")
    ofobj = file(outpath, "w")
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
    # -------------------------------------------
    # USE REGEXP TOKENIZE
    # toklist = nltk.tokenize.regexp_tokenize(text, tokpattern)
    # -------------------------------------------
    # USE WORD TOKENIZE
    toklist = nltk.tokenize.word_tokenize(text)
    # -------------------------------------------
    toklowlist = [word.lower() for word in toklist]
    # -------------------------------------------
    # print toklist
    # print len(toklist)
    # toklist = nltk.tokenize.wordpunct_tokenize(text)
    # toklist = [word.lower() for word in toklist]
    # print toklist
    # print len(toklist)
    # toklist = nltk.tokenize.word_tokenize(text)
    # toklist = [word.lower() for word in toklist]
    # print toklist
    # print len(toklist)
    # testFrequency(toklist, "and")
    # print "-" * 30
    # testText(toklist, ofobj)
    # collocationslist = testCollocations(toklist, 0)
    # print collocationslist
    # -------------------------------------------
    # TAG WHOLE TEXT ALL AT ONCE
    # CALL SEVERAL TAGGERS FOR COMPARISON
    # callAllTaggersForComparison(ofobj, toklist)
    # callAllTaggersForComparisonRelevant(ofobj, toklist)
    # -------------------------------------------
    # TAG WHOLE TEXT ALL AT ONCE
    # CALL BYTAGGER ONLY (BUILT-IN OFF THE SHELF TAGGER)
    # AS THIS SEEMS TO FIND THE BEST POS-TAGS
    callByTagger(ofobj, toklist)
    # -------------------------------------------
    # TAG TEXT SENTENCE BY SENTENCE
    # sentlist = byPunktSentenceTokenize(text)
    # for sentence in sentlist[:10]:
    #     senttoklist = nltk.tokenize.regexp_tokenize(sentence, tokpattern)
    #     senttoklist = [word.lower() for word in senttoklist]
    #     callAllTaggersForComparison(ofobj, senttoklist)
    # -------------------------------------------
        
    ifobj.close()
    ofobj.close()
    endtime = time.time()
    print "-= FINISHED =-"
    imptostart = starttime - importtime
    starttoend = endtime - starttime
    totaltime = imptostart + starttoend
    print "-= FROM IMPORT TO START: %6.2f seconds" % (imptostart, )
    print "-= FROM START TO FINISH: %6.2f seconds" % (starttoend, )
    print "-= TOTAL RUNNING TIME:   %6.2f seconds" % (totaltime, )

if __name__ == "__main__":
    main(sys.argv[1:])

