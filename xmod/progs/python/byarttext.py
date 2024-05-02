# -*- coding: utf-8 -*-

# TODO: check for <P> tag (paragraph) - seems not be used

import sys
import os, os.path
import string
# from xml.etree import ElementTree as ET
from lxml import etree as ET
from StringIO import StringIO
import bytocfile
import byzipfile
import unicodedata
from prxml_extract_metadata_fields import *

# import cProfile

quotmark = chr(146)
# emdash = unicodedata.lookup("EM DASH")
# endash = unicodedata.lookup("EN DASH")
# endash = chr(150).encode("cp1252")
# emdash = chr(151).encode("cp1252")
endash = chr(150)
emdash = chr(151)
# print endash, ord(endash)
# print emdash, ord(emdash)
# sys.exit()

class ByArticleText:
    """Construct an article from its constituent entities
    and provide methods to access its text.
    """
    def __init__(self, byarticleid, byarticlerefsdic, bytocobj, byzipobj, confvarsdic):
        self.articleid = byarticleid
        self.articlerefsdic = byarticlerefsdic
        self.tocobj = bytocobj
        self.zipobj = byzipobj
        self.corpusimagebasedir = confvarsdic["corpusimagebasedir"]
        self.generatecorpusimages = confvarsdic["generatecorpusimages"]
        self.generatearttext = confvarsdic["generatearttext"]
        self.tokenidbase = self.buildTokenIdBase(self.articleid)
        self.fullarticleid = self.buildFullArticleId(self.articleid)
        # self.processArticle()

    def getFileFromZip(self, eid):
        entityxmlzipfilepath = self.tocobj.entityrefsdic[eid]["HREF"]
        entityxmlzipfilepath = entityxmlzipfilepath[1:] + ".xml"
        # print currzip.getInfo(entityxmlzipfilepath).filename
        exml = self.zipobj.zipRead(entityxmlzipfilepath)
        # self.zipobj.closeZipFile()
        # del self.zipobj
        return exml

    def OLDgetImageFromZip(self, eid):
        entityimgzipfilepath = self.tocobj.entityrefsdic[eid]["HREF"]
        imgbase = ""
        (a, b) = os.path.split(entityimgzipfilepath)
        print "AAA", a
        print "BBB", b
        # entityxmlzipfilepath = entityxmlzipfilepath[1:] + ".xml"
        # exml = self.zipobj.zipRead(entityxmlzipfilepath)
        # return exml

    def getImageFromZip(self, ip):
        ip = ip[1:]
        img = self.zipobj.zipRead(ip)
        return img

    def getImageBaseDir(self, eid):
        entityimgzipfilepath = self.tocobj.entityrefsdic[eid]["HREF"]
        (imgbasedir, xf) = os.path.split(entityimgzipfilepath)
        imgbasedir += "/Img"
        return imgbasedir

    def getEntityImageId(self, prim):
        entimgid = prim.attrib["ID"]
        return entimgid

    def getEntityXmlTree(self, eid):
        entxml = self.getFileFromZip(eid)
        extree = ET.parse(StringIO(entxml))
        return extree

    def getEntityXmlRoot(self, eid):
        entxmltree = self.getEntityXmlTree(eid)
        entxmlroot = entxmltree.getroot()
        return entxmlroot

    def getEntityWordCountFromXml(self, root):
        """Get Olive word count per entity."""
        meta = root.find("Meta")
        if meta.attrib.has_key("WORDCNT"):
            entwordcountfromxml = meta.attrib["WORDCNT"]
        else:
            entwordcountfromxml = "0"
        return entwordcountfromxml

    def getEntityPublPageNo(self, root):
        """Get page number as diplayed in the publication."""
        meta = root.find("Meta")
        if meta.attrib.has_key("PAGE_LABEL"):
            pageno = meta.attrib["PAGE_LABEL"]
        else:
            pageno = ""
        return pageno

    def getEntityOlivePageNo(self, root):
        """Get sequential page number as Olive counts page numbers."""
        if root.attrib.has_key("PAGE_NO"):
            pageno = root.attrib["PAGE_NO"]
        else:
            pageno = "0"
        return pageno

    def getEntityDefaultImgExt(self, root):
        """Get default image extension for entity."""
        meta = root.find("Meta")
        if meta.attrib.has_key("DEFAULT_IMG_EXT"):
            defimgext = meta.attrib["DEFAULT_IMG_EXT"]
        else:
            defimgext = "png"
        return defimgext

    def ORIgetListOfPrimitives(self, root):
        cont = root.findall("Content/Primitive")
        return cont
    
    def getListOfPrimitives(self, root):
        # cont = root.findall("Content/Primitive")
        primitivelist = []
        for contlike in root:
            for primitive in contlike:
                if primitive.tag == "Primitive":
                    primitivelist.append(primitive)
        return primitivelist
    
    def getSpaceAfterToken(self, wel):
        if wel.attrib.has_key("NS"):
            if wel.attrib["NS"] == "y":
                space = ""
            else:
                space = " "
        else:
            space = " "
        return space

    def normaliseApfs(self, a):
        """Convert Olive representation to a shorter, list-like
        representation."""
        a = a.replace(" * ", ", ")
        if a.endswith(", "):
            a = a[:-2]
        return a
        
    def getWApfsVal(self, wel):
        """If there is an APFS value retrieve value and, as there
        should also be a leading underscore in the token, delete first
        character of token."""
        tok = wel.text
        # 
        # print tok.encode("cp1252")
        tok = tok.encode("cp1252")
        # print tok.encode("cp1252")
        # tok = tok.encode("cp1252")
        # 
        if wel.attrib.has_key("M"):
            apfsval = self.normaliseApfs(wel.attrib["M"])
            # print wel.tag, tok.encode("utf-8"), ">"+apfsval+"<"
            if tok.startswith("_"):
                tok = tok[1:]
        else:
            apfsval = ""
        # print wel.tag, tok.encode("utf-8"), apfsval
        return apfsval, tok

    def getQwApfsVal(self, apfsl, qtokl, wel):
        """If there were APFS values in one or several preceding "q"
        or "Q" tags, these values were appended to a list ("apfsl").
        Recalculate values so that they correspond to character positions
        in "QW" (which is concatenated from "q" and "Q" values and
        therefore the character positions from 2nd "Q"/"q" value
        onwards don't correspond to the original positions anymore)
        and write into string. Delete leading underscore from
        token."""
        tok = wel.text
        # 
        # print tok.encode("cp1252")
        tok = tok.encode("cp1252")
        # print tok.encode("cp1252")
        # tok = tok.encode("cp1252")
        # 
        apfsval = ""
        toklen = 0
        apfsllen = len(apfsl)
        # 
        # convert list of APFS values into string to quickly test
        # if the list contains any values
        apfss = "".join(apfsl)
        if len(apfss) > 0:
            # print "-" * 50
            # print wel.tag, tok.encode("utf-8"), apfsl, qtokl
            qlen = 0
            aoffset = 0
            for n in range(apfsllen):
                aoffset += qlen
                a = apfsl[n]
                q = qtokl[n]
                qlen = len(q)
                alist = a.split(", ")
                # print n, a, q.encode("utf-8"), aoffset, alist
                for av in alist:
                    if av != "":
                        av = int(av)
                        newav = av + aoffset
                        apfsval += "%d, " % (newav, )
                        # print "AV:   ", av, apfsl
                        # print "NEWAV:", newav
            if apfsval.endswith(", "):
                apfsval = apfsval[:-2]
            if tok.startswith("_"):
                tok = tok[1:]
            # print "NEW APFSVAL:", apfsval, tok.encode("utf-8")
        else:
            # print wel.tag, tok.encode("utf-8"), apfsl, len(apfsl)
            apfsval = ""
        return apfsval, tok

