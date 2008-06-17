<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id: proj_results_spec.xsl 1100 2008-04-29 13:25:06Z jvieira $
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:page="http://apache.org/cocoon/paginate/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="results-of">
    <xsl:variable name="page" select="//search-results/page:page/@current" />
    <xsl:variable name="total" select="//search-results/total" />

    <xsl:if test="$total > 0">
      <xsl:value-of select="$page * $rpp - ($rpp - 1)" />
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
    </xsl:if>
  </xsl:template>

  <xsl:template name="page-nav">
    <xsl:variable name="page" select="//search-results/page:page/@current" />
    <xsl:variable name="total" select="//search-results/total" />
    <xsl:variable name="page-link">page</xsl:variable>

    <xsl:if test="$total > $rpp">
      <ul class="s01">
        <xsl:for-each select="//page:page">
          <xsl:variable name="current-page" select="number(@current)" />

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
                <span class="s01">&#8249;&#8249; first</span>
              </li>
              <li>
                <span class="s01">&#8249; prev</span>
              </li>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:for-each select="page:link[$current-page > number(@page)]">
            <li>
              <a href="{$page-link}({@page})">
                <xsl:value-of select="@page" />
              </a>
            </li>
          </xsl:for-each>

          <li>
            <span class="s02">
              <xsl:value-of select="$current-page" />
            </span>
          </li>

          <xsl:for-each select="page:link[number(@page) > $current-page]">
            <li>
              <a href="{$page-link}({@page})">
                <xsl:value-of select="@page" />
              </a>
            </li>
          </xsl:for-each>

          <xsl:choose>
            <xsl:when test="page:link[@type = 'next'][position() = 1]">
              <li>
                <a href="{$page-link}({page:link[@type = 'next'][position() = 1]/@page})">next &#8250;</a>
              </li>
              <li>
                <a href="{$page-link}({@total})">last &#8250;&#8250;</a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li>
                <span class="s01">next &#8250;</span>
              </li>
              <li>
                <span class="s01">last &#8250;&#8250;</span>
              </li>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template name="hits-head-link">
    <xsl:param name="show-article-link" select="true()" />

    <xsl:variable name="entity" select="substring-after(substring-after(substring-after(substring-after(id, '-'), '-'), '-'), '-')" />
    <xsl:variable name="path" select="escape-html-uri(replace(substring-before(id, concat('-', $entity)), '-', '/'))" />
    <xsl:variable name="id" select="id" />
    <xsl:variable name="issue" select="@position" />

    <xsl:for-each select="tei/bibl">
      <xsl:variable name="page" select="biblScope[@type = 'page-start']" />

      <h3>
        <xsl:choose>
          <xsl:when test="string(title[@type = 'short-title'])">
            <xsl:value-of select="title[@type = 'short-title']" />
          </xsl:when>
          <xsl:when test="string(title[@type = 'full-title'])">
            <xsl:value-of select="title[@type = 'full-title']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Untitled</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="$show-article-link = false()">
          <xsl:for-each select="../../data">
            <xsl:if test="images/image">
              <span>
                <xsl:text>Images </xsl:text>
                <dfn>
                  <xsl:text>(</xsl:text>
                  <xsl:value-of select="count(images/image)" />
                  <xsl:text>)</xsl:text>
                </dfn>
              </span>
            </xsl:if>
            <xsl:if test="institutions/institution">
              <span>
                <xsl:text>Institutions </xsl:text>
                <dfn>
                  <xsl:text>(</xsl:text>
                  <xsl:value-of select="count(institutions/institution)" />
                  <xsl:text>)</xsl:text>
                </dfn>
              </span>
            </xsl:if>
            <xsl:if test="names/name">
              <span>
                <xsl:text>Persons </xsl:text>
                <dfn>
                  <xsl:text>(</xsl:text>
                  <xsl:value-of select="count(names/name)" />
                  <xsl:text>)</xsl:text>
                </dfn>
              </span>
            </xsl:if>
            <xsl:if test="places/place">
              <span>
                <xsl:text>Places </xsl:text>
                <dfn>
                  <xsl:text>(</xsl:text>
                  <xsl:value-of select="count(places/place)" />
                  <xsl:text>)</xsl:text>
                </dfn>
              </span>
            </xsl:if>
            <xsl:if test="semtags/semtag">
              <span>
                <xsl:text>Subjects </xsl:text>
                <dfn>
                  <xsl:text>(</xsl:text>
                  <xsl:value-of select="count(semtags/semtag)" />
                  <xsl:text>)</xsl:text>
                </dfn>
              </span>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </h3>
      
      

      <ul class="s01">
        <li class="s01">
          <xsl:value-of select="title[@type = 'full-title']" />

          <xsl:if test="string(biblScope[@type = 'volume'])">
            <xsl:text> Vol. </xsl:text>
            <xsl:value-of select="biblScope[@type = 'volume']" />
          </xsl:if>
          <xsl:if test="string(biblScope[@type = 'issue-number'])">
            <xsl:text> No. </xsl:text>
            <xsl:value-of select="biblScope[@type = 'issue-number']" />
          </xsl:if>
          <xsl:if test="string($page)">
            <xsl:text> Page </xsl:text>
            <xsl:value-of select="$page" />
          </xsl:if>
        </li>
      </ul>
      <ul class="s01">
        <li class="s01">
          <xsl:if test="string(extent)">
            <xsl:value-of select="extent" />
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:if test="string(biblScope[@type = 'price'])">
            <xsl:text>Price </xsl:text>
            <xsl:value-of select="biblScope[@type = 'price']" />
            <xsl:text>.</xsl:text>
          </xsl:if>
        </li>
      </ul>

      <ul class="s01">
        <li class="s02">
          <xsl:text>View facsimile: </xsl:text>
          <a href="http://ncse-viewpoint.cch.kcl.ac.uk/Default.htm?href={$path}&amp;entityid={$entity}&amp;view=entity" target="_blank">
            <xsl:text>item</xsl:text>
          </a>
          <xsl:text> | </xsl:text>
          <a
            href="http://ncse-viewpoint.cch.kcl.ac.uk/?href={$path}&amp;page={biblScope[@type = 'page-internal']}&amp;view=document"
            target="_blank">
            <xsl:text>page</xsl:text>
          </a>
          <xsl:text> | </xsl:text>
          <a href="http://ncse-viewpoint.cch.kcl.ac.uk/?href={$path}&amp;page=1&amp;view=document" target="_blank">
            <xsl:text>issue</xsl:text>
          </a>
        </li>
        <xsl:if test="$show-article-link = true()">
          <li class="s02">
            <a href="view-issue({$issue})?format=full">
              <xsl:text>View extracted keywords</xsl:text>
            </a>
          </li>
        </xsl:if>
      </ul>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
