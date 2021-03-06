<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:page="http://apache.org/cocoon/paginate/1.0"
  xmlns:r="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:s="http://www.w3.org/2004/02/skos/core#"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="collection">
    <xsl:choose>
      <xsl:when test="string(substring-before($context-id, '_result'))">
        <xsl:value-of select="substring-before(substring-after($context-id, 'browse_'), '_result')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-after($context-id, 'browse_')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="col-key">
    <xsl:choose>
      <xsl:when test="$collection = 'subject'">
        <xsl:text>semtag</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$collection" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pagehead">
    <xsl:value-of select="//filebase//item[@id = $context-id]/fileTitle" />
  </xsl:variable>

  <xsl:template match="/">
    <xsl:call-template name="html_tpl" />
  </xsl:template>

  <xsl:template name="ctpl_submenu"> </xsl:template>

  <xsl:template name="ctpl_pagehead">

    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of select="$pagehead" />
          <xsl:if test="contains($context-id, 'result')">
            <xsl:text>: </xsl:text>
            <!-- util/result_tpl -->
            <xsl:call-template name="results-of" />
          </xsl:if>
        </h1>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="ctpl_rhcontent">
    <xsl:variable name="concepts">
      <xsl:for-each select="//search-results/search-clauses-parameters/parameter">
        <xsl:value-of select="substring-before(., '::')" />

        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <div id="rightContent">
      <div class="facetBrowse">
        <a href="../subject.html" class="facetReset" title="Return to the Subject Category Index">&#8249;&#8249; <b>Back to Subject Index</b></a>
        <div class="facetPanel">
          <h3>Categories</h3>
          <dl>
            <xsl:for-each select="//r:RDF/s:Concept">
              <dt>
                <xsl:if test="contains($concepts, @r:about)">
                  <xsl:attribute name="class">x01</xsl:attribute>
                </xsl:if>

                <xsl:value-of select="@r:label" />
              </dt>
              <xsl:if test="s:narrower">
                <dd>
                  <xsl:if test="s:narrower/s:orderedCollection/s:memberList/s:Concept">
                    <xsl:call-template name="category-sub">
                      <xsl:with-param name="concepts" select="$concepts" />
                    </xsl:call-template>
                  </xsl:if>
                </dd>
              </xsl:if>
            </xsl:for-each>
          </dl>
        </div>
      </div>
      <!-- ## END RIGHTCONTENT, BEGIN MAINCONTENT ## -->
    </div>
  </xsl:template>

  <xsl:template name="category-sub">
    <xsl:param name="concepts" required="yes" />

    <ul>
      <xsl:for-each select="s:narrower/s:orderedCollection/s:memberList/s:Concept">
        <li>
          <xsl:choose>
            <xsl:when test="contains($concepts, @r:about)">
              <span class="x01" title="Term already selected.">
                <xsl:value-of select="@r:label" />
              </span>
            </xsl:when>
            <xsl:otherwise>
              <a href="add?field={$col-key}-key&amp;value={encode-for-uri(@r:about)}&amp;display={encode-for-uri(@r:label)}&amp;pos=0"
                title="Filter results by this term.">
                <xsl:value-of select="@r:label" />
              </a>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:if test="s:narrower/s:orderedCollection/s:memberList/s:Concept">
            <xsl:call-template name="category-sub">
              <xsl:with-param name="concepts" select="$concepts" />
            </xsl:call-template>
          </xsl:if>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="ctpl_toc1">
    <xsl:call-template name="ctpl_toc" />
  </xsl:template>

  <xsl:template name="ctpl_toc2">
    <xsl:call-template name="ctpl_toc" />
  </xsl:template>

  <xsl:template name="ctpl_toc" />

  <xsl:template name="ctpl_content">
    <xsl:choose>
      <xsl:when test="contains($context-id, 'result')">
        <xsl:call-template name="tpl-browse-results" />
      </xsl:when>
      <xsl:when test="$context-id = 'browse_subject'">
        <xsl:call-template name="tpl-browse-subject-start" />
      </xsl:when>
      <xsl:when test="$context-id = 'browse_image'">
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
