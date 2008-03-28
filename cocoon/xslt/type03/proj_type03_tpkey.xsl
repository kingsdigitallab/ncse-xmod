<?xml version="1.0" ?>
<!-- $Id: proj_type03_tpkey.xsl 629 2007-09-06 14:51:43Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">

  <xsl:strip-space elements="group"/>

  <xsl:template match="group/text">
    <xsl:if test="contains(@id, $context-id)">
      <xsl:call-template name="html_tpl"/>
    </xsl:if>
  </xsl:template>



  <!-- MAIN AREAS OF SITE -->
  <!-- All calls come from proj_tpl.xsl -->

  <xsl:template name="ctpl_submenu">
    <div class="submenu">
      <div class="t02">
        <!--<h3>Submenu</h3>-->
        <ul>
          <xsl:for-each select=".//body">
            <xsl:variable name="filename" select="substring-after(parent::text/@id, $text-type03-pre)"/>
            
            <li>
              <a href="{$filename}.html">
                <xsl:choose>
                  <xsl:when test="head and string(head)">
                    <xsl:apply-templates select="head" mode="submenu"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text> Section </xsl:text>
                    <xsl:value-of select="position()"/>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>



  <xsl:variable name="pagehead">
    <xsl:apply-templates select="/aggregation/TEI.2/teiHeader/fileDesc/titleStmt/title[1]" mode="htmltitle"/>    
  </xsl:variable>
  <xsl:template match="note" mode="htmltitle"/>
  
  <xsl:template name="ctpl_pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:apply-templates select="/aggregation/TEI.2/teiHeader/fileDesc/titleStmt/title[1]" mode="pagehead"/>
          <xsl:text>: </xsl:text>
          <xsl:apply-templates select="body/head" mode="pagehead"/>
        </h1>
      </div>
    </div>
  </xsl:template>



  <xsl:template name="ctpl_rhcontent">
    <xsl:variable name="rhcontent">
      <xsl:call-template name="tpl_rhcontent"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$rhcontent='on'">
        <!--  CHOOSE OPTIONS BELOW AS APPROPRIATE  -->
        <div id="rightContent">

          <!--  Table of contents  -->
          <!-- OPTIONS: As default, a TOC is only output if there are actually any divisional headings. Footnotes are not included in the TOC. -->
          <xsl:if test="text/body/div/head or text/front/div/head or text/back/div/head">
            <div class="toc">
              <div class="t01">
                <h3>Document contents</h3>
                <ul>
                  <xsl:for-each select="/aggregation/TEI.2/text/*/div/head">
                    <li>
                      <a href="#{generate-id()}">
                        <span>
                          <xsl:apply-templates select="." mode="toc"/>
                        </span>
                      </a>
                    </li>
                  </xsl:for-each>
                </ul>
              </div>
            </div>
          </xsl:if>

          <!--  Quick links  -->
          <!-- As used on CCH website, subsidiary navigation -->
          <div class="quickLinks">
            <div class="t01">
              <h3>Quicklinks</h3>
              <ul>
                <li>
                  <a href="">
                    <span>Quicklink</span>
                  </a>
                </li>
                <li>
                  <a href="">
                    <span>Quicklink</span>
                  </a>
                </li>
                <li>
                  <a href="">
                    <span>Quicklink</span>
                  </a>
                </li>
                <li>
                  <a href="">
                    <span>Quicklink with some additional text</span>
                  </a>
                </li>
              </ul>
            </div>
          </div>

          <!--  Promotional article  -->
          <div class="promoArticle">
            <!-- This is a start on the code for promo article, not finished yet -->

            <!-- Find info for images -->
            <!-- e.g. img001.gif -->

            <!-- folder info -->
            <xsl:variable name="img-group-folder"
              select="/aggregation/imagebase//image[@id=current()/@url]/parent::*/groupHead/groupFolder"/>
            <xsl:variable name="img-subpath-full" select="'full/'"/>
            <xsl:variable name="img-subpath-thumb" select="'thumb/'"/>
            <!-- file info -->
            <xsl:variable name="img-id" select="/aggregation/imagebase//image[@id=current()/@url]/@id"/>
            <xsl:variable name="img-ext"
              select="/aggregation/imagebase//image[@id=current()/@url]/ext/@n"/>
            <xsl:variable name="img-src" select="concat($img-id, '.', $img-ext)"/>
            <xsl:variable name="img-thm-prefix" select="'thm_'"/>
            <!-- other info -->
            <xsl:variable name="img-caption"
              select="/aggregation/imagebase//image[@id=current()/@url]/caption"/>
            <xsl:variable name="img-desc"
              select="/aggregation/imagebase//image[@id=current()/@url]/desc"/>
            <xsl:variable name="img-width"
              select="/aggregation/imagebase//image[@id=current()/@url]/width"/>
            <xsl:variable name="img-height"
              select="/aggregation/imagebase//image[@id=current()/@url]/height"/>

            <div class="t01">
              <h3>Promo Article</h3>
              <!-- Target output -->
              <dl>
                <dt>
                  <img title="" alt="" width="150">
                    <xsl:attribute name="src"><xsl:value-of
                        select="$pubimgswitch"/><xsl:value-of select="$img-subpath-full"
                    />img001.jpg</xsl:attribute>
                  </img>
                </dt>
                <dd>
                  <p>Photo by Don McPhee, The Guardian</p>
                </dd>
              </dl>

              <!-- Code in progress -->
              <!-- START WIP -->
              <!-- 
                            <dl>
                                <dt>                                
                                    <img>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="$pubimgswitch" />
                                            <xsl:value-of select="$img-subpath-full" />
                                            <xsl:value-of select="$img-src" />
                                        </xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="string($img-desc)">
                                                <xsl:attribute name="alt"><xsl:value-of select="$img-desc" /></xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="alt"><xsl:value-of select="$img-caption" /></xsl:attribute>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:attribute name="title"><xsl:value-of select="$img-caption" /></xsl:attribute>
                                        <xsl:attribute name="width"><xsl:value-of select="$img-width" /></xsl:attribute>
                                        <xsl:attribute name="height"><xsl:value-of select="$img-height" /></xsl:attribute>
                                    </img>
                                </dt>
                                <dd><p><xsl:value-of select="$img-caption" /></p></dd>
                            </dl>
                         -->
              <!-- END WIP -->

            </div>
          </div>
          <!--  End of RH options  -->
        </div>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="ctpl_content">
    <xsl:apply-templates/>
  </xsl:template>



  <xsl:template name="ctpl_toc1">
    <xsl:call-template name="ctpl_toc"/>
  </xsl:template>

  <xsl:template name="ctpl_toc2">
    <xsl:call-template name="ctpl_toc"/>
  </xsl:template>

  <!-- OPTIONS: As default, a TOC is only output if there are actually any divisional headings. Footnotes are not included in the TOC. -->
  <!-- If top and bottom TOC content need to differ change in the separate templates above.-->
  <xsl:template name="ctpl_toc">
    <xsl:if test="body/div/head">
      <div class="toc">
        <div class="t01">
          <h3>Document Contents</h3>
          <ul>
            <xsl:for-each select="body/div/head">
              <li>
                <a href="#{generate-id()}">
                  <span>
                    <xsl:apply-templates select="." mode="toc"/>
                  </span>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </div>
      </div>
    </xsl:if>
  </xsl:template>



  <xsl:template name="ctpl_footnotes">
    <xsl:if test=".//note">
      <div class="footnotes">
        <h3>Footnotes</h3>
        <dl>
          <!-- START model for each footnote -->
          <xsl:for-each select=".//note">
            <xsl:variable name="fnnum">
              <xsl:number level="any"/>
            </xsl:variable>
            <xsl:variable name="fnnumfull">
              <xsl:number level="any" format="01"/>
            </xsl:variable>

            <dt id="fn{$fnnumfull}"><xsl:value-of select="$fnnum"/>.</dt>
            <dd>
              <xsl:apply-templates/>
              <xsl:text> </xsl:text>
              <a href="#fnLink{$fnnumfull}" class="back">Back to context...</a>
            </dd>
          </xsl:for-each>
        </dl>
        <!-- END model for each footnote -->
      </div>
    </xsl:if>
  </xsl:template>



  <xsl:template name="ctpl_options1">
    <div class="options">
      <div class="t01">
        <xsl:call-template name="ctpl_option"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="ctpl_options2">
    <div class="options">
      <div class="t02">
        <xsl:call-template name="ctpl_option"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="ctpl_option">
    <xsl:variable name="fileprefix" select="/aggregation/TEI.2/@n"/>
    <xsl:variable name="cur-text-position" select="position()"/>
    <xsl:variable name="last-text-position" select="format-number(count(//text/group/text), '00')"/>
    <xsl:variable name="filesuffix" select="format-number($cur-text-position, '00')"/>
    <ul>
      <li>
        <a href="{substring-after(ancestor::TEI.2/text/group/text[1]/@id, $text-type03-pre)}.html" class="s01">
          <span>First Page</span>
        </a>
      </li>
      <xsl:if test="preceding-sibling::text">
        <li>
          <a href="{substring-after(preceding-sibling::text[1]/@id, $text-type03-pre)}.html" class="s02">
            <span>Previous Page</span>
          </a>
        </li>
      </xsl:if>
      <xsl:if test="following-sibling::text">
        <li>
          <a href="{substring-after(following-sibling::text[1]/@id, $text-type03-pre)}.html" class="s03">
            <span>Next Page</span>
          </a>
        </li>
      </xsl:if>
      <li>
        <a href="{substring-after(ancestor::TEI.2/text/group/text[not(following-sibling::text)]/@id, $text-type03-pre)}.html" class="s04">
          <span>Last Page</span>
        </a>
      </li>
      <!--
                <li>
                    <a href="" class="s05">
                        <span>1</span>
                    </a>
                </li>
                <li>
                    <a href="" class="s06">
                    <span>Previous</span>
                    </a>
                </li>
                <li>
                    <a href="" class="s07">
                    <span>Next</span>
                    </a>
                </li>
                <li>
                    <a href="" class="s08">
                    <span>Search</span>
                    </a>
                </li>
                <li>
                    <a href="" class="s09">
                    <span>Search Again</span>
                    </a>
                </li>
                <li>
                    <a href="" class="s10">
                    <span>Refine Search</span>
                    </a>
                </li>
                <li>
                    <a href="" class="s11">
                        <span>Print this Page</span>
                    </a>
                </li>
            -->
    </ul>
  </xsl:template>
</xsl:stylesheet>