#    def getApfsVal(self, wel):
#        if wel.attrib.has_key("M"):
#            apfsval = wel.attrib["M"]
#            print wel.tag, wel.text.encode("utf-8"), apfsval
#        else:
#            apfsval = ""
#        return apfsval
#
#    def getToken(self, wel, apfsval):
#        """If there is an APFS value there should also be a
#        leading underscore in the token - delete it."""
#        token = wel.text
#        if ((apfsval != "") and (token.startswith("_"))):
#            token = token[1:]
#        return token

    def getHyphenAfterToken(self, wel):
        if wel.attrib.has_key("LH"):
            if wel.attrib["LH"] == "y":
                hyphen = "-"
        else:
            hyphen = ""
        return hyphen

    def buildTokenIdBase(self, aid):
        tidbase = self.tocobj.basehref
        tidbase = tidbase.replace("/", "-")
        tidbase += "-"
        tidbase += aid
        tidbase += "-"
        return tidbase

    def buildFullArticleId(self, aid):
        afullid = self.buildTokenIdBase(aid)
        afullid = afullid[:-1]
        return afullid
    
    def buildTokenId(self, tidbase, tnr):
        tid = "%07d" % tnr
        tglobalid = tidbase + tid
        return tglobalid
    
    def buildTokenIdComponentParts(self, tid):
        tidlist = tid.split("-")
        return tidlist
    
    def buildTokenBoxStr(self, boxlist):
        coordstr = ""
        for coord in boxlist:
            if coordstr == "":
                coordstr += coord
            else:
                coordstr += ", " + coord
        return coordstr
    
    def XnormaliseHyphen(self, t):
        return t

    def normaliseHyphen(self, t):
        """Normalise Hyphen to "-", i. e. replace occurrences of EN_DASH and EM_DASH
        with a single Hyphen ("-")."""
        # EM DASH
        # t = t.replace(u"—", "-")
        # t = t.replace(unicodedata.lookup("EM DASH"), "-")
        # 
        t = t.replace(emdash, "-")
        # t = t.replace("—", "-")
        # 
        # EN DASH
        # t = t.replace(unicodedata.lookup("EN DASH"), "-")
        # 
        t = t.replace(endash, "-")
        # t = t.replace("–", "-")
        # 
        # --------------------
        # apparently the use of 'endash = unicodedata.lookup("EN DASH")'
        # converts the non-unicode string into unicode, as we want to
        # keep the data non-unicode, we have to convert it back to a
        # non-unicode string
        # t = t.encode("utf-8")
        return t

    def normaliseQuotMark(self, t):
        """Normalise quotation mark to "'"."""
        # RIGHT SINGLE QUOTATION MARK
        t = t.replace(quotmark, "'")
        return t


    def ORIgetArtFileApplicationDataMetaData(self, metaentid, entid):
        print "TRY:", entid
        self.entxmltree = self.getEntityXmlTree(entid)
        # tocxmlapplicationdatalist = self.tocxmltree.xpath('/XMD-entity/Application_Data')
        artxmlapplicationdatalist = self.entxmltree.xpath('/XMD-entity/Application_Data')
        if artxmlapplicationdatalist == [] and metaentid != '':
            print "TRY:", metaentid
            self.entxmltree = self.getEntityXmlTree(metaentid)
            artxmlapplicationdatalist = self.entxmltree.xpath('/XMD-entity/Application_Data')
        self.aiitemdic = {}
        print entid, artxmlapplicationdatalist
        for ad in artxmlapplicationdatalist:
            applicationinfolist = ad.getchildren()
            for applicationinfo in applicationinfolist:
                applicationinfoname = applicationinfo.attrib["AI_TYPE"]
                aiitemlist = applicationinfo.getchildren()
                if aiitemlist != []:
                    self.aiitemdic[applicationinfoname] = []
                    for aiitem in aiitemlist:
                        self.aiitemdic[applicationinfoname].append(aiitem.attrib["NAME"])
        return self.aiitemdic
    
    def filterRightToLeftUnicodeChars(self, s):
        """Some of the attributes contain bidirectional UNICODE chars
        202A;LEFT-TO-RIGHT EMBEDDING;Cf;0;LRE;;;;;N;;;;;
        202B;RIGHT-TO-LEFT EMBEDDING;Cf;0;RLE;;;;;N;;;;;
        202C;POP DIRECTIONAL FORMATTING;Cf;0;PDF;;;;;N;;;;;
        202D;LEFT-TO-RIGHT OVERRIDE;Cf;0;LRO;;;;;N;;;;;
        202E;RIGHT-TO-LEFT OVERRIDE;Cf;0;RLO;;;;;N;;;;;
        I filter them out here."""
        # reutfent = re.compile(r"""&#\d{4}?;""")
        # r = re.findall(reutfent, s)
        s = s.replace(unichr(0x202A), "")
        s = s.replace(unichr(0x202B), "")
        s = s.replace(unichr(0x202C), "")
        s = s.replace(unichr(0x202D), "")
        s = s.replace(unichr(0x202E), "")
        return s

    def getArtFileApplicationDataMetaData(self, entid):
        # print "TRY:", entid
        self.entxmltree = self.getEntityXmlTree(entid)
        # tocxmlapplicationdatalist = self.tocxmltree.xpath('/XMD-entity/Application_Data')
        artxmlapplicationdatalist = self.entxmltree.xpath('/XMD-entity/Application_Data')
        # if artxmlapplicationdatalist == [] and metaentid != '':
        #     print "TRY:", metaentid
        #     self.entxmltree = self.getEntityXmlTree(metaentid)
        #     artxmlapplicationdatalist = self.entxmltree.xpath('/XMD-entity/Application_Data')
        self.aiitemdic = {}
        if artxmlapplicationdatalist != []:
            # print entid, artxmlapplicationdatalist
            for ad in artxmlapplicationdatalist:
                applicationinfolist = ad.getchildren()
                for applicationinfo in applicationinfolist:
                    applicationinfoname = applicationinfo.attrib["AI_TYPE"]
                    applicationinfoname = applicationinfoname.replace(":", "_")
                    if applicationinfoname[0] in string.ascii_uppercase:
                        applicationinfoname = applicationinfoname.lower()
                        applicationinfoname = "o_ent_appd_" + applicationinfoname
                    else: 
                        applicationinfoname = applicationinfoname.lower()
                        applicationinfoname = "n_ent_appd_" + applicationinfoname
                    if applicationinfoname in mdfieldlist3:
                        aiitemlist = applicationinfo.getchildren()
                        if aiitemlist != []:
                            self.aiitemdic[applicationinfoname] = []
                            for aiitem in aiitemlist:
                                a = aiitem.attrib["NAME"].encode("cp1252")
                                a = self.normaliseHyphen(a)
                                a = self.normaliseQuotMark(a)
                                self.aiitemdic[applicationinfoname].append(a)
                                # nn = self.normaliseHyphen(aiitem.attrib["NAME"])
                                # self.aiitemdic[applicationinfoname].append(nn)
        # print self.aiitemdic
        topmetaobj = self.entxmltree.xpath('/XMD-entity/Meta')
        for k in topmetaobj[0].attrib.keys():
            kn = k.lower()
            kn = "o_ent_meta_" + kn
            if kn in mdfieldlist3:
                a = topmetaobj[0].attrib[k]
                a = self.filterRightToLeftUnicodeChars(a)
                self.aiitemdic[kn] = a.encode("utf8")
                # self.aiitemdic[kn] = topmetaobj[0].attrib[k].encode("cp1252")
                # self.aiitemdic[kn] = topmetaobj[0].attrib[k].encode("utf8")
        # print self.aiitemdic
        return self.aiitemdic
    
    def processImages(self, prim, ibd, iext):
        # print ibd, iext
        # print prim.attrib["BOX"]
        # print prim.attrib["ID"]
        entityimgid = self.getEntityImageId(prim)
        # print entityimgid
        # self.getImageFromZip(entityid)
        entityimgfile = entityimgid + "." + iext
        entityimgpath = os.path.join(ibd, entityimgfile)
        print entityimgpath
        currimg = self.getImageFromZip(entityimgpath)
        # TEMPORARY
        imgoutpath = os.path.join(confvarsdic["corpusimagebasedir"],entityimgfile)
        imgoutfileobj = file(imgoutpath, "w")
        imgoutfileobj.write(currimg)
        imgoutfileobj.close()
        print imgoutpath

    def processArticleMetaData(self):
        artrefs = self.tocobj.articlerefsdic
        # numberolivepublname = self.tocobj.getTocFileMetaPublName()
        numberolivepublname = self.tocobj.tocxmlmetapublname # "OLIVE PUBL NAME"
        # numberncsemetadatadic = self.tocobj.getTocFileApplicationDataMetaData()
        numberncsemetadatadic = self.tocobj.tocfileappmetadatadic
        fullartid = self.fullarticleid # "FULLARTID"
        eid = self.articleid # "ENTITY ID"
        # given up
        
    def processArticle(self):
        tokenidbase = self.buildTokenIdBase(self.articleid)
        self.tokenlist = []
        arttokencount = 0
        artolivewordcount = 0
        artlineno = 0
        charcount = 0
        charnscount = 0
        for entityid in self.articlerefsdic[self.articleid]:
            # if entityid.startswith("P"):
            #     print "------------------------------------------------------------ ENTID PC", entityid
            #     sys.exit()
            # print "ENTID", entityid
            entlineno = 0
            entxmlrootobj = self.getEntityXmlRoot(entityid)
            entolivewordcount = self.getEntityWordCountFromXml(entxmlrootobj)
            artolivewordcount += int(entolivewordcount)
            entolivepageno = self.getEntityOlivePageNo(entxmlrootobj)
            entpublpageno = self.getEntityPublPageNo(entxmlrootobj)
            primlist = self.getListOfPrimitives(entxmlrootobj)
            quadtokenlist = []
            quadboxlist = []
            apfslist = []
            if self.generatecorpusimages == True:
                imgbasedir = self.getImageBaseDir(entityid)
                imgext = self.getEntityDefaultImgExt(entxmlrootobj)
            # quadhyphenaftertokenlist = []
            for primitive in primlist:
                if self.generatecorpusimages == True:
                    self.processImages(primitive, imgbasedir, imgext)
                # Elements:
                # "P": Paragraph element (will appear before the start
                #      of a new paragraph)
                # "L": element holding a line.
                # "W" : word
                # "QW": element holding full word that was divided to quads.
                # "Q": quad element holding part of a word.
                # "q": quad element holding the last part of a word.
                # "S": element holding a special word ("SUP", "SUB", etc.)
                # Attributes:
                # "BOX": defines the BOX attribute as list of four integers.
                #        in L, W, Q, q
                # "QID": quad ID - unites the quads lists.
                #        in Q, q, QW
                # "NS": indicates that there should be no space after this word/quad.
                #        in W, q
                # "LH": indicates that the hyphen should be kept.
                #        in W, Q, q
                #        we can ignore "LH" as it is only relevant if want to know
                #        if a word is hyphenated at the end of a line, but as we
                #        take the token text from "QW" we get the reassembled token
                #        anyway
                # "M":   APFS (Adaptive Probability Fuzzy Search)
                #        Emil Shteinvil:
                #        APFS tags are part of our PRXML.  They mark quality of word
                #        returned by OCR and possible place of mistake.
                #        Tag M ( mistake) shows possible place of  mistake.
                #        So M="8 *" means possible mistake in 8th character of word
                #        assemblj ( see example below). Note that we add underscore
                #        before word to simplify handling of such cases by search engines.   
                #        <W BOX="1249 1039 1314 1060" STYLE_REF="7" M="8 *">_assemblj</W>
                #        Tag Q ( quad) means part of word with the same style.
                #        Tag M applied to quads also: 
                #        <q BOX="382 1148 429 1164" STYLE_REF="25" QID="77"
                #           M="2 * 3 * 6 * 7 * 8 *">Anierica</q>
                
                for word in primitive:
                    # elevate content of "S" elements (which are "W", "Q" or "q" elements)
                    # one level and replace current word element (which is "S") with
                    # the corresponding real word element ("W", "Q", or "q")
                    if word.tag == "S":
                        specialtype = word.attrib["S_TYPE"]
                        word = word.getchildren()[0]
                        # print "SPECIAL:", word.text.encode("utf-8"), specialtype
                    else:
                        specialtype = ""
                    if word.tag == "W":
                        onetokenattlist = []
                        # apfs = self.getApfsVal(word)
                        # token = word.text
                        # token = self.getToken(word, apfs)
                        (apfs, token) = self.getWApfsVal(word)
                        # print "TOKEN:", token.encode("utf-8"), apfs
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
                        charcount += len(token)
                        charcount += len(spaceaftertoken)
                        charnscount += len(token)
                        onetokenattlist.append(token)
                        onetokenattlist.append(spaceaftertoken)
                        onetokenattlist.append(entolivepageno)
                        onetokenattlist.append(entpublpageno)
                        onetokenattlist.append(entlineno)
                        onetokenattlist.append(artlineno)
                        tokenboxstr = self.buildTokenBoxStr(tokenbox)
                        onetokenattlist.append(tokenboxstr)
                        onetokenattlist.append(apfs)
                        onetokenattlist.append(specialtype)
                        self.tokenlist.append(onetokenattlist)
                        # hyphenaftertoken = self.getHyphenAfterToken(word)
                        # print token.encode("utf-8"), tokenbox, spaceaftertoken, specialtype
                        # print token.encode("utf-8"), tokenbox, spaceaftertoken
                        # print "-" * 30, ">>"+spaceaftertoken+"<<"
                        # print "#" * 30, ">>"+hyphenaftertoken+"<<"
                    elif word.tag == "Q":
                        # if word.attrib.has_key("M"):
                        #     apfslist.append(self.getWApfsVal(word))
                        apfslist.append(self.getWApfsVal(word)[0])
                        quadtokenlist.append(word.text)
                        quadboxlist.append(word.attrib["BOX"])
                        # quadhyphenaftertokenlist.append(self.getHyphenAfterToken(word))
                    elif word.tag == "q":
                        # if word.attrib.has_key("M"):
                        #     apfslist.append(self.getWApfsVal(word))
                        apfslist.append(self.getWApfsVal(word)[0])
                        quadtokenlist.append(word.text)
                        quadboxlist.append(word.attrib["BOX"])
                        quadspaceaftertoken = self.getSpaceAfterToken(word)
                        # quadhyphenaftertokenlist.append(self.getHyphenAfterToken(word))
                    elif word.tag == "QW":
                        onetokenattlist = []
                        # apfs = self.getApfsVal(word)
                        # recalculate APFS for the whole word and get
                        # new APFS value and token minus underscore
                        (apfs, token) = self.getQwApfsVal(apfslist, quadtokenlist, word)
                        # token = word.text
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
                        charcount += len(token)
                        charcount += len(spaceaftertoken)
                        charnscount += len(token)
                        onetokenattlist.append(token)
                        onetokenattlist.append(spaceaftertoken)
                        onetokenattlist.append(entolivepageno)
                        onetokenattlist.append(entpublpageno)
                        onetokenattlist.append(entlineno)
                        onetokenattlist.append(artlineno)
                        tokenboxstr = self.buildTokenBoxStr(tokenbox)
                        onetokenattlist.append(tokenboxstr)
                        onetokenattlist.append(apfs)
                        onetokenattlist.append(specialtype)
                        self.tokenlist.append(onetokenattlist)
                        quadtokenlist = []
                        quadboxlist = []
                        apfslist = []
                        # print token.encode("utf-8"), tokenbox, spaceaftertoken
                    elif word.tag == "L":
                        artlineno += 1
                        entlineno += 1
                        charcount += 1

                        
        self.arttokencount = arttokencount
        self.artolivewordcount = artolivewordcount
        self.artlineno = artlineno
        self.charcount = charcount
        self.charnscount = charnscount

            # self.ByTest(entityid, olivewordcount)
            # print primlist
        # OLIVE's wordcount seems to be slightly wrong sometimes
        # if artolivewordcount != arttokencount:
        #     pass
        # print "%s % 4d % 5d % 5d" % (tokenidbase, artolivewordcount-arttokencount, artolivewordcount, arttokencount)
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


