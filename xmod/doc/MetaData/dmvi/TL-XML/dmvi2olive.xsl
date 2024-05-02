<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
              <Key-words>
                    
                    <xsl:for-each-group select="$xml2Process//L1" group-by="@key">
                        <L1 id="{generate-id()}"><xsl:value-of select="current-group()[1]/text()"></xsl:value-of>
                               <xsl:for-each-group select="current-group()/L2" group-by="@key">
                                <L2 id="{generate-id()}"><xsl:value-of select="current-group()[1]/text()"></xsl:value-of>
                                    
                                    <xsl:for-each-group select="current-group()/L3" group-by="@key">
                                        <L3 id="{generate-id()}"><xsl:value-of select="current-group()[1]/text()"></xsl:value-of>
                                            
                                            <xsl:for-each-group select="current-group()/L4" group-by="@key">
                                                <L4 id="{generate-id()}"><xsl:value-of select="current-group()[1]/text()"></xsl:value-of></L4>
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
