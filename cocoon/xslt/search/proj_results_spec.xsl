<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:page="http://apache.org/cocoon/paginate/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="tpl-search-results">
    <div class="searchSummary">
      <div class="t01">
        <div class="s01">
          <!-- search parameters -->
          <dl>
            <dt>You searched for:</dt>
            <dd>
              <xsl:for-each select="//search-results/display-parameters/parameter">
                <xsl:variable name="par" select="." />

                <xsl:choose>
                  <xsl:when test="contains($par, '::')">
                    <xsl:value-of select="substring-after($par, '::')" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="." />
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="position() != last()">
                  <xsl:text>, </xsl:text>
                </xsl:if>
              </xsl:for-each>
            </dd>
            <dt>You sorted by:</dt>
            <dd>
              <xsl:variable name="sort" select="substring-after(//search-results/parameters/parameter[starts-with(., 'sortBy:')], 'sortBy:')" />

              <xsl:choose>
                <xsl:when test="$sort = 'by-date'">date</xsl:when>
                <xsl:when test="$sort = 'by-pub'">publication</xsl:when>
                <xsl:otherwise>relevance</xsl:otherwise>
              </xsl:choose>
            </dd>

            <xsl:if test="//search-results/search-clauses-parameters/parameter">
              <dt>You refined by:</dt>
              <xsl:for-each select="//search-results/search-clauses-parameters/parameter">
                <dd>
                  <a href="remove-search-clause?clause={position()}" title="Remove this filter">Remove</a>
                  <xsl:text> </xsl:text>

                  <xsl:variable name="par" select="." />

                  <xsl:choose>
                    <xsl:when test="contains($par, '::')">
                      <xsl:value-of select="substring-after($par, '::')" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="." />
                    </xsl:otherwise>
                  </xsl:choose>

                  <xsl:text> (chosen from: </xsl:text>

                  <!-- Floating results -->
                  <xsl:for-each select="//search-results/documents/document[current()/position()]/tei/bibl">
                    <xsl:value-of select="title[@type = 'full-title']" />
                    
                    <xsl:if test="string(biblScope[@type = 'volume'])">
                      <xsl:text> Vol. </xsl:text>
                      <xsl:value-of select="biblScope[@type = 'volume']" />
                    </xsl:if>
                    <xsl:if test="string(biblScope[@type = 'number'])">
                      <xsl:text> No. </xsl:text>
                      <xsl:value-of select="biblScope[@type = 'number']" />
                    </xsl:if>
                    <xsl:if test="string(biblScope[@type = 'page-start'])">
                      <xsl:text> Page </xsl:text>
                      <xsl:value-of select="biblScope[@type = 'page-start']" />
                    </xsl:if>
                  </xsl:for-each>
                  <xsl:text>)</xsl:text>
                </dd>
              </xsl:for-each>
            </xsl:if>
          </dl>
        </div>

        <!-- page navigation -->
        <div class="s02">
          <!-- util/result_tpl.xsl -->
          <xsl:call-template name="page-nav">
            <xsl:with-param name="page-sub" />
          </xsl:call-template>

          <ul class="s02">
            <li>
              <a href="refine-search.html" title="Alter search criteria">Modify search</a>
            </li>
            <li>
              <a href="search.html">New search</a>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <div class="resourceList">
      <div class="t02">
        <ul class="t01">
          <xsl:for-each select="//search-results/hits/hit">
            <xsl:variable name="pos" select="@position" />

            <li class="{if ($pos mod 2 = 0) then 'z02 s01' else 'z01 s01'}">
              <dfn>
                <xsl:value-of select="$pos" />
              </dfn>
              <!-- util/result_tpl -->
              <xsl:call-template name="hits-head-link">
                <xsl:with-param name="show-article-link" select="false()" />
              </xsl:call-template>

              <ul class="s02">
                <xsl:if test="data/semtags/semtag">
                  <li>
                    <dl>
                      <dt>
                        <xsl:text>Subjects </xsl:text>
                        <dfn>
                          <xsl:text>(</xsl:text>
                          <xsl:value-of select="count(data/semtags/semtag)" />
                          <xsl:text>)</xsl:text>
                        </dfn>
                      </dt>
                      <xsl:for-each-group group-by="@key" select="data/semtags/semtag">
                        <xsl:sort select="lower-case(.)" />

                        <dd>
                          <a
                            href="add-search-clause?field=semtag-key&amp;value={encode-for-uri(@key)}&amp;display={lower-case(.)}&amp;pos={$pos}"
                            title="Refine results by adding this term to the search query">
                            <xsl:value-of select="lower-case(.)" />
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="@count" />
                            <xsl:text>)</xsl:text>
                          </a>
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
                <xsl:if test="data/names/name">
                  <li>
                    <dl>
                      <dt>
                        <xsl:text>Persons </xsl:text>
                        <dfn>
                          <xsl:text>(</xsl:text>
                          <xsl:value-of select="count(data/names/name)" />
                          <xsl:text>)</xsl:text>
                        </dfn>
                      </dt>
                      <xsl:for-each-group group-by="@key" select="data/names/name">
                        <dd>
                          <a href="add-search-clause?field=name&amp;value={encode-for-uri(@key)}&amp;display={@key}&amp;pos={$pos}"
                            title="Refine results by adding this term to the search query">
                            <xsl:value-of select="@key" />
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="@count" />
                            <xsl:text>)</xsl:text>
                          </a>
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
                <xsl:if test="data/institutions/institution">
                  <li>
                    <dl>
                      <dt>
                        <xsl:text>Institutions </xsl:text>
                        <dfn>
                          <xsl:text>(</xsl:text>
                          <xsl:value-of select="count(data/institutions/institution)" />
                          <xsl:text>)</xsl:text>
                        </dfn>
                      </dt>
                      <xsl:for-each-group group-by="@key" select="data/institutions/institution">
                        <dd>
                          <a href="add-search-clause?field=institution&amp;value={encode-for-uri(@key)}&amp;display={@key}&amp;pos={$pos}"
                            title="Refine results by adding this term to the search query">
                            <xsl:value-of select="@key" />
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="@count" />
                            <xsl:text>)</xsl:text>
                          </a>
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
                <xsl:if test="data/places/place">
                  <li>
                    <dl>
                      <dt>
                        <xsl:text>Places </xsl:text>
                        <dfn>
                          <xsl:text>(</xsl:text>
                          <xsl:value-of select="count(data/places/place)" />
                          <xsl:text>)</xsl:text>
                        </dfn>
                      </dt>
                      <xsl:for-each-group group-by="@key" select="data/places/place">
                        <dd>
                          <a href="add-search-clause?field=place&amp;value={encode-for-uri(@key)}&amp;display={@key}&amp;pos={$pos}"
                            title="Refine results by adding this term to the search query">
                            <xsl:value-of select="@key" />
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="@count" />
                            <xsl:text>)</xsl:text>
                          </a>
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
                <xsl:if test="data/images/image">
                  <li>
                    <dl>
                      <dt>
                        <xsl:text>Images </xsl:text>
                        <dfn>
                          <xsl:text>(</xsl:text>
                          <xsl:value-of select="count(data/images/image)" />
                          <xsl:text>)</xsl:text>
                        </dfn>
                      </dt>
                      <xsl:for-each-group group-by="@key" select="data/images/image">
                        <xsl:sort select="lower-case(.)" />

                        <dd>
                          <a href="add-search-clause?field=image-key&amp;value={encode-for-uri(@key)}&amp;display={@key}&amp;pos={$pos}"
                            title="Refine results by adding this term to the search query">
                            <xsl:value-of select="lower-case(.)" />
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="@count" />
                            <xsl:text>)</xsl:text>
                          </a>
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
              </ul>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="tpl-view-issue">
    <div class="searchSummary">
      <div class="t01">
        <div class="rNav">

          <!-- issue navigation -->
          <div class="s02">
            <xsl:variable name="page-link" select="'view-issue'" />

            <xsl:variable name="entity"
              select="substring-after(substring-after(substring-after(substring-after(//search-results/hits/hit/id, '-'), '-'), '-'), '-')" />
            <xsl:variable name="path"
              select="escape-html-uri(replace(substring-before(//search-results/hits/hit/id, concat('-', $entity)), '-', '/'))" />

            <ul class="s01">
              <xsl:for-each select="//page:page">
                <xsl:variable name="current-page" select="@current" />
                <li>
                  <xsl:choose>
                    <xsl:when test="page:link[@type = 'prev'][position() = last()]">
                      <a href="{$page-link}({page:link[@type = 'prev'][position() = last()]/@page})?format=full">&#8249;&#8249; prev
                      article</a>
                    </xsl:when>
                    <xsl:otherwise>
                      <span class="s01">&#8249;&#8249; prev article</span>
                    </xsl:otherwise>
                  </xsl:choose>
                </li>

                <li>
                  <a href="http://137.73.123.44/KingsCollege/Default.htm?href={$path}&amp;entityid={$entity}&amp;view=entity" target="_blank">
                    <xsl:text>view article full text</xsl:text>
                  </a>
                </li>

                <li>
                  <xsl:choose>
                    <xsl:when test="page:link[@type = 'next'][position() = 1]">
                      <a href="{$page-link}({page:link[@type = 'next'][position() = 1]/@page})?format=full">next article &#8250;&#8250;</a>
                    </xsl:when>
                    <xsl:otherwise>
                      <span class="s01">next article &#8250;&#8250;</span>
                    </xsl:otherwise>
                  </xsl:choose>
                </li>
              </xsl:for-each>
            </ul>
            <ul class="s02">
              <li>
                <a href="page(1)">Back to results</a>
              </li>
            </ul>
          </div>
        </div>

        <div class="resourceItem">
          <div class="t01">
            <ul>
              <xsl:for-each select="//search-results/hits/hit">
                <xsl:if test="data/semtags/semtag">
                  <li>
                    <dl>
                      <dt>Subjects</dt>
                      <xsl:for-each-group group-by="@key" select="data/semtags/semtag">
                        <xsl:sort select="lower-case(.)" />

                        <dd>
                          <xsl:value-of select="." />
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
                <xsl:if test="data/names/name">
                  <li>
                    <dl>
                      <dt>Persons</dt>
                      <xsl:for-each-group group-by="@key" select="data/names/name">
                        <dd>
                          <xsl:value-of select="." />
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
                <xsl:if test="data/institutions/institution">
                  <li>
                    <dl>
                      <dt>Institutions</dt>
                      <xsl:for-each-group group-by="@key" select="data/institutions/institution">
                        <dd>
                          <xsl:value-of select="." />
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
                <xsl:if test="data/places/place">
                  <li>
                    <dl>
                      <dt>Places</dt>
                      <xsl:for-each-group group-by="@key" select="data/places/place">
                        <dd>
                          <xsl:value-of select="." />
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
                <xsl:if test="data/images/image">
                  <li>
                    <dl>
                      <dt>Images</dt>
                      <xsl:for-each-group group-by="@key" select="data/images/image">
                        <xsl:sort select="lower-case(.)" />

                        <dd>
                          <xsl:value-of select="." />
                        </dd>
                      </xsl:for-each-group>
                    </dl>
                  </li>
                </xsl:if>
              </xsl:for-each>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
