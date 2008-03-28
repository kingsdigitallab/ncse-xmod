<?xml version="1.0"?>
<!-- $Id: targeted_tpkey.xsl 598 2007-09-03 15:51:05Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="saxon dir" version="1.1">

  <xsl:output method="saxon:xhtml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <xsl:key name="index" match="xref[@type='internal']" use="normalize-space(@from)"/>


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

    <h2>Quick links to Targeted files</h2>

    <table class="links">
      <xsl:for-each
        select=".//xref[@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]">
        <!--
        -->
        <xsl:if test="position() mod 3 = 1">
          <tr>
            <td class="links">
              <a class="content" href="#{@from}">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@from"/>
                <xsl:text>]</xsl:text>
              </a>
            </td>
            <td class="links">
              <xsl:if
                test="following::xref[@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])][1]">
                <a class="content"
                  href="#{following::xref[@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])][1]/@from}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of
                    select="following::xref[@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])][1]/@from"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="links">
              <xsl:if
                test="following::xref[@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])][2]">
                <a class="content"
                  href="#{following::xref[@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])][2]/@from}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of
                    select="following::xref[@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])][2]/@from"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <!--
              <td class="links">
              <xsl:if test="following::xref[3][@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]">
              <a class="content" href="#{following::xref[3][@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]/@from}"><xsl:text>[</xsl:text><xsl:value-of select="following::xref[3][@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]/@from" /><xsl:text>]</xsl:text></a>
              </xsl:if>
              </td>
              <td class="links">
              <xsl:if test="following::xref[4][@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]">
              <a class="content" href="#{following::xref[4][@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]/@from}"><xsl:text>[</xsl:text><xsl:value-of select="following::xref[4][@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]/@from" /><xsl:text>]</xsl:text></a>
              </xsl:if>
              </td>		
              <td class="links">
              <xsl:if test="following::xref[5][@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]">
              <a class="content" href="#{following::xref[5][@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]/@from}"><xsl:text>[</xsl:text><xsl:value-of select="following::xref[5][@type='internal'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]/@from" /><xsl:text>]</xsl:text></a>
              </xsl:if>
              </td>
            -->
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>


    <h2>Targeted files</h2>
    <xsl:for-each
      select=".//xref[@type='internal'][@from='ROOT'][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]">
      <xsl:call-template name="tar-tables"/>
    </xsl:for-each>
    <xsl:for-each
      select=".//xref[@type='internal'][not(@from='ROOT')][generate-id(.)=generate-id(key('index', normalize-space(@from))[1])]">
      <xsl:sort select="@from"/>
      <xsl:call-template name="tar-tables"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="tar-tables">
    <table cellspacing="3" cellpadding="6" class="group">
      <tr>
        <th>
          <h3>Targeted file:</h3>
        </th>
        <td>
          <p id="{@from}">
            <strong>
              <xsl:text>[xref/@from] </xsl:text>
            </strong>
            <xsl:choose>
              <xsl:when test="@from='ROOT'">
                <span class="warning">ROOT - EMPTY VALUE</span>
              </xsl:when>
              <xsl:when test="not(string(normalize-space(@from)))">
                <span class="warning">EMPTY VALUE</span>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@from"/>
              </xsl:otherwise>
            </xsl:choose>
            <br/>
            <strong>
              <xsl:text>[@id] </xsl:text>
            </strong>
            <xsl:choose>
              <xsl:when test="not(//dir:file/dir:xpath/text()[1] = current()/@from)">
                <span class="warning">No XML file</span>
                <xsl:if test="not(/aggregation/filebase//item[@id = current()/@from])">
                  <xsl:text> and </xsl:text>
                  <span class="warning">NOT IN FILEBASE</span>
                </xsl:if>
              </xsl:when>
              <xsl:when test="not(/aggregation/filebase//item[@id = current()/@from])">
                <span class="warning">NOT IN FILEBASE</span>
              </xsl:when>
              <xsl:otherwise>
                <span class="keyid">
                  <xsl:value-of select="//dir:file/dir:xpath[text()[1] = current()/@from]/text()[1]"/>
                </span>
              </xsl:otherwise>
            </xsl:choose>
            <br/>
            <strong>
              <xsl:text>[fileTitle] </xsl:text>
            </strong>
            <xsl:value-of select="//dir:file/dir:xpath[text()[1] = current()/@from]//titleStmt/title"/>
            <xsl:text>&#xa0;</xsl:text>
            <br/>
            <strong>
              <xsl:text>[HTML fileName] </xsl:text>
            </strong>
            <xsl:value-of select="/aggregation/filebase//item[@id = current()/@from]/fileName"/>
            <xsl:text>&#xa0;</xsl:text>
            <br/>
          </p>
        </td>
      </tr>
    </table>
    <br clear="all"/>

    <table cellspacing="0" cellpadding="5" class="detail">
      <tr>
        <th class="subsid" align="center" colspan="4">
          <xsl:text>Link file</xsl:text>
        </th>
      </tr>
      <tr>
        <th class="id" width="10%">
          <xsl:text>TEI.2/@id</xsl:text>
        </th>
        <th class="tablenormal">
          <xsl:text>fileTitle:</xsl:text>
        </th>
        <th class="tablenormal" width="15%">
          <xsl:text>Linking text:</xsl:text>
        </th>
        <th class="tablenormal" width="25%">
          <xsl:text>HTML fileName:</xsl:text>
        </th>
      </tr>
      <xsl:for-each select="key('index', normalize-space(@from))">
        <xsl:sort select="ancestor::TEI.2/@id"/>
        <tr>
          <td>
            <span class="keyid">
              <xsl:value-of select="ancestor::dir:xpath/text()[1]"/>
            </span>
          </td>
          <td valign="top">
            <xsl:value-of select="ancestor::dir:xpath//titleStmt/title"/>
            <xsl:text>&#xa0;</xsl:text>
          </td>
          <td>
            <xsl:value-of select="../xref"/>
          </td>
          <td>
            <xsl:value-of
              select="/aggregation/filebase//item[@id=current()/ancestor::dir:xpath/text()[1]]/fileName"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <br clear="all"/>
    <hr size="1"/>
  </xsl:template>


</xsl:stylesheet>
