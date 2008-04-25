<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="2.0">

  <!-- Change depending on which filtered list is being run -->
  <xsl:param name="type" select="'image'"/>



  <xsl:variable name="sub-string">
    <xsl:choose>
      <xsl:when test="$type = 'subject'">
        <xsl:text>http://www.cch.kcl.ac.uk/ncse/ucrel/</xsl:text>
      </xsl:when>
      <xsl:when test="$type = 'image'">
        <xsl:text>http://www.cch.kcl.ac.uk/ncse/dmvi/</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="doc-key">
    <keys>
      <xsl:choose>
        <xsl:when test="$type = 'subject'">
          <xsl:for-each-group select="document('semtag-index-keys.xml')//key" group-by=".">
            <key>
              <xsl:sequence select="self::node()"/>
            </key>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:when test="$type = 'image'">
          <xsl:sequence select="document('image-index-keys.xml')"/>
        </xsl:when>
      </xsl:choose>
    </keys>
  </xsl:variable>

  <xsl:variable name="top-level" as="element()">
    <top>
      <xsl:choose>
        <xsl:when test="$type = 'subject'">
          <xsl:for-each-group select="$doc-key//key"
            group-by="substring(normalize-space(@id), 1, 1)">
            <level>
              <xsl:value-of select="substring(normalize-space(@id), 1, 1)"/>
            </level>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:when test="$type = 'image'">
          <xsl:for-each-group select="$doc-key//key" group-by="normalize-space(@id)">
            <level>
              <xsl:value-of select="normalize-space(@id)"/>
            </level>
          </xsl:for-each-group>
        </xsl:when>
      </xsl:choose>
    </top>
  </xsl:variable>
  <xsl:variable name="Ln" as="element()">
    <top>
      <xsl:choose>
        <xsl:when test="$type = 'subject'">
          <xsl:for-each-group select="$doc-key//key"
            group-by="substring(normalize-space(@id), 1, 2)">
            <level>
              <xsl:value-of select="substring(normalize-space(@id), 1, 2)"/>
            </level>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:when test="$type = 'image'">
          <xsl:for-each-group select="$doc-key//key" group-by="normalize-space(@id)">
            <level>
              <xsl:value-of select="normalize-space(@id)"/>
            </level>
          </xsl:for-each-group>
        </xsl:when>
      </xsl:choose>
    </top>
  </xsl:variable>

  <xsl:template match="/">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
      xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
      xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dc="http://purl.org/dc/elements/1.1/">

      <skos:ConceptScheme rdf:nodeID="schemenode">
        <xsl:copy-of select="rdf:RDF/skos:ConceptScheme/*[not(name() = 'skos:hasTopConcept')]"/>

        <xsl:for-each select="rdf:RDF/skos:ConceptScheme/skos:hasTopConcept">
          <xsl:if test="substring-after(@rdf:resource, $sub-string) = $top-level//level">
            <xsl:sequence select="self::node()"/>
          </xsl:if>
        </xsl:for-each>
      </skos:ConceptScheme>

      <xsl:for-each select="rdf:RDF/skos:Concept">
        <xsl:variable name="cur-key">
          <xsl:value-of select="normalize-space(skos:prefLabel[@xml:lang='x-notation'])"/>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$cur-key = $top-level//level">
            <xsl:comment>
              <xsl:value-of select="preceding-sibling::comment()[1]" />
            </xsl:comment>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:sequence select="*[not(name() = 'skos:narrower')]"/>
              <xsl:if test="skos:narrower">
                <skos:narrower>
                  <skos:orderedCollection>
                    <skos:memberList rdf:parseType="Collection">
                      <xsl:for-each select=".//skos:member">
                        <xsl:if test="substring-after(@rdf:about, $sub-string) = $Ln//level">
                          <xsl:sequence select="self::node()"/>
                        </xsl:if>
                      </xsl:for-each>
                    </skos:memberList>
                  </skos:orderedCollection>
                </skos:narrower>
              </xsl:if>
            </xsl:copy>
          </xsl:when>
          <xsl:when test="$cur-key = $doc-key//key/@id or $cur-key = $doc-key//key/@third">
            <xsl:comment>
              <xsl:value-of select="preceding-sibling::comment()[1]" />
            </xsl:comment>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:sequence select="*[not(name() = 'skos:narrower')]"/>
              <xsl:if test="skos:narrower">
                <skos:narrower>
                  <skos:orderedCollection>
                    <skos:memberList rdf:parseType="Collection">
                      <xsl:for-each select=".//skos:member">
                        <xsl:if test="@rdf:about = $doc-key//key">
                          <xsl:sequence select="self::node()"/>
                        </xsl:if>
                      </xsl:for-each>
                    </skos:memberList>
                  </skos:orderedCollection>
                </skos:narrower>
              </xsl:if>
            </xsl:copy>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>