def ByTestMultipleArticlesImages(toc, zip, cvdic):
    (artrefslist, artrefsdic) = toc.getArticleRefs()
    for artid in artrefslist:
        newart = ByArticleText(artid, artrefsdic, toc, zip, cvdic)
        print "FULLARTICLEID:", newart.fullarticleid
    
def ByTestSingleArticleImages(art, toc, zip, cvdic):
    (artrefslist, artrefsdic) = toc.getArticleRefs()
    newart = ByArticleText(art, artrefsdic, currtoc, currzip, cvdic)
    print "FULLARTICLEID:", newart.fullarticleid

def ByTestMultipleArticlesMetaData(toc, zip, cvdic):
    (artrefslist, artrefsdic) = toc.getArticleRefs()
    # print artrefslist
    # print artrefsdic
    for artid in artrefslist:
        newart = ByArticleText(artid, artrefsdic, toc, zip, cvdic)
        entdic = newart.tocobj.entityrefsdic[artid]
        print "FULLARTICLEID:", newart.fullarticleid
        # print newart.tocobj.entityrefsdic
        print artid, artrefsdic[artid]
        for eid in artrefsdic[artid]:
            artmetadic = newart.getArtFileApplicationDataMetaData(eid)
            if len(artmetadic) != 0:
                print eid
                print "LEN", len(artmetadic)
                print artmetadic
                # print newart.tocobj.entityrefsdic[artid]
                if entdic["EMBEDDED_INTO"] != '':
                    print "%50s : %s" % ("ENTITYREF", artid)
                    print "%50s : %s" % ("EMBEDDED_INTO", entdic["EMBEDDED_INTO"].encode("utf-8"))
                    print "%50s : %s" % ("ENTITY_TYPE", entdic["ENTITY_TYPE"].encode("utf-8"))

    
