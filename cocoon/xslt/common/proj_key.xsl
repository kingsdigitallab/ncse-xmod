<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- HTML TITLE -->
  <xsl:template name="ctpl_htmltitle">
    <!-- TWO OPTIONS at present -->

    <!-- Current option: option 1 -->
    <meta content="text/html; charset=utf-8" http-equiv="content-type"/>
    <meta content="no" http-equiv="imagetoolbar"/>
    <meta content="" name="abstract"/>
    <meta content="" name="author"/>
    <meta content="Copyright (c) 2008" name="copyright"/>
    <meta content="{current-date()}" name="date"/>
    <meta content="" name="description"/>
    <meta content="" name="keywords"/>
    <meta content="index,follow,archive" name="robots"/>
    <meta content="xMod 1.3" name="generator"/>

    <title>
      <xsl:text>NCSE</xsl:text>
      <xsl:if test="string($pagehead)">
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$pagehead"/>
      </xsl:if>
    </title>

    <!--<link rel="shortcut icon" href="{$scriptpers}/i/customicon.ico"/>-->

    <!-- CSS calls -->
    <link href="{$scriptswitch}/c/default.css" media="screen, projection" rel="stylesheet" type="text/css"/>
    <link href="{$scriptpers}/c/personality.css" media="screen, projection" rel="stylesheet" type="text/css"/>
    <link href="{$scriptswitch}/c/print.css" media="print" rel="stylesheet" type="text/css"/>

    <!-- IE browser specific css and script -->
    <xsl:comment>[if GTE IE 7]> &lt;link rel="stylesheet" type="text/css" href="<xsl:value-of select="$scriptpers"/>/c/compat.css"/> &lt;![endif]</xsl:comment>

    <!-- script -->
    <script src="{$scriptswitch}/j/jquery-1.2.3.pack.js" type="text/javascript">&#160;</script>
    <script src="{$scriptswitch}/j/jquery.popupwindow.min.js" type="text/javascript">&#160;</script>
    <script src="{$scriptpers}/s/jquery.dimensions.js" type="text/javascript">&#160;</script>
    <script src="{$scriptpers}/s/jquery.accordion.js" type="text/javascript">&#160;</script>
    <script src="{$scriptpers}/s/config.js" type="text/javascript">&#160;</script>
    <script src="{$scriptpers}/s/thesaurus.js" type="text/javascript">&#160;</script>
    
  </xsl:template>


  <!-- BANNER TEMPLATE -->
  <xsl:template name="ctpl_banner">
    <div id="banner">
      <div class="w01">
        <div class="w02">
          <div class="utilLinks">
            <div class="s01">&#160;</div>
            <div class="s02">
              <a href="">
                <span>Text Only</span>
              </a>
              <a href="#content">
                <span>Skip Navigation</span>
              </a>
              <a accesskey="c" href="" title="Link to contact information">
                <span>Contact Info</span>
              </a>
            </div>
          </div>
          <div id="decalRight">
            <span class="printOnly">Right Hand Decal</span>
          </div>
          <div id="decalLeft">
            <span class="printOnly">Left Hand Decal</span>
          </div>

          <!-- Heading can be shown as text or replaced with images -->
          <h1>
            <span>NCSE</span>
          </h1>
          <h2>
            <span>nineteenth-century serials edition</span>
          </h2>

        </div>
      </div>
    </div>
  </xsl:template>


  <!-- BREADCRUMBS TEMPLATE -->
  <xsl:template name="ctpl_bread">
    <div class="s01">
      <ul>
        <li>
          <span class="s01">You are here:</span>
        </li>
        <xsl:choose>
          <!-- Type01 and single pages -->
          <xsl:when test="//navbar//default[@ref = $context-id]">
            <xsl:for-each select="//navbar//default[@ref = $context-id]">
              <xsl:for-each select="ancestor::*[not(default[@ref = $context-id])][label]">
                <xsl:call-template name="bread-links">
                  <xsl:with-param name="nav_default_id" select="default/@ref"/>
                </xsl:call-template>
              </xsl:for-each>
              <li>
                <span class="s02">
                  <xsl:value-of select="preceding-sibling::label[1]"/>
                </span>
              </li>
            </xsl:for-each>
          </xsl:when>
          <!-- When pages are not type01 -->
          <xsl:when test="//navbar//file[starts-with($context-id, @start) and string(@start)]">
            <xsl:for-each select="//navbar//file[starts-with($context-id, @start) and string(@start)]">
              <xsl:for-each select="ancestor::*[starts-with(local-name(), 'level')][.//file[@ref=$context-id or starts-with($context-id, @start) and string(@start)]]">
                <xsl:call-template name="bread-links">
                  <xsl:with-param name="nav_default_id" select="default/@ref"/>
                </xsl:call-template>
              </xsl:for-each>
              <li>
                <span class="s02">
                  <xsl:value-of select="$pagehead"/>
                </span>
              </li>
            </xsl:for-each>
          </xsl:when>
          <!-- When type03 -->
          <xsl:when test="local-name() = 'text'">
            <xsl:for-each select="//navbar//file[$group-type03-id = @start and string(@start)]">
              <xsl:for-each select="ancestor::*[starts-with(local-name(), 'level')]">
                <xsl:call-template name="bread-links">
                  <xsl:with-param name="nav_default_id" select="default/@ref"/>
                </xsl:call-template>
              </xsl:for-each>
              <li>
                <span class="s02">
                  <xsl:value-of select="$pagehead"/>
                </span>
              </li>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
      </ul>
    </div>
  </xsl:template>


  <xsl:template name="bread-links">
    <xsl:param name="bc-lab"/>

    <!-- Sets up context //Gets @ref from 'AL_navbar.xml'  -->
    <xsl:param name="nav_default_id"/>

    <!-- Outputs filePath for a given navbar item //  -->
    <xsl:variable name="nav_default_path" select="//filebase//group[item[@id=$nav_default_id]]/groupHead/groupFolder"/>

    <!-- Outputs fileName for a given navbar item // Then matches that with fileBase to get fileName // Then adds '.html' -->
    <xsl:variable name="nav_default_name" select="//filebase//item[@id=$nav_default_id]/fileName"/>
    <xsl:variable name="nav_default_fullname" select="concat($nav_default_name, '.html')"/>

    <!-- Outputs filePath plus fileName -->
    <xsl:variable name="nav_default" select="concat($linkroot, '/', $nav_default_path, '/', $nav_default_fullname)"/>

    <xsl:variable name="bc-label">
      <xsl:choose>
        <xsl:when test="$bc-lab = 'on'">
          <xsl:value-of select="//navbar//body//level02[default[@ref = 'p2_1']]/label"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="label"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <li>
      <a href="{$nav_default}" title="{$bc-label}">
        <span>
          <xsl:value-of select="$bc-label"/>
        </span>
      </a>
    </li>
  </xsl:template>


  <!-- NAVIGATION TEMPLATES - TOP AND SIDE -->
  <!-- TOPNAV TEMPLATE -->
  <!--			
        li.s01 - the first list item
        li.s02 - the last list item
        a.s03 - the current page/section
    -->
  <xsl:template name="ctpl_topnav">
    <div class="clfx-b" id="pn">
      <xsl:for-each select="//navbar//body/layout[@id = 'topNav']/navGroup">
        <ul>
          <xsl:attribute name="class">
            <xsl:text>pn</xsl:text>
            <xsl:value-of select="count(preceding-sibling::navGroup) + 1"/>
          </xsl:attribute>
          <xsl:for-each select="level01">
            <xsl:variable name="img">
              <xsl:text>i</xsl:text>
              <xsl:value-of select="count(preceding-sibling::level01) +1" />
            </xsl:variable>
            <li>
              <xsl:choose>
                <!-- First -->
                <xsl:when test="not(preceding-sibling::level01)">
                  <xsl:attribute name="class">
                    <xsl:text>s01 </xsl:text>
                    <xsl:value-of select="$img" />
                  </xsl:attribute>
                </xsl:when>
                <!-- Last -->
                <xsl:when test="not(following-sibling::level01)">
                  <xsl:attribute name="class">
                    <xsl:text>s02 </xsl:text>
                    <xsl:value-of select="$img" />
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">
                    <xsl:value-of select="$img" />
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:call-template name="nav-item"/>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:for-each>
    </div>
  </xsl:template>


  <!-- NAVBAR TEMPLATE - SIDENAV -->
  <xsl:template name="ctpl_nav">
    <!--  START level 1 navigation  -->
    <xsl:for-each select="//navbar//body/layout[@id = 'sideNav']/*">

      <xsl:choose>
        <!-- navbar heading -->
        <xsl:when test="self::heading"> </xsl:when>

        <!--  linebreaks  -->
        <xsl:when test="self::line">
          <!-- spacer with dividing line -->
          <!-- Need to add new code here -->
        </xsl:when>

        <!--  breaks  -->
        <xsl:when test="self::break">
          <!-- spacer with height determined by XML -->
          <!-- Need to add new code here -->
          <!-- END spacer -->
        </xsl:when>

        <!--  START LEVEL 01 LABELS -->
        <xsl:otherwise>
          <!--  START level 1 navigation  -->
          <div>
            <xsl:attribute name="class">
              <xsl:text>pn</xsl:text>
              <xsl:value-of select="count(preceding-sibling::navGroup) + 1"/>
            </xsl:attribute>
            <xsl:if test="preceding-sibling::*[1][local-name() = 'heading']">
              <h3>
                <span>
                  <xsl:value-of select="preceding-sibling::heading[1]"/>
                </span>
              </h3>
            </xsl:if>
            <ul class="pn1">
              <xsl:for-each select="level01">
                <li>
                  <xsl:call-template name="nav-li-class"/>
                  <xsl:call-template name="nav-item"/>

                  <!--  START level 2 navigation  -->
                  <xsl:if test=".//file[@ref=$context-id or starts-with($context-id, @start) and string(@start)]">
                    <xsl:text>&#xA;</xsl:text>
                    <ul class="pn2">
                      <xsl:for-each select="sub02/level02">
                        <li>
                          <xsl:call-template name="nav-li-class"/>
                          <xsl:call-template name="nav-item"/>

                          <!--  START level 3 navigation  -->
                          <xsl:if test=".//file[@ref=$context-id or starts-with($context-id, @start) and string(@start)]">
                            <xsl:text>&#xA;</xsl:text>
                            <ul class="pn3">
                              <xsl:for-each select="sub03/level03">
                                <li>
                                  <xsl:call-template name="nav-li-class"/>
                                  <xsl:call-template name="nav-item"/>

                                  <!--  START level 4 navigation  -->
                                  <xsl:if test=".//file[@ref=$context-id or starts-with($context-id, @start) and string(@start)]">
                                    <xsl:text>&#xA;</xsl:text>
                                    <ul class="pn4">
                                      <xsl:for-each select="sub04/level04">
                                        <li>
                                          <xsl:call-template name="nav-li-class"/>
                                          <xsl:call-template name="nav-item"/>
                                        </li>
                                      </xsl:for-each>
                                    </ul>
                                  </xsl:if>
                                  <!--  END level 4 navigation  -->
                                </li>
                              </xsl:for-each>
                            </ul>
                          </xsl:if>
                          <!--  END level 3 navigation  -->
                        </li>
                      </xsl:for-each>
                    </ul>
                  </xsl:if>
                  <!--  END level 2 navigation  -->
                </li>
              </xsl:for-each>
            </ul>
          </div>
          <!--  END level 1 navigation  -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Defines the class for navbar li - used only in navbar and not topNav navbar -->
  <xsl:template name="nav-li-class">
    <xsl:choose>
      <!-- If it is active -->
      <xsl:when test=".//file[@ref = $context-id or starts-with($context-id, @start) and string(@start)]">
        <xsl:call-template name="nav-first-last">
          <xsl:with-param name="first" select="'s06'"/>
          <xsl:with-param name="last" select="'s08'"/>
          <xsl:with-param name="norm" select="'s04'"/>
        </xsl:call-template>
      </xsl:when>
      <!-- If it has a sublevel but is dormant -->
      <xsl:when test="child::active">
        <xsl:call-template name="nav-first-last">
          <xsl:with-param name="first" select="'s05'"/>
          <xsl:with-param name="last" select="'s07'"/>
          <xsl:with-param name="norm" select="'s03'"/>
        </xsl:call-template>
      </xsl:when>
      <!-- The norm -->
      <xsl:otherwise>
        <xsl:call-template name="nav-first-last"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Used in both navbar and topNav navbar -->
  <xsl:template name="nav-first-last">
    <!-- Parameters from nav-li-class for active and dormant li -->
    <xsl:param name="first" select="'s01'"/>
    <xsl:param name="last" select="'s02'"/>
    <xsl:param name="norm"/>

    <xsl:variable name="cur-level" select="local-name()"/>

    <xsl:variable name="count-li">
      <xsl:text>i</xsl:text>
      <xsl:value-of select="count(preceding-sibling::*) + 1"/>
    </xsl:variable>

    <xsl:choose>
      <!-- first page in the level -->
      <xsl:when test="not(preceding-sibling::*[name() = $cur-level])">
        <xsl:attribute name="class">
          <xsl:value-of select="$first"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$count-li"/>
        </xsl:attribute>
      </xsl:when>
      <!-- last page in the level -->
      <xsl:when test="not(following-sibling::*[name() = $cur-level])">
        <xsl:attribute name="class">
          <xsl:value-of select="$last"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$count-li"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="class">
          <xsl:if test="string($norm)">
            <xsl:value-of select="$norm"/>
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:value-of select="$count-li"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Last page class - only used in topNav navbar for level02 -->
  <xsl:template name="nav-top-last">
    <xsl:if test="not(following-sibling::level02)">
      <xsl:attribute name="class">
        <xsl:text>s02</xsl:text>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="nav-item">
    <!-- Sets up context //Gets @ref from 'AL_navbar.xml'  -->
    <xsl:variable name="nav_default_id" select="default/@ref"/>

    <!-- Outputs filePath for a given navbar item //  -->
    <xsl:variable name="nav_default_path" select="//filebase//group[item[@id=$nav_default_id]]/groupHead/groupFolder"/>

    <!-- Outputs fileName for a given navbar item // Then matches that with fileBase to get fileName // Then adds '.html' -->
    <xsl:variable name="nav_default_name" select="//filebase//item[@id=$nav_default_id]/fileName"/>
    <xsl:variable name="nav_default_fullname" select="concat($nav_default_name, '.html')"/>

    <!-- Outputs filePath plus fileName -->
    <xsl:variable name="nav_default" select="concat($linkroot, $nav_default_path, '/', $nav_default_fullname)"/>

    <!-- Outputs text for each nav item // Option 1 takes it from 'AL_fileBase.xml' // Option 2 takes it from 'AL_navbar.xml' -->
    <xsl:variable name="nav_fileTitle" select="//filebase//item[@id=$nav_default_id]/fileTitle"/>
    <xsl:variable name="nav_label" select="label"/>

    <a>
      <!-- Active page Class -->
      <xsl:if test="descendant::*[@ref=$loc-id]">
        <xsl:attribute name="class">
          <xsl:text>s03</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <!-- Special case added for search -->
      <xsl:if test=".//file[@ref = $context-id or starts-with($context-id, @start) and string(@start)]">
        <xsl:attribute name="class">
          <xsl:text>s03</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <!-- External page Class -->
      <xsl:if test="default/@type='external'">
        <xsl:attribute name="class">
          <xsl:text>ext</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href">
        <!-- Check for external links -->
        <xsl:choose>
          <xsl:when test="default/@type='external'">
            <xsl:value-of select="default/@ref"/>
          </xsl:when>
          <!-- Otherwise, look in fileBase for a fileTitle -->
          <xsl:otherwise>
            <xsl:value-of select="$nav_default"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <!-- If 'AL_navbar.xml' entry does not have a 'label' element or it is empty, look in fileBase for a fileTitle  -->
      <xsl:choose>
        <xsl:when test="not(string(label))">
          <span>
            <xsl:value-of select="$nav_fileTitle"/>
          </span>
        </xsl:when>
        <!-- Otherwise, use 'label' in 'AL_navbar.xml' -->
        <xsl:otherwise>
          <span>
            <xsl:value-of select="$nav_label"/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template name="ctpl_footer">
    <div id="footer">
      <div class="utilLinks">
        <div class="s01">
          <ul>
            <li>
              <xsl:text>Last Updated: </xsl:text>
              <!-- Add last update code here-->
              <xsl:value-of select="format-date(current-date(), '[FNn], [MNn] [D01], [Y0001]')"/>
            </li>
            <li>&#xa9; 2008</li>
            <li>Resp: <a href="http://www.kcl.ac.uk/cch">CCH</a></li>
            <li class="s01">
              <span>Powered by </span>
              <a href="http://www.kcl.ac.uk/cch/xmod/" title="link to the xMod home page">
                <span>xMod 1.3</span>
              </a>
            </li>
          </ul>
        </div>
        <div class="s02"> &#xa9;<strong>2005</strong> King's College London, Strand, London WC2R 2LS, England, United Kingdom. Tel +44 (0)20 7836 5454 </div>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
