<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- GENERAL INCLUDES -->
  <xsl:include href="../common/proj_tpl.xsl" />
  <xsl:include href="../common/proj_vars.xsl" />
  <xsl:include href="../common/proj_key.xsl" />

  <!-- INCLUDES COMMON TO MAIN PUBLICATIONS -->
  <xsl:include href="../common/proj_tei_com.xsl" />

  <!-- INCLUDES SPECIFIC TO THIS DRIVER -->
  <xsl:include href="proj_type01_tpkey.xsl" />
  <xsl:include href="proj_type01_spec.xsl" />
  <xsl:include href="proj_type01_stdext.xsl" />
</xsl:stylesheet>