def ByTestSingleArticleMetaData(art, toc, zip, cvdic):
    (artrefslist, artrefsdic) = toc.getArticleRefs()
    newart = ByArticleText(art, artrefsdic, currtoc, currzip, cvdic)
    print "FULLARTICLEID:", newart.fullarticleid
    # print newart.tocobj.entityrefsdic
    print artid, artrefsdic[artid]
    for eid in artrefsdic[artid]:
        print eid
    # print newart.tocobj.entityrefsdic[artid]
    entdic = newart.tocobj.entityrefsdic[artid]
    if entdic["EMBEDDED_INTO"] != '':
        print "%50s : %s" % ("ENTITYREF", artid)
        print "%50s : %s" % ("EMBEDDED_INTO", entdic["EMBEDDED_INTO"].encode("utf-8"))
        print "%50s : %s" % ("ENTITY_TYPE", entdic["ENTITY_TYPE"].encode("utf-8"))

def ByTestMultipleArticles(toc, zip, cvdic):
    (artrefslist, artrefsdic) = toc.getArticleRefs()
    # print artrefslist
    # print artrefsdic
    for artid in artrefslist:
        newart = ByArticleText(artid, artrefsdic, toc, zip, cvdic)
        newart.processArticle()
        print "FULLARTICLEID:", newart.fullarticleid
        # print newart.tocobj.entityrefsdic
        for tokenl in newart.tokenlist:
            print tokenl
    
