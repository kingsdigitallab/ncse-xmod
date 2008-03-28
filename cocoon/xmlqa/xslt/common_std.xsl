<?xml version="1.0"?>
<!-- $Id: common_std.xsl 596 2007-08-31 16:15:48Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">

  <xsl:template match="p">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>

  <xsl:template match="url">
    <p>
      <a class="content" href="{text()}" target="_blank">
        <xsl:apply-templates/>
      </a>
    </p>
  </xsl:template>

  <xsl:template match="i">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="b">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <xsl:template match="u">
    <u>
      <xsl:apply-templates/>
    </u>
  </xsl:template>

  <xsl:template match="list">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="li">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="label">
    <strong>
      <xsl:apply-templates/>
    </strong>
    <br/>
  </xsl:template>

  <xsl:template match="con">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="changeNotes">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="changeItem">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="name">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>


</xsl:stylesheet>
