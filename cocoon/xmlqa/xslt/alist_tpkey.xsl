<?xml version="1.0"?>
<!-- $Id: alist_tpkey.xsl 598 2007-09-03 15:51:05Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">

  <!-- INCLUDES -->
  <xsl:include href="common_key.xsl"/>
  <xsl:include href="common_tpl.xsl"/>
  <xsl:include href="common_std.xsl"/>
  <xsl:include href="..\..\xslt\common\proj_vars.xsl"/>


  <xsl:strip-space elements="div"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$context-id = 'iAL_docsite'">
        <xsl:apply-templates select="//docsite"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="//source"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="authorityList|projectList">
    <xsl:call-template name="html_tpl"/>
  </xsl:template>



  <!-- CTPL_CONTENT-->
  <xsl:template name="ctpl_content">
    <p>
      <xsl:text>The following table is for checking purposes. There is further explanation </xsl:text>
      <a class="content" href="#bottom">below</a>
    </p>

    <xsl:choose>
      <xsl:when test="descendant::group">
        <h2>Quick links to groups</h2>

        <table class="links">
          <xsl:for-each select=".//group">
            <xsl:if test="position() mod 6 = 1">
              <tr>
                <td class="links">
                  <a class="content" href="#{@id}">[<xsl:value-of select="@id"/>]</a>
                </td>
                <td class="links">
                  <xsl:if test="following::group[1]">
                    <a class="content" href="#{following::group[1]/@id}">[<xsl:value-of
                        select="following::group[1]/@id"/>]</a>
                  </xsl:if>
                </td>
                <td class="links">
                  <xsl:if test="following::group[2]">
                    <a class="content" href="#{following::group[2]/@id}">[<xsl:value-of
                        select="following::group[2]/@id"/>]</a>
                  </xsl:if>
                </td>
                <td class="links">
                  <xsl:if test="following::group[3]">
                    <a class="content" href="#{following::group[3]/@id}">[<xsl:value-of
                        select="following::group[3]/@id"/>]</a>
                  </xsl:if>
                </td>
                <td class="links">
                  <xsl:if test="following::group[4]">
                    <a class="content" href="#{following::group[4]/@id}">[<xsl:value-of
                        select="following::group[4]/@id"/>]</a>
                  </xsl:if>
                </td>
                <td class="links">
                  <xsl:if test="following::group[5]">
                    <a class="content" href="#{following::group[5]/@id}">[<xsl:value-of
                        select="following::group[5]/@id"/>]</a>
                  </xsl:if>
                </td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </table>
      </xsl:when>
      <xsl:otherwise> </xsl:otherwise>
    </xsl:choose>



    <h2>List of &lt;text&gt;/@id's used</h2>
    <table class="list">
      <xsl:for-each select=".//item">
        <xsl:if test="position() mod 9 = 1">
          <tr>
            <td class="list">
              <a class="content" href="#{@id}">[<xsl:value-of select="@id"/>]</a>
            </td>
            <td class="list">
              <xsl:if test="following::item[1]">
                <a class="content" href="#{following::item[1]/@id}">[<xsl:value-of
                    select="following::item[1]/@id"/>]</a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::item[2]">
                <a class="content" href="#{following::item[2]/@id}">[<xsl:value-of
                    select="following::item[2]/@id"/>]</a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::item[3]">
                <a class="content" href="#{following::item[3]/@id}">[<xsl:value-of
                    select="following::item[3]/@id"/>]</a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::item[4]">
                <a class="content" href="#{following::item[4]/@id}">[<xsl:value-of
                    select="following::item[4]/@id"/>]</a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::item[5]">
                <a class="content" href="#{following::item[5]/@id}">[<xsl:value-of
                    select="following::item[5]/@id"/>]</a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::item[6]">
                <a class="content" href="#{following::item[6]/@id}">[<xsl:value-of
                    select="following::item[6]/@id"/>]</a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::item[7]">
                <a class="content" href="#{following::item[7]/@id}">[<xsl:value-of
                    select="following::item[7]/@id"/>]</a>
              </xsl:if>
            </td>
            <td class="list">
              <xsl:if test="following::item[8]">
                <a class="content" href="#{following::item[8]/@id}">[<xsl:value-of
                    select="following::item[8]/@id"/>]</a>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>


    <h2>Main tables</h2>
    <xsl:if test=".//body[theme]">
      <table cellspacing="3" cellpadding="6" class="group">
        <tr>
          <th>
            <h3>Body:</h3>
          </th>
          <td>
            <p>
              <xsl:text> [rhcontent] </xsl:text>
              <xsl:if test="string(.//body/rhcontent/@value)">
                <span class="ftype">
                  <xsl:value-of select=".//body/rhcontent/@value"/>
                </span>
              </xsl:if>
              <br/>
              <xsl:text> [theme] </xsl:text>
              <span class="ftype">
                <xsl:value-of select=".//body/theme/@value"/>
              </span>
            </p>
          </td>
        </tr>
      </table>
      <br clear="all"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="descendant::group">
        <xsl:apply-templates select=".//group"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select=".//item"/>
      </xsl:otherwise>
    </xsl:choose>


    <a id="bottom">&#160;</a>

    <h2>Explanation of table headings</h2>

    <h2>Warnings</h2>

    <p>The following warnings are possible:</p>

    <ul>
      <li>
        <b>CONTENT MISSING</b>
        <xsl:text>: if there is no content for an essential attribute, e.g. an 'id'
