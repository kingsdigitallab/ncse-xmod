<?xml version="1.0" ?>
<!-- $Id: proj_indices_tpkey.xsl 594 2007-08-31 16:13:54Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">

  <xsl:strip-space elements="group"/>

  <xsl:template match="/">
    <xsl:call-template name="html_tpl"/>
  </xsl:template>


  <!--   MAIN AREAS OF SITE     -->
  <!-- All calls come from proj_tpl.xsl -->

  <xsl:template name="ctpl_submenu">
    <div class="submenu">
      <div class="t01">
        <ul>
          <li>
            <a href="">Submenu option 01</a>
          </li>
          <li>
            <a href="">Submenu option 02</a>
          </li>
          <li>
            <a href="">Submenu option 03</a>
          </li>
          <li>
            <a href="">Submenu option 04</a>
          </li>
          <li>
            <a href="">Submenu option 05</a>
          </li>
        </ul>
      </div>
    </div>
  </xsl:template>


  <xsl:variable name="pagehead">
    <xsl:value-of select="/aggregation/coreAL/filebase//item[@id = $context-id]/fileTitle"/>
  </xsl:variable>
  <xsl:template name="ctpl_pagehead">

    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of select="$pagehead"/>
        </h1>
      </div>
    </div>
  </xsl:template>



  <xsl:template name="ctpl_rhcontent">
    <!-- Sets right hand content variable within correct context -->
    <xsl:variable name="rhcontent">
      <xsl:call-template name="tpl_rhcontent"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$rhcontent='on'">
        <!-- CHOOSE OPTIONS BELOW AS APPROPRIATE -->
        <div id="rightContent">

          <!-- Table of contents -->
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

          <!-- Quick links -->
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

          <!-- Promotional article -->
          <div class="promoArticle">

            <!-- This is a start on the code for promo article, not finished yet -->
            <!--  Find info for  images -->
            <!-- e.g. img001.gif -->

            <!-- folder info -->
            <xsl:variable name="img-group-folder"
              select="//imagebase//image[@id=current()/@url]/parent::*/groupHead/groupFolder"/>
            <xsl:variable name="img-subpath-full" select="'full/'"/>
            <xsl:variable name="img-subpath-thumb" select="'thumb/'"/>
            <!-- file info -->
            <xsl:variable name="img-id" select="//imagebase//image[@id=current()/@url]/@id"/>
            <xsl:variable name="img-ext"
              select="//imagebase//image[@id=current()/@url]/ext/@n"/>
            <xsl:variable name="img-src" select="concat($img-id, '.', $img-ext)"/>
            <xsl:variable name="img-thm-prefix" select="'thm_'"/>
            <!-- other info -->
            <xsl:variable name="img-caption"
              select="//imagebase//image[@id=current()/@url]/caption"/>
            <xsl:variable name="img-desc"
              select="//imagebase//image[@id=current()/@url]/desc"/>
            <xsl:variable name="img-width"
              select="//imagebase//image[@id=current()/@url]/width"/>
            <xsl:variable name="img-height"
              select="//imagebase//image[@id=current()/@url]/height"/>


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
                     <xsl:attribute name="src"><xsl:value-of select="$pubimgswitch" /><xsl:value-of select="$img-subpath-full" /><xsl:value-of select="$img-src" /></xsl:attribute>
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
          <!-- End of RH options -->
        </div>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="ctpl_content">
    <xsl:choose>
      <!-- Index by author for type02 and type03 -->
      <xsl:when test="starts-with($context-id, 'idx') and contains($context-id, '_auth')">
        <xsl:call-template name="tpl_idx_auth"/>
      </xsl:when>
      <!-- A-Z Index by keyword for type02 -->
      <xsl:when test="starts-with($context-id, 'idx') and contains($context-id, '_az')">
        <xsl:call-template name="tpl_idx_foreign_az"/>
      </xsl:when>
      <!-- Index by keyword with authority list for type02 -->
      <xsl:when test="starts-with($context-id, 'idx') and contains($context-id, '_key')">
        <xsl:call-template name="tpl_idx_foreign_key"/>
      </xsl:when>
      <!-- Index by keyword for type02 and type03 -->
      <xsl:when test="starts-with($context-id, 'idx') and contains($context-id, '_foreign')">
        <xsl:call-template name="tpl_idx_foreign"/>
      </xsl:when>
    </xsl:choose>    
  </xsl:template>



  <xsl:template name="ctpl_toc1">
    <xsl:if test="contains($context-id, '_az')">
      <div class="alphaNav">
        <div class="t01">
          <h3>Alphabetical Index</h3>
          <ul>
            <xsl:for-each
              select="/aggregation/TEI.2/row/head[generate-id(.)=generate-id(key('kwForeignAZ', translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'))[1])]">
              <xsl:variable name="letter">
                <xsl:value-of
                  select="translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"
                />
              </xsl:variable>
              
              <li>
                <xsl:choose>
                  <xsl:when test="not(contains('ABCDEFGHIJKLMNOPQRSTUVWXYZ', $letter))">
                    <a>
                      <xsl:attribute name="href">
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="substring(.,1,1)"/>
                      </xsl:attribute>
                      <xsl:value-of select="substring(.,1,1)"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="#{$letter}">
                      <xsl:value-of select="$letter"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </li>
            </xsl:for-each>
          </ul>
        </div>
      </div>
    </xsl:if>
    <!--<xsl:call-template name="ctpl_toc"/>-->
  </xsl:template>

  <xsl:template name="ctpl_toc2">
    <!--<xsl:call-template name="ctpl_toc"/>-->
  </xsl:template>

  <!-- OPTIONS: As default, a TOC is only output if there are actually any divisional headings. Footnotes are not included in the TOC. -->
  <!-- If top and bottom TOC content need to differ change in the separate templates above.  -->

  <xsl:template name="ctpl_toc">
    <xsl:if test="text/body/div/head or text/front/div/head or text/back/div/head">
      <div class="toc">
        <div class="t01">
          <h3>Document Contents</h3>
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
  </xsl:template>



  <xsl:template name="ctpl_footnotes">
  </xsl:template>



  <xsl:template name="ctpl_options1">
    <!--<div class="options">
      <div class="t01">
        <xsl:call-template name="ctpl_option"/>
      </div>
    </div>-->
  </xsl:template>

  <xsl:template name="ctpl_options2">
    <!--<div class="options">
      <div class="t02">
        <xsl:call-template name="ctpl_option"/>
      </div>
    </div>-->
  </xsl:template>

  <xsl:template name="ctpl_option">
    <ul>
      <li>
        <a href="" class="s01">
          <span>First Page</span>
        </a>
      </li>
      <li>
        <a href="" class="s02">
          <span>Previous Page</span>
        </a>
      </li>
      <li>
        <a href="" class="s03">
          <span>Next Page</span>
        </a>
      </li>
      <li>
        <a href="" class="s04">
          <span>Last Page</span>
        </a>
      </li>
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
    </ul>
  </xsl:template>

</xsl:stylesheet>
