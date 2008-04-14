<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--   VARIABLES     -->
  <xsl:variable name="simpletable-colspan" select="'9'" />

  <!--   TOP LEVELS     -->

  <!--   Root Element     -->
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <!--   Website Header     -->
  <xsl:template match="teiHeader" />


  <!--   INFORMATION BLOCKS     -->

  <!--   PAGE HEADINGS     -->
  <!-- This is the only information block managed from here, the rest are in the relevant key file -->

  <xsl:template match="body/head" />

  <xsl:template match="body/head" mode="pagehead">
    <xsl:apply-templates />
    <!-- <xsl:apply-templates mode="pagehead" /> -->
  </xsl:template>

  <xsl:template match="/aggregation/TEI.2/teiHeader/fileDesc/titleStmt/title" mode="pagehead">
    <xsl:apply-templates />
    <!--  <xsl:apply-templates mode="pagehead" /> -->
  </xsl:template>

  <xsl:template match="/aggregation/TEI.2/teiHeader/fileDesc/titleStmt/*[self::author|self::editor|self::respStmt]" mode="pagehead">
    <xsl:apply-templates mode="pagehead" />
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/aggregation/TEI.2/teiHeader/fileDesc/titleStmt/respStmt/resp" mode="pagehead">
    <xsl:apply-templates />
    <xsl:if test="following-sibling::name">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <!--  COMMENT STARTS  -->
  <!-- ALTERNATIVELY, YOU CAN CALL THEM INDIVIDUALLY:
        
<xsl:template match="/aggregation/TEI.2/teiHeader/fileDesc/titleStmt/author" mode="pagehead">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="/aggregation/TEI.2/teiHeader/fileDesc/titleStmt/editor" mode="pagehead">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="/aggregation/TEI.2/teiHeader/fileDesc/titleStmt/respStmt" mode="pagehead">
  <xsl:apply-templates />
</xsl:template>
 -->

  <!-- THE MAIN CALL IS NOW HANDLED IN THE TPKEY FILE FOR EACH PUB TYPE, i.e.:
<xsl:template name="ctpl_pagehead">
  <h1>
     <xsl:apply-templates select="body/head" mode="pagehead" />
  </h1>
