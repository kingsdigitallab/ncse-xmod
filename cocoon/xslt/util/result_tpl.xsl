<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id: proj_results_spec.xsl 1100 2008-04-29 13:25:06Z jvieira $
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:page="http://apache.org/cocoon/paginate/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template name="results-of">
    <xsl:variable name="rpp" select="number(20)" />
    <xsl:variable name="page" select="//search-results/page:page/@current" />
    <xsl:variable name="total" select="//search-results/total" />
    
    <xsl:value-of select="$page * $rpp - 19" />
    <xsl:text> - </xsl:text>
    <xsl:choose>
      <xsl:when test="$page * $rpp > $total">
        <xsl:value-of select="$total" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$page * $rpp" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> (of </xsl:text>
    <xsl:value-of select="$total" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template name="page-nav">
    <xsl:param name="page-sub"/>

    <xsl:variable name="rpp" select="number(20)"/>
    <xsl:variable name="page" select="//search-results/page:page/@current"/>
    <xsl:variable name="total" select="//search-results/total"/>
    <xsl:variable name="page-link">
      <xsl:value-of select="$page-sub"/>
      <xsl:text>page</xsl:text>
    </xsl:variable>

    <xsl:if test="$total > $rpp">
      <ul class="s01">
        <xsl:for-each select="//page:page">
          <xsl:variable name="current-page" select="number(@current)"/>

          <xsl:choose>
            <xsl:when test="page:link[@type = 'prev'][position() = last()]">
              <li>
                <a href="{$page-link}(1)">&#8249;&#8249; first</a>
              </li>
              <li>
                <a href="{$page-link}({page:link[@type = 'prev'][position() = last()]/@page})">&#8249; prev</a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li>
                <span class="s02">&#8249;&#8249; first</span>
              </li>
              <li>
                <span class="s02">&#8249; prev</span>
              </li>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:for-each select="page:link[$current-page > number(@page)]">
            <li>
              <a href="{$page-link}({@page})">
                <xsl:value-of select="@page"/>
              </a>
            </li>
          </xsl:for-each>

          <li>
            <span class="s02">
              <xsl:value-of select="$current-page"/>
            </span>
          </li>

          <xsl:for-each select="page:link[number(@page) > $current-page]">
            <li>
              <a href="{$page-link}({@page})">
                <xsl:value-of select="@page"/>
              </a>
            </li>
          </xsl:for-each>

          <xsl:choose>
            <xsl:when test="page:link[@type = 'next'][position() = 1]">
              <li>
                <a href="{$page-link}({page:link[@type = 'next'][position() = 1]/@page})">next &#8250;</a>
              </li>
              <li>
                <a href="{$page-link}({@total})">&#8250;&#8250; last</a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li>
                <span class="s02">next &#8250;</span>
              </li>
              <li>
                <span class="s02">&#8250;&#8250; last</span>
              </li>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="hits-head-link">
    <xsl:variable name="entity" select="substring-after(substring-after(substring-after(substring-after(id, '-'), '-'), '-'), '-')" />
    <xsl:variable name="path" select="escape-html-uri(replace(substring-before(id, concat('-', $entity)), '-', '/'))" />
    
    <h3>
      <xsl:value-of select="tei/bibl/title[@type = 'full-title']" />
    </h3>
    
    <ul class="s01">
      <li class="s01">
        <a href="http://137.73.123.44/KingsCollege/Default.htm?href={$path}&amp;entityid={$entity}&amp;view=entity" target="_blank">
          <xsl:value-of select="id" />
        </a>
      </li>
      <li class="s02">
        <a href="view-issue({@position})">View all article data</a>
      </li>
    </ul>
  </xsl:template>
</xsl:stylesheet>
