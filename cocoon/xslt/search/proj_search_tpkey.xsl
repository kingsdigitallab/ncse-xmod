<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:page="http://apache.org/cocoon/paginate/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="pagehead">
    <xsl:choose>
      <xsl:when test="$context-id = 'search_results'">
        <div class="s01">
          <xsl:text>Search Results </xsl:text>
          <!-- util/result_tpl -->
          <xsl:call-template name="results-of" />
        </div>
      </xsl:when>
      <xsl:when test="$context-id = 'search_form'">
        <xsl:text>Search</xsl:text>
      </xsl:when>
      <xsl:when test="$context-id = 'view_issue'">
        <xsl:value-of select="//search-results/hits/hit/tei/bibl/title[@type = 'full-title']" />
      </xsl:when>
      <xsl:when test="$context-id != 'view_issue'">
        <xsl:value-of select="upper-case(substring($context-id, 8, 1))" />
        <xsl:value-of select="substring($context-id, 9)" />
        <xsl:text> Search</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$context-id = 'image_thesaurus'">
        <xsl:call-template name="tpl-thesaurus-window">
          <xsl:with-param name="type">image</xsl:with-param>
          <xsl:with-param name="key" select="$thesaurus-key" />
          <xsl:with-param name="text" select="$thesaurus-text" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$context-id = 'subject_thesaurus'">
        <xsl:call-template name="tpl-thesaurus-window">
          <xsl:with-param name="type">subject</xsl:with-param>
          <xsl:with-param name="key" select="$thesaurus-key" />
          <xsl:with-param name="text" select="$thesaurus-text" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="html_tpl" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ctpl_submenu"> </xsl:template>

  <xsl:template name="ctpl_pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of select="$pagehead" />
        </h1>
      </div>

      <xsl:choose>
        <xsl:when test="$context-id = 'search_results'">
          <p>
            <xsl:text>Expand search results by clicking the '+' sign next to each search result.  This will display a list of keywords that have been assigned to the item.  You may refine your resultset by adding these terms to your query or by returning to the search form using the 'modify' or 'new' search buttons.</xsl:text>
          </p>

          <p>
            <xsl:text>To view items in the facsimile repository, use the links provided with the bibliographic citations provided for each result.</xsl:text>
          </p>
        </xsl:when>
        <xsl:when test="$context-id = 'search_form'">
          <p>
            <xsl:text>Use this form to search for keywords that have been assigned to items in the facsimile repository. All fields are optional; entering
            multiple terms will produce a manageable set of results.</xsl:text>
          </p>
        </xsl:when>
      </xsl:choose>
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
      <xsl:when test="$context-id = 'search_form'">
        <xsl:call-template name="tpl-search-form" />
      </xsl:when>
      <xsl:when test="$context-id = 'search_results'">
        <xsl:call-template name="tpl-search-results" />
      </xsl:when>
      <xsl:when test="$context-id = 'view_issue'">
        <xsl:call-template name="tpl-view-issue" />
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
