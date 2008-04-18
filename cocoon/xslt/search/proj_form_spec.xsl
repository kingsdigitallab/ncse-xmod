<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="tpl-search-entity-form">
    <div class="form">
      <div class="t02">
        <form action="do-entity-search" id="frmSearch" method="POST" name="frmSearch">
          <fieldset class="s01">
            <legend>Type in Text</legend>
            <ol>
              <li class="clfx-b">
                <fieldset class="f05 n01">
                  <legend>Primary Search Criteria</legend>
                  <label for="field1Sel">Search in:</label>
                  <select id="field1Sel" name="field1Sel">
                    <xsl:call-template name="tpl-entity-select">
                      <xsl:with-param name="selected" select="'name'" />
                    </xsl:call-template>
                  </select>
                  <input id="field1Txt" name="field1Txt" type="text" value="" />
                  <select id="similarity1Sel" name="similarity1Sel">
                    <xsl:call-template name="tpl-similarity-select">
                      <xsl:with-param name="selected" select="'1'" />
                    </xsl:call-template>
                  </select>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f05 n02">
                  <legend>Secondary Search Criteria</legend>
                  <select id="booleanOp2Sel" name="booleanOp2Sel">
                    <xsl:call-template name="tpl-search-mode">
                      <xsl:with-param name="selected" select="'and'" />
                    </xsl:call-template>
                  </select>
                  <select id="field2Sel" name="field2Sel">
                    <xsl:call-template name="tpl-entity-select">
                      <xsl:with-param name="selected" select="'institution'" />
                    </xsl:call-template>
                  </select>
                  <input id="field2Txt" name="field2Txt" type="text" value="" />
                  <select id="similarity2Sel" name="similarity2Sel">
                    <xsl:call-template name="tpl-similarity-select">
                      <xsl:with-param name="selected" select="'1'" />
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
                      <xsl:with-param name="selected" select="'and'" />
                    </xsl:call-template>
                  </select>
                  <select id="field3Sel" name="field3Sel">
                    <xsl:call-template name="tpl-entity-select">
                      <xsl:with-param name="selected" select="'place'" />
                    </xsl:call-template>
                  </select>
                  <input id="field3Txt" name="field3Txt" type="text" value="" />
                  <select id="similarity3Sel" name="similarity3Sel">
                    <xsl:call-template name="tpl-similarity-select">
                      <xsl:with-param name="selected" select="'1'" />
                    </xsl:call-template>
                  </select>
                  <label class="s02" for="field3Txt">(optional)</label>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f06 n04">
                  <legend>Date Range</legend>
                  <select id="booleanOpDateSel" name="booleanOpDateSel">
                    <xsl:call-template name="tpl-search-mode">
                      <xsl:with-param name="selected" select="'0'" />
                    </xsl:call-template>
                  </select>
                  <label class="s01" for="lowerDateSel">From</label>
                  <select id="lowerDateSel" name="lowerDateSel">
                    <xsl:call-template name="tpl-year">
                      <xsl:with-param name="year" select="'0'" />
                    </xsl:call-template>
                  </select>
                  <label class="s01" for="higherDateSel">To</label>
                  <select id="higherDateSel" name="higherDateSel">
                    <xsl:call-template name="tpl-year">
                      <xsl:with-param name="year" select="'0'" />
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
                  <select id="publicationSel" name="publicationSel">
                    <xsl:call-template name="tpl-publications">
                      <xsl:with-param name="selected" select="''" />
                    </xsl:call-template>
                  </select>
                </fieldset>
              </li>
              <li class="clfx-b">
                <fieldset class="f10 n06">
                  <legend>Results Sorting</legend>
                  <label class="s01" for="sortByRelevance">Sort results by</label>
                  <ol>
                    <li class="clfx-b">
                      <label for="sortByRelevance">by relevance</label>
                      <input checked="checked" class="f02" id="sortByRelevance" name="sortBy" type="radio" value="" />
                    </li>
                    <li class="clfx-b">
                      <label for="sortByDate">by date</label>
                      <input class="f02" id="sortByDate" name="sortBy" type="radio" value="by-date" />
                    </li>
                    <li class="clfx-b">
                      <label for="any">by publication</label>
                      <input class="f02" id="sortByPub" name="sortBy" type="radio" value="by-pub" />
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
    
    <option value="1.0">Similarity...</option>
    <option value="0.9">90%</option>
    <option value="0.8">80%</option>
    <option value="0.7">70%</option>
    <option value="0.6">60%</option>
    <option value="0.5">50%</option>
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
    <xsl:param name="year" required="yes" />

    <option value="">Year...</option>
    <xsl:for-each select="1806 to 1890">
      <option value="{.}">
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
      <xsl:text>Leader (1850 - 1859)</xsl:text>
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
      <xsl:text>Publisher's Circular (1880 - 1890)</xsl:text>
    </option>
  </xsl:template>
</xsl:stylesheet>
