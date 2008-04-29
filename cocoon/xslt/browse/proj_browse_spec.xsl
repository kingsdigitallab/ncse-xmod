<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:page="http://apache.org/cocoon/paginate/1.0"
  xmlns:r="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:s="http://www.w3.org/2004/02/skos/core#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="tpl-browse-subject-start">
    <ul>
      <xsl:for-each select="//r:RDF/s:Concept">
        <li>
          <a href="subject-{encode-for-uri(@r:about)}-{encode-for-uri(@r:label)}">
            <xsl:value-of select="@r:about"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@r:label"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="tpl-browse-image-start"/>

  <xsl:template name="tpl-browse-results">

   

    <div class="resourceList">
      <div class="t02">
        <ul>
          <xsl:for-each select="//search-results/hits/hit">
            <xsl:variable name="pos" select="@position"/>

            <li class="{if ($pos mod 2 = 0) then 'z02 s01' else 'z01 s01'}">
              <xsl:variable name="entity"
                select="substring-after(substring-after(substring-after(substring-after(id, '-'), '-'), '-'), '-')"/>
              <xsl:variable name="path"
                select="escape-html-uri(replace(substring-before(id, concat('-', $entity)), '-', '/'))"/>

              <h3>
                <xsl:value-of select="tei/bibl/title[@type = 'full-title']"/>
              </h3>

              <ul class="s01">
                <li class="s01">
                  <a
                    href="http://137.73.123.44/KingsCollege/Default.htm?href={$path}&amp;entityid={$entity}&amp;view=entity"
                    target="_blank">
                    <xsl:value-of select="id"/>
                  </a>
                </li>
                <li class="s02">
                  <a href="view-issue({@position})">View all article data</a>
                </li>
              </ul>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
