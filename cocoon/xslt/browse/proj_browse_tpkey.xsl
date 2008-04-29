<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:r="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:s="http://www.w3.org/2004/02/skos/core#">
  
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
    <xsl:value-of select="//filebase//item[@id = $context-id]/fileTitle"/>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:call-template name="html_tpl"/>
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
          <xsl:value-of select="$pagehead"/>
        </h1>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="ctpl_rhcontent">
    <div id="rightContent">
            
      <div class="facetBrowse">
        <div class="facetBrowseSummary">
          <h3>Filtering by:</h3>
          <dl>
            <xsl:for-each select="//search-results/display-parameters/parameter">
              <dt>
                <!--<a href="#" title="Remove this category from the filter">Remove</a>-->
                <xsl:value-of select="."/>
              </dt>
            </xsl:for-each>
            <xsl:for-each-group select="//search-results/search-clauses-parameters/parameter" group-by=".">
              <dt>
                <!--<a href="#" title="Remove this category from the filter">Remove</a>-->
                <xsl:value-of select="."/>
              </dt>
            </xsl:for-each-group>
            <!--        <dd>
              <ul>
              <li>
              <a href="#">
              <span>Sub Term</span>
              </a>
              <ul>
              <li>
              <a href="#">
              <span>Sub Sub Term</span>
              </a>
              <ul>
              <li>
              <span class="s02">Sub Sub Sub Term</span>
              </li>
              </ul>
              </li>
              </ul>
              </li>
              </ul>
              </dd>-->
            <!--<dt><a href="#" title="Remove this category from the filter">Remove</a>General and Abstract
              Terms</dt>
              <dd>
              <ul>
              <li>
              <a href="#">
              <span>Sub Term</span>
              </a>
              <ul>
              <li>
              <span class="s02">Sub Sub Term</span>
              </li>
              </ul>
              </li>
              </ul>
              </dd>-->
          </dl>
        </div>
        
        
        <div class="facetPanel">
          <h3>Categories</h3>
          <dl>
            <xsl:for-each select="//r:RDF/s:Concept">
              <dt>
                <a href="#">
                  <xsl:value-of select="@r:label"/>
                </a>
              </dt>
              <xsl:if test="s:narrower">
                <dd>
                  <xsl:if test="s:narrower/s:orderedCollection/s:memberList/s:Concept">
                    <xsl:call-template name="category-sub"/>
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
    <ul>
      <xsl:for-each select="s:narrower/s:orderedCollection/s:memberList/s:Concept">
        <li>
          <a href="add-browse-{$collection}?field={$col-key}-key&amp;value={encode-for-uri(@r:about)}&amp;display={encode-for-uri(@r:label)}&amp;pos=0">
            <xsl:value-of select="@r:label"/>
          </a>
          <xsl:if test="s:narrower/s:orderedCollection/s:memberList/s:Concept">
            <xsl:call-template name="category-sub"/>
          </xsl:if>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="ctpl_toc1">
    <xsl:call-template name="ctpl_toc"/>
  </xsl:template>

  <xsl:template name="ctpl_toc2">
    <xsl:call-template name="ctpl_toc"/>
  </xsl:template>

  <xsl:template name="ctpl_toc"/>

  <xsl:template name="ctpl_content">
    <xsl:choose>
      <xsl:when test="contains($context-id, 'result')">
        <xsl:call-template name="tpl-browse-results"/>
      </xsl:when>
      <xsl:when test="$context-id = 'browse_subject'">
        <xsl:call-template name="tpl-browse-subject-start"/>
      </xsl:when>
      <xsl:when test="$context-id = 'browse_image'">
        <xsl:call-template name="tpl-browse-image-start"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ctpl_footnotes"/>

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
