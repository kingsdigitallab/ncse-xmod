<?xml version="1.0" encoding="UTF-8"?>
<!--
  SVN: $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Index Keys -->
  <xsl:key match="titleStmt/author" name="headerAuth" use="normalize-space(name[@type='surname'])"/>
  <xsl:key match="file" name="kwForeign" use="concat(@id, '-', ancestor::row/head)"/>
  <xsl:key match="head" name="kwForeignAZ"
    use="translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>

<xsl:template name="browse-search">
  <xsl:param name="file-id"/>
  <xsl:param name="link-text"/>
  
  <div class="w">
    <xsl:variable name="cur-node-fb">
      <xsl:sequence select="//coreAL/filebase//item[@id = $file-id]"/>
    </xsl:variable>
    <div class="h">
      <h3><a href="{$linkroot}{$cur-node-path}/{$cur-node-name}.html"><b>
        <xsl:value-of select="$cur-node-fb//fileTitle"></xsl:value-of>
      </b></a></h3>
    </div>
    <xsl:apply-templates select="$cur-node-fb//notes"/>
    <xsl:variable name="cur-node-path" select="//filebase//group[item[@id=$file-id]]/groupHead/groupFolder" />
    <xsl:variable name="cur-node-name" select="$cur-node-fb//fileName"/>
    <p><a href="{$linkroot}{$cur-node-path}/{$cur-node-name}.html"><xsl:value-of select="$link-text"/> &#8250;&#8250;</a></p>
  </div>
