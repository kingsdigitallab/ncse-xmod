<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="tpl-search-form">
    <div class="form">
      <div class="t02">
        <form action="do-search" id="frmSearch" method="POST" name="frmSearch">
          <fieldset class="s01">
            <legend>Type in Text</legend>
            <ol>
              <li class="clfx-b">
                <fieldset class="f05 n01">
                  <legend>Keywords</legend>
                  <label for="field1Sel">Search in:</label>
                  <select id="field1Sel" name="field1Sel">
                    <xsl:call-template name="tpl-entity-select">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'field1Sel:')], ':')" />
                    </xsl:call-template>
                  </select>
                  <input class="f01 s01" id="field1Txt" name="field1Txt" type="text"
                    value="{substring-after(//refine/parameters/parameter[starts-with(.,
                    'field1Txt:')], ':')}" />
                  <select id="similarity1Sel" name="similarity1Sel">
                    <xsl:call-template name="tpl-similarity-select">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'similarity1Sel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f05 n02">
                  <legend>Secondary Search Criteria</legend>
                  <select id="booleanOp2Sel" name="booleanOp2Sel">
                    <xsl:call-template name="tpl-search-mode">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'booleanOp2Sel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                  <select id="field2Sel" name="field2Sel">
                    <xsl:call-template name="tpl-entity-select">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'field2Sel:')], ':')" />
                    </xsl:call-template>
                  </select>
                  <input class="f01 s01" id="field2Txt" name="field2Txt" type="text"
                    value="{substring-after(//refine/parameters/parameter[starts-with(., 'field2Txt:')], ':')}" />
                  <select id="similarity2Sel" name="similarity2Sel">
                    <xsl:call-template name="tpl-similarity-select">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'similarity2Sel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f05 n02">
                  <legend>Secondary Search Criteria</legend>
                  <select id="booleanOp3Sel" name="booleanOp3Sel">
                    <xsl:call-template name="tpl-search-mode">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'booleanOp3Sel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                  <select id="field3Sel" name="field3Sel">
                    <xsl:call-template name="tpl-entity-select">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'field3Sel:')], ':')" />
                    </xsl:call-template>
                  </select>
                  <input class="f01 s01" id="field3Txt" name="field3Txt" type="text"
                    value="{substring-after(//refine/parameters/parameter[starts-with(., 'field3Txt:')], ':')}" />
                  <select id="similarity3Sel" name="similarity3Sel">
                    <xsl:call-template name="tpl-similarity-select">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'similarity3Sel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f05 n03">
                  <legend>Tertiary Search Criteria</legend>
                  <select id="booleanOp4Sel" name="booleanOp4Sel">
                    <xsl:call-template name="tpl-search-mode">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'booleanOp4Sel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                  <select id="field4Sel" name="field4Sel">
                    <xsl:call-template name="tpl-thesaurus-select">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'field4Sel:')], ':')" />
                    </xsl:call-template>
                  </select>

                  <input name="field4Key" type="hidden" value="{substring-after(//refine/parameters/parameter[starts-with(., 'field4Key:')], ':')}" />

                  <xsl:variable name="text" select="substring-after(//refine/parameters/parameter[starts-with(., 'field4Txt:')], ':')" />

                  <input class="f01 s01" id="field4Txt" name="field4Txt" readonly="readonly" type="text"
                    value="{if (string($text)) then $text else 'Filled from Thesaurus'}" />
                  <a class="s01" href="#" title="Look up a search term in the thesaurus">
                    <span>Thesaurus...</span>
                  </a>
                </fieldset>
              </li>
              <!-- Thesaurus -->
              <li class="s02">
                <xsl:call-template name="tpl-thesaurus-subject">
                  <xsl:with-param name="source">subject1Chk</xsl:with-param>
                  <xsl:with-param name="key">document.frmSearch.field4Key</xsl:with-param>
                  <xsl:with-param name="text">document.frmSearch.field4Txt</xsl:with-param>
                </xsl:call-template>
              </li>
              <li class="s02">
                <xsl:call-template name="tpl-thesaurus-image">
                  <xsl:with-param name="source">image1Chk</xsl:with-param>
                  <xsl:with-param name="key">document.frmSearch.field4Key</xsl:with-param>
                  <xsl:with-param name="text">document.frmSearch.field4Txt</xsl:with-param>
                </xsl:call-template>
              </li>
              <li class="clfx-b">
                <fieldset class="f05 n03">
                  <legend>Forth Search Criteria</legend>
                  <select id="booleanOp5Sel" name="booleanOp5Sel">
                    <xsl:call-template name="tpl-search-mode">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'booleanOp5Sel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                  <select id="field5Sel" name="field5Sel">
                    <xsl:call-template name="tpl-thesaurus-select">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'field5Sel:')], ':')" />
                    </xsl:call-template>
                  </select>
                  <input name="field5Key" type="hidden" value="{substring-after(//refine/parameters/parameter[starts-with(., 'field5Key:')], ':')}" />

                  <xsl:variable name="text" select="substring-after(//refine/parameters/parameter[starts-with(., 'field5Txt:')], ':')" />
                  
                  <input class="f01 s01" id="field5Txt" name="field5Txt" readonly="readonly" type="text"
                    value="{if (string($text)) then $text else 'Filled from Thesaurus'}" />
                  <a class="s01" href="#" title="Look up a search term in the thesaurus">
                    <span>Thesaurus...</span>
                  </a>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f06 n04">
                  <legend>Date Range</legend>
                  <ol>
                    <li>
                      <select id="booleanOpDateSel" name="booleanOpDateSel">
                        <xsl:call-template name="tpl-search-mode">
                          <xsl:with-param name="selected"
                            select="substring-after(//refine/parameters/parameter[starts-with(., 'booleanOpDateSel:')], ':')" />
                        </xsl:call-template>
                      </select>
                    </li>
                    <li>
                      <label class="s01" for="lowerDateSel">From</label>
                      <select id="lowerDateSel" name="lowerDateSel">
                        <xsl:call-template name="tpl-year">
                          <xsl:with-param name="selected"
                            select="substring-after(//refine/parameters/parameter[starts-with(., 'lowerDateSel:')], ':')" />
                        </xsl:call-template>
                      </select>
                    </li>
                    <li>
                      <label class="s01" for="higherDateSel">To</label>
                      <select id="higherDateSel" name="higherDateSel">
                        <xsl:call-template name="tpl-year">
                          <xsl:with-param name="selected"
                            select="substring-after(//refine/parameters/parameter[starts-with(., 'higherDateSel:')], ':')" />
                        </xsl:call-template>
                      </select>
                    </li>
                  </ol>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f06 n05">
                  <legend>Publication</legend>
                  <ol>
                    <li>
                      <select id="booleanOpPublicationSel" name="booleanOpPublicationSel">
                        <xsl:call-template name="tpl-search-mode">
                          <xsl:with-param name="selected" select="'0'" />
                        </xsl:call-template>
                      </select>
                    </li>
                    <li>
                      <label class="s01" for="publicationSel">Publication</label>
                      <select id="publicationSel" multiple="multiple" name="publicationSel" onchange="updatePublication();" size="7">
                        <xsl:call-template name="tpl-publications" />
                      </select>
                      <xsl:variable name="publication" select="substring-after(//refine/parameters/parameter[starts-with(., 'publicationTxt:')], ':')" />
                      <input id="publicationTxt" name="publicationTxt" type="hidden"
                        value="{if (string($publication)) then $publication else 'All Publications'}" />
                    </li>
                  </ol>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f10 n06">
                  <legend>Results Sorting</legend>
                  <label class="s01" for="sortByRelevance">Sort results by</label>
                  <ol>
                    <xsl:variable name="sort-by" select="substring-after(//refine/parameters/parameter[starts-with(., 'sortBy:')], ':')" />
                    <li class="clfx-b">
                      <label for="sortByRelevance">by relevance</label>
                      <input class="f02" id="sortByRelevance" name="sortBy" type="radio" value="">
                        <xsl:choose>
                          <xsl:when test="not(string($sort-by))">
                            <xsl:attribute name="checked">checked</xsl:attribute>
                          </xsl:when>
                          <xsl:when test="$sort-by = ''">
                            <xsl:attribute name="checked">checked</xsl:attribute>
                          </xsl:when>
                        </xsl:choose>
                      </input>
                    </li>
                    <li class="clfx-b">
                      <label for="sortByDate">by date</label>
                      <input class="f02" id="sortByDate" name="sortBy" type="radio" value="by-date">
                        <xsl:if test="$sort-by = 'by-date'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </input>
                    </li>
                    <li class="clfx-b">
                      <label for="any">by publication</label>
                      <input class="f02" id="sortByPub" name="sortBy" type="radio" value="by-pub">
                        <xsl:if test="$sort-by = 'by-pub'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </input>
                    </li>
                  </ol>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f06 n07">
                  <legend>Submit Search</legend>
                  <div>
                    <button type="submit">Search</button>
                    <button onclick="location.href='entity-search.html';" type="reset">Reset Form</button>
                  </div>
                </fieldset>
              </li>
            </ol>
          </fieldset>
        </form>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="tpl-entity-select">
    <xsl:param name="selected" required="yes" />

    <option value="name">
      <xsl:if test="$selected = 'name'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Persons</xsl:text>
    </option>
    <option value="institution">
      <xsl:if test="$selected = 'institution'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Institutions</xsl:text>
    </option>
    <option value="place">
      <xsl:if test="$selected = 'place'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Places</xsl:text>
    </option>
  </xsl:template>

  <xsl:template name="tpl-similarity-select">
    <xsl:param name="selected" required="yes" />

    <xsl:variable name="current">
      <xsl:choose>
        <xsl:when test="string($selected)">
          <xsl:value-of select="$selected" />
        </xsl:when>
        <xsl:otherwise>1.0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <option value="1.0">
      <xsl:if test="$current = '1.0'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Exact</xsl:text>
    </option>
    <option value="0.9">
      <xsl:if test="$current = '0.9'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>90%</xsl:text>
    </option>
    <option value="0.8">
      <xsl:if test="$current = '0.8'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>80%</xsl:text>
    </option>
    <option value="0.7">
      <xsl:if test="$current = '0.7'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>70%</xsl:text>
    </option>
    <option value="0.6">
      <xsl:if test="$current = '0.6'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>60%</xsl:text>
    </option>
    <option value="0.5">
      <xsl:if test="$current = '0.5'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>50%</xsl:text>
    </option>
  </xsl:template>

  <xsl:template name="tpl-search-mode">
    <xsl:param name="selected" required="yes" />

    <option value="and">
      <xsl:if test="$selected = 'and'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>and</xsl:text>
    </option>
    <option value="or">
      <xsl:if test="$selected = 'or'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>or</xsl:text>
    </option>
    <option value="not">
      <xsl:if test="$selected = 'not'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>not</xsl:text>
    </option>
  </xsl:template>

  <xsl:template name="tpl-year">
    <xsl:param name="selected" required="yes" />

    <option value="">Year...</option>
    <xsl:for-each select="1806 to 1890">
      <option value="{.}">
        <xsl:if test="number($selected) = .">
          <xsl:attribute name="selected">selected</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="." />
      </option>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="tpl-publications">
    <xsl:variable name="selected">
      <xsl:for-each select="//refine/parameters/parameter[starts-with(., 'publicationSel:')]">
        <xsl:value-of select="substring-after(., ':')" />
      </xsl:for-each>

      <xsl:if test="position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:variable>

    <option value="">
      <xsl:if test="not(string($selected))">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>All Publications</xsl:text>
    </option>
    <option value="mrp">
      <xsl:if test="contains($selected, 'mrp')">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Monthly Repository (1806 - 1838)</xsl:text>
    </option>
    <option value="nss">
      <xsl:if test="contains($selected, 'nss')">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Northern Star (1837 - 1852)</xsl:text>
    </option>
    <option value="ldr">
      <xsl:if test="contains($selected, 'ldr')">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Leader (1850 - 1860)</xsl:text>
    </option>
    <option value="ewj">
      <xsl:if test="contains($selected, 'ewj')">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>English Woman's Journal (1858 - 1864)</xsl:text>
    </option>
    <option value="ttw">
      <xsl:if test="contains($selected, 'ttw')">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Tomahawk (1867 - 1870)</xsl:text>
    </option>
    <option value="tec">
      <xsl:if test="contains($selected, 'tec')">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Publishers' Circular (1880 - 1890)</xsl:text>
    </option>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-select">
    <xsl:param name="selected" required="yes" />

    <option value="semtag-key">
      <xsl:if test="$selected = 'semtag-key'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Subjects</xsl:text>
    </option>
    <option value="$selected = 'image-key'">
      <xsl:if test="$selected = 'image-key'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Images</xsl:text>
    </option>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-subject">
    <xsl:param name="source" required="yes" />
    <xsl:param name="key" required="yes" />
    <xsl:param name="text" required="yes" />

    <div class="form">
      <div class="t04">
        <div class="unorderedList">
          <div class="t05">
            <ul>
              <xsl:for-each select="//subjectsAL/rdf:RDF/skos:Concept">
                <li class="s01">
                  <a class="s01" href="#">
                    <span>Expand</span>
                  </a>
                  <strong>
                    <xsl:value-of select="@rdf:label" />
                  </strong>
                  <xsl:if test="skos:narrower">
                    <xsl:call-template name="tpl-thesaurus-narrower">
                      <xsl:with-param name="name" select="$source" />
                    </xsl:call-template>
                  </xsl:if>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </div>
        <fieldset class="f06 n04">
          <div>
            <button onclick="javascript:addTerms(document.frmSearch.{$source}, {$key}, {$text}); return false;">Insert</button>
          </div>
        </fieldset>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-narrower">
    <xsl:param name="name" required="yes" />

    <ul>
      <xsl:for-each select="skos:narrower/skos:orderedCollection/skos:memberList/skos:Concept">
        <xsl:choose>
          <xsl:when test="skos:narrower/skos:orderedCollection/skos:memberList/skos:Concept">
            <li class="s01">
              <a class="s01" href="#">
                <span>Expand</span>
              </a>
              <!--<input class="f02" id="{@rdf:about}" name="{$name}" title="{@rdf:label}" type="checkbox" value="{@rdf:about}" />-->
              <strong>
                <xsl:value-of select="@rdf:label" />
              </strong>
              <xsl:call-template name="tpl-thesaurus-narrower">
                <xsl:with-param name="name" select="$name" />
              </xsl:call-template>
            </li>
          </xsl:when>
          <xsl:otherwise>
            <li>
              <input class="f02" id="{@rdf:about}" name="{$name}" title="{@rdf:label}" type="checkbox" value="{@rdf:about}" />
              <label for="{@rdf:about}">
                <xsl:value-of select="@rdf:label" />
              </label>
            </li>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-image">
    <xsl:param name="source" required="yes" />
    <xsl:param name="key" required="yes" />
    <xsl:param name="text" required="yes" />

    <div class="form">
      <div class="t04">
        <div class="unorderedList">
          <div class="t05">
            <ul>
              <xsl:for-each select="//imagesAL/rdf:RDF/skos:Concept">
                <li class="s01">
                  <a class="s01" href="#">
                    <span>Expand</span>
                  </a>
                  <strong>
                    <xsl:value-of select="@rdf:label" />
                  </strong>
                  <xsl:if test="skos:narrower">
                    <xsl:call-template name="tpl-thesaurus-narrower">
                      <xsl:with-param name="name" select="$source" />
                    </xsl:call-template>
                  </xsl:if>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </div>
        <fieldset class="f06 n04">
          <div>
            <button type="submit">Insert</button>
          </div>
        </fieldset>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
