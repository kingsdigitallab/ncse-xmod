<?xml version="1.0"?>
<!-- $Id: common_key.xsl 598 2007-09-03 15:51:05Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">
  
  <!-- Common page templates -->

  <xsl:template name="ctpl_htmltitle">
    <title>Checking Pages</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">&#160;</meta>
    <link rel="stylesheet" type="text/css" href="{$chqroot}{$chqswitchcss}projchq.css"/>
  </xsl:template>



  <xsl:template name="ctpl_logo">
    <p>THE BANNER GOES HERE</p>
  </xsl:template>



  <xsl:template name="ctpl_pagehead">

    <xsl:variable name="filename">
      <xsl:choose>
        <xsl:when test="$context-id = 'iAL_docsite'">
          <xsl:value-of select="/aggregation/docsite//item[@id='iAL_docsite']/fileTitle"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/aggregation/docsite//item[@id = $context-id]/fileTitle"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <a name="top">&#160;</a>
    <h1>
      <xsl:text>Checking page for: </xsl:text>
      <span class="new">&lt;<xsl:value-of select="$filename"/>&gt;</span>
    </h1>
  </xsl:template>



  <xsl:template name="ctpl_nav">
    <p>
      <xsl:text>[</xsl:text>
      <a class="content" href="../chq/AL_docsite.html">Back to documentation site</a>
      <xsl:text>]</xsl:text>
    </p>
  </xsl:template>



  <xsl:template name="ctpl_submenu">
    <table class="toc" cellspacing="0" cellpadding="5">
      <tr>
        <th colspan="2" class="head">Other checking pages</th>
      </tr>
      <xsl:for-each select="/aggregation/docsite//body/group[not(@id='docsite')]">
        <tr>
          <th class="table4">
            <xsl:value-of select=".//groupTitle"/>
            <xsl:text>:</xsl:text>
          </th>
          <td class="table4">
            <xsl:for-each select=".//item">
              <xsl:variable name="grp-path" select="..//groupFolder"/> 
              <a class="content">
                <xsl:attribute name="href">
                  <xsl:value-of select="$linkroot"/>
                  <xsl:value-of select="$grp-path"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="@id"/>
                  <xsl:text>.html</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="fileTitle"/>
              </a>
              <xsl:if test="position() != last()"> | </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:for-each>

    </table>
  </xsl:template>

  
  
  <xsl:template name="ctpl_footer">
    <h2>Last edited</h2>
    <p>This index was created using the XML file dated: [<span class="dateEdited">2003 -
        _unspecified - _unspecified</span>] and edited by: [<span class="dateEdited">ADD
      HERE</span>] <sup>*</sup>
      <!--[<span class="dateEdited">
  			<xsl:value-of select="@year" /> - 
  			<xsl:value-of select="@month" /> - 
  			<xsl:value-of select="@day" />
		</span>] and edited by: 
		[<span class="dateEdited">
  			<xsl:value-of select="@resp" />
		</span>]-->
    </p>
    <p>* <i>This comes from the attributes on &lt;authorityList&gt;.</i></p>
  </xsl:template>


</xsl:stylesheet>
