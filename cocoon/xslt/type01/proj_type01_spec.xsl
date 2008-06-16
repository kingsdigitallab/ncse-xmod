<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Index Keys -->
  <xsl:key match="titleStmt/author" name="headerAuth" use="normalize-space(name[@type='surname'])" />
  <xsl:key match="file" name="kwForeign" use="concat(@id, '-', ancestor::row/head)" />
  <xsl:key match="head" name="kwForeignAZ" use="translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />

  <!-- START: divGen  -->
  <xsl:template match="divGen">
    <!-- Templates in proj_type01_stdext.xsl -->
    <!-- Feedback form -->
    <xsl:if test="@id='feedback'">
      <div class="form">
        <div class="t01">
          <form action="http://curlew.cch.kcl.ac.uk/cgi-bin/doemail.pl" method="POST" name="ncse_fb">
            <input name="script" type="hidden" value="ncse_fb" />
            <fieldset>
              <legend>Personal Data</legend>
              <label>Name:</label>
              <input id="name" name="name" type="text" />
              <dfn>*</dfn>
              <br />
              <label>Email:</label>
              <input id="email" name="email" type="text" />
              <dfn>*</dfn>
            </fieldset>
            <fieldset>
              <legend>Comments</legend>
              <label>Comments:</label>
              <textarea cols="40" id="comments" name="comments" rows="6">&#160;</textarea>
              <dfn>*</dfn>
            </fieldset>
            <fieldset>

              <button type="submit">Submit</button>
              <button type="reset">Reset</button>
            </fieldset>
          </form>
        </div>
      </div>
    </xsl:if>

    <!-- Search of the month -->
    <xsl:if test="@id='sm_list'">
      <div class="unorderedList">
        <div class="t01">
          <ul>
            <xsl:for-each select="//projDIR/dir:directory/dir:file[starts-with(@name, 'sm-')]">
              <xsl:sort select="@name"/>
              <li>
                <a href="{substring-before(@name, '.xml')}.html">
                  <xsl:value-of select="dir:xpath/title"/>
                </a>
              </li>
            </xsl:for-each>
            </ul>
        </div>
      </div>
    </xsl:if>
    
    <!--  GLOSSARY -->
    <xsl:if test="@id='tpl_glossary'">
      <xsl:call-template name="ctpl_glossary" />
    </xsl:if>

    <!--  SITE MAP -->
    <xsl:if test="@id='tpl_sitemap'">
      <xsl:call-template name="ctpl_sitemap" />
    </xsl:if>
    <!-- END: divGen  -->
  </xsl:template>

  <!--  Variables for CSS on the dt and dd -->
  <xsl:template name="row-vars">
    <xsl:text>r</xsl:text>
    <xsl:number format="01" value="position()" />
  </xsl:template>

  <xsl:template name="col-vars">
    <xsl:choose>
      <xsl:when test="position() = count(key('headerAuth', normalize-space(name[@type='surname'])))">
        <xsl:text> x01</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> c</xsl:text>
        <xsl:number format="01" value="position()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  Moded Templates  -->

  <!-- Does not process notes in the titles -->
  <xsl:template match="note" mode="index" />
</xsl:stylesheet>