</xsl:template>

  <!-- START: divGen  -->
  <xsl:template match="divGen">
    <!-- Templates in proj_type01_stdext.xsl -->
    <!-- Home boxes for the homepage -->
    <xsl:if test="@id = 'home-boxes'">
      <div class="homeBoxes">
        <div class="t01">
          <div class="i1">
            <!-- Box for browse page -->
            <xsl:call-template name="browse-search">
              <xsl:with-param name="file-id" select="'p3'"/>
              <xsl:with-param name="link-text" select="'browse ncse'"/>
            </xsl:call-template>
          </div>
          <div class="i2">
            <!-- Box for search page -->
            <xsl:call-template name="browse-search">
              <xsl:with-param name="file-id" select="'p4'"/>
              <xsl:with-param name="link-text" select="'search ncse'"/>
            </xsl:call-template>
          </div>
          <div class="ix">
            <div class="w">
              <!-- Box for Journal titles -->
              <div class="h">
                <h3><b>about the titles</b></h3>
              </div>              
              <ul>
                <xsl:for-each select="//coreAL/navbar//level01[default[starts-with(@ref, 'p2_')]]">
                  <li>
                    <!-- Templates found in proj_key.xsl -->
                    <xsl:call-template name="nav-li-class"/>
                    <xsl:call-template name="nav-item"/>
                    </li>
                </xsl:for-each>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>
    <!-- contact form -->
    <xsl:if test="@id='contact'">
      <div class="form">
        <div class="t01">
          <form action="http://curlew.cch.kcl.ac.uk/cgi-bin/doemail.pl" method="POST"
            name="ncse_contact">
            <input name="script" type="hidden" value="ncse_contact"/>
            <fieldset>
              <legend>Personal Data</legend>
              <label>Name:</label>
              <input id="name" name="name" type="text"/>
              <dfn>*</dfn>
              <br/>
              <label>Email:</label>
              <input id="email" name="email" type="text"/>
              <dfn>*</dfn>
            </fieldset>
            <fieldset>
              <legend>Comments</legend>
              <label>Comments:</label>
              <textarea cols="40" id="comments" name="comments" rows="6">&#160;</textarea>
              <dfn>*</dfn>
            </fieldset>
            <fieldset>
              <input type="text" value="" name="subtotal" class="fs" />
              <button type="submit">Submit</button>
              <button type="reset">Reset</button>
            </fieldset>
          </form>
        </div>
      </div>
    </xsl:if>

    <!-- User feedback form -->
    <xsl:if test="@id='feedback'">
      <style>
        br { clear: both; }
        .Likert {}
        .Likert td,
        .Likert th { font-size: 70%; padding: 3px 5px; line-height: 1.55em; }
        .Likert th {white-space: nowrap;}
        input.fs { visibility:hidden;font-size:0;line-height:0; }
        
      </style>

      <div class="form">
        <div class="t01">
          <form action="http://curlew.cch.kcl.ac.uk/cgi-bin/doemail.pl" method="POST"
            name="ncse_feedback">
            <input name="script" type="hidden" value="ncse_feedback"/>
            <p>Please tell us about yourself:</p>
            <fieldset>
              <legend>Personal Data</legend>
              <label>Name:</label>
              <input id="name" name="name" type="text"/>
              <dfn>*</dfn>
              <br/>
              <label>Email:</label>
              <input id="email" name="email" type="text"/>
              <dfn>*</dfn>
            </fieldset>
            <fieldset>
              <p>I use the web:</p>
              <label>daily</label>
              <input id="daily" name="webusage" type="radio" value="daily"/>
              <br/>
              <label>weekly</label>
              <input id="weekly" name="webusage" type="radio" value="weekly"/>
              <br/>
              <label>monthly</label>
              <input id="monthly" name="webusage" type="radio" value="monthly"/>
              <br/>


              <p>My age is:</p>
              <label>under 18</label>
              <input id="age" name="age" type="radio" value="under18"/>
              <br/>
              <label>18-24</label>
              <input id="age" name="age" type="radio" value="18-24"/>
              <br/>
              <label>25-34</label>
              <input id="age" name="age" type="radio" value="25-34"/>
              <br/>
              <label>35-44</label>
              <input id="age" name="age" type="radio" value="35-44"/>
              <br/>
              <label>44-60</label>
              <input id="age" name="age" type="radio" value="44-60"/>
              <br/>
              <label>60+</label>
              <input id="age" name="age" type="radio" value="60+"/>
              <br/>


              <p>I am using ncse for:</p>
              <label>academic research</label>
              <input id="reason" name="reason" type="radio" value="academic_research"/>
              <br/>
              <label>academic study</label>
              <input id="reason" name="reason" type="radio" value="academic_study"/>
              <br/>
              <label>professional research</label>
              <input id="reason" name="reason" type="radio" value="professional_research"/>
              <br/>
              <label>personal use</label>
              <input id="reason" name="reason" type="radio" value="personal_use"/>
              <br/>


              <p>I use a:</p>
              <label>Mac</label>
              <input id="os" name="os" type="radio" value="mac"/>
              <br/>
              <label>Windows</label>
              <input id="os" name="os" type="radio" value="microsoft"/>
              <br/>
              <label>Linux or Unix Computer</label>
              <input id="os" name="os" type="radio" value="linux_unix"/>
              <br/>
              <p>I browse the web with:</p>
              <label>Firefox</label>
              <input id="browser" name="browser" type="radio" value="firefox"/>
              <br/>
              <label>Internet Explorer</label>
              <input id="browser" name="browser" type="radio" value="explorer"/>
              <br/>
              <label>Safari</label>
              <input id="browser" name="browser" type="radio" value="safari"/>
              <br/>
              <label>Other</label>
              <input id="browser" name="browser" type="radio" value="other"/>
              <br/>
              <label>Version</label>
              <input type="text" id="version" name="version"/>
              <br/>

              <p>I use a:</p>
              <label>Laptop</label>
              <input id="computer" name="computer" type="radio" value="laptop"/>
              <br/>
              <label>Desktop computer</label>
              <input id="computer" name="computer" type="radio" value="desktop"/>

            </fieldset>
            <fieldset>
              <p>For the following statements, please indicate how strongly you agree or disagree
                (where 1 represents strongly agree, 5 represents strongly disagree, and 3 indicates
                no preference or not applicable).</p>
              <table class="Likert">
                <tr>
                  <td/>
                  <th>Strongly <br/> Agree</th>
                  <th>Agree</th>
                  <th>No Opinion </th>
                  <th>Disagree</th>
                  <th>Strongly <br/> Disagree </th>
                </tr>
                <tr>
                  <td scope="row" align="left">1.The ncse is attractively designed.</td>
                  <td>
                    <input name="a1" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a1" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a1" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a1" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a1" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">2. The ncse is well organized.</td>
                  <td>
                    <input name="a2" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a2" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a2" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a2" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a2" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">3. It is easy to find information about how to use
                    the ncse.</td>
                  <td>
                    <input name="a3" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a3" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a3" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a3" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a3" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">4. Information about how to use the ncse is
                    comprehensive.</td>
                  <td>
                    <input name="a4" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a4" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a4" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a4" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a4" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">5. The ncse downloads quickly.</td>
                  <td>
                    <input name="a5" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a5" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a5" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a5" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a5" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">6. The ncse seemed to work without any problems in my
                    web browser.</td>
                  <td>
                    <input name="a6" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a6" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a6" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a6" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a6" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">7. I always knew where I was, and where I need to go,
                    within the ncse website.</td>
                  <td>
                    <input name="a7" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a7" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a7" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a7" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a7" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">8. I was able to make full use of the site without
                    consulting the documentation / help.</td>
                  <td>
                    <input name="a8" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a8" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a8" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a8" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a8" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">9. When I didn’t understand how something worked I
                    was able to find help easily.</td>
                  <td>
                    <input name="a9" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a9" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a9" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a9" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a9" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">10. (If applicable) Information I knew, or expected,
                    to be present in the ncse was present, and was easy to find.</td>
                  <td>
                    <input name="a10" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a10" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a10" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a10" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a10" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">11. It is easy to find items in the facsimile
                    repository.</td>
                  <td>
                    <input name="a11" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a11" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a11" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a11" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a11" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">12. The facsimile search facility is easy to use.</td>
                  <td>
                    <input name="a12" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a12" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a12" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a12" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a12" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left"> 13. I understand how to manipulate facsimiles in the
                    repository (e.g. to make them smaller, larger, to view the OCR text).</td>
                  <td>
                    <input name="a13" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a13" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a13" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a13" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a13" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">14. I understand how to export facsimiles for later
                    use.</td>
                  <td>
                    <input name="a14" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a14" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a14" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a14" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a14" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">15. It is easy to move between browsing for
                    facsimiles and browsing for keywords.</td>
                  <td>
                    <input name="a15" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a15" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a15" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a15" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a15" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">16. The keywords search facility is easy to use.</td>
                  <td>
                    <input name="a16" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a16" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a16" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a16" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a16" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">17. Keywords search results are easy to understand.</td>
                  <td>
                    <input name="a17" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a17" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a17" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a17" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a17" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">18. The keywords search facility returns a useful
                    summary of items for detailed review.</td>
                  <td>
                    <input name="a18" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a18" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a18" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a18" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a18" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">19. The browsing indexes help me identify items for
                    detailed review.</td>
                  <td>
                    <input name="a19" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a19" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a19" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a19" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a19" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">20. The keywords browsing indexes are intuitive to
                    use.</td>

                  <td>
                    <input name="a20" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a20" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a20" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a20" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a20" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">21. When I follow a link from the keyword tools to
                    the facsimile repository, the connection between the item I clicked on and the
                    facsimile I am shown is clear.</td>
                  <td>
                    <input name="a21" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a21" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a21" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a21" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a21" type="radio" value="1"/>
                  </td>
                </tr>
                <tr>
                  <td scope="row" align="left">22. I understand the difference between the facsimile
                    repository search and the keyword search engine.</td>
                  <td>
                    <input name="a22" type="radio" value="5"/>
                  </td>
                  <td>
                    <input name="a22" type="radio" value="4"/>
                  </td>
                  <td>
                    <input name="a22" type="radio" value="3"/>
                  </td>
                  <td>
                    <input name="a22" type="radio" value="2"/>
                  </td>
                  <td>
                    <input name="a22" type="radio" value="1"/>
                  </td>
                </tr>
              </table>

            </fieldset>
            
            <!--<fieldset>
              <p>Please tick any of the following words which you think capture your experience of
                using ncse. You can tick as many as you like. If you want to annotate the words you
                choose please use the comments space below.</p>
              <label>Accessible</label><input id="Accessible" type="checkbox" name="Accessible" value="on"/><br/>
              <label>Accurate</label><input id="Accurate" type="checkbox" name="Accurate" value="on"/><br/>
              <label>Advanced</label><input id="Advanced" type="checkbox" name="Accurate" value="on"/><br/>
              <label>Appealing</label><input id="Advanced" type="checkbox" name="Accurate" value="on"/><br/>
              <label>Busy</label><input id="Advanced" type="checkbox" name="Accurate" value="on"/><br/>
              <label> Clean</label><input id="Advanced" type="checkbox" name="Accurate" value="on"/><br/>
              <label> Clear</label><input id="Advanced" type="checkbox" name="Accurate" value="on"/><br/>
              <label> Comprehensive</label><input id="experience" type="checkbox" name="experience" value="Comprehensive"/><br/>
              <label> Consistent</label><input id="experience" type="checkbox" name="experience" value="Consistent"/><br/>
              <label> Controllable</label><input id="experience" type="checkbox" name="experience" value="Controllable"/><br/>
              <label> Convenient</label><input id="experience" type="checkbox" name="experience" value="Convenient"/><br/>
              <label> Distracting</label><input id="experience" type="checkbox" name="experience" value="Distracting"/><br/>
              <label> Easy to use</label><input id="experience" type="checkbox" name="experience" value="Easy to use"/><br/>
              <label> Effective</label><input id="experience" type="checkbox" name="experience" value="Effective"/><br/>
              <label> Efficient</label><input id="experience" type="checkbox" name="experience" value="Efficient"/><br/>
              <label> Engaging</label><input id="experience" type="checkbox" name="experience" value="Engaging"/><br/>
              <label> Expected</label><input id="experience" type="checkbox" name="experience" value="Expected"/><br/>
              <label> Familiar</label><input id="experience" type="checkbox" name="experience" value="Familiar"/><br/>
              <label> Fresh</label><input id="experience" type="checkbox" name="experience" value="Fresh"/><br/>
              <label> Friendly</label><input id="experience" type="checkbox" name="experience" value="Friendly"/><br/>
              <label> Frustrating</label><input id="experience" type="checkbox" name="experience" value="Frustrating"/><br/>
              <label> High Quality</label><input id="experience" type="checkbox" name="experience" value="High Quality"/><br/>
              <label> Intuitive</label><input id="experience" type="checkbox" name="experience" value="Intuitive"/><br/>
              <label> Organised</label><input id="experience" type="checkbox" name="experience" value="Organised"/><br/>
              <label> Predictable</label><input id="experience" type="checkbox" name="experience" value="Predictable"/><br/>
              <label> Quick</label><input id="experience" type="checkbox" name="experience" value="Quick"/><br/>
              <label> Relevant</label><input id="experience" type="checkbox" name="experience" value="Relevant"/><br/>
              <label> Slow</label><input id="experience" type="checkbox" name="experience" value="Slow"/><br/>
              <label> Straightforward</label><input id="experience" type="checkbox" name="experience" value="Straightforward"/><br/>
              <label> Time Consuming</label><input id="experience" type="checkbox" name="experience" value="Time Consuming"/><br/>
              <label> Time saving</label><input id="experience" type="checkbox" name="experience" value="Time saving"/><br/>
              <label> Understandable</label><input id="experience" type="checkbox" name="experience" value="Understandable"/><br/>
              <label> Usable</label><input id="experience" type="checkbox" name="experience" value="Usable"/><br/>
              <label> Useful</label><input id="experience" type="checkbox" name="experience" value="Useful"/><br/>


            </fieldset>-->
            <fieldset>
              <p>Please offer any additional comments about things you like or don't like about ncse</p>
              <legend>Comments</legend>
              <label>Comments:</label>
              <textarea cols="40" id="comments" name="comments" rows="6">&#160;</textarea>
              
            </fieldset>
            <fieldset>
              <input type="text" value="" name="subtotal" class="fs" />
              <button type="submit">Submit</button>
              <button type="reset">Reset</button>
            </fieldset>
          </form>
        </div>
      </div>
    </xsl:if>

    <!-- Search of the month -->
    <xsl:if test="@id='sm_list'">
      <div class="unorderedList">
        <div class="t01">
          <ul>
            <xsl:for-each select="//projDIR/dir:directory/dir:file[starts-with(@name, 'sm-')]">
              <xsl:sort select="@name"/>
              <li>
                <a href="{substring-before(@name, '.xml')}.html">
                  <xsl:value-of select="dir:xpath/title"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </div>
      </div>
    </xsl:if>

    <!--  GLOSSARY -->
    <xsl:if test="@id='tpl_glossary'">
      <xsl:call-template name="ctpl_glossary"/>
    </xsl:if>

    <!--  SITE MAP -->
    <xsl:if test="@id='tpl_sitemap'">
      <xsl:call-template name="ctpl_sitemap"/>
    </xsl:if>
    <!-- END: divGen  -->
  </xsl:template>

  <!--  Variables for CSS on the dt and dd -->
  <xsl:template name="row-vars">
    <xsl:text>r</xsl:text>
    <xsl:number format="01" value="position()"/>
  </xsl:template>

  <xsl:template name="col-vars">
    <xsl:choose>
      <xsl:when test="position() = count(key('headerAuth', normalize-space(name[@type='surname'])))">
        <xsl:text> x01</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> c</xsl:text>
        <xsl:number format="01" value="position()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  Moded Templates  -->

  <!-- Does not process notes in the titles -->
  <xsl:template match="note" mode="index"/>
</xsl:stylesheet>
