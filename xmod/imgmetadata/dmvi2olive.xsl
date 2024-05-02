<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
 
<!--  DMVI Converter (dmvi2olive.xsl)
         Desc: This stylesheet takes as input html produced from the DMVI excel spreadsheet, and 
                   converts it to an XML format that can be loaded into the Olive Software system.
                    
        The output structure looks like:
        
        <Key_words>
        <L1>settings id:dmvi:d2e607
        <L2>interiors id:dmvi:d2e617</L2>
        <L2>exteriors id:dmvi:d2e609</L2>
        <L2>natural environments id:dmvi:d2e620
        <L3>the sea id:dmvi:d2e630</L3>
        </L2>
        </L1>
        </Key_words> 
        
        Each tag (L1, L2, L3, L4, etc) represents a hierarchical level within the DMVI scheme;
        the values of the tags will be associated with image resources in the Olive administrative tool,
        and will subsequently be passed as metadata to the CCH for additional proccessing.
        
        
        settings id:dmvi:d2e607
        interiors id:dmvi:d2e617
        natural environments id:dmvi:d2e620
        the sea id:dmvi:d2e620 
        
        
        To allow for reconstruction of the hierarchy at a later date and to allow for repetition
        in term strings, each value has also been given an id that unambiguously identifies this particular term
        and also the provenance of the term's inclusion within the structure (i.e. dmvi, or ncse)
        
        Author: tamara.lopez@kcl.ac.uk
        Last Modified: 21 November, 2007
        
        $Id: $
 -->

 <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/body">
    <xsl:variable name="html2Xml">
           <xsl:apply-templates select="table"/>
    </xsl:variable>
    
    <xsl:call-template name="createOutput">
        <xsl:with-param name="xml2Process" select="$html2Xml"/>
    </xsl:call-template>
</xsl:template>
    
    <xsl:template name="createOutput">
        <xsl:param name="xml2Process"/>
        <xsl:comment>
            DMVI for Olive
            Desc: This XML is to be loaded into the Olive Software
            Administration Tool, to live at: 
            olive\Applications\Director\Keywords
            
            
            
            Each tag (L1, L2, L3, L4, etc) represents a hierarchical level within the DMVI scheme;
            the values of the tags will be associated with image resources in the Olive administrative tool,
            and will subsequently be passed as metadata to the CCH for additional proccessing.
            
            Strings sent to the CCH will look like:
            
            settings id:dmvi:d2e607
            interiors id:dmvi:d2e617
            natural environments id:dmvi:d2e620
            the sea id:dmvi:d2e620 
            
            
            To allow for reconstruction of the hierarchy at a later date and to allow for repetition
            in term strings, each value has also been given an id that unambiguously identifies this particular term
            and also the provenance of the term's inclusion within the structure (i.e. dmvi, or ncse)
            
            Entries added to this file should take a similar form, however, the id's should reflect
            'ncse' as the author, and should include a unique ID:
            
            the mountains id:ncse:d9z9999
            
            Where ids are assigned in sequentially descending order, i.e. d9z9999, d9z9998, d9z9997. 
            
            Author: tamara.lopez@kcl.ac.uk
            Last Modified: 21 November, 2007
            
            $Id: $
                        
        </xsl:comment>
        
              <Key-words>
        
                   
                    <xsl:for-each-group select="$xml2Process//L1" group-by="@key">
                        <L1><xsl:value-of select="current-group()[1]/text()"/><xsl:text>     </xsl:text><xsl:value-of select="concat('id:dmvi:',generate-id())"/>
                               <xsl:for-each-group select="current-group()/L2" group-by="@key">
                                   <L2><xsl:value-of select="current-group()[1]/text()"/><xsl:text>    </xsl:text><xsl:value-of select="concat('id:dmvi:',generate-id())"/>
                                    
                                    <xsl:for-each-group select="current-group()/L3" group-by="@key">
                                        <L3><xsl:value-of select="current-group()[1]/text()" /><xsl:text>     </xsl:text><xsl:value-of select="concat('id:dmvi:',generate-id())"/>
                                            
                                            <xsl:for-each-group select="current-group()/L4" group-by="@key">
                                                <L4><xsl:value-of select="current-group()[1]/text()"/><xsl:text>     </xsl:text><xsl:value-of select="concat('id:dmvi:',generate-id())"/></L4>
                                            </xsl:for-each-group>
                                        </L3>
                                    </xsl:for-each-group>
                                </L2>
                            </xsl:for-each-group>
                        </L1>
                    </xsl:for-each-group>
                </Key-words>           
      </xsl:template>
    
    
    <xsl:template match="table">
        <Key_words>
        
        <xsl:apply-templates select="tr[not(@class='ignore')]"/>
        </Key_words>
    </xsl:template>
    
    
 <xsl:template match="tr">
     <xsl:element name="L1">
         <xsl:attribute name="key"><xsl:value-of select="normalize-space(td[2]/text())"/></xsl:attribute>
         <xsl:value-of select="td[2]/text()"/>
         <xsl:text></xsl:text>
         
         <xsl:apply-templates select="td[3]" mode="cat1" />
     </xsl:element>   
 </xsl:template>
    
    <xsl:template match="td" mode="cat1"><!--td[3]-->
        <L2>
            <xsl:attribute name="key"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
            <xsl:value-of select="."/>
            <xsl:apply-templates select="../td[4]" mode="cat2"/>
         </L2>
    </xsl:template>
    
    <xsl:template match="td" mode="cat2"><!--td[4]-->
        <L3>
            <xsl:attribute name="key"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
            <xsl:value-of select="."/>
            <xsl:if test="not(normalize-space(../td[5]) = '')">
                <xsl:apply-templates select="../td[5]" mode="cat3"/>
             </xsl:if>
         </L3>
    </xsl:template>
    <xsl:template match="td" mode="cat3">
        <L4>
            <xsl:attribute name="key"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
        <xsl:value-of select="."/>
        </L4>
     </xsl:template>
</xsl:stylesheet>
