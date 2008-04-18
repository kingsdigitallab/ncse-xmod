<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id: proj_search_DR.xsl 1010 2008-04-18 13:11:54Z jvieira $
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- GENERAL INCLUDES -->
    <xsl:include href="../common/proj_tpl.xsl" />
    <xsl:include href="../common/proj_vars.xsl" />
    <xsl:include href="../common/proj_key.xsl" />

    <!-- INCLUDES SPECIFIC TO THIS DRIVER -->
    <xsl:include href="proj_search_tpkey.xsl" />
    <xsl:include href="proj_form_spec.xsl" />
    <xsl:include href="proj_results_spec.xsl" />
</xsl:stylesheet>