<!-- If they want the headings after the title
  <xsl:for-each select="../../data">
  <xsl:choose>
  <xsl:when test="images/image">
  <span>
  <xsl:text>Images </xsl:text>
  <dfn>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="count(images/image)" />
  <xsl:text>)</xsl:text>
  </dfn>
  </span>
  </xsl:when>
  <xsl:otherwise>
  <span class="s01">
  <xsl:text>Images </xsl:text>
  <dfn>
  <xsl:text>(0)</xsl:text>
  </dfn>
  </span>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
  <xsl:when test="institutions/institution">
  <span>
  <xsl:text>Institutions </xsl:text>
  <dfn>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="count(institutions/institution)" />
  <xsl:text>)</xsl:text>
  </dfn>
  </span>
  </xsl:when>
  <xsl:otherwise>
  <span class="s01">
  <xsl:text>Institutions </xsl:text>
  <dfn>
  <xsl:text>(0)</xsl:text>
  </dfn>
  </span>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
  <xsl:when test="names/name">
  <span>
  <xsl:text>Persons </xsl:text>
  <dfn>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="count(names/name)" />
  <xsl:text>)</xsl:text>
  </dfn>
  </span>
  </xsl:when>
  <xsl:otherwise>
  <span class="s01">
  <xsl:text>Persons </xsl:text>
  <dfn>
  <xsl:text>(0)</xsl:text>
  </dfn>
  </span>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
  <xsl:when test="places/place">
  <span>
  <xsl:text>Places </xsl:text>
  <dfn>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="count(places/place)" />
  <xsl:text>)</xsl:text>
  </dfn>
  </span>
  </xsl:when>
  <xsl:otherwise>
  <span class="s01">
  <xsl:text>Places </xsl:text>
  <dfn>
  <xsl:text>(0)</xsl:text>
  </dfn>
  </span>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
  <xsl:when test="semtags/semtag">
  <span>
  <xsl:text>Subjects </xsl:text>
  <dfn>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="count(semtags/semtag)" />
  <xsl:text>)</xsl:text>
  </dfn>
  </span>
  </xsl:when>
  <xsl:otherwise>
  <span class="s01">
  <xsl:text>Images </xsl:text>
  <dfn>
  <xsl:text>(0)</xsl:text>
  </dfn>
  </span>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:for-each>
-->