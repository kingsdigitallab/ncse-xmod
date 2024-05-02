<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output name="output" method="xml" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:for-each select="//Row">
            <!-- first <Row> is column headings, so ignore it -->
            <xsl:variable name="NCSE_id" select="child::Cell[1]/Data"/>
            <xsl:variable name="output_file_href"
                select="concat(replace($NCSE_id,'/', '_'), '.xml')"/>
            <xsl:variable name="Serial_name">
                <xsl:choose>
                    <xsl:when test="string-length(child::Cell[3]/Data/text()) != 0">
                        <xsl:value-of select="child::Cell[3]/Data"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>[Unknown]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Vol_num">
                <xsl:choose>
                    <xsl:when test="string-length(child::Cell[4]/Data/text()) != 0">
                        <xsl:value-of select="child::Cell[4]/Data"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>[n/a]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Issue_num">
                <xsl:choose>
                    <xsl:when test="string-length(child::Cell[5]/Data/text()) != 0">
                        <xsl:choose><!-- aieee, what a hack -->
                            <xsl:when test="substring(child::Cell[5]/Data/text(), 1, 1) = '1'">
                                <xsl:value-of select="child::Cell[5]/Data"/>
                            </xsl:when>
                            <xsl:when test="substring(child::Cell[5]/Data/text(), 1, 1) = '2'">
                                <xsl:value-of select="child::Cell[5]/Data"/>
                            </xsl:when>
                            <xsl:when test="substring(child::Cell[5]/Data/text(), 1, 1) = '3'">
                                <xsl:value-of select="child::Cell[5]/Data"/>
                            </xsl:when>
                            <xsl:when test="substring(child::Cell[5]/Data/text(), 1, 1) = '4'">
                                <xsl:value-of select="child::Cell[5]/Data"/>
                            </xsl:when>
                            <xsl:when test="substring(child::Cell[5]/Data/text(), 1, 1) = '5'">
                                <xsl:value-of select="child::Cell[5]/Data"/>
                            </xsl:when>
                            <xsl:when test="substring(child::Cell[5]/Data/text(), 1, 1) = '6'">
                                <xsl:value-of select="child::Cell[5]/Data"/>
                            </xsl:when>
                            <xsl:when test="substring(child::Cell[5]/Data/text(), 1, 1) = '7'">
                                <xsl:value-of select="child::Cell[5]/Data"/>
                            </xsl:when>
                            <xsl:when test="substring(child::Cell[5]/Data/text(), 1, 1) = '8'">
                                <xsl:value-of select="child::Cell[5]/Data"/>
                            </xsl:when>
                            <xsl:when test="substring(child::Cell[5]/Data/text(), 1, 1) = '9'">
                                <xsl:value-of select="child::Cell[5]/Data"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>[</xsl:text>
                                <xsl:value-of select="lower-case(child::Cell[5]/Data)"/>
                                <xsl:text>]</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>[n/a]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Edition_TOC">
                <xsl:choose>
                    <xsl:when test="string-length(child::Cell[5]/Data/text()) != 0">
                        <xsl:value-of select="lower-case(child::Cell[6]/Data)"/>
                    </xsl:when>
                    <xsl:otherwise>[n/a]</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Editor">
                <xsl:choose>
                    <xsl:when test="string-length(child::Cell[8]/Data/text()) != 0">
                        <xsl:value-of select="replace(child::Cell[8]/Data, ';', '; ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>[Unknown]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Publisher">
                <xsl:choose>
                    <xsl:when test="string-length(child::Cell[9]/Data/text()) != 0">
                        <xsl:value-of select="replace(child::Cell[9]/Data, ';', '; ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>[Unknown]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Date_string_year">
                <xsl:choose>
                    <xsl:when test="child::Cell[2]/Data[@ss:Type=DateTime]">
                        <xsl:value-of select="substring(child::Cell[2]/Data, 1, 4)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(substring-after($NCSE_id, '/'), 1, 4)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Date_string_month">
                <xsl:choose>
                    <xsl:when test="child::Cell[2]/Data[@ss:Type=DateTime]">
                        <xsl:value-of select="substring(child::Cell[2]/Data, 6, 2)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(substring-after($NCSE_id, '/'), 6, 2)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Date_string_day">
                <xsl:choose>
                    <xsl:when test="child::Cell[2]/Data[@ss:Type=DateTime]">
                        <xsl:value-of select="substring(child::Cell[2]/Data, 9, 2)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(substring-after($NCSE_id, '/'), 9, 2)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="thumbnail">
                <xsl:choose>
                    <xsl:when test="contains($NCSE_id, 'EW')">
                        <xsl:text>ewj.png</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'LD')">
                        <xsl:text>ldr.png</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'MR')">
                        <xsl:text>mr.png</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'NS')">
                        <xsl:text>ns.png</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'TEC')">
                        <xsl:text>pc.png</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'TTW')">
                        <xsl:text>th.png</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="generic_name">
                <xsl:choose>
                    <xsl:when test="contains($NCSE_id, 'EW')">
                        <xsl:text>English Woman's Journal</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'LD')">
                        <xsl:text>Leader</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'MR')">
                        <xsl:text>Monthly Repository</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'NS')">
                        <xsl:text>Northern Star</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'TEC')">
                        <xsl:text>Publishers' Circular</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($NCSE_id, 'TTW')">
                        <xsl:text>Tomahawk</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="position()=2">
                <!-- gives us some output to check what the variables templates above are producing -->
                <div id="var_values_check">
                    <p>NCSE_id = <xsl:value-of select="$NCSE_id"/></p>
                    <p>output_file_href = <xsl:value-of select="$output_file_href"/></p>
                    <p>Serial_name = <xsl:value-of select="$Serial_name"/></p>
                    <p>Vol_num = <xsl:value-of select="$Vol_num"/></p>
                    <p>Issue_num = <xsl:value-of select="$Issue_num"/></p>
                    <p>Editor = <xsl:value-of select="$Editor"/></p>
                    <p>Publisher = <xsl:value-of select="$Publisher"/></p>
                    <p>Date_string_year = <xsl:value-of select="$Date_string_year"/></p>
                    <p>Date_string_month = <xsl:value-of select="$Date_string_month"/></p>
                    <p>Date_string_day = <xsl:value-of select="$Date_string_day"/></p>
                    <p>thumbnail = <xsl:value-of select="$thumbnail"/></p>
                    <p>generic_name = <xsl:value-of select="$generic_name"/></p>
                </div>
            </xsl:if>
            <xsl:choose>
                <!-- in the "when" test below we're just checking for duplicate values in the first column; we had some in the early version of the spreadsheet but probably none remain -->
                <xsl:when test="preceding-sibling::Row/child::Cell[1]/Data = $NCSE_id"/>
                <xsl:otherwise>
                    <xsl:result-document format="output" href="{$output_file_href}">
                        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                            xmlns:dc="http://purl.org/dc/elements/1.1/"
                            xmlns:collex="http://www.collex.org/schema#"
                            xmlns:dcterms="http://purl.org/dc/terms/"
                            xmlns:ncse="http://www.ncse.ac.uk/"
                            xmlns:role="http://www.loc.gov/loc.terms/relators">
                            <ncse:doc>
                                <xsl:attribute name="rdf:about"
                                    select="concat('http://ncse-viewpoint.cch.kcl.ac.uk/?href=',$NCSE_id,'&amp;page=1&amp;view=document')"/>
                                <collex:archive>ncse</collex:archive>
                                <dc:title>
                                    <xsl:value-of select="$Serial_name"/>
                                    <xsl:text> volume </xsl:text>
                                    <xsl:value-of select="$Vol_num"/>
                                    <xsl:text>, number </xsl:text>
                                    <xsl:value-of select="$Issue_num"/>
                                    <xsl:if test="string-length($Edition_TOC) != 0">
                                        <xsl:text>, edition: </xsl:text>
                                        <xsl:value-of select="$Edition_TOC"/>
                                    </xsl:if>
                                </dc:title>
                                <dc:date>
                                    <xsl:variable name="month">
                                        <xsl:call-template name="months_of_the_year">
                                            <xsl:with-param name="string"
                                                select="$Date_string_month"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <collex:date>
                                        <rdfs:label>
                                            <xsl:value-of select="$Date_string_day"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="$month"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="$Date_string_year"/>
                                        </rdfs:label>
                                        <rdf:value>
                                            <xsl:value-of select="$Date_string_year"/>
                                        </rdf:value>
                                    </collex:date>
                                </dc:date>
                                <role:EDT>
                                    <xsl:value-of select="replace($Editor, 'QQQ', '[?] ')"/>
                                </role:EDT>
                                <role:PBL>
                                    <xsl:value-of select="replace($Publisher, 'QQQ', '[?] ')"/>
                                </role:PBL>
                                <dc:source>
                                    <xsl:value-of select="$generic_name"/>
                                </dc:source>
                                <collex:genre>Periodical</collex:genre>
                                <rdfs:seeAlso>
                                    <xsl:attribute name="rdf:resource"
                                        select="concat('http://ncse-viewpoint.cch.kcl.ac.uk/?href=',$NCSE_id,'&#x0026;page=1&#x0026;view=document')"
                                    />
                                </rdfs:seeAlso>
                                <collex:thumb>
                                    <xsl:attribute name="rdf:resource"
                                        select="concat('http://www.ncse.ac.uk/Assets/p/23/i/',$thumbnail)"
                                    />
                                </collex:thumb>
                            </ncse:doc>
                        </rdf:RDF>
                    </xsl:result-document>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="months_of_the_year">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="$string = '01'">January</xsl:when>
            <xsl:when test="$string = '02'">February</xsl:when>
            <xsl:when test="$string = '03'">March</xsl:when>
            <xsl:when test="$string = '04'">April</xsl:when>
            <xsl:when test="$string = '05'">May</xsl:when>
            <xsl:when test="$string = '06'">June</xsl:when>
            <xsl:when test="$string = '07'">July</xsl:when>
            <xsl:when test="$string = '08'">August</xsl:when>
            <xsl:when test="$string = '09'">September</xsl:when>
            <xsl:when test="$string = '10'">October</xsl:when>
            <xsl:when test="$string = '11'">November</xsl:when>
            <xsl:when test="$string = '12'">December</xsl:when>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