</xsl:template>
 -->
  <!--  COMMENT ENDS -->


  <!--   DIVISIONS     -->
  <xsl:template match="div">
    <xsl:choose>
      <!--Contact Details Box -->
      <xsl:when test="@type='box'">
        <address>
          <xsl:apply-templates />
        </address>
      </xsl:when>
      <!--   Default  -->
      <xsl:otherwise>
        <!-- Creates anchor if there is @id -->
        <xsl:if test="@id">
          <a>
            <xsl:attribute name="id">
              <xsl:value-of select="@id" />
            </xsl:attribute>
            <xsl:text>&#160;</xsl:text>
          </a>
        </xsl:if>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--   HEADINGS     -->
  <xsl:template match="body/div/head">
    <h2 id="{generate-id()}">
      <xsl:apply-templates />
    </h2>
  </xsl:template>

  <xsl:template match="body/div/div/head">
    <h3 id="{generate-id()}">
      <xsl:apply-templates />
    </h3>
  </xsl:template>

  <xsl:template match="body/div/div/div/head">
    <h4 id="{generate-id()}">
      <xsl:apply-templates />
    </h4>
  </xsl:template>

  <xsl:template match="body/div/div/div/div/head">
    <h5 id="{generate-id()}">
      <xsl:apply-templates />
    </h5>
  </xsl:template>

  <xsl:template match="body/div/div/div/div/div/head">
    <h6 id="{generate-id()}">
      <xsl:apply-templates />
    </h6>
  </xsl:template>

  <xsl:template match="body/div/div/div/div/div/div/head">
    <h6 id="{generate-id()}">
      <xsl:apply-templates />
    </h6>
  </xsl:template>


  <!--   FRONT AND BACK     -->
  <xsl:template match="front/div/head">
    <h2 id="{generate-id()}">
      <xsl:apply-templates />
    </h2>
  </xsl:template>

  <xsl:template match="front/div/div/head">
    <h3 id="{generate-id()}">
      <xsl:apply-templates />
    </h3>
  </xsl:template>

  <xsl:template match="front/div/div/div/head">
    <h4 id="{generate-id()}">
      <xsl:apply-templates />
    </h4>
  </xsl:template>

  <xsl:template match="front/div/div/div/div/head">
    <h5 id="{generate-id()}">
      <xsl:apply-templates />
    </h5>
  </xsl:template>

  <xsl:template match="front/div/div/div/div/div/head">
    <h6 id="{generate-id()}">
      <xsl:apply-templates />
    </h6>
  </xsl:template>

  <xsl:template match="front/div/div/div/div/div/div/head">
    <h6 id="{generate-id()}">
      <xsl:apply-templates />
    </h6>
  </xsl:template>

  <!-- BACK -->
  <xsl:template match="back/div/head">
    <h2 id="{generate-id()}">
      <xsl:apply-templates />
    </h2>
  </xsl:template>

  <xsl:template match="back/div/div/head">
    <h3 id="{generate-id()}">
      <xsl:apply-templates />
    </h3>
  </xsl:template>

  <xsl:template match="back/div/div/div/head">
    <h4 id="{generate-id()}">
      <xsl:apply-templates />
    </h4>
  </xsl:template>

  <xsl:template match="back/div/div/div/div/head">
    <h5 id="{generate-id()}">
      <xsl:apply-templates />
    </h5>
  </xsl:template>

  <xsl:template match="back/div/div/div/div/div/head">
    <h6 id="{generate-id()}">
      <xsl:apply-templates />
    </h6>
  </xsl:template>

  <xsl:template match="back/div/div/div/div/div/div/head">
    <h6 id="{generate-id()}">
      <xsl:apply-templates />
    </h6>
  </xsl:template>


  <!--   TOC     -->
  <xsl:template match="body/head" mode="toc">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="note" mode="toc"> </xsl:template>

  <xsl:template match="term" mode="toc"> </xsl:template>

  <xsl:template match="hi" mode="toc">
    <xsl:apply-templates />
  </xsl:template>


  <!--   TOC FOR FRONT AND BACK TOO?     -->
  <xsl:template match="front/head" mode="toc">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="back/head" mode="toc">
    <xsl:apply-templates />
  </xsl:template>


  <!--   SUBMENU EXTRAS     -->
  <xsl:template match="head" mode="submenu">
    <xsl:apply-templates mode="submenu" />
  </xsl:template>

  <xsl:template match="note" mode="submenu"> </xsl:template>

  <xsl:template match="hi" mode="submenu">
    <xsl:apply-templates />
  </xsl:template>



  <!--   BLOCK LEVEL     -->

  <!-- Creates anchor if there is @id -->
  <xsl:template name="a-id">
    <xsl:if test="@id">
      <xsl:attribute name="id">
        <xsl:value-of select="@id" />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!--   PARAS     -->
  <xsl:template match="p">
    <xsl:choose>
      <!-- CASE 1: special case where it is in a list -->
      <xsl:when test="parent::item">
        <p>
          <xsl:call-template name="a-id" />
          <xsl:apply-templates />
        </p>
      </xsl:when>

      <!-- CASE 2: preformatted text  -->
      <xsl:when test="@rend='pre'">
        <pre>
          <xsl:call-template name="a-id" />
          <xsl:apply-templates />
        </pre>
      </xsl:when>

      <!-- CASE 3: paragraph contains thumb with caption -->
      <xsl:when test="figure[@type='thumb-caption']">
        <xsl:for-each select="figure[@type='thumb-caption'][string(@url)]">
          <xsl:call-template name="showFigure" />
        </xsl:for-each>
        <p>
          <xsl:call-template name="a-id" />
          <xsl:apply-templates />
        </p>
      </xsl:when>

      <!-- OTHER CASES -->
      <xsl:otherwise>
        <p>
          <xsl:call-template name="a-id" />
          <xsl:apply-templates />
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!--   LISTS     -->

  <!--  Selecting list rendition used in the templates below-->
  <xsl:template name="list-rend">
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="@rend='arabic'">t01</xsl:when>
        <xsl:when test="@rend='lower_case'">t02</xsl:when>
        <xsl:when test="@rend='lower_roman'">t03</xsl:when>
        <xsl:when test="@rend='upper_case'">t04</xsl:when>
        <xsl:when test="@rend='upper_roman'">t05</xsl:when>
        <xsl:otherwise>
          <!--  DEFAULT is usually arabic -->
          <xsl:text>t01</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="list-head">
    <xsl:if test="head">
      <h3>
        <xsl:apply-templates select="head" />
      </h3>
    </xsl:if>
  </xsl:template>

  <xsl:template match="list">
    <xsl:choose>
      <!-- Figure in lists -->
      <!-- CASE 1: Full sized figures in a grid -->
      <xsl:when test="@type='figure-full'">
        <div class="image">
          <div class="t01">
            <xsl:apply-templates />
          </div>
        </div>
      </xsl:when>

      <!-- CASE 2: Thumbnail figures in a grid -->
      <xsl:when test="@type='figure-thumb'">
        <div class="image">
          <div class="t04">
            <xsl:apply-templates />
          </div>
        </div>
      </xsl:when>

      <!-- CASE 3: Full sized images in a list -->
      <xsl:when test="@type='figure-list'">
        <div class="image">
          <div class="t02">
            <dl>
              <xsl:apply-templates />
            </dl>
          </div>
        </div>
      </xsl:when>

      <!--  CASE 1: Test for nested lists -->
      <xsl:when test="parent::item">
        <div>
          <xsl:call-template name="list-rend" />
          <xsl:call-template name="list-models" />
        </div>
      </xsl:when>

      <!--  CASE 2: Test for lists within tables -->
      <xsl:when test="ancestor::table">
        <xsl:call-template name="list-models" />
      </xsl:when>

      <!--  CASE 3: Test for lists within blockquotes -->
      <xsl:when test="ancestor::quote">
        <xsl:call-template name="list-models" />
      </xsl:when>

      <!--  CASE 4: Ordered lists -->
      <xsl:when test="@type='ordered'">
        <div class="orderedList">
          <div>
            <xsl:call-template name="list-rend" />
            <xsl:call-template name="list-models" />
          </div>
        </div>
      </xsl:when>

      <!--  CASE 5: Inline simple lists -->
      <xsl:when test="@type='simple'">
        <xsl:call-template name="list-models" />
      </xsl:when>

      <!--  CASE 6: Glossary lists -->
      <xsl:when test="@type='gloss'">
        <div class="resourceList">
          <div class="t02">
            <xsl:call-template name="list-models" />
          </div>
        </div>
      </xsl:when>

      <!--  CASE 6: Normal/bulleted lists -->
      <xsl:otherwise>
        <div class="unorderedList">
          <div class="t01">
            <xsl:call-template name="list-models" />
          </div>
        </div>
      </xsl:otherwise>
      <!--  END OF ALL CASES -->
    </xsl:choose>
  </xsl:template>

  <xsl:template name="list-models">
    <!-- Basic list formatting starts -->
    <xsl:choose>

      <!--  ORDERED LIST  -->
      <xsl:when test="@type='ordered'">
        <xsl:call-template name="list-head" />
        <ol>
          <xsl:call-template name="a-id" />
          <xsl:apply-templates select="*[not(local-name()='head')]" />
        </ol>
      </xsl:when>

      <!--  BULLETED LIST  -->
      <xsl:when test="@type='bulleted'">
        <xsl:call-template name="list-head" />
        <ul>
          <xsl:call-template name="a-id" />
          <xsl:apply-templates select="*[not(local-name()='head')]" />
        </ul>
      </xsl:when>

      <!--  SIMPLE  -->
      <xsl:when test="@type='simple'">
        <xsl:choose>
          <xsl:when test="ancestor::p">
            <xsl:apply-templates />
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:call-template name="a-id" />
              <xsl:apply-templates />
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!--  GLOSS  -->
      <xsl:when test="@type='gloss'">
        <dl>
          <xsl:call-template name="a-id" />
          <xsl:apply-templates />
        </dl>
      </xsl:when>

      <!--  DEFAULT  -->
      <xsl:otherwise>
        <xsl:call-template name="list-head" />
        <ul>
          <xsl:call-template name="a-id" />
          <xsl:apply-templates select="*[not(local-name()='head')]" />
        </ul>
      </xsl:otherwise>
    </xsl:choose>
    <!-- Basic list formatting ends -->
  </xsl:template>

  <xsl:template name="item-class-oddeven">
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="count(preceding-sibling::item) mod 2 = 0">tableeven</xsl:when>
        <xsl:otherwise>tableodd</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="item[parent::list]">
    <xsl:choose>
      <!-- Figure in lists -->
      <!-- CASE 1: Full sized figures in a grid -->
      <xsl:when test="../@type='figure-full'">
        <xsl:apply-templates />
      </xsl:when>

      <!-- CASE 2: Thumbnail figures in a grid -->
      <xsl:when test="../@type='figure-thumb'">
        <xsl:apply-templates />
      </xsl:when>
      <!-- CASE 3: Full sized images in a list -->
      <xsl:when test="../@type='figure-list'">
        <dt>
          <xsl:apply-templates select="figure" />
        </dt>
        <xsl:choose>
          <xsl:when test="p">
            <dd>
              <xsl:apply-templates select="text()|*[not(local-name()='figure')]" />
            </dd>
          </xsl:when>
          <xsl:otherwise>
            <dd>
              <p>
                <xsl:apply-templates select="text()|*[not(local-name()='figure')]" />
              </p>
            </dd>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <!--  CASE 1: Simple list items -->
      <xsl:when test="../@type='simple'">
        <!-- Note a simple list in TEI is often interpreted as a list of items on the same line. We don't support this in any special way any more. -->
        <xsl:apply-templates />
      </xsl:when>

      <!--  CASE 2: Glossary items -->
      <xsl:when test="../@type='gloss'">
        <!-- item HERE -->
        <dt>
          <xsl:attribute name="class">
            <xsl:call-template name="r-num" />
            <xsl:call-template name="odd-even" />
          </xsl:attribute>
          <xsl:apply-templates mode="glossary" select="preceding-sibling::label[1]" />
        </dt>
        <!-- label HERE -->
        <dd>
          <xsl:attribute name="class">
            <xsl:call-template name="r-num" />
            <xsl:text> c01</xsl:text>
            <xsl:call-template name="odd-even" />
          </xsl:attribute>
          <xsl:apply-templates />
        </dd>
      </xsl:when>

      <!--  CASE 3: Items with their own numbers -->
      <xsl:when test="parent::list/item/@n">
        <li>
          <xsl:apply-templates select="@n" />
          <xsl:text>. </xsl:text>
          <xsl:apply-templates />
        </li>
      </xsl:when>

      <!--  CASE 4: All other list items -->
      <xsl:otherwise>
        <li>
          <xsl:apply-templates />
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="label[parent::list]" />

  <xsl:template match="label" mode="glossary">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="headLabel">
    <dt class="r01 z01">
      <xsl:apply-templates />
    </dt>
    <dd class="r01 c01 z01">
      <xsl:apply-templates mode="glossary" select="following-sibling::headItem[1]" />
    </dd>
  </xsl:template>

  <xsl:template match="headItem" />

  <xsl:template match="headItem" mode="glossary">
    <xsl:apply-templates />
  </xsl:template>


  <!--   TABLE    -->
  <xsl:template match="table">
    <xsl:choose>
      <!--  CASE 1: thumbnails   -->
      <!-- Images should no longer be in tables -->
      <xsl:when test="@type='thumbnail'">
        <xsl:if test="head">
          <h6>
            <xsl:apply-templates select="head" />
          </h6>
        </xsl:if>
        <div class="image">
          <xsl:call-template name="a-id" />
          <div class="t01">
            <xsl:apply-templates select="*[not(name()='head')]" />
          </div>
        </div>
      </xsl:when>

      <!--  CASE 2: links biblio  -->
      <xsl:when test="@type='linkBib'">
        <xsl:call-template name="table-linkDisplay" />
      </xsl:when>

      <!--  CASE 3: special table  -->
      <xsl:when test="@type='special'">
        <xsl:call-template name="table-specialListDisplay" />
      </xsl:when>

      <!--  CASE 4: logo table  -->
      <!-- Logo needs to be moved into a list in the XML -->
      <xsl:when test="@type='logo'">
        <div class="logoMatrix">
          <xsl:call-template name="a-id" />
          <div class="t01 clfx-b">
            <xsl:apply-templates />
          </div>
        </div>
      </xsl:when>

      <!--  CASE 5: rowspan/colspan tables  -->
      <xsl:when test="@type='complex'">
        <xsl:call-template name="table-complexDisplay" />
      </xsl:when>

      <!--  DEFAULT option: normal tables  -->
      <xsl:otherwise>
        <xsl:call-template name="table-simpleDisplay" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--   ROW   -->
  <xsl:template match="row">
    <!-- Parameters passed through -->
    <xsl:param name="number-of-rows" />
    <xsl:param name="number-of-cells" />

    <xsl:choose>
      <!--  CASE 1: thumbnails   -->
      <xsl:when test="../@type='thumbnail'">
        <!-- No models needed here, because it's all done in the 'table' template -->
        <xsl:apply-templates />
      </xsl:when>

      <!--  CASE 2: links biblio  -->
      <xsl:when test="../@type='linkBib'">
        <xsl:call-template name="row-linkDisplay" />
      </xsl:when>

      <!--  CASE 3: special table  -->
      <xsl:when test="../@type='special'">
        <xsl:call-template name="row-specialListDisplay" />
      </xsl:when>

      <!--  CASE 4: logo table  -->
      <xsl:when test="../@type='logo'">
        <ul>
          <xsl:apply-templates />
        </ul>
      </xsl:when>

      <!--  CASE 5: rowspan/colspan tables  -->
      <xsl:when test="../@type='complex'">
        <xsl:call-template name="row-complexDisplay">
          <xsl:with-param name="number-of-rows" select="$number-of-rows" />
          <xsl:with-param name="number-of-cells" select="$number-of-cells" />
        </xsl:call-template>
      </xsl:when>

      <!--  DEFAULT option: normal tables  -->
      <xsl:otherwise>
        <xsl:call-template name="row-simpleDisplay"> </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--   CELL   -->
  <xsl:template match="cell">
    <!-- Parameters passed through -->
    <xsl:param name="number-of-rows" />
    <xsl:param name="number-of-cells" />
    <xsl:param name="context-row" />

    <xsl:choose>
      <!--  CASE 1: thumbnails   -->
      <xsl:when test="../../@type='thumbnail'">
        <dl>
          <dt>
            <xsl:apply-templates select="figure" />
          </dt>
          <dd>
            <p>
              <xsl:apply-templates select="//imagebase//image[@id=current()/figure/@url]/caption" />
            </p>
          </dd>
        </dl>
      </xsl:when>

      <!--  CASE 2: links biblio  -->
      <xsl:when test="../../@type='linkBib'">
        <xsl:call-template name="cell-linkDisplay" />
      </xsl:when>

      <!--  CASE 3: special table  -->
      <xsl:when test="../../@type='special'">
        <xsl:call-template name="cell-specialListDisplay" />
      </xsl:when>

      <!--  CASE 4: logo table  -->
      <xsl:when test="../../@type='logo'">
        <li>
          <xsl:apply-templates />
        </li>
      </xsl:when>

      <!--  CASE 5: rowspan/colspan tables  -->
      <xsl:when test="../../@type='complex'">
        <xsl:call-template name="cell-complexDisplay">
          <xsl:with-param name="number-of-rows" select="$number-of-rows" />
          <xsl:with-param name="number-of-cells" select="$number-of-cells" />
          <xsl:with-param name="context-row" select="count(preceding-sibling::row) + 1" />
        </xsl:call-template>
      </xsl:when>

      <!--  DEFAULT option: normal tables  -->
      <xsl:otherwise>
        <xsl:call-template name="cell-simpleDisplay" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- TEMPLATES FOR SHADING AND ROW NUMBERS -->
  <!-- Template for alternate shading -->
  <xsl:template name="odd-even">
    <xsl:choose>
      <xsl:when test="../@type='gloss'">
        <xsl:choose>
          <xsl:when test="count(preceding-sibling::item) mod 2 = 0"> z01</xsl:when>
          <xsl:otherwise>
            <xsl:text> z02</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="../../@type='special' or ../../@type='linkBib'">
        <xsl:choose>
          <xsl:when test="count(parent::row/preceding-sibling::row) mod 2 = 0"> z01</xsl:when>
          <xsl:otherwise>
            <xsl:text> z02</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="count(preceding-sibling::row) mod 2 = 0"> z01</xsl:when>
          <xsl:otherwise>
            <xsl:text> z02</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Template for counting rows -->
  <xsl:template name="r-num">
    <xsl:choose>
      <xsl:when test="../@type='gloss'">
        <xsl:variable name="count-item">
          <xsl:number count="item" format="01" level="single" />
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="preceding-sibling::headLabel or preceding-sibling::headItem">
            <xsl:text>r</xsl:text>
            <xsl:number format="01" value="$count-item + 1" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>r</xsl:text>
            <xsl:value-of select="$count-item" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="../../@type='special' or ../../@type='linkBib'">
        <xsl:choose>
          <xsl:when test="not(parent::row/following-sibling::row)">
            <xsl:text>x02</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>r</xsl:text>
            <xsl:number count="row" format="01" level="single" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="not(following-sibling::row)">
            <xsl:text>x02</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>r</xsl:text>
            <xsl:number count="row" format="01" level="single" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Template for counting cells -->
  <xsl:template name="c-num">
    <xsl:choose>
      <xsl:when test="not(following-sibling::cell)">
        <xsl:text>x01</xsl:text>
      </xsl:when>
      <xsl:when test="../../@type='special' or ../../@type='linkBib'">
        <xsl:variable name="bcell">
          <xsl:number count="cell" level="single" />
        </xsl:variable>
        <xsl:variable name="ccell">
          <xsl:value-of select="$bcell - 1" />
        </xsl:variable>
        <xsl:text>c</xsl:text>
        <xsl:number format="01" value="$ccell" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>c</xsl:text>
        <xsl:number count="cell" format="01" level="single" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Template for Table heads and captions -->
  <xsl:template name="tableHead">
    <xsl:attribute name="title">
      <xsl:value-of select="head" />
    </xsl:attribute>
    <caption>
      <xsl:value-of select="head" />
    </caption>
  </xsl:template>

  <xsl:template name="thScope">
    <xsl:attribute name="scope">
      <xsl:choose>
        <xsl:when test="../@role='label'">
          <xsl:text>col</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>row</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!--  TABLE: linkDisplay model  -->
  <xsl:template name="table-linkDisplay">
    <xsl:if test="head">
      <h6>
        <xsl:apply-templates select="head" />
      </h6>
    </xsl:if>
    <div class="resourceList">
      <xsl:call-template name="a-id" />
      <div class="t01">
        <dl>
          <xsl:apply-templates select="row" />
        </dl>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="row-linkDisplay">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="cell-linkDisplay">
    <xsl:call-template name="genCellLinkDisplay" />
  </xsl:template>

  <!--  TABLE: specialListDisplay model  -->

  <xsl:template name="table-specialListDisplay">
    <xsl:if test="head">
      <h6>
        <xsl:apply-templates select="head" />
      </h6>
    </xsl:if>
    <div class="resourceList">
      <xsl:call-template name="a-id" />
      <div class="t01">
        <dl>
          <xsl:apply-templates select="row" />
        </dl>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="row-specialListDisplay">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="cell-specialListDisplay">
    <xsl:call-template name="genCellLinkDisplay" />
  </xsl:template>


  <!--  Generic Cell processing  -->
  <!-- LinkBiblio and Special list Table template uses. Table => definition list transformation -->

  <xsl:template name="genCellLinkDisplay">
    <xsl:choose>
      <xsl:when test="not(preceding-sibling::cell)">
        <dt>
          <xsl:attribute name="class">
            <xsl:call-template name="r-num" />
            <xsl:call-template name="odd-even" />
          </xsl:attribute>
          <xsl:apply-templates />
        </dt>
      </xsl:when>
      <xsl:otherwise>
        <dd>
          <xsl:attribute name="class">
            <xsl:call-template name="r-num" />
            <xsl:text> </xsl:text>
            <xsl:call-template name="c-num" />
            <xsl:call-template name="odd-even" />
          </xsl:attribute>

          <xsl:choose>
            <!-- Output links -->
            <xsl:when test="@role='linkUrl'">
              <xsl:choose>
                <xsl:when test="not(xref) and not(xptr)">
                  <a href="{.}">
                    <xsl:apply-templates />
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- Default content -->
            <xsl:otherwise>
              <xsl:apply-templates />
            </xsl:otherwise>
          </xsl:choose>
        </dd>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  table: complexDisplay model  -->

  <!-- Test to prevent endless looping -->
  <xsl:template name="consistency-test">
    <xsl:param name="number-of-cells" />
    <xsl:for-each select="row[position()>1]">
      <xsl:variable name="cur-cell-count" select="count(cell) + sum(cell/@cols) - count(cell/@cols)" />
      <xsl:if test="$cur-cell-count > $number-of-cells">
        <xsl:text>1</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="table-complexDisplay">

    <!-- Number of rows in the table. -->
    <xsl:variable name="number-of-rows" select="count(row)" />
    <!-- Number of columns in a row. -->
    <xsl:variable name="number-of-cells"
      select="count(row[position() = 1]/cell) + sum(row[position() = 1]/cell/@cols) - count(row[position() = 1]/cell/@cols)" />

    <!-- To prevent extra cells causing the process to break -->
    <xsl:variable name="error">
      <xsl:call-template name="consistency-test">
        <xsl:with-param name="number-of-cells" select="$number-of-cells" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <!-- Test to prevent endless looping -->
      <xsl:when test="contains($error, '1')">
        <h3>Error converting table. Please check encoding for extra cells or missing colspans.</h3>
      </xsl:when>
      <!-- Output -->
      <xsl:otherwise>
        <div class="table">
          <xsl:call-template name="a-id" />
          <div class="t01">
            <table>
              <xsl:if test="string(head)">
                <xsl:call-template name="tableHead" />
              </xsl:if>
              <xsl:if test="row[@role='label']">
                <thead>
                  <xsl:apply-templates select="row[@role='label']">
                    <xsl:with-param name="number-of-rows" select="$number-of-rows" />
                    <xsl:with-param name="number-of-cells" select="$number-of-cells" />
                  </xsl:apply-templates>
                </thead>
              </xsl:if>
              <tbody>
                <xsl:apply-templates select="row[not(@role='label')]">
                  <xsl:with-param name="number-of-rows" select="$number-of-rows" />
                  <xsl:with-param name="number-of-cells" select="$number-of-cells" />
                </xsl:apply-templates>
              </tbody>
            </table>
          </div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="row-complexDisplay">
    <!-- Parameters passed through -->
    <xsl:param name="number-of-rows" />
    <xsl:param name="number-of-cells" />

    <!-- Variable for current row class -->
    <xsl:variable name="r-num">
      <xsl:choose>
        <xsl:when test="not(following-sibling::row)">
          <xsl:text>x02</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>r</xsl:text>
          <xsl:number count="row" format="01" level="single" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <tr>
      <xsl:attribute name="class">
        <xsl:value-of select="$r-num" />
        <!-- Shaded rows so that the borders show up -->
        <xsl:text> z01</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates>
        <xsl:with-param name="number-of-rows" select="$number-of-rows" />
        <xsl:with-param name="number-of-cells" select="$number-of-cells" />
        <xsl:with-param name="context-row" select="count(preceding-sibling::row) + 1" />
      </xsl:apply-templates>
    </tr>
  </xsl:template>

  <xsl:template name="cell-complexDisplay">
    <!-- Parameters passed through -->
    <xsl:param name="number-of-rows" />
    <xsl:param name="number-of-cells" />
    <xsl:param name="context-row" />

    <xsl:choose>
      <!-- Heading cells -->
      <xsl:when test="@role='label'">
        <th>
          <xsl:call-template name="cell-att">
            <xsl:with-param name="number-of-rows" select="$number-of-rows" />
            <xsl:with-param name="number-of-cells" select="$number-of-cells" />
            <xsl:with-param name="context-row" select="$context-row" />
          </xsl:call-template>

          <xsl:apply-templates />
        </th>
      </xsl:when>
      <!-- Data cells -->
      <xsl:otherwise>
        <td>
          <xsl:call-template name="cell-att">
            <xsl:with-param name="number-of-rows" select="$number-of-rows" />
            <xsl:with-param name="number-of-cells" select="$number-of-cells" />
            <xsl:with-param name="context-row" select="$context-row" />
          </xsl:call-template>

          <xsl:apply-templates />
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  TABLE: simpleDisplay model  -->

  <xsl:template name="table-simpleDisplay">
    <div class="table">
      <xsl:call-template name="a-id" />
      <!-- Type only changes if a project needs different formatting-->
      <div class="t01">
        <table>
          <xsl:if test="string(head)">
            <xsl:call-template name="tableHead" />
          </xsl:if>
          <xsl:if test="row[@role='label']">
            <thead>
              <xsl:apply-templates select="row[@role='label']" />
            </thead>
          </xsl:if>
          <tbody>
            <xsl:apply-templates select="row[@role='data' or not(@role)]" />
          </tbody>
        </table>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="row-simpleDisplay">

    <!-- Variable for alternate shading -->
    <xsl:variable name="oddeven">
      <xsl:call-template name="odd-even" />
    </xsl:variable>

    <!-- Variable for counting rows -->
    <xsl:variable name="r-num">
      <xsl:call-template name="r-num" />
    </xsl:variable>

    <tr>
      <xsl:attribute name="class">
        <xsl:value-of select="$r-num" />
        <xsl:value-of select="$oddeven" />
      </xsl:attribute>
      <xsl:apply-templates />
    </tr>
  </xsl:template>

  <xsl:template name="cell-simpleDisplay">

    <!-- Variable for counting cells -->
    <xsl:variable name="c-num">
      <xsl:call-template name="c-num" />
    </xsl:variable>


    <xsl:choose>
      <!-- Heading cells -->
      <xsl:when test="@role='label'">
        <th>
          <xsl:attribute name="class">
            <xsl:value-of select="$c-num" />
          </xsl:attribute>
          <xsl:call-template name="thScope" />

          <xsl:apply-templates />
        </th>
      </xsl:when>
      <!-- Data cells -->
      <xsl:otherwise>
        <td>
          <xsl:attribute name="class">
            <xsl:value-of select="$c-num" />
          </xsl:attribute>
          <xsl:apply-templates />
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- COMPLEX TABLE: complexDisplay cell attribute template -->

  <xsl:template name="cell-att">
    <xsl:param name="number-of-rows" />
    <xsl:param name="number-of-cells" />
    <xsl:param name="context-row" />

    <!-- Context cell position -->
    <xsl:variable name="con-cell-position"
      select="count(preceding-sibling::cell)  + sum(preceding-sibling::cell/@cols) - count(preceding-sibling::cell/@cols) + 1" />

    <xsl:variable name="updated-position">
      <xsl:call-template name="update-position">
        <xsl:with-param name="number-of-rows" select="$number-of-rows" />
        <xsl:with-param name="number-of-cells" select="$number-of-cells" />
        <xsl:with-param name="context-row" select="$context-row" />
        <xsl:with-param name="con-cell" select="$con-cell-position" />
        <!-- Cell position -->
        <xsl:with-param name="cell" select="1" />
        <!-- Row position -->
        <xsl:with-param name="row" select="1" />
        <!-- Total number of cells in the table -->
        <xsl:with-param name="count" select="count(ancestor::table//cell)" />
        <xsl:with-param name="pos" select="$con-cell-position" />
      </xsl:call-template>
    </xsl:variable>

    <!-- Output value of the column position -->
    <xsl:variable name="col-position">
      <xsl:choose>
        <!-- Test for last cell -->
        <!-- No spanning cell -->
        <xsl:when test="$updated-position = $number-of-cells">
          <xsl:text>x01</xsl:text>
        </xsl:when>
        <!-- Colspan on self -->
        <xsl:when test="$updated-position +@cols - 1 = $number-of-cells">
          <xsl:text>x01</xsl:text>
        </xsl:when>
        <!-- Normal numbering -->
        <xsl:otherwise>
          <xsl:text>c</xsl:text>
          <xsl:number format="01" value="$updated-position" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- ATTRIBUTE OUTPUTS -->

    <!-- class attributes including column position, rowspan and colspan -->
    <xsl:attribute name="class">
      <xsl:value-of select="$col-position" />

      <xsl:if test="string(@rows) and not(@rows='1')">
        <xsl:text> rs</xsl:text>
        <xsl:value-of select="@rows" />
      </xsl:if>
      <xsl:if test="string(@cols) and not(@cols='1')">
        <xsl:text> cs</xsl:text>
        <xsl:value-of select="@cols" />
      </xsl:if>
    </xsl:attribute>

    <!-- rowspan and colspan attributes -->
    <xsl:if test="string(@rows) and not(@rows='1')">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="@rows" />
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="string(@cols) and not(@cols='1')">
      <xsl:attribute name="colspan">
        <xsl:value-of select="@cols" />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!--
        Recursive template to calculate the position of cells in the table according to the previous cells. 
        The new position of the cell depends on the rowspans and colspans of the sibling cells and the cells in the
        previous rows.
    -->
  <xsl:template name="update-position">
    <xsl:param name="number-of-rows" />
    <xsl:param name="number-of-cells" />
    <xsl:param name="context-row" />
    <xsl:param name="con-cell" />
    <xsl:param name="cell" />
    <xsl:param name="row" />
    <xsl:param name="count" />
    <xsl:param name="pos" />

    <xsl:choose>
      <!-- Stop condition -->
      <xsl:when test="$count > 0">
        <!-- Update the count -->
        <xsl:variable name="new-count">
          <xsl:choose>
            <xsl:when test="ancestor::table/row[position() = $row]/cell[position() = $cell]">
              <xsl:value-of select="$count - 1" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$count" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="new-pos">
          <xsl:choose>
            <xsl:when test="ancestor::table/row[position() = $row and $context-row > position()]/cell[position() = $cell and @rows]">
              <!-- Cases where preceding-siblings of the cell being tested have colspan -->
              <xsl:variable name="pre-cols"
                select="sum(ancestor::table/row[position() = $row]/cell[position() = $cell]/preceding-sibling::cell[$cell > position()]/@cols)" />

              <!-- 
                The position of the context cell is updated if there are rowspans in previous cells of the previous rows and the
                column spans until the context cell position.
              -->
              <xsl:choose>
                <xsl:when
                  test="$pos >= $cell + $pre-cols and $row + ancestor::table/row[position() = $row]/cell[position() = $cell]/@rows - 1 >= $context-row">
                  <!-- 
                    Creates the value that is added to the context cell position. Where there are colspans, it adds the value of the colspan,
                    otherwise it just increases the value of the context cell by one.
                  -->
                  <xsl:variable name="step">
                    <xsl:choose>
                      <xsl:when test="ancestor::table/row[position() = $row]/cell[position() = $cell and @cols]">
                        <xsl:value-of select="ancestor::table/row[position() = $row]/cell[position() = $cell]/@cols" />
                      </xsl:when>
                      <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>

                  <xsl:value-of select="$pos + $step" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$pos" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$pos" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Position of the new cell being tested -->
        <xsl:variable name="new-cell">
          <xsl:choose>
            <xsl:when test="$number-of-cells > $cell">
              <xsl:value-of select="$cell + 1" />
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Checks if the row position needs to be incremented -->
        <xsl:variable name="new-row">
          <xsl:choose>
            <xsl:when test="$cell = $number-of-cells">
              <xsl:value-of select="$row + 1" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$row" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- 
          Recurs a call to the current template with the updated values of the context cell position, previous row position and previous cell
          position that was tested last. 
        -->
        <xsl:call-template name="update-position">
          <xsl:with-param name="number-of-rows" select="$number-of-rows" />
          <xsl:with-param name="number-of-cells" select="$number-of-cells" />

          <xsl:with-param name="context-row" select="$context-row" />
          <xsl:with-param name="con-cell" select="$con-cell" />

          <xsl:with-param name="cell" select="$new-cell" />
          <xsl:with-param name="row" select="$new-row" />

          <xsl:with-param name="count" select="$new-count" />
          <xsl:with-param name="pos" select="$new-pos" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pos" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  END Table templates     -->


  <!--   NEW BIB SECTION     -->
  <xsl:template match="listBibl">
    <ul>
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="bibl[parent::listBibl]">
    <li>
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <xsl:template match="listBibl/head">
    <caption>
      <strong>
        <xsl:apply-templates />
      </strong>
    </caption>
  </xsl:template>

  <xsl:template match="title">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <xsl:template match="author">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>


  <!--   BLOCKQUOTES   -->
  <xsl:template match="quote">
    <blockquote>
      <xsl:apply-templates />
    </blockquote>
  </xsl:template>

  <!-- The 'q' element is no longer used, but template kept for legacy reasons -->
  <xsl:template match="q">
    <blockquote>
      <p>
        <xsl:apply-templates />
      </p>
    </blockquote>
  </xsl:template>


  <!--   ADDRESSES   -->
  <xsl:template match="address">
    <address>
      <xsl:apply-templates />
    </address>
    <xsl:if test="following-sibling::address">
      <br />
    </xsl:if>
  </xsl:template>

  <xsl:template match="addrLine">
    <!-- START automatic links or email addresses -->
    <xsl:choose>
      <xsl:when test="@type='email'">
        <a href="mailto:{text()}">
          <xsl:apply-templates />
        </a>
      </xsl:when>
      <xsl:when test="@type='url'">
        <a href="{.}">
          <xsl:apply-templates />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
    <!-- END automatic links or email addresses -->
    <xsl:if test="following-sibling::addrLine">
      <br />
    </xsl:if>
  </xsl:template>


  <!--   FIGURES   -->
  <xsl:template match="figure">
    <xsl:if test="string(@url)">
      <xsl:choose>
        <xsl:when test="@type='thumb-caption'" />
        <xsl:otherwise>
          <xsl:call-template name="showFigure" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- Image dimensions -->
  <xsl:template name="img-dim">
    <xsl:param name="img-width" />
    <xsl:param name="img-height" />
    <xsl:attribute name="width">
      <xsl:value-of select="$img-width" />
    </xsl:attribute>
    <xsl:attribute name="height">
      <xsl:value-of select="$img-height" />
    </xsl:attribute>
  </xsl:template>
  <!-- Popup information -->
  <xsl:template name="img-popup">
    <xsl:param name="popup" />
    <xsl:choose>
      <xsl:when test="string($popup)">
        <xsl:value-of select="$popup" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>x87</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- SHOW FIGURE -->
  <xsl:template name="showFigure">
    <!--   Find info for publication images  -->
    <!-- folder info -->
    <xsl:variable name="img-group-folder" select="//imagebase//image[@id=current()/@url]/parent::*/groupHead/groupFolder" />
    <xsl:variable name="img-subpath-full" select="'full/'" />
    <xsl:variable name="img-subpath-thumb" select="'thumb/'" />
    <!-- file info -->
    <xsl:variable name="img-id" select="//imagebase//image[@id=current()/@url]/@id" />
    <xsl:variable name="img-ext" select="//imagebase//image[@id=current()/@url]/ext/@n" />
    <xsl:variable name="img-src" select="concat($img-id, '.', $img-ext)" />
    <xsl:variable name="img-thm-prefix" select="'thm_'" />
    <!-- path to images -->
    <xsl:variable name="img-path-full">
      <xsl:value-of select="$pubimgswitch" />
      <xsl:value-of select="$img-subpath-full" />
      <xsl:value-of select="$img-src" />
    </xsl:variable>
    <xsl:variable name="img-path-thumb">
      <xsl:value-of select="$pubimgswitch" />
      <xsl:value-of select="$img-subpath-thumb" />
      <xsl:value-of select="$img-group-folder" />
      <xsl:value-of select="$img-thm-prefix" />
      <xsl:value-of select="$img-src" />
    </xsl:variable>
    <!-- Dimensions -->
    <xsl:variable name="img-width" select="//imagebase//image[@id=current()/@url]/width" />
    <xsl:variable name="img-height" select="//imagebase//image[@id=current()/@url]/height" />
    <xsl:variable name="img-thm-width" select="//imagebase//image[@id=current()/@url]/thmWidth" />
    <xsl:variable name="img-thm-height" select="//imagebase//image[@id=current()/@url]/thmHeight" />
    <xsl:variable name="img-max-height-full">
      <xsl:for-each select="ancestor::list[starts-with(@type, 'figure')]/item">
        <xsl:sort data-type="number" order="descending"
          select="document('../../xml/03_alist/AL_imageBase.xml')//image[@id=current()/figure/@url]/height" />

        <xsl:variable name="cur-img-url" select="figure/@url" />
        <xsl:variable name="cur-img-height" select="number(document('../../xml/03_alist/AL_imageBase.xml')//image[@id=$cur-img-url]/height)" />

        <xsl:if test="position()=1">
          <xsl:value-of select="$cur-img-height" />
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="img-max-height-thumb">
      <xsl:for-each select="ancestor::list[not(@type='figure-list')][starts-with(@type, 'figure')]/item">
        <xsl:sort data-type="number" order="descending"
          select="document('../../xml/03_alist/AL_imageBase.xml')//image[@id=current()/figure/@url]/thmHeight" />

        <xsl:variable name="cur-img-url" select="figure/@url" />
        <xsl:variable name="cur-img-height" select="number(document('../../xml/03_alist/AL_imageBase.xml')//image[@id=$cur-img-url]/thmHeight)" />

        <xsl:if test="position()=1">
          <xsl:value-of select="$cur-img-height" />
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <!-- Caption or description -->
    <xsl:variable name="img-caption" select="//imagebase//image[@id=current()/@url]/caption" />
    <xsl:variable name="img-desc" select="//imagebase//image[@id=current()/@url]/desc" />
    <xsl:variable name="img-cap-desc">
      <xsl:choose>
        <xsl:when test="string($img-caption)">
          <xsl:value-of select="$img-caption" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$img-desc" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="img-desc-cap">
      <xsl:choose>
        <xsl:when test="string($img-desc)">
          <xsl:value-of select="$img-desc" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$img-caption" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Rendition info -->
    <!-- extra width to delimit captions for the inline thumbnails -->
    <xsl:variable name="img-thm-plus-width" select="$img-thm-width + 12" />
    <!-- Use for the image: prefix with 's' and the div: prefix with 't' -->
    <xsl:variable name="img-left-right">
      <xsl:choose>
        <xsl:when test="contains(@rend, 'left')">
          <xsl:text>01</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@rend, 'right')">
          <xsl:text>02</xsl:text>
        </xsl:when>
        <xsl:otherwise />
      </xsl:choose>
    </xsl:variable>
    <!-- Used on the anchor for thumb-captions -->
    <xsl:variable name="cap-left-right">
      <xsl:choose>
        <xsl:when test="contains(@rend, 'left')">
          <xsl:text>s03</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@rend, 'right')">
          <xsl:text>s04</xsl:text>
        </xsl:when>
        <xsl:otherwise />
      </xsl:choose>
    </xsl:variable>
    <!-- Different popup options, x87: shrink to fit, x88 and x89 different html pages -->
    <xsl:variable name="popup">
      <xsl:choose>
        <xsl:when test="contains(@rend, 'img') or ancestor::table[@type='thumbnail'][@rend='img']">
          <xsl:text>x87</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@rend, 'html1') or ancestor::table[@type='thumbnail'][@rend='html1']">
          <xsl:text>x88</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@rend, 'html2') or ancestor::table[@type='thumbnail'][@rend='html2']">
          <xsl:text>x89</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- OUTPUT FIGURE TEMPLATE -->
    <xsl:choose>
      <!-- START Option 1: showing thumbnail tables -->
      <!-- Should no longer have thumbnails in tables replaced with ones in lists-->
      <xsl:when test="ancestor::table/@type='thumbnail'">
        <!-- Popup full image path -->
        <a href="{$img-path-full}">
          <xsl:attribute name="class">
            <xsl:call-template name="img-popup">
              <xsl:with-param name="popup" select="$popup" />
            </xsl:call-template>
          </xsl:attribute>

          <!-- Thumbnail path -->
          <img src="{$img-path-thumb}">

            <!-- @alt info -->
            <xsl:if test="string($img-cap-desc)">
              <xsl:attribute name="alt">
                <xsl:value-of select="$img-cap-desc" />
              </xsl:attribute>
            </xsl:if>
            <!-- dimension info -->
            <!-- 
              <xsl:call-template name="img-dim">
              <xsl:with-param name="img-width" select="$img-width"/>
              <xsl:with-param name="img-height" select="$img-height"/>
              </xsl:call-template>
            -->
          </img>
        </a>
      </xsl:when>

      <xsl:when test="ancestor::list[@type='figure-full']">
        <dl style="width: {$img-width}px;">
          <dt style="height: {$img-max-height-full}px;">
            <!-- Image -->
            <img src="{$img-path-full}">
              <!-- @alt info -->
              <xsl:if test="string($img-cap-desc)">
                <xsl:attribute name="alt">
                  <xsl:value-of select="$img-cap-desc" />
                </xsl:attribute>
              </xsl:if>
            </img>
          </dt>
          <dd>
            <p>
              <xsl:value-of select="$img-cap-desc" />
            </p>
          </dd>
        </dl>
      </xsl:when>

      <xsl:when test="ancestor::list[@type='figure-thumb']">
        <dl style="width: {$img-thm-width}px;">
          <dt style="height: {$img-max-height-thumb}px;">
            <!-- Full size popup -->
            <a class="x87" href="{$img-path-full}">
              <span>&#160;</span>
              <!-- Thumbnail image -->
              <img src="{$img-path-thumb}">
                <!-- @alt info -->
                <xsl:if test="string($img-cap-desc)">
                  <xsl:attribute name="alt">
                    <xsl:value-of select="$img-cap-desc" />
                  </xsl:attribute>
                </xsl:if>
              </img>
            </a>
          </dt>
          <dd>
            <p>
              <xsl:value-of select="$img-cap-desc" />
            </p>
          </dd>
        </dl>
      </xsl:when>

      <xsl:when test="ancestor::list[@type='figure-list']">
        <img>
          <xsl:attribute name="src">
            <xsl:value-of select="$pubimgswitch" />
            <xsl:value-of select="$img-subpath-full" />
            <xsl:value-of select="$img-src" />
          </xsl:attribute>
          <!-- IMG @ALT INFO STARTS -->
          <xsl:choose>
            <xsl:when test="string($img-desc)">
              <xsl:attribute name="alt">
                <xsl:value-of select="$img-desc" />
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="alt">
                <xsl:value-of select="$img-caption" />
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <!-- IMG @ALT INFO ENDS -->
          <xsl:attribute name="width">
            <xsl:value-of select="$img-width" />
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:value-of select="$img-height" />
          </xsl:attribute>
        </img>
      </xsl:when>

      <!-- START Option 2: Inline images -->
      <!-- Images with renditional information are treated differently, they can be thumbnails, thumbnails with captions or full sized images -->
      <xsl:when test="string(@rend)">
        <xsl:choose>
          <xsl:when test="@type='thumb'">
            <a href="{$img-path-full}">
              <xsl:attribute name="class">
                <xsl:value-of select="$cap-left-right" />
                <xsl:text> </xsl:text>
                <xsl:call-template name="img-popup">
                  <xsl:with-param name="popup" select="$popup" />
                </xsl:call-template>
              </xsl:attribute>
              <span>&#160;</span>
              <img class="s{$img-left-right}" src="{$img-path-thumb}">
                <!-- @alt info -->
                <xsl:if test="string($img-cap-desc)">
                  <xsl:attribute name="alt">
                    <xsl:value-of select="$img-cap-desc" />
                  </xsl:attribute>
                </xsl:if>
              </img>
            </a>
          </xsl:when>
          <!-- Thumbnail with caption inline image -->
          <xsl:when test="@type='thumb-caption'">
            <div class="figure">
              <div class="t{$img-left-right}">
                <dl style="width: {$img-thm-plus-width}px;">
                  <dt>
                    <!-- Full size popup -->
                    <a href="{$img-path-full}">
                      <xsl:attribute name="class">
                        <xsl:value-of select="$cap-left-right" />
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="img-popup">
                          <xsl:with-param name="popup" select="$popup" />
                        </xsl:call-template>
                      </xsl:attribute>
                      <span>&#160;</span>
                      <!-- Thumbnail image -->
                      <img class="s{$img-left-right}" src="{$img-path-thumb}">
                        <!-- @alt info -->
                        <xsl:if test="string($img-cap-desc)">
                          <xsl:attribute name="alt">
                            <xsl:value-of select="$img-cap-desc" />
                          </xsl:attribute>
                        </xsl:if>
                      </img>
                    </a>
                  </dt>
                  <dd>
                    <xsl:value-of select="$img-cap-desc" />
                  </dd>
                </dl>
              </div>
            </div>
          </xsl:when>
          <!-- Full size inline image -->
          <xsl:otherwise>
            <img class="s{$img-left-right}" src="{$img-path-full}">
              <!-- @alt info -->
              <xsl:if test="string($img-desc-cap)">
                <xsl:attribute name="alt">
                  <xsl:value-of select="$img-desc-cap" />
                </xsl:attribute>
              </xsl:if>
            </img>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- START Option 3: showing oneoff thumbnail -->
      <xsl:when test="@type='thumb'">
        <!-- Displayed in a div unlike the thumbnails which are inline. -->
        <div class="image">
          <div class="t03">
            <dl style="width: {$img-thm-plus-width}px;">
              <dt>
                <!-- Full size popup -->
                <a href="{$img-path-full}">
                  <xsl:attribute name="class">
                    <xsl:call-template name="img-popup">
                      <xsl:with-param name="popup" select="$popup" />
                    </xsl:call-template>
                  </xsl:attribute>
                  <span>&#160;</span>
                  <!-- Thumbnail image -->
                  <img class="s{$img-left-right}" src="{$img-path-thumb}">
                    <!-- @alt info -->
                    <xsl:if test="string($img-cap-desc)">
                      <xsl:attribute name="alt">
                        <xsl:value-of select="$img-cap-desc" />
                      </xsl:attribute>
                    </xsl:if>
                  </img>
                </a>
              </dt>
              <dd>
                <xsl:value-of select="$img-cap-desc" />
              </dd>
            </dl>
          </div>
        </div>
      </xsl:when>

      <!-- START Option 4: showing logo tables -->
      <xsl:when test="ancestor::table/@type='logo'">
        <img src="{$img-path-full}">
          <!-- @alt info -->
          <xsl:if test="string($img-desc-cap)">
            <xsl:attribute name="alt">
              <xsl:value-of select="$img-desc-cap" />
            </xsl:attribute>
          </xsl:if>
          <!-- dimension info -->
          <xsl:call-template name="img-dim">
            <xsl:with-param name="img-width" select="$img-width" />
            <xsl:with-param name="img-height" select="$img-height" />
          </xsl:call-template>
        </img>
      </xsl:when>

      <!-- START Default: show full image -->
      <xsl:otherwise>
        <!-- Changed: div is centered -->
        <div class="image">
          <div class="t03">
            <dl style="width: {$img-width}px;">
              <dt>
                <img src="{$img-path-full}">
                  <!-- @alt info -->
                  <xsl:if test="string($img-desc-cap)">
                    <xsl:attribute name="alt">
                      <xsl:value-of select="$img-desc-cap" />
                    </xsl:attribute>
                  </xsl:if>
                  <!-- dimension info -->
                  <xsl:call-template name="img-dim">
                    <xsl:with-param name="img-width" select="$img-width" />
                    <xsl:with-param name="img-height" select="$img-height" />
                  </xsl:call-template>
                </img>
              </dt>
              <dd>
                <xsl:value-of select="$img-desc-cap" />
              </dd>
            </dl>
          </div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!--   PHRASE LEVEL   -->

  <!--   LINKS: xref   -->
  <xsl:template match="xref">
    <!-- NOTE: the main types of links are now specified using @type. Any reference to @rend is legacy only, and kept in the code just in case, but @rend should not be used. -->

    <!-- VARIABLES FOR NORMAL INTERNAL LINKS -->
    <xsl:variable name="internal-link-path" select="//filebase//item[@id=current()/@from]/parent::*/groupHead/groupFolder" />
    <xsl:variable name="internal-link-filename" select="//filebase//item[@id=current()/@from]/fileName" />
    <xsl:variable name="internal-link-filetitle" select="//filebase//item[@id=current()/@from]/fileTitle" />
    <xsl:variable name="internal-link-anchor" select="@n" />

    <!-- VARIABLES FOR GROUP INTERNAL LINKS -->

    <!-- specify 'id' in fileBase of group that requires extra directory, e.g. type03 docs -->
    <xsl:variable name="give-group-model2-id" select="$group-type03-id" />

    <xsl:variable name="internal-link-group-path-2-prep" select="substring-before(substring-after(@url, $text-type03-pre), '_')" />

    <!-- For most documents, no extra directory needed -->
    <xsl:variable name="internal-link-group-path1" select="//filebase//group[@id=current()/@from]/groupHead/groupFolder" />

    <!-- For type03 documents, need extra directory to appear -->
    <xsl:variable name="internal-link-group-path2" select="concat($internal-link-group-path1, '/', $internal-link-group-path-2-prep)" />

    <!-- Other variables -->
    <xsl:variable name="internal-link-group-filename" select="substring-after(@url, $text-type03-pre)" />
    <xsl:variable name="internal-link-group-anchor" select="@n" />


    <!--START MAIN THREE CASES -->
    <xsl:choose>
      <!-- START First option: external urls -->
      <xsl:when test="@type='external' or @rend='external'">
        <a href="{@url}">
          <xsl:call-template name="extWindow" />
          <xsl:apply-templates />
        </a>
      </xsl:when>
      <!-- END First option: external urls -->

      <!-- START Second option: emails -->
      <xsl:when test="@type='email' or @rend='email'">
        <a class="mail" href="mailto:{@url}" title="Email link">
          <xsl:apply-templates />
        </a>
      </xsl:when>
      <!-- END Second option: emails -->

      <!-- START Third option: internal pointer -->
      <xsl:when test="@type='internal' or @rend='internal'">
        <xsl:choose>
          <!--  Pointers to groups  -->
          <!-- This model could test for certain 'ids' only, instead of being so general as 'starting with 'g'' -->
          <xsl:when test="starts-with(@from, 'g')">
            <a>
              <xsl:call-template name="intWindow">
                <xsl:with-param name="linked-filename" select="$internal-link-group-filename" />
              </xsl:call-template>
              <xsl:attribute name="href">
                <xsl:value-of select="$linkroot" />
                <!-- START choose path -->
                <xsl:choose>
                  <!-- If the group is a type03 for the extra folder -->
                  <xsl:when test="@from = $give-group-model2-id">
                    <xsl:value-of select="$internal-link-group-path2" />
                  </xsl:when>
                  <!-- Gets the path from filebase -->
                  <xsl:otherwise>
                    <xsl:value-of select="$internal-link-group-path1" />
                  </xsl:otherwise>
                </xsl:choose>
                <!-- END choose path -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$internal-link-group-filename" />
                <xsl:text>.html</xsl:text>
                <!-- START specify anchor -->
                <xsl:if test="@n">
                  <xsl:text>#</xsl:text>
                  <xsl:value-of select="$internal-link-group-anchor" />
                </xsl:if>
                <!-- END specify anchor -->
              </xsl:attribute>
              <xsl:apply-templates />
            </a>
          </xsl:when>

          <!--  Pointers to individual files  -->
          <xsl:otherwise>
            <a>
              <xsl:call-template name="intWindow">
                <xsl:with-param name="linked-filename" select="$internal-link-filetitle" />
              </xsl:call-template>
              <xsl:attribute name="href">
                <xsl:value-of select="$linkroot" />
                <xsl:value-of select="$internal-link-path" />
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$internal-link-filename" />
                <xsl:text>.html</xsl:text>
                <xsl:if test="@n">
                  <xsl:text>#</xsl:text>
                  <xsl:value-of select="$internal-link-anchor" />
                </xsl:if>
              </xsl:attribute>
              <xsl:apply-templates />
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- END Third option: internal pointer -->

      <!-- START Fourth option: redist urls -->
      <xsl:when test="@type='redist'">
        <a class="file">
          <xsl:attribute name="title">
            <xsl:text>File Link (</xsl:text>
            <xsl:value-of select="substring-after(@from, '.')" />
            <xsl:text>file)</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$linkroot" />
            <xsl:text>/redist/</xsl:text>
            <xsl:value-of select="@from" />
          </xsl:attribute>
          <xsl:apply-templates />
        </a>
      </xsl:when>
      <!-- END Fourth option: redist urls -->

      <!-- START DEFAULT option: external urls -->
      <!-- For some reason XMetal doesn't output default attributes, so treat all others as external links -->
      <xsl:otherwise>
        <a href="{@url}">
          <xsl:call-template name="extWindow" />
          <xsl:apply-templates />
        </a>
      </xsl:otherwise>
      <!-- END DEFAULT option: external urls -->
    </xsl:choose>
  </xsl:template>

  <!-- href classes for same or new window -->
  <xsl:template name="extWindow">
    <!-- Title information and extra class for if external window -->
    <xsl:choose>
      <!-- Open in a new window -->
      <xsl:when test="@rend='newWindow'">
        <xsl:attribute name="class">
          <xsl:text>extNew</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="rel">
          <xsl:text>external</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>External website (Opens in a new window)</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <!-- Open in same window -->
      <xsl:otherwise>
        <xsl:attribute name="class">
          <xsl:text>ext</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>External website</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="intWindow">
    <xsl:param name="linked-filename" />
    <!-- Title information and extra class for if external window -->
    <xsl:choose>
      <!-- Open in a new window -->
      <xsl:when test="@rend='newWindow'">
        <xsl:attribute name="class">
          <xsl:text>intNew</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="rel">
          <xsl:text>external</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>Link to </xsl:text>
          <xsl:value-of select="$linked-filename" />
          <xsl:text> (Opens in a new window)</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <!-- Open in same window -->
      <xsl:otherwise>
        <xsl:attribute name="class">
          <xsl:text>int</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>Link to </xsl:text>
          <xsl:value-of select="$linked-filename" />
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--   LINKS: other models     -->
  <xsl:template match="ref">
    <!-- INTERNAL LINKS IN SAME OUTPUT DOCUMENT. This *won't* work if the pointer leads to a different output file -->
    <a href="#{@target}" title="Link internal to this page">
      <xsl:apply-templates />
    </a>
  </xsl:template>

  <xsl:template match="anchor">
    <a id="{@id}" />
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xptr">
    <a href="{@from}">
      <xsl:choose>
        <xsl:when test="starts-with(@from, 'http://')">
          <xsl:call-template name="extWindow" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="title">
            <xsl:text>Encoding error: @from does not start with 'http://'</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@from" />
    </a>
  </xsl:template>


  <!--  UBI     -->
  <xsl:template match="hi">
    <xsl:choose>
      <!-- ITALICS -->
      <xsl:when test="@rend='italic'">
        <em>
          <xsl:apply-templates />
        </em>
      </xsl:when>
      <!-- BOLD -->
      <xsl:when test="@rend='bold'">
        <strong>
          <xsl:apply-templates />
        </strong>
      </xsl:when>
      <!-- BOLD AND ITALICS -->
      <xsl:when test="@rend='bolditalic'">
        <strong>
          <em>
            <xsl:apply-templates />
          </em>
        </strong>
      </xsl:when>
      <!-- CURRENT DEFAULT: italics -->
      <xsl:otherwise>
        <em>
          <xsl:apply-templates />
        </em>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--   FOOTNOTES     -->
  <xsl:template match="note">
    <sup>
      <a class="fnLink">
        <xsl:attribute name="href">
          <xsl:text>#fn</xsl:text>
          <xsl:number format="01" from="text" level="any" />
        </xsl:attribute>
        <xsl:attribute name="id">
          <xsl:text>fnLink</xsl:text>
          <xsl:number format="01" from="text" level="any" />
        </xsl:attribute>
        <xsl:number from="text" level="any" />
      </a>
    </sup>

    <!--  TOOK OUT THIS: count="note" from="group/text" -->
  </xsl:template>


  <!--   VARIOUS TERMS   -->
  <xsl:template match="foreign">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <xsl:template match="rs">
    <xsl:if test="@type='keyconcept'">
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="ancestor::TEI.2/@id" />
          <xsl:text>-kc</xsl:text>
          <xsl:number level="any" />
        </xsl:attribute>
      </a>
    </xsl:if>
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <xsl:template match="date[not(ancestor::bibl)]">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <xsl:template match="emph">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>


  <!--   SEARCHABLE TESTS   -->
  <xsl:template match="name">
    <span>
      <xsl:attribute name="id">
        <xsl:value-of select="ancestor::TEI.2/@id" />
        <xsl:text>-</xsl:text>
        <xsl:number level="any" />
      </xsl:attribute>
      <xsl:apply-templates />
    </span>
  </xsl:template>

</xsl:stylesheet>
