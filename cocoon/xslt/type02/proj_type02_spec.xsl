<?xml version="1.0" ?>
<!-- $Id: proj_type02_spec.xsl 584 2007-08-29 14:14:46Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" xmlns="http://www.w3.org/1999/xhtml"
  extension-element-prefixes="saxon" exclude-result-prefixes="saxon" version="1.1">


  <!-- SUPERSEDES TEMPLATES IN PROJ_TEI_COM -->

  <xsl:template match="foreign" priority="1">
    <em id="{@id}">
      <xsl:apply-templates/>
    </em>
  </xsl:template>

</xsl:stylesheet>


