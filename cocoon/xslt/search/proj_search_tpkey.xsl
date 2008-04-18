<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id: proj_search_tpkey.xsl 1010 2008-04-18 13:11:54Z jvieira $
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:variable name="pagehead">
    <xsl:value-of select="$context-id" />
  </xsl:variable>
  
  <xsl:template match="/">
    <xsl:call-template name="html_tpl" />
  </xsl:template>
  
  <xsl:template name="ctpl_content">
    <xsl:choose>
      <xsl:when test="$context-id = 'search_entity'">
        <xsl:call-template name="tpl-search-entity-form" />
      </xsl:when>
      <xsl:when test="$context-id = 'search_advanced'">
        <xsl:call-template name="tpl-search-advanced-form" />
      </xsl:when>
      <xsl:when test="$context-id = 'search_thesaurus'">
        <xsl:call-template name="tpl-search-thesaurus-form" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
