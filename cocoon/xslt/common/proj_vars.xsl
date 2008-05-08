<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--  GLOBAL VARIABLES  -->

  <!--    Parameters passed by the Cocoon sitemap used for publication website  -->
  <xsl:param name="context-path" />
  <xsl:param name="sm-context-id" />

  <!-- Context id -->
  <xsl:variable name="context-id">
    <xsl:choose>
      <xsl:when test="string($sm-context-id)">
        <xsl:value-of select="$sm-context-id" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$loc-id" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Results per page -->
  <xsl:variable name="rpp" select="number(10)" />

  <!-- Useful translate variables -->
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'" />

  <!-- Group type02 and type03 ids -->
  <xsl:variable name="file-type02-pre" select="'tp'" />
  <xsl:variable name="group-type02-id" select="'g3'" />
  <xsl:variable name="text-type03-pre" select="'p4_'" />
  <xsl:variable name="group-type03-id" select="'g4'" />

  <!-- Group type02 and type03 paths -->
  <xsl:variable name="group-type02-path" select="//filebase//group[@id=$group-type02-id]/groupHead/groupFolder" />
  <xsl:variable name="group-type03-path" select="//filebase//group[@id=$group-type03-id]/groupHead/groupFolder" />

  <!--       KEY PROJECT VARIABLES       -->

  <!--   LINKROOT   -->
  <xsl:variable name="linkroot" select="$context-path" />


  <!--   IMAGES   -->
  <!-- Pointer to switch for general design images -->
  <xsl:variable name="genimgswitch" select="'Assets/g/i'" />

  <!-- Pointer to switch for specific publication images -->
  <xsl:variable name="pubimgswitch" select="'images/pubimg/'" />



  <!--  SCRIPTS -->
  <!-- Pointer to switch for scripts -->
  <!-- e.g. /Assets/g -->
  <xsl:variable name="scriptswitch" select="'Assets/g'" />
  <!-- e.g. /Assets/p/04 -->
  <!-- CHANGE ME -->
  <xsl:variable name="scriptpers" select="'Assets/p/23'" />



  <!-- BASIC CSS FOR CHECKING PAGES -->
  <!--<xsl:variable name="chqroot" select="document($ALprocess)//item[@id='chqroot']/param"/>-->
  <!-- Now relative -->
  <xsl:variable name="chqroot" select="$locroot" />

  <!-- Pointer to switch for css -->
  <!-- e.g. final\css\ -->
  <xsl:variable name="chqswitchcss" select="'/css/'" />




  <!-- CALCULATING THE RELATIVE PATH -->
  <!-- context @id -->
  <xsl:variable name="loc-id">
    <xsl:choose>
      <!-- Test for checking pages -->
      <xsl:when test="/aggregation/docsite and not(/aggregation/source)">
        <xsl:text>iAL_docsite</xsl:text>
      </xsl:when>
      <xsl:when test="/aggregation/source">
        <xsl:value-of select="/aggregation/source/authorityList/@id" />
      </xsl:when>
      <!-- XML Processing -->
      <xsl:otherwise>
        <xsl:value-of select="/aggregation/TEI.2/@id" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- context type - special case for type03 -->
  <xsl:variable name="loc-type">
    <xsl:if test="/aggregation/TEI.2[starts-with(@id, $group-type03-id)]">
      <xsl:text>type03</xsl:text>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="loc-grp">
    <xsl:choose>
      <!-- Test for checking pages -->
      <!--<xsl:when test="/authorityList">
        <xsl:value-of select="document($docsite)//group[item/@id=$loc-id]/groupHead/groupFolder"/>
      </xsl:when>
      <xsl:when test="/projectList">
        <xsl:value-of select="document($docsite)//group[item/@id=$loc-id]/groupHead/groupFolder"/>
      </xsl:when>
      <xsl:when test="/root">
        <xsl:value-of select="document($docsite)//group[item/@id=$loc-id]/groupHead/groupFolder"/>
      </xsl:when>-->
      <!-- context group - different test for each type02 and type03 -->
      <xsl:when test="/aggregation/TEI.2[starts-with(@id, $file-type02-pre)]">
        <xsl:value-of select="//filebase//group[@id=$group-type02-id]/groupHead/groupFolder" />
      </xsl:when>
      <xsl:when test="/aggregation/TEI.2[starts-with(@id, $group-type03-id)]">
        <xsl:value-of select="//filebase//group[@id=$group-type03-id]/groupHead/groupFolder" />
      </xsl:when>
      <!-- Normal type01 files -->
      <xsl:otherwise>
        <xsl:value-of select="//filebase//group[item/@id=$loc-id]/groupHead/groupFolder" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- removes everything but the forward slashes and counts that -->
  <xsl:variable name="dash" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ-abcdefghijklmnopqrstuvwxyz_0123456789'" />

  <xsl:variable name="loc-num">
    <xsl:value-of select="string-length(translate($loc-grp, $dash, ''))" />
  </xsl:variable>

  <!-- creates the context or calls the recursive template -->
  <xsl:variable name="locroot01">
    <xsl:choose>
      <xsl:when test="$loc-num=0">
        <xsl:text>.</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="dotdotslash" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- extra step for type03 where a new folder is created for each file -->
  <xsl:variable name="locroot">
    <xsl:choose>
      <xsl:when test="/aggregation/TEI.2[starts-with(@id, $group-type03-id)]">
        <xsl:text>../</xsl:text>
        <xsl:value-of select="$locroot01" />
      </xsl:when>
      <!--
      <xsl:when test="$loc-type='type03'">
        <xsl:text>../</xsl:text>
        <xsl:value-of select="$locroot01"/>
      </xsl:when>
      -->
      <xsl:otherwise>
        <xsl:value-of select="$locroot01" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- creates the relative ../ needed -->
  <xsl:template name="dotdotslash">
    <xsl:param name="ploc-num" select="$loc-num" />
    <xsl:variable name="remainder">
      <xsl:value-of select="$ploc-num - 1" />
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$ploc-num = 0"> </xsl:when>
      <xsl:when test="$ploc-num = 1">
        <xsl:text>..</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>../</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="not($remainder=0)">
      <xsl:call-template name="dotdotslash">
        <xsl:with-param name="ploc-num" select="$remainder" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>



  <!-- DEFINE RIGHTHAND CONTENT -->
  <xsl:template name="tpl_rhcontent">
    <xsl:variable name="rhc-site" select="//filebase//body/rhcontent/@value" />
    <xsl:variable name="rhc-type01" select="//filebase//body/rhcontent/@type01" />
    <xsl:variable name="rhc-type02-val" select="//filebase//group[@id=$group-type02-id]/groupHead/rhcontent/@value" />
    <xsl:variable name="rhc-type02">
      <xsl:choose>
        <xsl:when test="string($rhc-type02-val)">
          <xsl:value-of select="$rhc-type02-val" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="//filebase//group[@id=$group-type02-id]/ancestor::group[groupHead/rhcontent[string(@value)]][1]/groupHead/rhcontent/@value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rhc-type03-val" select="//filebase//group[@id=$group-type03-id]/groupHead/rhcontent/@value" />
    <xsl:variable name="rhc-type03">
      <xsl:choose>
        <xsl:when test="string($rhc-type03-val)">
          <xsl:value-of select="$rhc-type03-val" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="//filebase//group[@id=$group-type03-id]/ancestor::group[groupHead/rhcontent[string(@value)]][1]/groupHead/rhcontent/@value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rhc-group-val" select="//filebase//group[item[@id=current()/@id]]/groupHead/rhcontent/@value" />
    <xsl:variable name="rhc-group">
      <xsl:choose>
        <xsl:when test="string($rhc-group-val)">
          <xsl:value-of select="$rhc-group-val" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="//filebase//group[item[@id=current()/@id]]/ancestor::group[groupHead/rhcontent[string(@value)]][1]/groupHead/rhcontent/@value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rhc-item" select="//filebase//item[@id=$context-id]/rhcontent/@value" />

    <xsl:choose>
      <!-- Type02 and Type03 file specific -->
      <xsl:when test="string(@rend) and (contains(normalize-space(@rend), 'on') or contains(normalize-space(@rend), 'off'))">
        <xsl:choose>
          <xsl:when test="contains(normalize-space(@rend), 'on')">
            <xsl:text>on</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>off</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- Type01 file specific -->
      <xsl:when test="string($rhc-item)">
        <xsl:value-of select="$rhc-item" />
      </xsl:when>
      <!-- Filebase output group specific (type01) -->
      <xsl:when test="string($rhc-group)">
        <xsl:value-of select="$rhc-group" />
      </xsl:when>
      <!-- Type01 specific -->
      <xsl:when test="string($rhc-type01)">
        <xsl:value-of select="$rhc-type01" />
      </xsl:when>
      <!-- Type02 specific -->
      <xsl:when test="/aggregation/TEI.2[starts-with($loc-id, $file-type02-pre)] and string($rhc-type02)">
        <xsl:value-of select="$rhc-type02" />
      </xsl:when>
      <!-- Type03 specific -->
      <xsl:when test="/aggregation/TEI.2[starts-with($loc-id, $group-type03-id)] and string($rhc-type03)">
        <xsl:value-of select="$rhc-type03" />
      </xsl:when>
      <!-- Site specific -->
      <xsl:when test="string($rhc-site)">
        <xsl:value-of select="$rhc-site" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>off</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- DEFINE THEME -->
  <xsl:template name="tpl_theme">
    <xsl:variable name="th-site" select="//filebase//body/theme/@value" />
    <xsl:variable name="th-type01" select="//filebase//body/theme/@type01" />
    <xsl:variable name="th-type02-val" select="//filebase//group[@id=$group-type02-id]/groupHead/theme/@value" />
    <xsl:variable name="th-type02">
      <xsl:choose>
        <xsl:when test="string($th-type02-val)">
          <xsl:value-of select="$th-type02-val" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="//filebase//group[@id=$group-type02-id]/ancestor::group[groupHead/rhcontent[string(@value)]][1]/groupHead/theme/@value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="th-type03-val" select="//filebase//group[@id=$group-type03-id]/groupHead/theme/@value" />
    <xsl:variable name="th-type03">
      <xsl:choose>
        <xsl:when test="string($th-type03-val)">
          <xsl:value-of select="$th-type03-val" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="//filebase//group[@id=$group-type03-id]/ancestor::group[groupHead/rhcontent[string(@value)]][1]/groupHead/theme/@value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="th-group-val" select="//filebase//group[item[@id=current()/@id]]/groupHead/theme/@value" />
    <xsl:variable name="th-group">
      <xsl:choose>
        <xsl:when test="string($th-group-val)">
          <xsl:value-of select="$th-group-val" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="//filebase//group[item[@id=current()/@id]]/ancestor::group[groupHead/rhcontent[string(@value)]][1]/groupHead/theme/@value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="th-item" select="//filebase//item[@id=$loc-id]/theme/@value" />

    <xsl:choose>
      <!-- Type02 and Type03 file specific -->
      <xsl:when test="string(@rend) and contains(normalize-space(@rend), 'th')">
        <xsl:value-of select="translate(normalize-space(@rend), ' onf', '')" />
      </xsl:when>
      <!-- Type01 file specific -->
      <xsl:when test="string($th-item)">
        <xsl:value-of select="$th-item" />
      </xsl:when>
      <!-- Filebase output group specific (type01) -->
      <xsl:when test="string($th-group)">
        <xsl:value-of select="$th-group" />
      </xsl:when>
      <!-- Type01 specific -->
      <xsl:when test="string($th-type01)">
        <xsl:value-of select="$th-type01" />
      </xsl:when>
      <!-- Type02 specific -->
      <xsl:when test="/aggregation/TEI.2[starts-with($loc-id, $file-type02-pre)] and string($th-type02)">
        <xsl:value-of select="$th-type02" />
      </xsl:when>
      <!-- Type03 specific -->
      <xsl:when test="/aggregation/TEI.2[starts-with($loc-id, $group-type03-id)] and string($th-type03)">
        <xsl:value-of select="$th-type03" />
      </xsl:when>
      <!-- Site specific -->
      <xsl:when test="string($th-site)">
        <xsl:value-of select="$th-site" />
      </xsl:when>
      <xsl:otherwise>th0</xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- DEFINE TOP NAVIGATION -->
  <xsl:variable name="topNav">
    <xsl:choose>
      <xsl:when test="//navbar//body[@topNav = 'on']">
        <xsl:text>on</xsl:text>
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:variable>


  <!-- DEFINE SIDE NAVIGATION -->
  <xsl:variable name="sideNav">
    <xsl:for-each select="//navbar//body//level01[default/@ref = $loc-id]">
      <xsl:if test="not(active)">
        <xsl:text> sn0</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <!--  Temporary fixes   -->

  <!-- Alternative text for general images -->
  <!-- e.g. 'layout image' -->
  <xsl:variable name="alt_text" select="'layout text'" />

  <!-- Navbar column width -->
  <!-- e.g. '150' -->
  <xsl:variable name="tab1_1_width_left" select="'150'" />

  <!-- Navbar column width minus 20 pixels -->
  <!-- e.g. '130' -->
  <xsl:variable name="tab1_1_1_width_center" select="'130'" />
</xsl:stylesheet>
