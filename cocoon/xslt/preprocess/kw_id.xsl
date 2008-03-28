<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon"
    exclude-result-prefixes="saxon" version="1.1">

    <xsl:output method="xml" indent="yes"/>

    <!-- ============================================================= -->
    <!--  MODULE:           conversion.xsl   -->
    <!--  VERSION DATE:     1.0                                        -->
    <!--  VERSION:          2006-08-17                             -->
    <!--  VERSION CONTROL:                                             -->
    <!-- ============================================================= -->

    <!-- ============================================================= -->
    <!-- ORIGINAL CREATION DATE:     2006-08-17                        -->
    <!-- PURPOSE: To add ids to the keywords for anchors and links     -->
    <!-- CREATED FOR:      xMod 1.3                                         -->
    <!-- CREATED BY:   ZA                                             -->
    <!-- ============================================================= -->

    <!-- ============================================================= -->
    <!--                                                        Copy all elements                                                        -->
    <!-- ============================================================= -->

    <xsl:template match="*">
        <xsl:copy>
            <xsl:variable name="teiform-id" select="generate-id(@TEIform)"/>
            <xsl:copy-of select="@*[generate-id() != $teiform-id]"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- =======================  CHANGES ======================= -->

    <xsl:template match="TEI.2">
        <xsl:text disable-output-escaping="yes">
	</xsl:text>
        <TEI.2>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:attribute name="n">
                <xsl:value-of select="@n"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </TEI.2>
    </xsl:template>

    <xsl:template match="foreign">
        <foreign>
            <xsl:attribute name="id">
                <xsl:text>fgn-</xsl:text>
                <xsl:value-of select="ancestor::TEI.2/@id"/>
                <xsl:text>-</xsl:text>
                <xsl:number level="any" from="TEI.2"/>
            </xsl:attribute>
            <xsl:attribute name="n">
                <xsl:value-of select="@n"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </foreign>
    </xsl:template>

</xsl:stylesheet>
<!--    ***********************************************       -->
<!--    *************   END OF STYLESHEET  ************       -->
<!--    ***********************************************       -->
