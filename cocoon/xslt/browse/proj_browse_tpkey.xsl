<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id: proj_search_tpkey.xsl 1010 2008-04-18 13:11:54Z jvieira $
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:variable name="pagehead">
    <xsl:value-of select="//filebase//item[@id = $context-id]/fileTitle" />
  </xsl:variable>

  <xsl:template match="/">
    <xsl:call-template name="html_tpl" />
  </xsl:template>

  <xsl:template name="ctpl_submenu">
<!--    <xsl:if test="$context-id = 'search_results'">
      <div class="submenu">
        <div class="t01">
          <ul>
            <li>
              <a href="refine-{//search-results/search-link}.html">Modify search</a>
            </li>
          </ul>
        </div>
      </div>
    </xsl:if>-->
  </xsl:template>

  <xsl:template name="ctpl_pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of select="$pagehead" />
        </h1>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="ctpl_rhcontent"> </xsl:template>

  <xsl:template name="ctpl_toc1">
    <xsl:call-template name="ctpl_toc" />
  </xsl:template>

  <xsl:template name="ctpl_toc2">
    <xsl:call-template name="ctpl_toc" />
  </xsl:template>

  <xsl:template name="ctpl_toc" />

  <xsl:template name="ctpl_content">
    <xsl:choose>
      <xsl:when test="$context-id = 'browse_subject'">
        <xsl:call-template name="tpl-browse-subject-start" />
      </xsl:when>
      <xsl:when test="$context-id = 'browse_image_meta'">
        <xsl:call-template name="tpl-browse-image-start" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ctpl_footnotes" />

  <xsl:template name="ctpl_options1">
    <!--<div class="options">
      <div class="t01">
      <xsl:call-template name="ctpl_option" />
      </div>
      </div>-->
  </xsl:template>

  <xsl:template name="ctpl_options2">
    <!--  <div class="options">
      <div class="t02">
      <xsl:call-template name="ctpl_option" />
      </div>
      </div>-->
  </xsl:template>

  <xsl:template name="ctpl_option"> </xsl:template>
</xsl:stylesheet>
