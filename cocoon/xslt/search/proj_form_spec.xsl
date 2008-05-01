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
                  <legend>Primary Search Criteria</legend>
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
                  <label class="s02" for="field2Txt">(optional)</label>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f05 n03">
                  <legend>Tertiary Search Criteria</legend>
                  <select id="booleanOp3Sel" name="booleanOp3Sel">
                    <xsl:call-template name="tpl-search-mode">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'booleanOp3Sel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                  <select id="field3Sel" name="field3Sel">
                    <xsl:call-template name="tpl-thesaurus-select">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'field3Sel:')], ':')" />
                    </xsl:call-template>
                  </select>

                  <input name="field3Key" type="hidden" value="{substring-after(//refine/parameters/parameter[starts-with(., 'field3Key:')], ':')}" />

                  <input class="f01 s01" id="field3Txt" name="field3Txt" onchange="document.forms.frmSearch.field3Key.value = '';" readonly="readonly"
                    type="text" value="Filled from Thesaurus" />
                  <a class="s01"
                    href="javascript:openThesaurus(document.forms.frmSearch.field3Sel.options[document.forms.frmSearch.field3Sel.selectedIndex].value);"
                    title="Look up a search term in the thesaurus">
                    <span>Thesaurus...</span>
                  </a>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f05 n03">
                  <legend>Tertiary + 1 Search Criteria</legend>
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

                  <input class="f01 s01" id="field4Txt" name="field4Txt" onchange="document.forms.searchForm.field4Key.value = '';"
                    readonly="readonly" type="text" value="Filled from Thesaurus" />
                  <a class="s01"
                    href="javascript:openThesaurus(document.forms.frmSearch.field4Sel.options[document.forms.frmSearch.field4Sel.selectedIndex].value);"
                    title="Look up a search term in the thesaurus">
                    <span>Thesaurus...</span>
                  </a>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f06 n04">
                  <legend>Date Range</legend>
                  <select id="booleanOpDateSel" name="booleanOpDateSel">
                    <xsl:call-template name="tpl-search-mode">
                      <xsl:with-param name="selected"
                        select="substring-after(//refine/parameters/parameter[starts-with(., 'booleanOpDateSel:')], ':')" />
                    </xsl:call-template>
                  </select>
                  <label class="s01" for="lowerDateSel">From</label>
                  <select id="lowerDateSel" name="lowerDateSel">
                    <xsl:call-template name="tpl-year">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'lowerDateSel:')], ':')" />
                    </xsl:call-template>
                  </select>
                  <label class="s01" for="higherDateSel">To</label>
                  <select id="higherDateSel" name="higherDateSel">
                    <xsl:call-template name="tpl-year">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'higherDateSel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                  <label class="s02" for="higherDateSel">(optional)</label>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f06 n05">
                  <legend>Publication</legend>
                  <select id="booleanOpPublicationSel" name="booleanOpPublicationSel">
                    <xsl:call-template name="tpl-search-mode">
                      <xsl:with-param name="selected" select="'0'" />
                    </xsl:call-template>
                  </select>
                  <label class="s01" for="publicationSel">Publication</label>
                  <select id="publicationSel" name="publicationSel" onchange="publicationTxt.value=this.options[this.selectedIndex].text;">
                    <xsl:call-template name="tpl-publications">
                      <xsl:with-param name="selected" select="substring-after(//refine/parameters/parameter[starts-with(., 'publicationSel:')], ':')"
                       />
                    </xsl:call-template>
                  </select>
                  <input id="publicationTxt" name="publicationTxt" type="hidden"
                    value="{substring-after(//refine/parameters/parameter[starts-with(., 'publicationTxt:')], ':')}" />
                  <label class="s02" for="publicationSel">(optional)</label>
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
      <xsl:text>Names</xsl:text>
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
    <xsl:param name="selected" required="yes" />

    <option value="">
      <xsl:text>Publication...</xsl:text>
    </option>
    <option value="mrp">
      <xsl:if test="$selected = 'mrp'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Monthly Repository (1806 - 1838)</xsl:text>
    </option>
    <option value="nss">
      <xsl:if test="$selected = 'nss'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Northern Star (1837 - 1852)</xsl:text>
    </option>
    <option value="ldr">
      <xsl:if test="$selected = 'ldr'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Leader (1850 - 1860)</xsl:text>
    </option>
    <option value="ewj">
      <xsl:if test="$selected = 'ewj'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>English Woman's Journal (1858 - 1864)</xsl:text>
    </option>
    <option value="ttw">
      <xsl:if test="$selected = 'ttw'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Tomahawk (1867 - 1870)</xsl:text>
    </option>
    <option value="tec">
      <xsl:if test="$selected = 'tec'">
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
      <xsl:text>Semantic Tags</xsl:text>
    </option>
    <option value="$selected = 'image-key'">
      <xsl:if test="$selected = 'image-key'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Image metadata</xsl:text>
    </option>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-window">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta content="text/html; charset=utf-8" http-equiv="content-type" />
        <link href="{$scriptswitch}/i/favicon.ico" rel="shortcut icon" />

        <link href="{$scriptswitch}/c/default.css" media="screen, projection" rel="stylesheet" type="text/css" />
        <link href="{$scriptpers}/c/personality.css" media="screen, projection" rel="stylesheet" type="text/css" />
        <link href="{$scriptswitch}/c/print.css" media="print" rel="stylesheet" type="text/css" />

        <!-- IE browser specific css and script -->
        <xsl:comment>[if GTE IE 7]> &lt;link rel="stylesheet" type="text/css" href="<xsl:value-of select="$scriptpers" />/c/compat.css"/>
          &lt;![endif]</xsl:comment>

        <!-- script -->
        <script src="{$scriptswitch}/j/jquery-1.2.3.pack.js" type="text/javascript">&#160;</script>
        <script src="{$scriptpers}/s/jquery.dimensions.js" type="text/javascript">&#160;</script>
        <script src="{$scriptpers}/s/jquery.accordion.js" type="text/javascript">&#160;</script>
        <script src="{$scriptpers}/s/config.js" type="text/javascript">&#160;</script>
        <script src="{$scriptpers}/s/thesaurus.js" type="text/javascript">&#160;</script>

        <title>Thesaurus</title>
      </head>

      <body id="xmd">
        <xsl:attribute name="class">v1 r3 pu</xsl:attribute>

        <div id="mainContent">
          <div class="form">
            <div class="t02">
              <form method="GET" name="frmThesaurus" onSubmit="javascript:addTerms(); return false;">
                <div>
                  <xsl:text>Sematic Tag Thesaurus</xsl:text>
                </div>

                <fieldset class="s01">
                  <legend>Semantic tag thesaurus</legend>
                  <ol>
                    <li class="clfx-b">
                      <fieldset class="f05 n01">
                        <legend>Thesaurus</legend>
                        <div class="unorderedList">
                          <div class="t02">
                            <xsl:for-each select="//projAL/rdf:RDF">
                              <xsl:call-template name="tpl-thesaurus-semtag" />
                            </xsl:for-each>
                          </div>
                        </div>
                      </fieldset>
                    </li>
                    <li class="clfx-b">
                      <fieldset class="f06 n07">
                        <legend>Submit Search</legend>
                        <div>
                          <button type="submit">Insert</button>
                          <button type="reset">Reset</button>
                          <button onclick="javascript:window.close(); return false;">Close</button>
                        </div>
                      </fieldset>
                    </li>
                  </ol>
                </fieldset>
              </form>
            </div>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-semtag">
    <xsl:param name="ul-class" />

    <ul>
      <!--
      <xsl:if test="string($ul-class)">
        <xsl:attribute name="class">
          <xsl:value-of select="$ul-class" />
        </xsl:attribute>
      </xsl:if>
      -->

      <xsl:for-each select="skos:Concept">
        <li>
          <xsl:choose>
            <xsl:when test="skos:narrower">
              <!--<a class="x70 z03">-->
              <input class="f02" id="thesCheck" type="checkbox" value="{@rdf:about}" />
              <label for="{@rdf:about}" id="{@rdf:about}" title="{@rdf:label}">
                <strong>
                  <xsl:value-of select="@rdf:label" />
                </strong>
              </label>
              <!--</a>-->
              <xsl:for-each select="skos:narrower/skos:orderedCollection/skos:memberList">
                <xsl:call-template name="tpl-thesaurus-semtag">
                  <!--<xsl:with-param name="ul-class" select="'s02'" />-->
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <input class="f02" id="thesCheck" type="checkbox" value="{@rdf:about}" />
              <label for="{@rdf:about}" id="{@rdf:about}" title="{@rdf:label}">
                <xsl:value-of select="@rdf:label" />
              </label>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
</xsl:stylesheet>
