<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:include href="../common/proj_vars.xsl"/>
  <xsl:variable name="file-id">
    <xsl:value-of select="substring-after($context-id, 'zoomify-')" />
  </xsl:variable>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
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

        <title>Zoomify image</title>
        <link href="{$scriptswitch}/c/default.css" media="screen, projection" rel="stylesheet" type="text/css"/>
        <link href="{$scriptpers}/c/personality.css" media="screen, projection" rel="stylesheet" type="text/css"/>
        <link href="{$scriptswitch}/c/print.css" media="print" rel="stylesheet" type="text/css"/>

        <!-- IE browser specific css and script -->
        <xsl:comment>[if GTE IE 7]> &lt;link rel="stylesheet" type="text/css" href="<xsl:value-of select="$scriptpers"/>/c/compat.css"/> &lt;![endif]</xsl:comment>

      </head>
      <body id="xmd" class="v1 r3 pu">
        <div id="mainContent">
          <object type="application/x-shockwave-flash" data="http://137.73.123.18/zoomify/zoomifyViewer.swf" width="500" height="600">
            <param name="movie" value="http://137.73.123.18/zoomify/zoomifyViewer.swf"/>
            <param name="FlashVars" value="zoomifyImagePath=http://137.73.123.18/ncse/liv/zoomify/{$file-id}/"/>
            <img src="noflash.gif" width="200" height="100" alt=""/>
          </object>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
