<?xml version="1.0"?>
<!-- $Id: master_tpkey.xsl 598 2007-09-03 15:51:05Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">

  <xsl:output method="saxon:xhtml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>


  <!-- INCLUDES -->
  <xsl:include href="common_key.xsl"/>
  <xsl:include href="common_tpl.xsl"/>
  <xsl:include href="common_std.xsl"/>
  <xsl:include href="..\..\xslt\common\proj_vars.xsl"/>


  <xsl:strip-space elements="div"/>


  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:variable name="nameid" select="root/@id"/>

  <xsl:template match="root">
    <!--PATHCREATOR = CONSTRUCTS PATH FROM ROOT TO TARGET DIRECTORY -->
    <!-- GET IT FROM DOCSITE, USING THE TEI.2/@ID ATTRIBUTE -->
    <xsl:variable name="pathcreator"
      select="/aggregation/docsite//item[@id=current()/@id]/parent::*/groupHead/groupFolder"/>


    <!-- FILECREATOR = CONSTRUCTS CORRECT FILENAME FOR AN ID -->
    <xsl:variable name="filename" select="/aggregation/docsite//item[@id=current()/@id]/fileName"/>


    <!-- CALLS TEMPLATE TO CREATE HTML FILE -->
    <xsl:document href="{$docsiteroot}{$pathcreator}\{$filename}.html">
      <xsl:call-template name="html_tpl"/>
    </xsl:document>
  </xsl:template>




  <xsl:template name="ctpl_content">
    <!-- Start Filelist -->
    <h2>File list</h2>
    <p>
      <strong>Files processed: </strong>
      <xsl:apply-templates select="//TEI.2" mode="filelist"/>
    </p>
    <table class="list">
      <xsl:for-each select="//TEI.2">
        <xsl:if test="position() mod 9 = 1">
          <tr>
            <td class="list">
              <a class="content" href="#{@id}">
                <xsl:value-of select="@id"/>
              </a>
            </td>
            <td class="list">
              <xsl:if test="following::TEI.2[1]">
                <a class="content" href="#{following::TEI.2[1]/@id}">
                  <xsl:value-of select="following::TEI.2[1]/@id"/>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::TEI.2[2]">
                <a class="content" href="#{following::TEI.2[2]/@id}">
                  <xsl:value-of select="following::TEI.2[2]/@id"/>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::TEI.2[3]">
                <a class="content" href="#{following::TEI.2[3]/@id}">
                  <xsl:value-of select="following::TEI.2[3]/@id"/>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::TEI.2[4]">
                <a class="content" href="#{following::TEI.2[4]/@id}">
                  <xsl:value-of select="following::TEI.2[4]/@id"/>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::TEI.2[5]">
                <a class="content" href="#{following::TEI.2[5]/@id}">
                  <xsl:value-of select="following::TEI.2[5]/@id"/>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::TEI.2[6]">
                <a class="content" href="#{following::TEI.2[6]/@id}">
                  <xsl:value-of select="following::TEI.2[6]/@id"/>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::TEI.2[7]">
                <a class="content" href="#{following::TEI.2[7]/@id}">
                  <xsl:value-of select="following::TEI.2[7]/@id"/>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::TEI.2[8]">
                <a class="content" href="#{following::TEI.2[8]/@id}">
                  <xsl:value-of select="following::TEI.2[8]/@id"/>
                </a>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>



    <!-- Start Main table -->
    <h2>Quick summary of publications</h2>
    <table width="100%" cellpadding="6" class="detail">
      <tr>
        <th valign="top" class="main">autonum</th>
        <th valign="top" class="main">@n</th>
        <th valign="top" class="id">@id</th>
        <th valign="top" class="main">
          <xsl:text>&lt;titleStmt/title&gt; &amp; &lt;author&gt;</xsl:text>
        </th>
        <th valign="top" class="main">last &lt;change&gt;</th>
        <xsl:if test="//TEI.2//text//text">
          <th width="*" valign="top" class="main">&lt;group&gt;/&lt;text&gt;</th>
        </xsl:if>
      </tr>

      <xsl:for-each select="//TEI.2" mode="maintable">
        <tr>
          <td valign="top">
            <a id="{@id}">&#160;</a>
            <a>
              <xsl:attribute name="href">
                <xsl:text>#summ-</xsl:text>
                <xsl:number format="01"/>
              </xsl:attribute>
              <xsl:number format="01"/>
            </a>
          </td>
          <td valign="top">
            <a class="content" href="#{generate-id()}">
              <xsl:apply-templates select="@n"/>
            </a>
            <xsl:if test="not(string(@n))">
              <br/>
            </xsl:if>
          </td>
          <td valign="top">
            <xsl:choose>
              <xsl:when test="not(@id)">
                <xsl:attribute name="class">warning</xsl:attribute>
                <span class="warning">MISSING</span>
              </xsl:when>
              <xsl:when test="not(string(@id))">
                <xsl:attribute name="class">warning</xsl:attribute>
                <span class="warning">
                  <strong>EMPTY VALUE</strong>
                </span>
              </xsl:when>
              <xsl:when test="@id=preceding::*/@id">
                <xsl:attribute name="class">warning</xsl:attribute>
                <span class="warning">
                  <strong>REPEATED VALUE</strong>
                </span>:<br/>
                <xsl:apply-templates select="@id"/>&#xa0;</xsl:when>
              <xsl:otherwise>
                <span class="keyid">
                  <xsl:apply-templates select="@id"/>
                </span>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td valign="top">
            <xsl:apply-templates select="teiHeader/fileDesc/titleStmt/title"/>
            <br/>
            <xsl:apply-templates select="teiHeader/fileDesc/titleStmt/author"/>
          </td>
          <td valign="top">
            <strong>
              <xsl:apply-templates select="teiHeader/revisionDesc/change[1]/date"/>
            </strong>
            <br/>
            <xsl:apply-templates select="teiHeader/revisionDesc/change[1]/respStmt/name"/>
            <br/>
          </td>
          <xsl:if test="text//text">
            <td width="*" valign="top">
              <table width="100%" border="1" cellpadding="6" cellspacing="3">
                <tr>
                  <th class="subsid">#</th>
                  <th class="id">@id</th>
                  <th class="subsid">head</th>
                </tr>
                <xsl:for-each select="text//text">
                  <tr>
                    <!-- New cell starts -->
                    <td>
                      <xsl:number format="01"/>
                    </td>
                    <!-- New cell starts -->
                    <td>
                      <xsl:choose>
                        <xsl:when test="@id=preceding::*/@id">
                          <xsl:attribute name="class">warning</xsl:attribute>
                          <span class="warning">
                            <strong>REPEATED VALUE</strong>
                          </span>:<br/>
                          <xsl:apply-templates select="@id"/>&#xa0; </xsl:when>
                        <xsl:when test="not(@id)">
                          <xsl:attribute name="class">warning</xsl:attribute>
                          <span class="warning">MISSING</span>
                        </xsl:when>
                        <xsl:when test="not(string(@id))">
                          <xsl:attribute name="class">warning</xsl:attribute>
                          <span class="warning">
                            <strong>EMPTY VALUE</strong>
                          </span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="@id"/>&#xa0; </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <!-- New cell starts -->
                    <td class="table2">
                      <xsl:choose>
                        <xsl:when test="not(body/head)">
                          <xsl:attribute name="class">warning</xsl:attribute>
                          <span class="warning">MISSING</span>
                        </xsl:when>
                        <xsl:when test="not(string(body/head))">
                          <xsl:attribute name="class">warning</xsl:attribute>
                          <span class="warning">
                            <strong>EMPTY VALUE</strong>
                          </span>
                        </xsl:when>
                      </xsl:choose>
                      <xsl:apply-templates select="body/head"/>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
    <br clear="all"/>
    <!-- End Main table -->


    <!-- Start Main body -->
    <h2>Full information for publications</h2>
    <xsl:apply-templates select="//TEI.2"/>
    <!-- End Main body -->


    <!-- Start Filelist -->
    <xsl:call-template name="filelist"/>
    <!-- End Filelist -->
  </xsl:template>



  <xsl:template match="TEI.2">
    <a name="{generate-id()}">&#160;</a>
    <table width="100%" border="1" cellspacing="3" cellpadding="6">
      <tr>
        <th class="tablenormal" width="20%">Autonumber: </th>
        <td width="10%">
          <a>
            <xsl:attribute name="name">summ-<xsl:number format="01"/></xsl:attribute>
          </a>
          <strong>
            <xsl:number format="01"/>
          </strong>
        </td>
        <th class="id" width="15%">@id: </th>
        <td width="20%" class="keyid">
          <strong>
            <xsl:apply-templates select="@id"/>
          </strong>
        </td>
        <th class="tablenormal" width="15%">@n: </th>
        <td width="20%">
          <strong>
            <xsl:apply-templates select="@n"/>
          </strong>
          <xsl:if test="not(string(@n))"> &#xa0; </xsl:if>
        </td>
      </tr>
      <xsl:apply-templates select="teiHeader/fileDesc/titleStmt/title" mode="main"/>
      <xsl:apply-templates select="teiHeader/fileDesc/titleStmt/author" mode="main"/>
      <xsl:apply-templates/>

      <!-- Internal structure -->
      <tr>
        <th class="tablenormal" width="20%" valign="top">
          <xsl:text>Internal structure:</xsl:text>
          <br/>
          <br/>
          <br/>
          <small>
            <em>
              <xsl:text>[body/div/head </xsl:text>
              <br/>
              <xsl:text>and</xsl:text>
              <br/>
              <xsl:text>body/div/div/head]</xsl:text>
            </em>
          </small>
        </th>
        <td class="table3" colspan="5">
          <xsl:for-each select=".//group/text">
            <!-- output text/@id as heading -->
            <xsl:choose>
              <xsl:when test="not(string(@id))">
                <xsl:text> [</xsl:text>
                <span class="authList8">MISSING</span>
                <xsl:text>] </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text> [</xsl:text>
                <span class="authList8">
                  <xsl:apply-templates select="@id"/>
                </span>
                <xsl:text>] </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <!-- output div info -->
            <p>
              <xsl:for-each select="body/div">
                <xsl:text>&#xa0;&#xa0; [</xsl:text>
                <span class="authList7">
                  <xsl:number level="multiple" count="div" from="body" format="1"/>
                </span>
                <xsl:text>] &#xa0;&#xa0;</xsl:text>
                <xsl:apply-templates select="head"/>
                <xsl:if test="@type">
                  <xsl:text>&#xa0;&#xa0;</xsl:text>
                  <span class="authList5">
                    <xsl:value-of select="@type"/>
                  </span>
                  <xsl:text>&#xa0;&#xa0;</xsl:text>
                </xsl:if>
                <br/>
                <!-- next div starts -->
                <xsl:for-each select="div">
                  <xsl:text>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; [</xsl:text>
                  <span class="authList7">
                    <xsl:number level="multiple" count="div" from="body" format="1"/>
                  </span>
                  <xsl:text>] &#xa0;&#xa0;</xsl:text>
                  <xsl:apply-templates select="head"/>
                  <xsl:if test="@type">
                    <xsl:text>&#xa0;&#xa0;</xsl:text>
                    <span class="authList5">
                      <xsl:value-of select="@type"/>
                    </span>
                    <xsl:text>&#xa0;&#xa0;</xsl:text>
                  </xsl:if>
                  <br/>
                </xsl:for-each>
                <!-- next div ends -->
              </xsl:for-each>
            </p>
            <!-- output div infoends-->
          </xsl:for-each>
        </td>
      </tr>

      <!-- Chunk level problems-->
      <tr>
        <th class="tablenormal" width="20%" valign="top"> Chunk-level: </th>
        <td class="table3" colspan="5">
          <!-- paras -->
          <xsl:text> [</xsl:text>
          <span class="authList8">&lt;p&gt;</span>
          <xsl:text>] </xsl:text>
          <br/>
          <br/>
          <xsl:choose>
            <xsl:when test=".//p[child::list]">
              <xsl:for-each select=".//p[child::list]">
                <xsl:text> [</xsl:text>
                <span class="authList7">
                  <xsl:apply-templates select="ancestor::text[1]/@id"/>
                </span>
                <xsl:text>] </xsl:text>
                <span class="warning">&lt;p&gt; Can't contain &lt;list&gt;</span>
                <br/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test=".//p[child::q]">
              <xsl:for-each select=".//p[child::q]">
                <xsl:text> [</xsl:text>
                <span class="authList7">
                  <xsl:apply-templates select="ancestor::text[1]/@id"/>
                </span>
                <xsl:text>] </xsl:text>
                <span class="warning">&lt;p&gt; Can't contain &lt;q&gt;</span>
                <br/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test=".//p[child::p]">
              <xsl:for-each select=".//p[child::p]">
                <xsl:text> [</xsl:text>
                <span class="authList7">
                  <xsl:apply-templates select="ancestor::text[1]/@id"/>
                </span>
                <xsl:text>] </xsl:text>
                <span class="warning">&lt;p&gt; Can't contain &lt;p&gt;</span>
                <br/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise> No errors </xsl:otherwise>
          </xsl:choose>
          <br/>
          <br/>
          <xsl:text> [</xsl:text>
          <span class="authList8">&lt;q&gt;</span>
          <xsl:text>] </xsl:text>
          <br/>
          <br/>
          <xsl:choose>
            <xsl:when test=".//p[child::list]">
              <xsl:for-each select=".//p[child::list]">
                <xsl:text> [</xsl:text>
                <span class="authList7">
                  <xsl:apply-templates select="ancestor::text[1]/@id"/>
                </span>
                <xsl:text>] </xsl:text>
                <span class="warning">&lt;p&gt; Can't contain &lt;list&gt;</span>
                <br/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test=".//p[child::q]">
              <xsl:for-each select=".//p[child::q]">
                <xsl:text> [</xsl:text>
                <span class="authList7">
                  <xsl:apply-templates select="ancestor::text[1]/@id"/>
                </span>
                <xsl:text>] </xsl:text>
                <span class="warning">&lt;p&gt; Can't contain &lt;q&gt;</span>
                <br/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test=".//p[child::p]">
              <xsl:for-each select=".//p[child::p]">
                <xsl:text> [</xsl:text>
                <span class="authList7">
                  <xsl:apply-templates select="ancestor::text[1]/@id"/>
                </span>
                <xsl:text>] </xsl:text>
                <span class="warning">&lt;p&gt; Can't contain &lt;p&gt;</span>
                <br/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise> No errors </xsl:otherwise>
          </xsl:choose>
          <br/>
          <br/>
          <!-- list -->
          <xsl:text> [</xsl:text>
          <span class="authList8">&lt;list&gt;</span>
          <xsl:text>] </xsl:text>
          <br/>
          <br/>
          <xsl:if test="not(string(.//list/@type))">
            <xsl:for-each select=".//list[not(string(@type))]">
              <xsl:text> [</xsl:text>
              <span class="authList7">
                <xsl:apply-templates select="ancestor::text[1]/@id"/>
              </span>
              <xsl:text>] </xsl:text>
              <span class="warning">List needs a 'type' attribute</span>
              <br/>
            </xsl:for-each>
          </xsl:if>
          <xsl:if
            test="not(.//list/@type='ordered') and not(.//list/@type ='bulleted') and not(.//list/@type='simple') ">
            <xsl:for-each
              select=".//list[not(@type='ordered') or not(@type='bulleted') or not(@type='simple')]">
              <xsl:text> [</xsl:text>
              <span class="authList7">
                <xsl:apply-templates select="ancestor::text[1]/@id"/>
              </span>
              <xsl:text>] </xsl:text>
              <span class="warning">Value of 'type' attribute has not been contemplated. Please
                confer.</span>
              <br/>
            </xsl:for-each>
          </xsl:if>
          <xsl:text> &#xa0; </xsl:text>
        </td>
      </tr>



      <!-- Phrase-level problems -->
      <tr>
        <th class="tablenormal" width="20%" valign="top"> Phrase-level: </th>
        <td class="table3" colspan="5">
          <!-- bibl -->
          <xsl:text> [</xsl:text>
          <span class="authList8">Phrase-level elements</span>
          <xsl:text>] </xsl:text>
          <br/>
          <br/>
          <xsl:if test=".//bibl[parent::div]">
            <xsl:for-each select=".//bibl[parent::div]">
              <xsl:text> [</xsl:text>
              <span class="authList7">
                <xsl:apply-templates select="ancestor::text[1]/@id"/>
              </span>
              <xsl:text>] </xsl:text>
              <span class="warning">&lt;bibl&gt; Can't appear at chunk level</span>
              <br/>
            </xsl:for-each>
            <br/>
            <br/>
          </xsl:if>
          <xsl:if test=".//note[parent::div]">
            <xsl:for-each select=".//note[parent::div]">
              <xsl:text> [</xsl:text>
              <span class="authList7">
                <xsl:apply-templates select="ancestor::text[1]/@id"/>
              </span>
              <xsl:text>] </xsl:text>
              <span class="warning">&lt;note&gt; Can't appear at chunk level</span>
              <br/>
            </xsl:for-each>
            <br/>
            <br/>
          </xsl:if>
          <xsl:if test=".//figure[parent::div]">
            <xsl:for-each select=".//figure[parent::div]">
              <xsl:text> [</xsl:text>
              <span class="authList7">
                <xsl:apply-templates select="ancestor::text[1]/@id"/>
              </span>
              <xsl:text>] </xsl:text>
              <span class="warning">&lt;figure&gt; Can't appear at chunk level</span>
              <br/>
            </xsl:for-each>
            <br/>
            <br/>
          </xsl:if>
          <xsl:text> &#xa0; </xsl:text>
        </td>
      </tr>



      <!-- Images-->
      <tr>
        <th class="tablenormal" width="20%" valign="top"> Images: </th>
        <td class="table3" colspan="5">
          <xsl:if test=".//figure[not(starts-with(@url, 'a')) and not(starts-with(@url, 'c'))]">
            <xsl:for-each
              select=".//figure[not(starts-with(@url, 'a')) or not(starts-with(@url, 'c'))]">
              <xsl:text> [</xsl:text>
              <span class="authList7">
                <xsl:apply-templates select="ancestor::text[1]/@id"/>
              </span>
              <xsl:text>] </xsl:text>
              <span class="warning">&lt;figure&gt; has incorrect value for url attribute</span>
              <br/>
            </xsl:for-each>
            <br/>
            <br/>
          </xsl:if>
          <xsl:if test=".//figure[not(@url)]">
            <xsl:for-each select=".//figure[not(@url)]">
              <xsl:text> [</xsl:text>
              <span class="authList7">
                <xsl:apply-templates select="ancestor::text[1]/@id"/>
              </span>
              <xsl:text>] </xsl:text>
              <span class="warning">&lt;figure&gt; has no url attribute</span>
              <br/>
            </xsl:for-each>
            <br/>
            <br/>
          </xsl:if>
          <xsl:text> &#xa0; </xsl:text>
        </td>
      </tr>



      <!-- Linking problems-->
      <tr>
        <th class="tablenormal" width="20%" valign="top"> Links: </th>
        <td class="table3" colspan="5">
          <p>
            <xsl:text>[</xsl:text>
            <span class="authList8">&lt;xref&gt;</span>
            <xsl:text>]</xsl:text>
          </p>
          <ul>
            <xsl:apply-templates select=".//xref" mode="links"/>
          </ul>
        </td>
      </tr>


      <!-- Linking problems-->
      <tr>
        <th class="tablenormal" width="20%" valign="top"> Other links: </th>
        <td class="table3" colspan="5">
          <p>
            <xsl:text>[</xsl:text>
            <span class="authList8">&lt;xref&gt;</span>
            <xsl:text>]</xsl:text>
          </p>
          <ul>
            <xsl:apply-templates select=".//ref" mode="links"/>
          </ul>
        </td>
      </tr>
      <!-- End of error checking -->
    </table>
    <br clear="all"/>
    <br/>
    <br/>
  </xsl:template>




  <xsl:template match="teiHeader"> </xsl:template>

  <xsl:template match="TEI.2/text"> </xsl:template>

  <xsl:template match="note"> </xsl:template>

  <xsl:template match="note" mode="main"> </xsl:template>




  <xsl:template match="titleStmt/title" mode="main">
    <xsl:choose>
      <xsl:when test="@type='sub'">
        <tr>
          <th class="tablenormal" width="20%">Subtitle: </th>
          <td class="authList3" colspan="5">
            <em>
              <xsl:apply-templates/>
            </em>
          </td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <th class="tablenormal" width="20%">Main title: </th>
          <td class="authList1" colspan="5">
            <strong>
              <xsl:apply-templates/>
            </strong>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="titleStmt/author" mode="main">
    <tr>
      <th class="tablenormal" width="20%">Author: </th>
      <td class="authList9" colspan="5">
        <strong>
          <xsl:apply-templates/>
        </strong>
      </td>
    </tr>
  </xsl:template>



  <!--LINKS -->
  <xsl:template match="xref" mode="links">
    <xsl:variable name="fileBase-from" select="document($filebase)//item[@id=current()/@from]/@id"/>
    <xsl:variable name="fileBase-from-fileName"
      select="document($filebase)//item[@id=current()/@from]/fileName"/>
    <xsl:variable name="fileBase-from-folderName"
      select="document($filebase)//item[@id=current()/@from]/parent::group/groupHead/groupFolder"/>
    <xsl:variable name="fileBase-from-fileExtension" select="'html'"/>

    <li>
      <!-- TESTING FOR '@REND' STARTS -->
      <xsl:choose>
        <!-- EXTERNAL LINKS -->
        <xsl:when test="@rend='external'">
          <span class="authList3">
            <xsl:apply-templates/>
          </span>
          <br/>
          <xsl:choose>
            <xsl:when test="not(starts-with(@url, 'http://'))">
              <span class="warning">Shouldn't @url start with 'http://'?</span>
            </xsl:when>
            <xsl:when test="not(@url)">
              <span class="warning">Missing @url</span>
            </xsl:when>
            <xsl:otherwise>
              <a class="content" href="{@url}" target="_blank">
                <xsl:apply-templates select="@url"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- EMAILS -->
        <xsl:when test="@rend='email'">
          <span class="authList9">
            <xsl:apply-templates/>
          </span>
          <br/>
          <xsl:choose>
            <xsl:when test="not(contains(@url, '@'))">
              <span class="warning">Shouldn't it contain an '@' somewhere?</span>
            </xsl:when>
            <xsl:when test="not(@url)">
              <span class="warning">Missing @url</span>
            </xsl:when>
            <xsl:otherwise>
              <a class="content" href="{@url}" target="_blank">
                <xsl:apply-templates select="@url"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- INTERNAL -->
        <xsl:when test="@rend='internal'">
          <span class="authList10">
            <xsl:apply-templates/>
          </span>
          <br/>
          <xsl:choose>
            <xsl:when test="@type='mapinternal'">
              <xsl:if test="@url">
                <span class="warning">If it is an internal map link, it shouldn't contain a @url</span>
                <br/>
              </xsl:if>
              <xsl:if test="not(@doc)">
                <span class="warning">The @doc is missing</span>
                <br/>
              </xsl:if>
              <xsl:if test="not(string(@doc))">
                <span class="warning">There is no content for the @doc</span>
                <br/>
              </xsl:if>
              <xsl:if test="not(contains(@doc, '.html'))">
                <span class="warning">Unusually, this special kind of link needs a relative link to
                  a real html file. See the notes.</span>
                <br/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="not($fileBase-from)">
                <span class="warning">
                  <xsl:text>@from="</xsl:text>
                  <xsl:apply-templates select="@from"/>
                  <xsl:text>" doesn't match any file in the fileBase</xsl:text>
                </span>
              </xsl:if>
              <xsl:text> Path: </xsl:text>
              <span class="authList11">
                <xsl:value-of select="$fileBase-from-folderName"/>
                <xsl:text>/</xsl:text>
              </span>
              <span class="att">
                <xsl:value-of select="$fileBase-from-fileName"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="$fileBase-from-fileExtension"/>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <span class="warning">Missing or incorrect @rend value</span>
        </xsl:otherwise>
      </xsl:choose>
      <br/>
      <xsl:text> [</xsl:text>
      <xsl:value-of select="@rend"/>
      <xsl:text>] </xsl:text>
      <xsl:if test="@from!='ROOT'">
        <xsl:text> [@from="</xsl:text>
        <span class="authList6">
          <xsl:apply-templates select="@from"/>
        </span>
        <xsl:text>"] </xsl:text>
      </xsl:if>
    </li>
  </xsl:template>




  <xsl:template name="ref" mode="links">
    <li>
      <xsl:value-of select="@target"/>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  
  
  <!-- FILELIST -->
  <xsl:template name="filelist">
    <h2>File list</h2>
    <p>
      <strong>Files processed: </strong>
      <xsl:apply-templates select="//TEI.2" mode="filelist"/>
    </p>
  </xsl:template>
  
  

  <xsl:template match="TEI.2" mode="filelist">
    <!--
      <a>
        <xsl:attribute name="href">
          <xsl:text>#summ-</xsl:text>
          <xsl:number format="01" />
        </xsl:attribute>
        <xsl:apply-templates select="@id" />
      </a>
      <xsl:if test="position() != last()">
        <xsl:text> | </xsl:text>
        </xsl:if>
    -->
  </xsl:template>



</xsl:stylesheet>
