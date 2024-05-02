
import sys
import os, os.path
import string
import re
# from xml.etree import ElementTree as ET
from lxml import etree as ET
from prxml_extract_metadata_fields import *

quotmark = chr(146)
endash = chr(150)
emdash = chr(151)

class ByTocFile:
    """Provide several methods to access a PrXML TOC file
    and get various information out of it.
    """
    def __init__(self, path):
        self.path = path
        self.tocfilename = "TOC.xml"
        self.tocfilepath = os.path.join(self.path, self.tocfilename)
        self.tocxmltree = ET.parse(self.tocfilepath)
        self.tocxmlrootobj = self.tocxmltree.getroot()
        self.tocxmlmetaobj = self.tocxmltree.xpath('/Xmd_toc/Head_np/Meta')
        self.basehref = self.tocxmlmetaobj[0].get("BASE_HREF")
        self.tocxmllinkobj = self.tocxmltree.xpath('/Xmd_toc/Head_np/Link')
        self.pdffile = self.tocxmllinkobj[0].get("SOURCE")
        self.getTocFileMetaPublName()
        self.getTocFileApplicationDataMetaData()
        self.pageentattlist = [
                          "SECTION_NAME",
                          "PAGE_NO",
                          "PAGE_LABEL",
                          "ENTITY_TYPE",
                          "ENTITY_SUBTYPE",
                          "FIRST_TOC_ENTRY_ID",
                          "DEPTH_LEVEL",
                          "INDEX_IN_DOC",
                          "LOGICAL_NAME",
                          "NAME",
                          "ID",
                          "HREF",
                          "SIZE",
                          "EMBEDDED_INTO",
                          "IMAGES_RESOLUTION",
                          "CONTINUATION_FROM",
                          "CONTINUATION_TO"
                          ]

    def getTocFileName(self):
        return self.tocfilename
    
    def getTocFilePath(self):
        return self.tocfilepath
    
    def getTocFileMetaPublName(self):
        publnamesobjlist = self.tocxmltree.xpath('/Xmd_toc/Head_np/Meta/Name')
        self.tocxmlmetapublname = ""
        for l in publnamesobjlist:
            if self.tocxmlmetapublname == "":
                 self.tocxmlmetapublname = l.text.encode("cp1252")
                 # self.tocxmlmetapublname = l.text.encode("utf8")
            else:
                 self.tocxmlmetapublname += ", " + l.text.encode("cp1252")
                 # self.tocxmlmetapublname += ", " + l.text.encode("utf8")
        return self.tocxmlmetapublname

    def getTocFileHeadMetaData(self):
        headmetaobj = self.tocxmltree.xpath('/Xmd_toc/Head_np/Meta')
        self.tocfileheadmetadatadic = {}
        for k in headmetaobj[0].attrib.keys():
            kn = k.lower()
            kn = "o_toc_meta_" + kn
            if kn in mdfieldlist3:
                self.tocfileheadmetadatadic.setdefault(kn, headmetaobj[0].attrib[k].encode("cp1252"))
                # self.tocfileheadmetadatadic.setdefault(kn, headmetaobj[0].attrib[k].encode("utf8"))
        return self.tocfileheadmetadatadic
    
    
    def getTocFileApplicationDataMetaData(self):
        tocxmlapplicationdatalist = self.tocxmltree.xpath('/Xmd_toc/Head_np/Application_Data')
        self.tocfileappmetadatadic = {}
        for ad in tocxmlapplicationdatalist:
            applicationinfolist = ad.getchildren()
            for applicationinfo in applicationinfolist:
                applicationinfoname = applicationinfo.attrib["AI_TYPE"]
                applicationinfoname = applicationinfoname.replace(":", "_")
                if applicationinfoname[0] in string.ascii_uppercase:
                    applicationinfoname = applicationinfoname.lower()
                    applicationinfoname = "o_toc_appd_" + applicationinfoname
                else: 
                    applicationinfoname = applicationinfoname.lower()
                    applicationinfoname = "n_toc_appd_" + applicationinfoname
                if applicationinfoname in mdfieldlist3:
                    aiitemlist = applicationinfo.getchildren()
                    if aiitemlist != []:
                        self.tocfileappmetadatadic[applicationinfoname] = []
                        for aiitem in aiitemlist:
                            a = aiitem.attrib["NAME"].encode("cp1252")
                            a = self.normaliseHyphen(a)
                            a = self.normaliseQuotMark(a)
                            self.tocfileappmetadatadic[applicationinfoname].append(a)
                            # nn = self.normaliseHyphen(aiitem.attrib["NAME"])
                            # self.tocfileappmetadatadic[applicationinfoname].append(nn)
        return self.tocfileappmetadatadic
    
    def getTocContStr(self):
        self.tocfobj = file(self.tocfilepath, "r")
        # toclinelist = tocfobj.readlines()
        self.toccontstr = self.tocfobj.read()
        self.tocfobj.close()
        return self.toccontstr

    def getTocXmlRoot(self):
        # self.tocxmlrootobj = self.tocxmltree.getroot()
        self.tocxmlroottag = self.tocxmlrootobj.tag
        return self.tocxmlroottag
    
    def getRootChildren(self):
        self.rootchildren = self.tocxmlrootobj.getchildren()
        return self.rootchildren
    
    def getSections(self):
        self.sections = self.tocxmlrootobj.findall('Body_np/Section')
        return self.sections
    
    def setEntityGlobalId(self, ehref):
        entityid = self.basehref + ehref
        return entityid
    
    def normaliseHyphen(self, t):
        """Normalise Hyphen to "-", i. e. replace occurrences of EN_DASH and EM_DASH
        with a single Hyphen ("-")."""
        # EM DASH
        t = t.replace(emdash, "-")
        # 
        # EN DASH
        t = t.replace(endash, "-")
        return t

    def normaliseQuotMark(self, t):
        """Normalise quotation mark to "'"."""
        # RIGHT SINGLE QUOTATION MARK
        t = t.replace(quotmark, "'")
        return t

    def getEntityRefs(self):
        self.entityrefslist = []
        self.entity_ids_sorted = []
        self.entityrefsdic = {}
        sections = self.getSections()
        for sectionobj in sections:
            # sectionname = sectionobj.attrib["NAME"]
            sectionname = sectionobj.attrib["NAME"].encode("cp1252")
            for pageobj in sectionobj:
                if pageobj.attrib.has_key("PAGE_NO"):
                    page_no = pageobj.attrib["PAGE_NO"]
                else:
                    page_no = "0"
                if pageobj.attrib.has_key("PAGE_LABEL"):
                    page_label = pageobj.attrib["PAGE_LABEL"]
                else:
                    page_label = ""
                for entityobj in pageobj:
                    tmperefdic = {}
                    tmperefdic["SECTION_NAME"] = sectionname
                    tmperefdic["PAGE_NO"] = page_no
                    tmperefdic["PAGE_LABEL"] = page_label
                    for attname in self.pageentattlist[3:]:
                        if entityobj.attrib.has_key(attname):
                            tmperefdic[attname] = entityobj.attrib[attname]
                        else:
                            tmperefdic[attname] = ''
                    self.entity_ids_sorted.append(tmperefdic["ID"])
                    entityglobalid = tmperefdic["ID"]
                    self.entityrefsdic[entityglobalid] = tmperefdic
        return self.entityrefsdic

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

    def getEntityRefsForExtractMetaData(self):
        self.entity_ids_m_sorted = []
        self.entityrefsmetadic = {}
        sections = self.getSections()
        for sectionobj in sections:
            # sectionname = sectionobj.attrib["NAME"]
            # sectionname = sectionobj.attrib["NAME"].encode("cp1252")
            sectionname = sectionobj.attrib["NAME"].encode("utf8")
            for pageobj in sectionobj:
                # if pageobj.attrib.has_key("PAGE_NO"):
                #     page_no = pageobj.attrib["PAGE_NO"]
                # else:
                #     page_no = "0"
                # if pageobj.attrib.has_key("PAGE_LABEL"):
                #     page_label = pageobj.attrib["PAGE_LABEL"]
                # else:
                #     page_label = ""
                for entityobj in pageobj:
                    tmperefdic = {}
                    tmperefdic["o_toc_sect_section_name"] = sectionname
                    for k in pageobj.attrib.keys():
                        kn = k.lower()
                        kn = "o_toc_page_" + kn
                        if kn in mdfieldlist3:
                            # tmperefdic[kn] = pageobj.attrib[k].encode("cp1252")
                            tmperefdic[kn] = pageobj.attrib[k].encode("utf8")
                    
                    # tmperefdic["PAGE_NO"] = page_no
                    # tmperefdic["PAGE_LABEL"] = page_label
                    # for attname in self.pageentattlist[3:]:
                    #     if entityobj.attrib.has_key(attname):
                    #         tmperefdic[attname] = entityobj.attrib[attname]
                    #     else:
                    #         tmperefdic[attname] = ''
                    for k in entityobj.attrib.keys():
                        kn = k.lower()
                        kn = "o_toc_enty_" + kn
                        if kn in mdfieldlist3:
                            # print type(entityobj.attrib[k])
                            a = entityobj.attrib[k]
                            # print type(a)
                            a = self.filterRightToLeftUnicodeChars(a)
                            # print type(a), type(a.encode("utf8")), type(a.encode("cp1252"))
                            # print k, "u:", a.encode("utf8")
                            # print k, "c:", a.encode("cp1252")
                            # print k, "-:", a
                            # print k, ":", entityobj.attrib[k].encode("utf8")
                            # print entityobj.attrib[k].encode("cp1252")
                            # tmperefdic[kn] = entityobj.attrib[k].encode("cp1252")
                            tmperefdic[kn] = a.encode("utf8")
                    
                    self.entity_ids_m_sorted.append(tmperefdic["o_toc_enty_id"])
                    entityglobalid = tmperefdic["o_toc_enty_id"]
                    self.entityrefsmetadic[entityglobalid] = tmperefdic
        return self.entityrefsmetadic

    def getSortedEntityRefsKeys(self, d):
        """Generate a sorted list of entity ids.
        Not needed anymore, as list is produced in getEntityRefs"""
        erl = d.keys()
        erls = [int(e[2:]) for e in erl]
        erls.sort()
        erls = ["Ar%05d" % e for e in erls]
        return erls

    def getArticleRefs(self):
        self.articlerefsdic = {}
        erefsdic = self.getEntityRefs()
        lastarticleid = {}
        for eid in self.entity_ids_sorted:
            if erefsdic[eid]["CONTINUATION_FROM"] == '':
                self.articlerefsdic[eid] = [eid]
                if erefsdic[eid]["CONTINUATION_TO"] != '':
                    toeid = erefsdic[eid]["CONTINUATION_TO"]
                    while toeid != '':
                        self.articlerefsdic[eid].append(toeid)
                        toeid = erefsdic[toeid]["CONTINUATION_TO"]
        self.articlerefslist = self.articlerefsdic.keys()
        self.articlerefslist.sort()
        return self.articlerefslist, self.articlerefsdic

        
    
    # def getBaseHref(self):
    #     self.tocxmlmetaobj = self.tocxmltree.xpath('/Xmd_toc/Head_np/Meta')
    #     self.basehref = self.tocxmlmetaobj[0].get("BASE_HREF")
    #     return self.basehref

    # def getPdf(self):
    #     self.tocxmllinkobj = self.tocxmltree.xpath('/Xmd_toc/Head_np/Link')
    #     self.pdffile = self.tocxmllinkobj[0].get("SOURCE")
    #     return self.pdffile

