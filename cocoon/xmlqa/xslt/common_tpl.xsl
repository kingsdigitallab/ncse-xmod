<?xml version="1.0"?>
<!-- $Id: common_tpl.xsl 596 2007-08-31 16:15:48Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">

  <xsl:strip-space elements="div"/>


<!-- Creates the Basic HTML Template -->
  <xsl:template name="html_tpl">
    <html>
      <head>        
        <xsl:comment>CTPL_HTMLTITLE STARTS</xsl:comment>
        <xsl:call-template name="ctpl_htmltitle"/>
        <xsl:comment>CTPL_HTMLTITLE ENDS</xsl:comment>
      </head>
      <body>
        <xsl:comment>CTPL_LOGO STARTS</xsl:comment>
        <xsl:call-template name="ctpl_logo"/>
        <xsl:comment>CTPL_LOGO ENDS</xsl:comment>
        
        
        <xsl:comment>CTPL_PAGEHEAD STARTS</xsl:comment>
        <xsl:call-template name="ctpl_pagehead"/>
        <xsl:comment>CTPL_PAGEHEAD ENDS</xsl:comment>


        <xsl:comment>CTPL_NAV STARTS</xsl:comment>
        <xsl:call-template name="ctpl_nav"/>
        <xsl:comment>CTPL_NAV ENDS</xsl:comment>


        <xsl:comment>CTPL_SUBMENU STARTS</xsl:comment>
        <xsl:call-template name="ctpl_submenu"/>
        <xsl:comment>CTPL_SUBMENU ENDS</xsl:comment>


        <xsl:comment>CTPL_CONTENT STARTS</xsl:comment>
        <xsl:call-template name="ctpl_content"/>
        <xsl:comment>CTPL_CONTENT ENDS</xsl:comment>


        <xsl:comment>CTPL_FOOTER STARTS</xsl:comment>
        <xsl:call-template name="ctpl_footer"/>
        <xsl:comment>CTPL_FOOTER ENDS</xsl:comment>
      </body>
    </html>
  </xsl:template>
  
</xsl:stylesheet>