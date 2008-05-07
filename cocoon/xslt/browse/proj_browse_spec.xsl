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
          <a href="subject/{encode-for-uri(@r:about)}-{encode-for-uri(@r:label)}">
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
          <a href="image/{encode-for-uri(@r:about)}-{encode-for-uri(@r:label)}">
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
        <div class="s01">
          <dl>
            <dt>Filtering by:</dt>
            <xsl:for-each select="//search-results/display-parameters/parameter">
              <xsl:variable name="key" select="translate(substring-before(., '::'), '*', '')" />
              <dd>
                <xsl:for-each select="//projAL//s:Concept[descendant-or-self::node()[@r:about = $key]]">
                  <xsl:value-of select="@r:label" />
                </xsl:for-each>
              </dd>
            </xsl:for-each>
            <xsl:for-each select="//search-results/search-clauses-parameters/parameter">
              <xsl:variable name="key" select="substring-before(., '::')" />
              <dd>
                <a href="remove?clause={position()}" title="Remove this category from the filter">Remove</a>
                <xsl:for-each select="//projAL//s:Concept[descendant-or-self::node()[@r:about = $key]]">
                  <xsl:value-of select="@r:label" />
                  <xsl:if test="not(self::node()[@r:about = $key])">
                    <xsl:text> > </xsl:text>
                  </xsl:if>
                </xsl:for-each>
              </dd>
            </xsl:for-each>
            <dt>Sorted by: </dt>
            <dd>Relevance</dd>
          </dl>
        </div>
        <!-- page navigation -->
        <!-- util/result_tpl.xsl -->
        <div class="s02">
          <xsl:call-template name="page-nav" />
            <!--<xsl:with-param name="page-sub">
              <xsl:value-of select="$collection" />
              <xsl:text>-</xsl:text>
            </xsl:with-param>
          </xsl:call-template>-->
        </div>
      </div>
    </div>

    <div class="resourceList">
      <div class="t02">
        <ul class="t01">
          <xsl:for-each select="//search-results/hits/hit">
            <xsl:variable name="pos" select="@position" />

            <li class="{if ($pos mod 2 = 0) then 'z02' else 'z01'}">
              <!-- util/result_tpl -->
              <xsl:call-template name="hits-head-link" />
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
