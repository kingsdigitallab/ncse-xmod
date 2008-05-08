<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:r="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:s="http://www.w3.org/2004/02/skos/core#"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
                  <legend>Entity Search Criteria</legend>
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
                  <legend>Entity Search Criteria</legend>
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
                  <legend>Thesaurus Search Criteria</legend>
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
                  <a class="s01"
                    href="javascript:openThesaurus(document.frmSearch.field4Sel.options[document.frmSearch.field4Sel.selectedIndex].value, 
                    'field4Key-field4Txt');"
                    title="Look up a search term in the thesaurus">
                    <span>Thesaurus...</span>
                  </a>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f05 n03">
                  <legend>Thesaurus Search Criteria</legend>
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
                  <a class="s01"
                    href="javascript:openThesaurus(document.frmSearch.field5Sel.options[document.frmSearch.field5Sel.selectedIndex].value,
                    'field5Key-field5Txt');"
                    title="Look up a search term in the thesaurus">
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
                    <button onclick="location.href='search.html';" type="reset">Reset Form</button>
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
    <option value="image-key">
      <xsl:if test="$selected = 'image-key'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:text>Images</xsl:text>
    </option>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-window">
    <xsl:param name="type" required="yes" />
    <xsl:param name="key" required="yes" />
    <xsl:param name="text" required="yes" />

    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta content="text/html; charset=utf-8" http-equiv="content-type" />
        <meta http-equiv="imagetoolbar" content="no" />
        <meta name="abstract" content="" />
        <meta name="author" content="" />
        <meta name="copyright" content="Copyright (c) 2008" />
        <meta name="date" content="{current-date()}" />
        <meta name="description" content="" />
        <meta name="keywords" content="" />
        <meta name="robots" content="index,follow,archive" />
        <meta name="generator" content="xMod 1.3" />

        <title>
          <xsl:text>NCSE: </xsl:text>
          <xsl:value-of select="$type" />
          <xsl:text> thesaurus</xsl:text>
        </title>
        <!-- CSS calls -->
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
      </head>
      <body class="v1 r3 pu" id="xmd">
        <div id="mainContent">
          <h3>
            <xsl:value-of select="$type" />
            <xsl:text> thesaurus</xsl:text>
          </h3>
          <div class="form">
            <div class="t04">
              <form id="frmThesaurus" name="frmThesaurus">
                <div class="unorderedList">
                  <div class="t05">
                    <xsl:choose>
                      <xsl:when test="$type = 'subject'">
                        <xsl:call-template name="tpl-thesaurus-subject" />
                      </xsl:when>
                      <xsl:when test="$type = 'image'">
                        <xsl:call-template name="tpl-thesaurus-image" />
                      </xsl:when>
                    </xsl:choose>
                  </div>
                </div>
                <fieldset class="f06 n04">
                  <div>
                    <button onclick="javascript:addTerms(window.opener.document.frmSearch.{$key}, window.opener.document.frmSearch.{$text});">Insert</button>
                    <button type="reset">Reset</button>
                    <button onclick="window.close();">Close</button>
                  </div>
                </fieldset>
              </form>
            </div>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-subject">
    <ul>
      <xsl:for-each select="//r:RDF/s:Concept">
        <li class="s01">
          <a class="s01" href="#">
            <span>Expand</span>
          </a>
          <strong>
            <xsl:value-of select="@r:label" />
          </strong>
          <xsl:if test="s:narrower">
            <xsl:call-template name="tpl-thesaurus-narrower" />
          </xsl:if>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-narrower">
    <ul>
      <xsl:for-each select="s:narrower/s:orderedCollection/s:memberList/s:Concept">
        <xsl:choose>
          <xsl:when test="s:narrower/s:orderedCollection/s:memberList/s:Concept">
            <li class="s01">
              <a class="s01" href="#">
                <span>Expand</span>
              </a>
              <!--<input class="f02" id="{@r:about}" name="{$name}" title="{@r:label}" type="checkbox" value="{@r:about}" />-->
              <strong>
                <xsl:value-of select="@r:label" />
              </strong>
              <xsl:call-template name="tpl-thesaurus-narrower" />
            </li>
          </xsl:when>
          <xsl:otherwise>
            <li>
              <input class="f02" id="{@r:about}" name="thesChk" title="{@r:label}" type="checkbox" value="{@r:about}" />
              <label for="{@r:about}">
                <xsl:value-of select="@r:label" />
              </label>
            </li>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="tpl-thesaurus-image">
    <ul>
      <xsl:for-each select="//r:RDF/s:Concept">
        <li class="s01">
          <a class="s01" href="#">
            <span>Expand</span>
          </a>
          <strong>
            <xsl:value-of select="@r:label" />
          </strong>
          <xsl:if test="s:narrower">
            <xsl:call-template name="tpl-thesaurus-narrower" />
          </xsl:if>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
</xsl:stylesheet>
