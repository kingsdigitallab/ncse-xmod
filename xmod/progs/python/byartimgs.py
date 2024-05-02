# -*- coding: utf-8 -*-

# TODO:
# use page numbers and entityrefs to get all images for an article
# from the Img directory and write them all to a subdirectory (named
# after the articleid) of the corpus image base directory
# the images can be referenced later by using the page number and
# entity id in the tokenDB
# 
# Ar00301S.png : snippet for this article
# Ar0030100.png, Ar0030101.png, ... : entity images
# Pg003.png : image of full page
# Pv003.png : thumbnail of full page

import os, os.path
# from xml.etree import ElementTree as ET
from lxml import etree as ET
from StringIO import StringIO
import bytocfile
import byzipfile
import unicodedata

class ByArticleImgs:
    """Get all images that belong to an article
    and copy them to a subdirectory named after the article id.
    """
    def __init__(self, byarticleid, byarticlerefsdic, bytocobj, byzipobj):
        self.articleid = byarticleid
        self.articlerefsdic = byarticlerefsdic
        self.tocobj = bytocobj
        self.zipobj = byzipobj
        self.tokenidbase = self.buildTokenIdBase(self.articleid)
        self.ProcessArticle()

    def getFileFromZip(self, eid):
        entityxmlzipfilepath = self.tocobj.entityrefsdic[eid]["HREF"]
        entityxmlzipfilepath = entityxmlzipfilepath[1:] + ".xml"
        # print currzip.getInfo(entityxmlzipfilepath).filename
        exml = self.zipobj.zipRead(entityxmlzipfilepath)
        # self.zipobj.closeZipFile()
        # del self.zipobj
        return exml


    def ProcessArticle(self):
        tokenidbase = self.buildTokenIdBase(self.articleid)
        self.tokenlist = []
        arttokencount = 0
        artolivewordcount = 0
        artlineno = 0
        for entityid in self.articlerefsdic[self.articleid]:
            entlineno = 0
            entxmlrootobj = self.getEntityXmlRoot(entityid)
            entolivewordcount = self.getEntityWordCountFromXml(entxmlrootobj)
            artolivewordcount += int(entolivewordcount)
            entolivepageno = self.getEntityOlivePageNo(entxmlrootobj)
            entpublpageno = self.getEntityPublPageNo(entxmlrootobj)
            primlist = self.getListOfPrimitives(entxmlrootobj)
            quadtokenlist = []
            quadboxlist = []
            # quadhyphenaftertokenlist = []
            for primitive in primlist:
                # Elements:
                # "L": Element holding a line.
                # "W" : Word
                # "QW": Element holding full word that was divided to quads.
                # "Q": Element holding part of a word.
                # "q": Element holding the last part of a word.
                # "S": Element holding a special word.
                # Attributes:
                # "BOX": Defines the BOX attribute as list of four integers.
                #        in L, W, Q, q
                # "QID": Quad ID. Unites the quads lists.
                #        in Q, q, QW
                # "NS": Indicates that there should be no space after this word/quad.
                #        in W, q
                # "LH": Indicates that the hyphen should be kept.
                #        in W, Q, q
                #        we can ignore "LH" as it is only relevant if want to know
                #        if a word is hyphenated at the end of a line, but as we
                #        take the token text from "QW" we get the reassembled token
                #        anyway
                
                for word in primitive:
                    # elevate content of "S" elements (which are "W", "Q" or "q" elements)
                    # one level and replace current word element (which is "S") with
                    # the corresponding real word element ("W", "Q", or "q")
                    if word.tag == "S":
                        word = word.getchildren()[0]
                    if word.tag == "W":
                        onetokenattlist = []
                        token = word.text
                        tokenbox = [word.attrib["BOX"]]
                        spaceaftertoken = self.getSpaceAfterToken(word)
                        arttokencount += 1
                        tokenid = self.buildTokenId(tokenidbase, arttokencount)
                        tokenidcomppartslist = self.buildTokenIdComponentParts(tokenid)
                        for tic in tokenidcomppartslist:
                            onetokenattlist.append(tic)
                        onetokenattlist.append(tokenid)
                        onetokenattlist.append(entityid)
                        token = self.normaliseHyphen(token)
                        onetokenattlist.append(token)
                        onetokenattlist.append(spaceaftertoken)
                        onetokenattlist.append(entolivepageno)
                        onetokenattlist.append(entpublpageno)
                        onetokenattlist.append(entlineno)
                        onetokenattlist.append(artlineno)
                        tokenboxstr = self.buildTokenBoxStr(tokenbox)
                        onetokenattlist.append(tokenboxstr)
                        self.tokenlist.append(onetokenattlist)
                        # hyphenaftertoken = self.getHyphenAfterToken(word)
                        # print token.encode("utf-8"), tokenbox, spaceaftertoken
                        # print "-" * 30, ">>"+spaceaftertoken+"<<"
                        # print "#" * 30, ">>"+hyphenaftertoken+"<<"
                    elif word.tag == "Q":
                        quadtokenlist.append(word.text)
                        quadboxlist.append(word.attrib["BOX"])
                        # quadhyphenaftertokenlist.append(self.getHyphenAfterToken(word))
                    elif word.tag == "q":
                        quadtokenlist.append(word.text)
                        quadboxlist.append(word.attrib["BOX"])
                        quadspaceaftertoken = self.getSpaceAfterToken(word)
                        # quadhyphenaftertokenlist.append(self.getHyphenAfterToken(word))
                    elif word.tag == "QW":
                        onetokenattlist = []
                        token = word.text
                        tokenbox = quadboxlist
                        spaceaftertoken = quadspaceaftertoken
                        arttokencount += 1
                        tokenid = self.buildTokenId(tokenidbase, arttokencount)
                        tokenidcomppartslist = self.buildTokenIdComponentParts(tokenid)
                        for tic in tokenidcomppartslist:
                            onetokenattlist.append(tic)
                        onetokenattlist.append(tokenid)
                        onetokenattlist.append(entityid)
                        token = self.normaliseHyphen(token)
                        onetokenattlist.append(token)
                        onetokenattlist.append(spaceaftertoken)
                        onetokenattlist.append(entolivepageno)
                        onetokenattlist.append(entpublpageno)
                        onetokenattlist.append(entlineno)
                        onetokenattlist.append(artlineno)
                        tokenboxstr = self.buildTokenBoxStr(tokenbox)
                        onetokenattlist.append(tokenboxstr)
                        self.tokenlist.append(onetokenattlist)
                        quadtokenlist = []
                        quadboxlist = []
                        # print token.encode("utf-8"), tokenbox, spaceaftertoken
                    elif word.tag == "L":
                        artlineno += 1
                        entlineno += 1

                        
            # self.ByTest(entityid, olivewordcount)
            # print primlist
        # OLIVE's wordcount seems to be slightly wrong sometimes
        # if artolivewordcount != arttokencount:
        #     pass
        #     print "%s % 4d % 5d % 5d" % (tokenidbase, artolivewordcount-arttokencount, artolivewordcount, arttokencount)
        # 
        # format of self.tokenlist:
        # unique tokenid - example: LDR-1852-03-27-Ar02420-0000002
        #                           "Ar02420" is article id
        #                           articles made up of several entities
        #                           use first entity id as article id
        #                           last number is number of token within article
        # entity id/file - example: Ar02420
        # token
        # space:                    if " " --> follow token with space
        #                           if ""  --> do not follow token with space
        # Olive page no.
        # Publication page no.
        # line number within entity
        # line number within article
        # list of coordinates of token: has to be a list, as token can
        #                               can be broken at line ends
        return self.tokenlist

    def ByTest(self, eid, owcnt):
        print self.articleid, eid, owcnt
        
        # self.tocxmltree = ET.parse(self.tocfilepath)
        # self.tocxmlrootobj = self.tocxmltree.getroot()