def ByTestSingleArticle(art, toc, zip, cvdic):
    (artrefslist, artrefsdic) = toc.getArticleRefs()
    newart = ByArticleText(art, artrefsdic, currtoc, currzip, cvdic)
    print "FULLARTICLEID:", newart.fullarticleid
    for tokenl in newart.tokenlist:
        print tokenl

def ByTestSingleArticleApfs(art, toc, zip, cvdic):
    (artrefslist, artrefsdic) = toc.getArticleRefs()
    newart = ByArticleText(art, artrefsdic, currtoc, currzip, cvdic)
    print "FULLARTICLEID:", newart.fullarticleid
    for tokenl in newart.tokenlist:
        print tokenl

if __name__ == '__main__':
    confvarsdic = {}
    confvarsdic["corpusimagebasedir"] = "/projects/cch/ncse/olive/corpusimg/TEST"
    # confvarsdic["generatecorpusimages"] = True
    confvarsdic["generatecorpusimages"] = False
    confvarsdic["generatearttext"] = True
    corpusbasedir = "/projects/cch/ncse/olive/repository200803"
    # CLD sample - APFS - 2008 metadata version
    publdir = "CLD/1850/05/04"
    artid = "Ar01205"
    # FMRP sample - APFS - 2008 metadata version
    # publdir = "FMRP/1822/12/02"
    # NSS sample - APFS - 2008 metadata version
    # publdir = "NSS/1837/12/16"
    # TEC sample - APFS - 2008 metadata version
    # publdir = "TEC/1889/12/16"
    # TTW sample - APFS - 2008 metadata version
    # publdir = "TTW/1867/06/01"
    
    corpussubpath = os.path.join(corpusbasedir, publdir)
    for walkroot, walkdirs, walkfiles in os.walk(corpussubpath):
        currzip = byzipfile.ByZipFile(walkroot, walkfiles)
        currtoc = bytocfile.ByTocFile(walkroot)
        # ByTestSingleArticleMetaData(artid, currtoc, currzip, confvarsdic)
        ByTestMultipleArticlesMetaData(currtoc, currzip, confvarsdic)

    
    
        currzip.closeZipFile()

    print "--== FINISHED ==--"