attribute.</xsl:text>
      </li>
      <li>
        <b>TOO SHORT?</b>
        <xsl:text>: If some attributes or elements have just one character then a warning
message appears.</xsl:text>
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
            <xsl:if test="string(groupHead/groupFolder)">
              <span class="ftype">
                <xsl:value-of select="groupHead/groupFolder"/>
              </span>
            </xsl:if>
            <br/>
            <xsl:text> [rhcontent] </xsl:text>
            <xsl:if test="string(groupHead/rhcontent/@value)">
              <span class="ftype">
                <xsl:value-of select="groupHead/rhcontent/@value"/>
              </span>
            </xsl:if>
            <br/>
            <xsl:text> [theme] </xsl:text>
            <span class="ftype">
              <xsl:value-of select="groupHead/theme/@value"/>
            </span>
          </p>
        </td>
      </tr>
    </table>
    <br clear="all"/>
    <xsl:if test="child::item">
      <!-- MAIN TABLE STARTS -->
      <table cellspacing="0" cellpadding="5" class="detail">
        <!-- headings -->
        <tr>
          <th valign="top" class="main">@id</th>
          <xsl:if test="not(ancestor::authorityList[@id='AL_process'])">
            <th valign="top" class="main">&lt;filetitle&gt;</th>
          </xsl:if>
          <xsl:if test="not(ancestor::authorityList[@id='AL_process'])">
            <th valign="top" class="main">&lt;filename&gt;</th>
          </xsl:if>
          <th valign="top" class="main">&lt;rhcontent&gt;</th>
          <th valign="top" class="main">&lt;theme&gt;</th>
          <th valign="top" class="main">&lt;param&gt;</th>
          <xsl:if test="not(ancestor::authorityList[@id='AL_process'])">
            <th valign="top" class="subsid">&lt;@print&gt;</th>
          </xsl:if>
          <th valign="top" class="subsid">&lt;notes&gt;</th>
          <th valign="top" class="subsid">&lt;internal&gt;</th>
        </tr>

        <xsl:apply-templates select="item">
          <xsl:sort select="@id" order="ascending"/>
        </xsl:apply-templates>
      </table>
      <br clear="all"/>
      <br clear="all"/>
    </xsl:if>
  </xsl:template>



  <!-- GROUP -->
  <xsl:template match="group">
    <xsl:choose>
      <!-- LEVEL ONE -->
      <xsl:when test="parent::body">
        <hr size="1"/>
        <a name="{@id}">&#160;</a>
        <div class="level1">
          <xsl:call-template name="ctpl_group"/>
        </div>
      </xsl:when>
      <!-- LEVEL TWO -->
      <xsl:when test="../parent::body">
        <hr size="1"/>
        <a name="{@id}">&#160;</a>
        <div class="level2">
          <xsl:call-template name="ctpl_group"/>
        </div>
      </xsl:when>
      <!-- LEVEL THREE -->
      <xsl:otherwise>
        <a name="{@id}">&#160;</a>
        <div class="level3">
          <xsl:call-template name="ctpl_group"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!-- ITEM-->
  <xsl:template match="item">
    <xsl:choose>
      <xsl:when test="parent::group">
        <!-- a row for each item -->
        <tr>
          <!-- next table cell -->
          <xsl:choose>
            <xsl:when test="not(string(@id))">
              <td valign="top" class="warning"> CONTENT MISSING </td>
            </xsl:when>
            <xsl:when test="string-length(@id) &lt; 2">
              <td valign="top" class="warning">
                <xsl:apply-templates select="@id"/>
                <xsl:text> TOO SHORT? </xsl:text>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td valign="top" class="keyid">
                <a id="{@id}">&#160;</a>
                <strong>
                  <xsl:apply-templates select="@id"/>
                </strong>
              </td>
            </xsl:otherwise>
          </xsl:choose>
          <!-- next table cell -->
          <xsl:if test="not(ancestor::authorityList[@id='AL_process'])">
            <xsl:choose>
              <xsl:when test="not(string(fileName))">
                <td valign="top" class="blank">&#160;</td>
              </xsl:when>
              <!-- <xsl:when test="string-length(fileName) &lt; 2">
                <td valign="top" class="warning">
                  <xsl:apply-templates select="fileName" />
                  <xsl:text>TOO SHORT?</xsl:text>
                </td>
              </xsl:when>-->
              <xsl:otherwise>
                <td valign="top" class="fname">
                  <xsl:apply-templates select="fileName"/>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!-- next table cell -->
          <xsl:if test="not(ancestor::authorityList[@id='AL_process'])">
            <xsl:choose>
              <xsl:when test="not(string(fileTitle))">
                <td valign="top" class="blank">&#160;</td>
              </xsl:when>
              <!-- <xsl:when test="string-length(fileTitle) &lt; 2">
                <td valign="top" class="warning">
                  <xsl:apply-templates select="fileTitle" />
                  <xsl:text>TOO SHORT?</xsl:text>
                </td>
              </xsl:when>-->
              <xsl:otherwise>
                <td valign="top" class="authList4">
                  <xsl:apply-templates select="fileTitle"/>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!-- next table cell -->
          <td valign="top" class="authList4">
            <xsl:value-of select="rhcontent/@value"/>&#160; </td>
          <!-- next table cell -->
          <td valign="top" class="authList4">
            <xsl:value-of select="theme/@value"/>&#160; </td>
          <!-- next table cell -->
          <xsl:choose>
            <xsl:when test="not(string(param))">
              <td valign="top" class="blank">&#160;</td>
            </xsl:when>
            <!-- <xsl:when test="string-length(param) &lt; 2">
                <td valign="top" class="warning">
                  <xsl:apply-templates select="param" />
                  <xsl:text>TOO SHORT?</xsl:text>
                </td>
              </xsl:when>-->
            <xsl:otherwise>
              <td valign="top" class="authList4">
                <xsl:apply-templates select="param"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
          <!-- next table cell -->
          <xsl:if test="not(ancestor::authorityList[@id='AL_process'])">
            <xsl:choose>
              <xsl:when test="not(string(@print))">
                <td valign="top" class="blank">&#160;</td>
              </xsl:when>
              <xsl:when test="string-length(@print) &lt; 2">
                <td valign="top" class="blank">
                  <xsl:text>&#160;</xsl:text>
                  <xsl:apply-templates select="@print"/>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td valign="top" class="authList3">
                  <xsl:apply-templates select="@print"/>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!-- next table cell -->
          <xsl:choose>
            <xsl:when test="not(string(notes))">
              <td valign="top" class="blank">&#160;</td>
            </xsl:when>
            <xsl:when test="not(string(notes/p))">
              <td valign="top" class="blank">&#160;</td>
            </xsl:when>
            <xsl:otherwise>
              <td valign="top">
                <xsl:apply-templates select="notes"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
          <!-- next table cell -->
          <xsl:choose>
            <xsl:when test="not(string(internal))">
              <td valign="top" class="blank">&#160;</td>
            </xsl:when>
            <xsl:when test="not(string(internal/p))">
              <td valign="top" class="blank">&#160;</td>
            </xsl:when>
            <xsl:otherwise>
              <td valign="top">
                <xsl:apply-templates select="internal"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <table width="100%" cellspacing="0" cellpadding="5" class="detail">
          <tr>
            <th width="10%" class="id">
              <a name="{@id}">&#160;</a>
              <strong>@id</strong>
            </th>
            <th width="10%" class="main">Full Name</th>
            <th width="40%" class="subsid">Notes</th>
            <th width="40%" class="subsid">Internal</th>
          </tr>
          <tr>
            <td valign="top" align="center" class="keyid">
              <xsl:apply-templates select="@id"/>
            </td>
            <td valign="top" align="center">
              <xsl:apply-templates select="full"/>
            </td>
            <xsl:choose>
              <xsl:when test="not(string(notes))">
                <td valign="top" class="blank">&#160;</td>
              </xsl:when>
              <xsl:when test="not(string(notes/p))">
                <td valign="top" class="blank">&#160;</td>
              </xsl:when>
              <xsl:otherwise>
                <td valign="top">
                  <xsl:apply-templates select="notes"/>
                </td>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
              <xsl:when test="not(string(internal))">
                <td valign="top" class="blank">&#160;</td>
              </xsl:when>
              <xsl:when test="not(string(internal/p))">
                <td valign="top" class="blank">&#160;</td>
              </xsl:when>
              <xsl:otherwise>
                <td valign="top">
                  <xsl:apply-templates select="internal"/>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
        </table>
        <br clear="all"/>
        <br clear="all"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
