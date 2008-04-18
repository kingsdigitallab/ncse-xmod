<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:page="http://apache.org/cocoon/paginate/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="tpl-search-results">
    <div class="searchResults">
      <div class="t02">
        <div class="rNav">
          <xsl:variable name="rpp" select="number(20)" />
          <xsl:variable name="page" select="//search-results/page:page/@current" />
          <xsl:variable name="total" select="//search-results/total" />

          <div class="s01">
            <xsl:text>Results </xsl:text>
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
          </div>

          <xsl:if test="$total > $rpp">
            <!-- page navigation -->
            <div class="s02">
              <xsl:variable name="page-link" select="'page'" />
              
              <xsl:for-each select="//page:page">
                <xsl:variable name="current-page" select="@current" />
                <xsl:choose>
                  <xsl:when test="page:link[@type = 'prev'][position() = last()]">
                    <a href="{$page-link}({page:link[@type = 'prev'][position() = last()]/@page})">&#8249;&#8249; prev</a>
                  </xsl:when>
                  <xsl:otherwise>
                    <span class="s02">&#8249;&#8249; prev</span>
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:for-each select="page:link[@page &lt; $current-page]">
                  <a href="{$page-link}({@page})">
                    <xsl:value-of select="@page" />
                  </a>
                </xsl:for-each>

                <span class="s02">
                  <xsl:value-of select="$current-page" />
                </span>

                <xsl:for-each select="page:link[@page > $current-page]">
                  <a href="{$page-link}({@page})">
                    <xsl:value-of select="@page" />
                  </a>
                </xsl:for-each>

                <xsl:choose>
                  <xsl:when test="page:link[@type = 'next'][position() = 1]">
                    <a href="{$page-link}({page:link[@type = 'next'][position() = 1]/@page})">next &#8250;&#8250;</a>
                  </xsl:when>
                  <xsl:otherwise>
                    <span class="s02">next &#8250;&#8250;</span>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </div>
          </xsl:if>
        </div>
        
        <!-- search parameters -->
        <div class="s01">
          <xsl:text>You searched for:</xsl:text>
          <div class="s02">
            <xsl:for-each select="//search-results/display-parameters/parameter">
              <xsl:value-of select="." />
              
              <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </div>
        </div>

        <dl>
          <xsl:for-each select="//search-results/hits/hit">
            <dt>
              <strong>
                  <xsl:value-of select="id" />
              </strong>
            </dt>
            <dd>
              <xsl:apply-templates select="tei/bibl" />
            </dd>
          </xsl:for-each>
        </dl>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