# --------------------------------------------------------------------
# TESTING
# --------------------------------------------------------------------


def ByTestMultipleArticles(toc, zip):
    (artrefslist, artrefsdic) = toc.getArticleRefs()
    for artid in artrefslist:
        newart = ByArticleText(artid, artrefsdic, toc, zip)
        print "FULLARTICLEID:", newart.buildFullArticleId(art)
        for tokenl in newart.tokenlist:
            # pass
            print tokenl
    
def ByTestSingleArticle(art, toc, zip):
    (artrefslist, artrefsdic) = toc.getArticleRefs()
    newart = ByArticleText(art, artrefsdic, currtoc, currzip)
    print "FULLARTICLEID:", newart.buildFullArticleId(art)
    for tokenl in newart.tokenlist:
        print tokenl

if __name__ == '__main__':
    corpusinpath = "/projects/cch/ncse/olive/skua/Drive_E_OliveInternal/2007samples"
    walkroot = "/projects/cch/ncse/olive/skua/Drive_E_OliveInternal/2007samples/LDR/1852/03/27"
    walkdirs = []
    walkfiles = ['041-LDR-1852-03-27-001-SINGLE.PDF', '1852_03_27.zip', 'TOC.xml']
    currzip = byzipfile.ByZipFile(walkroot, walkfiles)
    currtoc = bytocfile.ByTocFile(walkroot)
    ByTestSingleArticle("Ar00601", currtoc, currzip)
    # ByTestMultipleArticles(currtoc, currzip)
    currzip.closeZipFile()

    print "--== FINISHED ==--"
