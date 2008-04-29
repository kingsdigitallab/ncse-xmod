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

            <xsl:if test="//search-results/search-clauses-parameters/parameter">
              <dt>You refined by:</dt>
              <xsl:for-each select="//search-results/search-clauses-parameters/parameter">
                <dd>
                  <a href="remove-search-clause?clause={position()}">Remove</a>
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
                  <xsl:for-each select="//search-results/documents/document[current()/position()]">
                    <xsl:value-of select="tei/bibl/title[@type = 'full-title']" />
                  </xsl:for-each>
                  <xsl:text>)</xsl:text>
                </dd>
              </xsl:for-each>
            </xsl:if>
          </dl>
        </div>

        <xsl:variable name="rpp" select="number(20)" />
        <xsl:variable name="page" select="//search-results/page:page/@current" />
        <xsl:variable name="total" select="//search-results/total" />

        <!-- page navigation -->
        <div class="s02">
          <xsl:variable name="page-link" select="'page'" />
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
          
          <ul class="s02">
            <li>
              <a href="refine-{//search-results/search-link}.html">Modify search</a>
            </li>
            <li>
              <a href="{//search-results/search-link}.html">New search</a>
            </li>
          </ul>
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
                        <dd>
                          <a
                            href="add-search-clause?field=semtag-key&amp;value={encode-for-uri(@key)}&amp;display={lower-case(.)}&amp;pos={$pos}">
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
                        <xsl:text>Names </xsl:text>
                        <dfn>
                          <xsl:text>(</xsl:text>
                          <xsl:value-of select="count(data/names/name)" />
                          <xsl:text>)</xsl:text>
                        </dfn>
                      </dt>
                      <xsl:for-each-group group-by="@key" select="data/names/name">
                        <dd>
                          <a href="add-search-clause?field=name&amp;value={encode-for-uri(@key)}&amp;display={@key}&amp;pos={$pos}">
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
                          <a href="add-search-clause?field=institution&amp;value={encode-for-uri(@key)}&amp;display={@key}&amp;pos={$pos}">
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
                          <a href="add-search-clause?field=place&amp;value={encode-for-uri(@key)}&amp;display={@key}&amp;pos={$pos}">
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
              </ul>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="tpl-view-issue">
    <div class="searchResults">
      <div class="t02">
        <div class="rNav">

          <div class="s01">
            <xsl:value-of select="//search-results/hits/hit/tei/bibl/title[@type = 'full-title']" />
          </div>

          <!-- issue navigation -->
          <div class="s02">
            <xsl:variable name="page-link" select="'view-issue'" />

            <xsl:variable name="entity"
              select="substring-after(substring-after(substring-after(substring-after(//search-results/hits/hit/id, '-'), '-'), '-'), '-')" />
            <xsl:variable name="path"
              select="escape-html-uri(replace(substring-before(//search-results/hits/hit/id, concat('-', $entity)), '-', '/'))" />

            <xsl:for-each select="//page:page">
              <xsl:variable name="current-page" select="@current" />
              <xsl:choose>
                <xsl:when test="page:link[@type = 'prev'][position() = last()]">
                  <a href="{$page-link}({page:link[@type = 'prev'][position() = last()]/@page})">&#8249;&#8249; prev article</a>
                </xsl:when>
                <xsl:otherwise>
                  <span class="s02">&#8249;&#8249; prev article</span>
                </xsl:otherwise>
              </xsl:choose>

              <a href="http://137.73.123.44/KingsCollege/Default.htm?href={$path}&amp;entityid={$entity}&amp;view=entity" target="_blank">
                <xsl:text>view article</xsl:text>
              </a>

              <xsl:choose>
                <xsl:when test="page:link[@type = 'next'][position() = 1]">
                  <a href="{$page-link}({page:link[@type = 'next'][position() = 1]/@page})">next article &#8250;&#8250;</a>
                </xsl:when>
                <xsl:otherwise>
                  <span class="s02">next article &#8250;&#8250;</span>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </div>
        </div>

        <div>
          <xsl:for-each select="//search-results/hits/hit">
            <xsl:if test="data/semtags/semtag">
              <ul>
                <span>Subjects</span>
                <xsl:for-each-group group-by="@key" select="data/semtags/semtag">
                  <li>
                    <xsl:value-of select="." />
                  </li>
                </xsl:for-each-group>
              </ul>
            </xsl:if>
            <xsl:if test="data/names/name">
              <ul>
                <span>People</span>
                <xsl:for-each-group group-by="@key" select="data/names/name">
                  <li>
                    <xsl:value-of select="." />
                  </li>
                </xsl:for-each-group>
              </ul>
            </xsl:if>
            <xsl:if test="data/institutions/institution">
              <ul>
                <span>Institutions</span>
                <xsl:for-each-group group-by="@key" select="data/institutions/institution">
                  <li>
                    <xsl:value-of select="." />
                  </li>
                </xsl:for-each-group>
              </ul>
            </xsl:if>
            <xsl:if test="data/places/place">
              <ul>
                <span>Places</span>
                <xsl:for-each-group group-by="@key" select="data/places/place">
                  <li>
                    <xsl:value-of select="." />
                  </li>
                </xsl:for-each-group>
              </ul>
            </xsl:if>
          </xsl:for-each>
        </div>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
