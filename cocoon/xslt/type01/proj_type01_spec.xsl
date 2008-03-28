<?xml version="1.0" ?>
<!-- $Id: proj_type01_spec.xsl 592 2007-08-31 16:10:27Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">

  <!-- Index Keys -->

  <xsl:key name="headerAuth" match="titleStmt/author" use="normalize-space(name[@type='surname'])"/>
  <xsl:key name="kwForeign" match="file" use="concat(@id, '-', ancestor::row/head)"/>
  <xsl:key name="kwForeignAZ" match="head"
    use="translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>

  <!-- START: divGen  -->
  <xsl:template match="divGen">
    <!-- Templates in proj_type01_stdext.xsl -->
    <!-- Feedback form -->
    <xsl:if test="@id='feedback'">
      <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
       <div class="form">
<div class="t01">                 
<form name="ncse_fb" method="POST" action="http://curlew.cch.kcl.ac.uk/cgi-bin/doemail.pl">
<input type="hidden" name="script" value="ncse_fb" />
<fieldset><legend>Personal Data</legend>
<label>Name:</label>
<input name="name" type="text" id="name"/><dfn>*</dfn><br/>
<label>Email:</label>
<input name="email" type="text" id="email"/><dfn>*</dfn></fieldset>
<fieldset><legend>Comments</legend>
<label>Comments:</label>
<textarea name="comments" cols="40" rows="6" id="comments"></textarea><dfn>*</dfn></fieldset>
<fieldset>
          
<button type="submit">Submit</button><button type="reset">Reset</button>
</fieldset>
                     </form>            
           </div></div>
]]></xsl:text>
    </xsl:if>


    <!--  GLOSSARY -->
    <xsl:if test="@id='tpl_glossary'">
      <xsl:call-template name="ctpl_glossary"/>
    </xsl:if>

    <!--  SITE MAP -->
    <xsl:if test="@id='tpl_sitemap'">
      <xsl:call-template name="ctpl_sitemap"/>
    </xsl:if>

    <!-- END: divGen  -->
  </xsl:template>



  <!--  Variables for CSS on the dt and dd -->
  <xsl:template name="row-vars">
    <xsl:text>r</xsl:text>
    <xsl:number value="position()" format="01"/>
  </xsl:template>

  <xsl:template name="col-vars">
    <xsl:choose>
      <xsl:when test="position() = count(key('headerAuth', normalize-space(name[@type='surname'])))">
        <xsl:text> x01</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> c</xsl:text>
        <xsl:number value="position()" format="01"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!--  Moded Templates  -->

  <!-- Does not process notes in the titles -->
  <xsl:template match="note" mode="index"> </xsl:template>

</xsl:stylesheet>
