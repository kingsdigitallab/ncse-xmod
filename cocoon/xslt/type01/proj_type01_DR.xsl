<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
    xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
    exclude-result-prefixes="saxon" version="1.1">

    <xsl:output method="saxon:xhtml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <!-- ============================================================= -->
    <!--  MODULE:           proj_type01_DR.xsl                                                                              -->
    <!--  VERSION DATE:     1.0                                                                                                      -->
    <!--  VERSION:          $Id: proj_type01_DR.xsl 573 2007-08-23 12:57:31Z zau $          -->
    <!--  VERSION CONTROL:                                                                                                       -->
    <!-- ============================================================= -->

    <!-- ============================================================= -->
    <!-- ORIGINAL CREATION DATE:    2003-09-05                                                                  -->
    <!-- PURPOSE:   Driver for type01 transformations                                                             -->
    <!-- CREATED FOR:  CCH  www.kcl.ac.uk/cch                                                                     -->
    <!-- CREATED BY:   PJS  spencepj@yahoo.com                                                                 -->
    <!-- COPYRIGHT:   CCH/PJS                                                                                                   -->
    <!-- ============================================================= -->


    <!-- GENERAL INCLUDES -->
    <xsl:include href="..\common\proj_tpl.xsl"/>
    <xsl:include href="..\common\proj_vars.xsl"/>
    <xsl:include href="..\common\proj_key.xsl"/>

    <!-- INCLUDES COMMON TO MAIN PUBLICATIONS -->
    <xsl:include href="..\common\proj_tei_com.xsl"/>

    <!-- INCLUDES SPECIFIC TO THIS DRIVER -->
    <xsl:include href="proj_type01_tpkey.xsl"/>
    <xsl:include href="proj_type01_spec.xsl"/>
    <xsl:include href="proj_type01_stdext.xsl"/>

</xsl:stylesheet>
