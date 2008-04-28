<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:r="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:s="http://www.w3.org/2004/02/skos/core#"
  xmlns:page="http://apache.org/cocoon/paginate/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="tpl-browse-subject-start">
    <ul>
      <xsl:for-each select="//r:RDF/s:Concept">
        <li>
          <xsl:value-of select="@r:about" />
          <xsl:text>: </xsl:text>
          <xsl:value-of select="@r:label" />
        </li>
      </xsl:for-each>
      </ul>
  </xsl:template>

  <xsl:template name="tpl-browse-image-start"/>

</xsl:stylesheet>
