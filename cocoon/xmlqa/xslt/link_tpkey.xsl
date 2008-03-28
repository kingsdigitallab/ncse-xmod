<?xml version="1.0"?>
<!-- $Id: link_tpkey.xsl 598 2007-09-03 15:51:05Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="saxon dir" version="1.1">

  <xsl:output method="saxon:xhtml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>


  <!-- INCLUDES -->
  <xsl:include href="common_key.xsl"/>
  <xsl:include href="common_tpl.xsl"/>
  <xsl:include href="common_std.xsl"/>
  <xsl:include href="..\..\xslt\common\proj_vars.xsl"/>



  <xsl:template match="/">
    <xsl:apply-templates select="//source"/>
  </xsl:template>
  
  <xsl:template match="source">
    <xsl:call-template name="html_tpl"/>
  </xsl:template>



  <xsl:template name="ctpl_content">
    <h2>List of working links</h2>

    <table width="100%" cellpadding="6" class="detail">
      <tr>
        <th valign="top" class="id">From file TEI/@id</th>
        <th valign="top" class="main">From file title</th>
        <th valign="top" class="main">From HTML fileName</th>
        <th valign="top" class="subsid">Linking text</th>
        <th valign="top" class="subsid">xref/@from</th>
        <th valign="top" class="id">target file @id</th>
        <th valign="top" class="tablenormal">target file title</th>
        <th valign="top" class="tablenormal">Target HTML fileName</th>
      </tr>
      <xsl:for-each select=".//xref[@type='internal' or @rend='internal']">
        <xsl:variable name="cur-id" select="ancestor::dir:xpath/text()[1]"/>
        <xsl:if
          test="//source//dir:file/dir:xpath/text()[1] = current()/@from and /aggregation/filebase//item[@id = current()/@from]">
          <tr>
            <td valign="top">
              <xsl:choose>
                <xsl:when test="not($cur-id)">
                  <xsl:attribute name="class">warning</xsl:attribute>
                  <span class="warning">MISSING</span>
                </xsl:when>
                <xsl:when test="not(string($cur-id))">
                  <xsl:attribute name="class">warning</xsl:attribute>
                  <span class="warning">
                    <strong>EMPTY VALUE</strong>
                  </span>
                </xsl:when>
                <xsl:otherwise>
                  <span class="keyid">
                    <xsl:apply-templates select="$cur-id"/>
                  </span>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td valign="top">
              <xsl:apply-templates select="ancestor::dir:xpath/titleStmt/title"/>
            </td>
            <td valign="top">
              <xsl:apply-templates
                select="/aggregation/filebase//item[@id=current()/ancestor::TEI.2/@id]/fileName"/>
              <xsl:text>&#xa0;</xsl:text>
            </td>
            <td valign="top">
              <xsl:apply-templates/>
            </td>
            <td valign="top">
              <xsl:choose>
                <xsl:when test="@from = 'ROOT'">
                  <xsl:attribute name="class">warning</xsl:attribute>
                  <span class="warning">EMPTY VALUE</span>
                </xsl:when>
                <xsl:when test="not(string(normalize-space(@from)))">
                  <xsl:attribute name="class">warning</xsl:attribute>
                  <span class="warning">EMPTY VALUE</span>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@from"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td valign="top">
              <span class="keyid">
                <xsl:value-of select="//dir:file/dir:xpath[text()[1] = current()/@from]/text()[1]"/>
              </span>
            </td>
            <td valign="top">
              <xsl:value-of select="//dir:file[dir:xpath[text()[1] = current()/@from]]//titleStmt/title"/>
            </td>
            <td valign="top">
              <xsl:apply-templates select="/aggregation/filebase//item[@id = current()/@from]/fileName"/>
              <xsl:text>&#xa0;</xsl:text>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>
    <br clear="all"/>
  </xsl:template>

</xsl:stylesheet>
