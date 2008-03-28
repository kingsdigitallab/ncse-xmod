<?xml version="1.0"?>
<!-- $Id: plist_tpkey.xsl 598 2007-09-03 15:51:05Z zau $ -->
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

  <xsl:variable name="nameid">
    <xsl:value-of select="authorityList/@id"/>
    <xsl:value-of select="projectList/@id"/>
  </xsl:variable>

  <xsl:template match="authorityList|projectList">
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
    <p>
      <xsl:text>The following table is for checking purposes. There is further explanation </xsl:text>
      <a class="content" href="#bottom">below</a>
    </p>

    <h2>Quick links to groups</h2>
    <table class="links">
      <xsl:for-each select="//group">
        <xsl:if test="position() mod 6 = 1">
          <tr>
            <td class="links">
              <a class="content" href="#{@id}">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>]</xsl:text>
              </a>
            </td>
            <td class="links">
              <xsl:if test="following::group[1]">
                <a class="content" href="#{following::group[1]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::group[1]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="links">
              <xsl:if test="following::group[2]">
                <a class="content" href="#{following::group[2]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::group[2]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="links">
              <xsl:if test="following::group[3]">
                <a class="content" href="#{following::group[3]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::group[3]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="links">
              <xsl:if test="following::group[4]">
                <a class="content" href="#{following::group[4]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::group[4]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="links">
              <xsl:if test="following::group[5]">
                <a class="content" href="#{following::group[5]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::group[5]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>



    <h2>List of projects</h2>
    <table class="list">
      <xsl:for-each select="//project">
        <xsl:if test="position() mod 9 = 1">
          <tr>
            <td class="list">
              <a class="content" href="#{@id}">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>]</xsl:text>
              </a>
            </td>
            <td class="list">
              <xsl:if test="following::project[1]">
                <a class="content" href="#{following::project[1]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::project[1]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::project[2]">
                <a class="content" href="#{following::project[2]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::project[2]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::project[3]">
                <a class="content" href="#{following::project[3]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::project[3]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::project[4]">
                <a class="content" href="#{following::project[4]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::project[4]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::project[5]">
                <a class="content" href="#{following::project[5]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::project[5]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::project[6]">
                <a class="content" href="#{following::project[6]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::project[6]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::project[7]">
                <a class="content" href="#{following::project[7]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::project[7]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::project[8]">
                <a class="content" href="#{following::project[8]/@id}">
                  <xsl:text>[</xsl:text>
                  <xsl:value-of select="following::project[8]/@id"/>
                  <xsl:text>]</xsl:text>
                </a>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>


    <h2>Main tables</h2>
    <xsl:apply-templates select="//group"/>

    <a name="bottom" id="bottom"/>


    <h2>Explanation of table headings</h2>

    <h2>Warnings</h2>

    <p>The following warnings are possible:</p>

    <ul>
      <li>
        <strong>CONTENT MISSING</strong>
        <xsl:text>: if there is no content for an essential attribute, e.g. an 'id' attribute.</xsl:text>
      </li>
      <li>
        <strong>TOO SHORT?</strong>
        <xsl:text>: If some attributes or elements have just one character then a warning message appears.</xsl:text>
      </li>
      <li>Many elements or attributes can be empty, these have been shown with a plain grey
        backround.</li>
    </ul>

    <h2>Full &lt;header&gt; information</h2>

    <p>The authority list contains a header element with information. Here is the content of
    that:</p>
  </xsl:template>



  <!-- CTPL_GROUP -->
  <xsl:template name="ctpl_group">
    <table cellspacing="3" cellpadding="6" class="group">
      <tr>
        <th>
          <h3>Group:</h3>
        </th>
        <td>
          <p>
            <xsl:text> [@id] </xsl:text>
            <span class="keyid">
              <strong>
                <xsl:value-of select="@id"/>
              </strong>
            </span>
            <br/>
            <xsl:text> [groupTitle] </xsl:text>
            <strong>
              <xsl:value-of select="groupHead/groupTitle"/>
            </strong>
            <br/>
            <xsl:text> [groupFolder] </xsl:text>
            <span class="ftype">
              <xsl:value-of select="groupHead/groupFolder"/>
            </span>
          </p>
        </td>
      </tr>
    </table>
    <br clear="all"/>
    <xsl:if test="child::project">
      <!-- MAIN TABLE STARTS -->
      <xsl:apply-templates select="project">
        <xsl:sort select="@id" order="ascending"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>



  <!--	  GROUP     -->
  <xsl:template match="group">
    <xsl:choose>
      <!-- 	 LEVEL ONE -->
      <xsl:when test="parent::body">
        <hr size="1"/>
        <a id="{@id}">&#160;</a>
        <div class="level1">
          <xsl:call-template name="ctpl_group"/>
        </div>
      </xsl:when>
      <!-- 	 LEVEL TWO   -->
      <xsl:when test="../parent::body">
        <hr size="1"/>
        <a id="{@id}">&#160;</a>
        <div class="level2">
          <xsl:call-template name="ctpl_group"/>
        </div>
      </xsl:when>
      <!-- 	LEVEL THREE -->
      <xsl:otherwise>
        <a id="{@id}">&#160;</a>
        <div class="level3">
          <xsl:call-template name="ctpl_group"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!--	  project     -->
  <xsl:template match="project">
    <table border="1" width="100%" cellspacing="3" cellpadding="6">
      <tr>
        <th valign="top" class="id" width="10%">
          <a id="{@id}">&#160;</a>
          <xsl:text>@id:</xsl:text>
        </th>
        <td valign="top" width="15%" class="keyid">
          <xsl:apply-templates select="@id"/>
        </td>
        <th valign="top" class="tablenormal" width="10%">Acronym:</th>
        <td valign="top" width="15%">
          <xsl:apply-templates select="acronym"/>
        </td>
      </tr>
      <tr>
        <th valign="top" class="tablenormal" width="10%">Project Title</th>
        <xsl:choose>
          <xsl:when test="not(string(projTitle))">
            <td valign="top" class="warning3" colspan="3"> EMPTY </td>
          </xsl:when>
          <xsl:otherwise>
            <td valign="top" colspan="3">
              <xsl:apply-templates select="projTitle"/>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
      <tr>
        <th valign="top" class="tablenormal" width="10%">Project Description</th>
        <td valign="top" colspan="3">
          <xsl:apply-templates select="projDescrip"/>
        </td>
      </tr>
      <tr>
        <th valign="top" class="tablenormal" width="10%">Project Partners</th>
        <td valign="top" colspan="3">
          <xsl:choose>
            <xsl:when test="not(string(projPartners))"> &#xa0; </xsl:when>
            <xsl:otherwise>
              <ul>
                <xsl:apply-templates select="projPartners"/>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <th valign="top" class="tablenormal" width="10%">Sites</th>
        <td valign="top" colspan="3">
          <xsl:choose>
            <xsl:when test="not(string(sites))"> &#xa0; </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="sites"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <th valign="top" class="tablenormal" width="10%">Internal</th>
        <td valign="top" colspan="3">
          <xsl:apply-templates select="internal"/>
        </td>
      </tr>
    </table>
    <br clear="all"/>
  </xsl:template>




  <!--     OTHER     -->
  <xsl:template match="person">
    <li>
      <xsl:choose>
        <xsl:when test="not(string(ttl))"> </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="ttl"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="not(string(first))"> </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="first"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="not(string(surname))"> </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="surname"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="not(string(institution))"> </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="institution"/>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="ttl">
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="surname">
    <xsl:apply-templates/>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template match="first">
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="institution">
    <xsl:text>Institution: </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!--<xsl:template match="sites">
  	<xsl:apply-templates select="site[@type='official']"/>
  	<xsl:apply-templates select="site[@type='internal']"/>
</xsl:template>-->

  <xsl:template match="site[@type='internal']">
    <p>
      <xsl:apply-templates/>
      <xsl:text>: </xsl:text>
      <a class="content" href="{@url}">
        <xsl:apply-templates select="./@url"/>
      </a>
    </p>
  </xsl:template>

  <xsl:template match="site[@type='official']">
    <p>
      <xsl:apply-templates/>
      <xsl:text>: </xsl:text>
      <a class="content" href="{@url}">
        <xsl:apply-templates select="./@url"/>
      </a>
    </p>
  </xsl:template>
</xsl:stylesheet>