if __name__ == '__main__':
    # corpusinpath = "/projects/cch/ncse/olive/skua/Drive_E_OliveInternal/2007samples"
    corpusinpath = "/projects/cch/ncse/olive/repository200803"
    # fileinpath = corpusinpath + "/LDR/1852/03/06"
    # fileinpath = corpusinpath + "/LDR/1852/03/27"
    # fileinpath = corpusinpath + "/NSS/1837/12/16"
    fileinpath = corpusinpath + "/CLD/1850/05/04"
    # fileinpath = corpusinpath + "/FMRP/1822/12/02"
    # fileinpath = corpusinpath + "/TEC/1889/12/16"
    # fileinpath = corpusinpath + "/TTW/1867/06/01"
    currtoc = ByTocFile(fileinpath)
    ctcont = currtoc.getTocContStr()
    print len(ctcont), ctcont[0:10],  ctcont[-10:]
    print len(currtoc.tocxmltree.getroot().text), ">>"+currtoc.tocxmltree.getroot().text+"<<"
    print currtoc.getTocXmlRoot()
    print currtoc.getRootChildren()
    print currtoc.basehref
    print currtoc.pdffile
    print currtoc.getSections()
    ard = currtoc.getEntityRefs()
    # print ard
    # print currtoc.entityrefslist
    for k in currtoc.entity_ids_sorted:
        print k
        for a in currtoc.pageentattlist:
            print "   ", a, ":", ard[k][a].encode("utf-8")
    print currtoc.getSortedEntityRefsKeys(ard)
    print len(currtoc.entity_ids_sorted)
    for k in currtoc.entity_ids_sorted:
        print "%15s  CONT_FROM: %15s    CONT_TO: %15s" % (k,
                                                          ard[k]["CONTINUATION_FROM"],
                                                          ard[k]["CONTINUATION_TO"],
                                                          )
    (tl, ar) = currtoc.getArticleRefs()
    # tl = currtoc.articlerefsdic.keys()
    # tl.sort()
    for k in tl:
        print k, ar[k]
    print 
    print "METADATA ---------------------------"
    print 
    print "META PUBL NAME:", currtoc.getTocFileMetaPublName()
    print currtoc.getTocFileApplicationDataMetaData()
    print currtoc.getEntityRefsForExtractMetaData()
    print "--== FINISHED ==--"
