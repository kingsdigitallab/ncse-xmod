<?xml version="1.0" ?>
<!-- $Id: proj_indices_spec.xsl 594 2007-08-31 16:13:54Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="saxon"
  xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="saxon dir"
  version="1.1">

  <xsl:key name="headerAuth" match="titleStmt/author" use="normalize-space(name[@type='surname'])"/>
  <xsl:key name="kwForeign" match="file" use="concat(@id, '-', ancestor::row/head)"/>
  <xsl:key name="kwForeignAZ" match="head"
    use="translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>

  <xsl:template name="tpl_idx_auth">
    <div class="index">
      <div class="t02">
        <dl>
          <!--  Getting each unique instance -->
          <xsl:for-each
            select="//projDIR//titleStmt/author[generate-id()=generate-id(key('headerAuth', normalize-space(name[@type='surname']))[1])]">
            <xsl:sort select="normalize-space(name[@type='surname'])"/>

            <!--  Variables for CSS -->
            <xsl:variable name="row">
              <xsl:call-template name="row-vars"/>
            </xsl:variable>

            <xsl:variable name="oddeven">
              <xsl:call-template name="oddeven"/>
            </xsl:variable>

            <!--  Output the unique instance -->
            <dt>
              <xsl:attribute name="class">
                <xsl:value-of select="$row"/>
                <xsl:value-of select="$oddeven"/>
              </xsl:attribute>
              <xsl:value-of select="name[@type='surname']"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="name[@type='foreName']"/>
            </dt>

            <!--  Each instance -->
            <xsl:for-each select="key('headerAuth', normalize-space(name[@type='surname']))">
              <xsl:sort select="ancestor::titleStmt/title[1]"/>

              <!--  Variables for CSS -->
              <xsl:variable name="col">
                <xsl:call-template name="col-vars"/>
              </xsl:variable>

              <!--  Link output -->
              <dd>
                <xsl:attribute name="class">
                  <xsl:value-of select="$row"/>
                  <xsl:value-of select="$col"/>
                  <xsl:value-of select="$oddeven"/>
                </xsl:attribute>
                <a>
                  <xsl:variable name="filename"
                    select="substring-before(ancestor::dir:file/@name, '.xml')"/>

                  <xsl:choose>
                    <xsl:when test="contains($context-id, '03')">
                      <xsl:attribute name="href">
                        <xsl:value-of select="$linkroot"/>
                        <xsl:value-of select="$group-type03-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$filename"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$filename"/>
                        <xsl:text>_01.html</xsl:text>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="href">
                        <xsl:value-of select="$linkroot"/>
                        <xsl:value-of select="$group-type02-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$filename"/>
                        <xsl:text>.html</xsl:text>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <span>
                    <xsl:apply-templates select="ancestor::titleStmt/title[1]" mode="index"/>
                  </span>
                </a>
              </dd>
            </xsl:for-each>
          </xsl:for-each>
        </dl>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="tpl_idx_foreign_az">
    <div class="unorderedList">
      <div class="t03">
        <ul>
          <xsl:for-each
            select="/aggregation/TEI.2/row/head[generate-id(.)=generate-id(key('kwForeignAZ', translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'))[1])]">
            <xsl:variable name="letter">
              <xsl:value-of
                select="translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"
              />
            </xsl:variable>
            <li>
              <a class="x70 z03">
                <xsl:choose>
                  <xsl:when test="not(contains('ABCDEFGHIJKLMNOPQRSTUVWXYZ', $letter))">
                    <xsl:attribute name="name">
                      <xsl:value-of select="substring(.,1,1)"/>
                    </xsl:attribute>
                    <xsl:value-of select="substring(.,1,1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="name">
                      <xsl:value-of select="$letter"/>
                    </xsl:attribute>
                    <xsl:value-of select="$letter"/>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
              <dl class="x71 z02">
                <xsl:for-each
                  select="key('kwForeignAZ', translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'))">
                  <xsl:sort select="." order="ascending"/>
                  <xsl:for-each select="parent::row">
                    <!--  Output the unique instance -->
                    <dt>
                      <xsl:value-of select="head"/>
                    </dt>

                    <!--  Getting each unique instance -->
                    <xsl:for-each
                      select="file[generate-id()=generate-id(key('kwForeign', concat(@id, '-', ancestor::row/head))[1])]">
                      <!--  Link output -->
                      <dd>
                        <label>
                          <xsl:apply-templates/>
                        </label>
                        <xsl:for-each
                          select="key('kwForeign', concat(@id, '-', ancestor::row/head))">
                          <a class="s02">
                            <xsl:attribute name="href">
                              <xsl:value-of select="$linkroot"/>
                              <xsl:value-of select="$group-type02-path"/>
                              <xsl:text>/</xsl:text>
                              <xsl:value-of select="@id"/>
                              <xsl:text>.html</xsl:text>
                              <xsl:if test="string(@href)">
                                <xsl:text>#</xsl:text>
                                <xsl:value-of select="@href"/>
                              </xsl:if>
                            </xsl:attribute>
                            <span>
                              <xsl:text>Occurrence </xsl:text>
                              <xsl:value-of select="position()"/>
                            </span>
                          </a>
                        </xsl:for-each>
                      </dd>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
              </dl>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>

  </xsl:template>

  <xsl:template name="tpl_idx_foreign_key">
    <div class="index">
      <div class="t01">
        <dl>
          <xsl:for-each select="/aggregation/TEI.2/row">
            <xsl:sort select="head"/>
            <xsl:call-template name="kw-idx"/>
          </xsl:for-each>
        </dl>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="tpl_idx_foreign">
    <div class="index">
      <div class="t01">
        <dl>
          <xsl:for-each select="/aggregation/TEI.2/row">
            <xsl:call-template name="kw-idx"/>
          </xsl:for-each>
        </dl>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="kw-idx">

    <!--  Variables for CSS -->
    <xsl:variable name="row">
      <xsl:call-template name="row-vars"/>
    </xsl:variable>
    <xsl:variable name="oddeven">
      <xsl:call-template name="oddeven"/>
    </xsl:variable>

    <!--  Output the unique instance -->
    <dt>
      <xsl:attribute name="class">
        <xsl:value-of select="$row"/>
        <xsl:value-of select="$oddeven"/>
      </xsl:attribute>
      <xsl:value-of select="head"/>
    </dt>

    <!--  Getting each unique instance -->
    <xsl:for-each
      select="file[generate-id()=generate-id(key('kwForeign', concat(@id, '-', ancestor::row/head))[1])]">

      <!--  Variables for CSS -->
      <xsl:variable name="col">
        <xsl:call-template name="col-vars"/>
      </xsl:variable>
      <!--  Link output -->
      <dd>
        <xsl:attribute name="class">
          <xsl:value-of select="$row"/>
          <xsl:value-of select="$col"/>
          <xsl:value-of select="$oddeven"/>
        </xsl:attribute>
        <label>
          <xsl:apply-templates/>
        </label>
        <xsl:for-each select="key('kwForeign', concat(@id, '-', ancestor::row/head))">
          <a class="s02">
            <xsl:choose>
              <xsl:when test="starts-with(@id, $group-type03-id)">
                <xsl:variable name="type03-file" select="substring-after(@id, concat($group-type03-id, '_'))"/>
                <xsl:attribute name="href">
                  <xsl:value-of select="$linkroot"/>
                  <xsl:value-of select="$group-type03-path"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$type03-file"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="substring-after(@pg, $text-type03-pre)"/>
                  <xsl:text>.html</xsl:text>
                  <xsl:if test="string(@href)">
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="@href"/>
                  </xsl:if>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="href">
                  <xsl:value-of select="$linkroot"/>
                  <xsl:value-of select="$group-type02-path"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="@id"/>
                  <xsl:text>.html</xsl:text>
                  <xsl:if test="string(@href)">
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="@href"/>
                  </xsl:if>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <span>
              <xsl:text>Occurrence </xsl:text>
              <xsl:value-of select="position()"/>
            </span>
          </a>
        </xsl:for-each>
      </dd>
    </xsl:for-each>
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

  <!-- ODD and EVEN SHADING -->
  <xsl:template name="oddeven">
    <xsl:choose>
      <xsl:when test="position() mod 2 = 0">
        <xsl:text> z02</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> z01</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
