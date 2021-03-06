<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- These come from the sitemap and are used for the thesaurus window to communicate with the parent window -->
  <xsl:param name="thesaurus-key" />
  <xsl:param name="thesaurus-text" />
  
  <!-- GENERAL INCLUDES -->
  <xsl:include href="../common/proj_tpl.xsl"/>
  <xsl:include href="../common/proj_vars.xsl"/>
  <xsl:include href="../common/proj_key.xsl"/>

  <!-- INCLUDES SPECIFIC TO THIS DRIVER -->
  <xsl:include href="proj_search_tpkey.xsl"/>
  <xsl:include href="proj_form_spec.xsl"/>
  <xsl:include href="proj_results_spec.xsl"/>
  <xsl:include href="../util/result_tpl.xsl"/>
</xsl:stylesheet>
