<?xml version="1.0" ?>
<!-- $Id: proj_indices_DR.xsl 594 2007-08-31 16:13:54Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">

  <xsl:output method="saxon:xhtml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <!-- GENERAL INCLUDES -->
  <xsl:include href="..\common\proj_tpl.xsl"/>
  <xsl:include href="..\common\proj_vars.xsl"/>
  <xsl:include href="..\common\proj_key.xsl"/>

  <!-- INCLUDES COMMON TO MAIN PUBLICATIONS -->
  <xsl:include href="..\common\proj_tei_com.xsl"/>

  <!-- INCLUDES SPECIFIC TO THIS DRIVER -->
  <xsl:include href="proj_indices_tpkey.xsl"/>
  <xsl:include href="proj_indices_spec.xsl"/>

</xsl:stylesheet>
