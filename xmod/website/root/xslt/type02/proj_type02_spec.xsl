<?xml version="1.0" ?>
<!-- $Id: proj_type02_spec.xsl 984 2008-04-17 15:53:27Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" xmlns="http://www.w3.org/1999/xhtml"
  extension-element-prefixes="saxon" exclude-result-prefixes="saxon" version="1.1">


  <!-- SUPERSEDES TEMPLATES IN PROJ_TEI_COM -->

  <xsl:template match="foreign" priority="1">
    <em id="{@id}">
      <xsl:apply-templates/>
    </em>
  </xsl:template>

</xsl:stylesheet>


