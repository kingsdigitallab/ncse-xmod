<?xml version="1.0"?>
<!-- $Id: navbar_tpkey.xsl 598 2007-09-03 15:51:05Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  exclude-result-prefixes="saxon" version="1.1">


  <!-- INCLUDES -->
  <xsl:include href="common_key.xsl"/>
  <xsl:include href="common_tpl.xsl"/>
  <xsl:include href="common_std.xsl"/>
  <xsl:include href="..\..\xslt\common\proj_vars.xsl"/>



  <xsl:template match="authorityList[@id = 'AL_navbar']">
    <xsl:call-template name="html_tpl"/>
  </xsl:template>

  <xsl:template match="docsite|filebase"/>


  <xsl:template name="ctpl_content">
    <h1 class="content">Navbar Structure</h1>
    <xsl:apply-templates select="body"/>
    <xsl:apply-templates select=".//layout"/>
  </xsl:template>
  
  <xsl:template match="body">
    <table cellspacing="0" cellpadding="5" class="head">
      <tr>
        <th class="head" valign="bottom">topNav:</th>
        <td width="60%">
          <strong>
            <xsl:value-of select="@topNav"/>
          </strong>
        </td>
      </tr>
    </table>
  </xsl:template>



  <xsl:template name="ctpl_active">
    <table cellspacing="0" cellpadding="5" class="detail">
      <tr>
        <th class="subsid" width="40%" rowspan="2">active</th>
        <xsl:if test="active/file/@ref">
          <th class="subsid">@ref</th>
        </xsl:if>
        <xsl:if test="active/file/@start">
          <th class="subsid">@start</th>
        </xsl:if>
        <xsl:if test="not(active/file[@start or @ref])">
          <td rowspan="2" class="warning">no @ref or @start</td>
        </xsl:if>
      </tr>
      <tr>
        <xsl:if test="active/file/@ref">
          <td valign="top" align="center">
            <xsl:for-each select="active/file/@ref">
              <xsl:apply-templates select="."/>
              <br/>
            </xsl:for-each>
          </td>
        </xsl:if>
        <xsl:if test="active/file/@start">
          <td valign="top" align="center">
            <xsl:for-each select="active/file/@start">
              <xsl:apply-templates select="."/>
              <br/>
            </xsl:for-each>
          </td>
        </xsl:if>
      </tr>
    </table>
  </xsl:template>



  <xsl:template match="line">
    <hr style="height: 10px; border: 0; color: #000; background-color: #000;"/>
  </xsl:template>



  <xsl:template match="heading">
    <table cellspacing="0" cellpadding="5" class="head">
      <tr>
        <th class="head" valign="bottom">Heading:</th>
        <td width="60%">
          <strong>
            <xsl:apply-templates/>
          </strong>
        </td>
      </tr>
    </table>
  </xsl:template>



  <xsl:template match="break">
    <table cellspacing="0" cellpadding="5" class="detail">
      <tr>
        <th class="subsid" valign="bottom">Break: </th>
        <td valign="bottom">
          <xsl:apply-templates select="@height"/>
        </td>
      </tr>
    </table>
    <br/>
  </xsl:template>



  <xsl:template match="level01">
    <div class="level1">
      <table cellspacing="3" cellpadding="6" class="group">
        <tr>
          <th valign="center">
            <h3>1</h3>
          </th>
          <td width="60%">
            <p>
              <xsl:choose>
                <xsl:when test="not(label)">
                  <span class="warning2">no label</span>
                  <br/>
                </xsl:when>
                <xsl:when test="not(string(label))">
                  <span class="warning2">no label</span>
                  <br/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text> [label] </xsl:text>
                  <strong>
                    <xsl:apply-templates select="label"/>
                  </strong>
                  <br/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>[default] </xsl:text>
              <xsl:if test="not(/aggregation/filebase//item[@id=current()/default/@ref]/fileName)">
                <span class="warning2">not in fileBase: </span>
                <br/>
              </xsl:if>
              <xsl:apply-templates select="default/@ref"/>
            </p>
          </td>
        </tr>
      </table>
    </div>
    <xsl:if test="active">
      <div class="level2">
        <xsl:call-template name="ctpl_active"/>
      </div>
    </xsl:if>
    <xsl:if test="sub02">
      <xsl:apply-templates select="/level02"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="level02">
    <div class="level2">
      <table cellspacing="3" cellpadding="6" class="group">
        <tr>
          <th valign="center">
            <h3>2</h3>
          </th>
          <td width="60%">
            <p>
              <xsl:choose>
                <xsl:when test="not(label)">
                  <span class="warning2">no label</span>
                  <br/>
                </xsl:when>
                <xsl:when test="not(string(label))">
                  <span class="warning2">no label</span>
                  <br/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text> [label] </xsl:text>
                  <strong>
                    <xsl:apply-templates select="label"/>
                  </strong>
                  <br/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text> [default] </xsl:text>
              <xsl:apply-templates select="default/@ref"/>
            </p>
          </td>
        </tr>
      </table>
    </div>
    <xsl:if test="active">
      <div class="level3">
        <xsl:call-template name="ctpl_active"/>
      </div>
    </xsl:if>
    <xsl:if test="sub03">
      <xsl:apply-templates select="/level03"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="level03">
    <div class="level3">
      <table cellspacing="3" cellpadding="6" class="group">
        <tr>
          <th valign="center">
            <h3>3</h3>
          </th>
          <td width="60%">
            <p>
              <xsl:choose>
                <xsl:when test="not(label)">
                  <span class="warning2">no label</span>
                  <br/>
                </xsl:when>
                <xsl:when test="not(string(label))">
                  <span class="warning2">no label</span>
                  <br/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text> [label] </xsl:text>
                  <strong>
                    <xsl:apply-templates select="label"/>
                  </strong>
                  <br/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text> [default] </xsl:text>
              <xsl:apply-templates select="default/@ref"/>
            </p>
          </td>
        </tr>
      </table>
    </div>
    <xsl:if test="active">
      <div class="level4">
        <xsl:call-template name="ctpl_active"/>
      </div>
    </xsl:if>
    <xsl:if test="sub04">
      <xsl:apply-templates select="/level04"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="level04">
    <div class="level4">
      <table cellspacing="3" cellpadding="6" class="group">
        <tr>
          <th valign="center">
            <h3>4</h3>
          </th>
          <td width="60%">
            <p>
              <xsl:choose>
                <xsl:when test="not(label)">
                  <span class="warning2">no label</span>
                  <br/>
                </xsl:when>
                <xsl:when test="not(string(label))">
                  <span class="warning2">no label</span>
                  <br/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text> [label] </xsl:text>
                  <strong>
                    <xsl:apply-templates select="label"/>
                  </strong>
                  <br/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text> [default] </xsl:text>
              <xsl:apply-templates select="default/@ref"/>
            </p>
          </td>
        </tr>
      </table>
    </div>
    <xsl:if test="active">
      <div class="level5">
        <xsl:call-template name="ctpl_active"/>
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
