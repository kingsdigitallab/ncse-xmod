<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:page="http://apache.org/cocoon/paginate/1.0"
  xmlns:r="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:s="http://www.w3.org/2004/02/skos/core#"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="tpl-browse-subject-start">
    <ul>
      <xsl:for-each select="//r:RDF/s:Concept">
        <li>
          <a href="subject-{encode-for-uri(@r:about)}-{encode-for-uri(@r:label)}">
            <xsl:value-of select="@r:about" />
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@r:label" />
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="tpl-browse-image-start">
    <ul>
      <xsl:for-each select="//r:RDF/s:Concept">
        <li>
          <a href="image-{encode-for-uri(@r:about)}-{encode-for-uri(@r:label)}">
            <xsl:value-of select="@r:label" />
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="tpl-browse-results">
    <xsl:variable name="rpp" select="number(20)" />
    <xsl:variable name="page" select="//search-results/page:page/@current" />
    <xsl:variable name="total" select="//search-results/total" />

    <div class="searchSummary">
      <div class="t01">
        <div class="facetBrowseSummary">
          <h3>Filtering by:</h3>
          <dl>
            <xsl:for-each select="//search-results/display-parameters/parameter">
              <xsl:variable name="key" select="translate(substring-before(., '::'), '*', '')" />
              <dt>
                <xsl:for-each select="//projAL//s:Concept[descendant-or-self::node()[@r:about = $key]]">
                  <xsl:value-of select="@r:label" />
                </xsl:for-each>
              </dt>
            </xsl:for-each>
            <xsl:for-each select="//search-results/search-clauses-parameters/parameter">
              <xsl:variable name="key" select="substring-before(., '::')" />
              <dt>
                <xsl:text>[</xsl:text>
                <a href="remove-browse-{$collection}?clause={position()}" title="Remove this category from the filter">Remove</a>
                <xsl:text>] </xsl:text>
                <xsl:for-each select="//projAL//s:Concept[descendant-or-self::node()[@r:about = $key]]">
                  <xsl:value-of select="@r:label" />
                  <xsl:if test="not(self::node()[@r:about = $key])">
                    <xsl:text> > </xsl:text>
                  </xsl:if>
                </xsl:for-each>
              </dt>
            </xsl:for-each>
          </dl>
        </div>
        <!-- page navigation -->
        <div class="s02">
          <xsl:variable name="page-link">
            <xsl:value-of select="$collection" />
            <xsl:text>-page</xsl:text>
          </xsl:variable>
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
        </div>
      </div>
    </div>

    <div class="resourceList">
      <div class="t02">
        <ul>
          <xsl:for-each select="//search-results/hits/hit">
            <xsl:variable name="pos" select="@position" />

            <li class="{if ($pos mod 2 = 0) then 'z02 s01' else 'z01 s01'}">
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
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
