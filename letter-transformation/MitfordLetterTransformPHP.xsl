<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns:dm="http://digitalmitford.org/nss/dm"
    exclude-result-prefixes = "dm">
    <xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
    <!--<xsl:strip-space elements="*"/>-->
    <xsl:variable name="si" select="document('https://digitalmitford.org/si.xml')" as="document-node()+"/>
    <xsl:param name="letterPath"/>
    <xsl:param name="uri"/>
    <xsl:function name="dm:respHandler" as="item()">
        <xsl:param name="resp" as="attribute()"/>
        <xsl:sequence select="$resp ! tokenize(., '\s+') ! substring-after(., '#') => string-join(', ')"/>     
    </xsl:function>
    <xsl:template match="/">
    <div id="nav_wide">
    <div id="menu">
        <ul id="siteMenu">
            <li class="title">
                        <span class="mainTitle">Digital Mitford:</span>
                        <br/> <span class="subTitle">The Mary Russell Mitford Archive</span>
                    </li>
            <li class="mainMenu">
                <ul class="mainMenu">
                    <li class="section" id="home">
                       <a href="index.html">Main Home</a>
                    </li>
                    <li class="section" id="letters">
                       <ul class="subSec">
                           <li class="subMenu">
                                        <a href="letters.html">Letters Main</a>
                                    </li>           
                           <li class="subMenu">
                                        <a href="lettersInterface.php">Choose a new letter</a>
                                    </li>
                           <li> <a href="getLetterTEI.php?letterPath={$letterPath}">TEI encoding of this letter</a>
                                    </li>
                       </ul>
                    </li>
                   <li class="section" id="Bib"><!--Bibliography & MSS-->
                    <ul class="subSec">
                        <li class="subMenu">
                                        <a href="bibliogType.html">Bibliography</a>
                                    </li>
                        <li class="subMenu">
                                        <a href="lettersData.html">Manuscript Locations</a>
                                    </li>
                        
                    </ul>
                </li>
                </ul>
            </li>
        </ul>
  </div>
</div>   
        <div id="container">
            <div id="letterHead">
                <xsl:apply-templates select="//teiHeader"/> 
                <!--  ebb: Maybe too much to read. Try to make a more obvious, nonverbal cue.   <section class="interfaceInstructions">
                    <h3>For mouse or touchscreen interaction:</h3>
                    
                    <ul>
                        <li>Click, tap, or move your cursor over a highlighted passage or number to display an annotation.</li>
                        <li>Multiple annotations may appear as you touch or click on multiple highlighted passages.</li>
                        <li>To hide an annotation, double-click with the mouse, or drag your finger out of the annotation box.</li>
                        
                    </ul>
                </section>-->
                <div id="fieldset">
                    <fieldset>
                        <legend><span class="dipNorm">Our default is the Diplomatic view.<br/> Click to toggle the Normalized view</span><span class="dipNormSmall"> (shows conventional spellings;<br/> hides pagebreaks, insertion marks, and deletions):</span></legend>
                        <input type="checkbox"
                            id="REGtoggle"
                            style="cursor:pointer"/>
                        <br/>
                    </fieldset>
                </div>
                
                
                
                
                <p class="boilerplate">
                    <span>
                        Maintained by: Elisa E. Beshero-Bondar (eeb4 at
                        psu.edu) <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/80x15.png" /></a>
                    </span>
                    <span>
                        Last modified: 
                        <xsl:value-of select="current-dateTime()"/>
                    </span>  
                </p> 
            </div>
            <div id="floatright">
                <div id="letter">
                    <xsl:apply-templates select="//body"/>
                </div>
                <hr/>
            </div>
        </div>
    </xsl:template>

    <!--<xsl:template match="titleStmt/title">
        <h2><xsl:apply-templates/></h2>
    </xsl:template>

<xsl:template match="editor">
    <h3><xsl:text>Edited by </xsl:text><xsl:apply-templates/><xsl:text>. </xsl:text></h3>
</xsl:template>-->
    <xsl:template match="titleStmt">
        <h2>
            <xsl:apply-templates select="title"/>
        </h2>
        <h3>
            <xsl:text>Edited by </xsl:text>
            <xsl:apply-templates select="editor"/>
            <xsl:text>. </xsl:text>
        </h3>
        <p>Sponsored by: </p>
        <ul>
            <li>Mary Russell Mitford Society: Digital Mitford
                Project</li>
            <li>Penn State Erie, The Behrend College</li>
        </ul>
        <!-- 2021-08-14 ebb: Activate once letters files TEI headers are updated with new sponsor information
         
         <xsl:choose> 
           <xsl:when test="count(descendant::sponsor) gt 1">
            <ul>
        <xsl:for-each select="sponsor">
            <li><xsl:apply-templates select="current()//text()"/></li>
        </xsl:for-each>
        </ul>
           </xsl:when>
       <xsl:otherwise>
           <xsl:apply-templates select="sponsor//text()"/>
       </xsl:otherwise>
       </xsl:choose>-->
    </xsl:template>
    <xsl:template match="principal"/>
  <!-- 2021-08-15 ebb: This template processes a series of statements that output links to the image files (that we can't open yet)
      <xsl:template match="respStmt">
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
    </xsl:template>-->
    <xsl:template match="respStmt"/><!--ebb: Remove this templatewhen ready to link to images? -->
    <xsl:template match="editionStmt">
        <p>
            <a href="getLetterTEI.php?letterPath={$letterPath}">
                <xsl:apply-templates select="edition"/>
            </a>
            <xsl:value-of select="respStmt[1]/resp[1][not(idno)]"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="respStmt[1]/resp[1]/following-sibling::orgName"/>
            <xsl:text>. </xsl:text>
            <xsl:if test="respStmt[2]">
                <xsl:value-of select="respStmt[2]/orgName"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="respStmt[2]/orgName/following-sibling::resp/text()"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="contains(//msIdentifier/repository, 'Reading Central')">
                    <xsl:for-each select="tokenize(respStmt/resp[idno]/idno, ', ')">
                        <a href="{current()}">
                            <xsl:value-of select="current()"/>
                        </a>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="tokenize(respStmt/resp[idno]/idno, ', ')">
                        <xsl:value-of select="current()"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>. </xsl:text>
        </p>
    </xsl:template>
    <!-- 2021-08-15 ebb: Suppressing this to stop old UPG / Pgh Supercomputing Center info from outputting:   <xsl:template match="publicationStmt">
        <p><xsl:text>Published by: </xsl:text>
        <xsl:apply-templates select="authority"/><xsl:text>, </xsl:text>
        <xsl:apply-templates select="pubPlace"/><xsl:text>: </xsl:text>
        <xsl:apply-templates select="date"/><xsl:text>. </xsl:text></p>
        <xsl:apply-templates select="availability/p"/><xsl:text> </xsl:text> 
    </xsl:template>-->
    <xsl:template match="publicationStmt"/>
    
    <xsl:template match="seriesStmt">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="sourceDesc">
        <p>
            <xsl:text>Repository: </xsl:text>
            <xsl:apply-templates select=".//repository"/>
            <xsl:text>. </xsl:text>
            <xsl:text>Shelf mark: </xsl:text>
            <xsl:apply-templates select=".//idno"/>
        </p>
        <xsl:apply-templates select=".//support"/>
        <xsl:apply-templates select=".//condition"/>
        <xsl:apply-templates select=".//sealDesc"/>
    </xsl:template>
    <xsl:template match="profileDesc">
        <p>
            <xsl:text>Hands other than Mitford's noted on this manuscript: </xsl:text>
        </p>
        <ul>
            <xsl:for-each select=".//handNote">
                <li>
                    <xsl:apply-templates select="."/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template match="encodingDesc">
        <xsl:apply-templates select="editorialDecl"/>
    </xsl:template>
    <xsl:template match="revisionDesc"/>
    <!-- 2021-08-14 ebb: Uncomment this (and comment out the preceding template) to output a change log on the Mitford edition file, if present
      in a revisionDesc.
      
      <xsl:template match="revisionDesc">
        <h3>Change log</h3>
        <table>
            <tr><th>When</th><th>Who</th><th>What</th></tr>
            <xsl:apply-templates/>
        </table>
        
    </xsl:template>
    <xsl:template match="change">
       <tr>
          <td><xsl:apply-templates select="(@when, @notBefore)[1]"/></td> 
          <td><xsl:sequence select="dm:respHandler(@who)"/>
          </td>
           <td><xsl:apply-templates/></td>
       </tr>
    </xsl:template>-->
    <xsl:template match="opener">
        <div id="opener">
            <!--    <xsl:apply-templates select=".//date/preceding-sibling::*"/><br/>
            <xsl:apply-templates select=".//date"/><br/>
            <xsl:apply-templates select=".//date/following-sibling::*"/><br/>-->
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="body//p">
        <p>
            <span class="prose">
                <xsl:apply-templates/>
            </span>
        </p>
    </xsl:template>
    <xsl:template match="rdg">
        <!--ebb: Be careful of this. I'm writing this template match to suppress rdg elements on the understanding that we are using <lem> to indicate a Mitford editor's authoritative reading of the ms, vs. a misreading or alternate reading by L'Estrange or someone else. I'm not indicating the @wit here; it may need to be adjusted depending on the letter.-->
    </xsl:template>
    <xsl:template match="closer">
        <div class="closer">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="signed">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="addrLine">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="lb">
        <br/>
    </xsl:template>
    <xsl:template match="lg">
        <div class="lg">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="l">
        <span class="line" id="L{@n}">
            <xsl:value-of select="@n"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
            <br/>
        </span>
    </xsl:template>
    <xsl:template match="l[not(ancestor::note)]">
        <div class="line"> 
            <span class="line" id="L{@n}">
                <xsl:apply-templates/></span>
            <span class="lineNumber"><xsl:value-of select="@n"/></span>
        </div>
    </xsl:template>
    
    <xsl:template match="l[ancestor::note]">
        <span class="line">
            <xsl:apply-templates/>
            <br/>
        </span>
    </xsl:template>
    <xsl:template match="hi[@rend = 'smallcaps']">
        <span class="smallcaps">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="pb">
        <span class="pagebreak">
            <xsl:text>page </xsl:text>
            <xsl:value-of select="@n"/>
            <br/>
        </span>
    </xsl:template>
    <xsl:template match="note[not(ancestor::*[@sortKey])]">
        <!-- 2021-08-14 ebb: Added predicate to stop this template from outputting note numbers in SI entries -->
        <span id="Note{count (preceding::note) + 1}" class="anchor">[<xsl:value-of
            select="count (preceding::note)+ 1"/>] <span class="note"
                id="n{count (preceding::note) + 1}">
                <xsl:if test="@resp"> <xsl:apply-templates/><xsl:text>—</xsl:text>
                    <xsl:sequence select="dm:respHandler(@resp)"/></xsl:if>
            </span>
        </span>
    </xsl:template>
    <!-- 2021-08-14 ebb: For processing SI notes:-->
    <xsl:template match="note[ancestor::*[@sortKey]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="*[@sortKey]//p">
        <!-- 2021-08-15 ebb: For site index <p> in note elements -->
        <xsl:apply-templates/><br/>
    </xsl:template>
    
    <!-- ******************************************* -->
    
    <!-- 2021-08-14 ebb: Updated templates for SI context coding. -->
    
    <!-- ******************************************* -->

    <xsl:template match="placeName | name[@type='place']">
        <span class="context" title="place">
            <xsl:apply-templates/>
            
            <xsl:if test="$si//*[@xml:id = substring-after(current()/@ref, '#')] and not(ancestor::note)"><span class="si">
                <xsl:variable name="siPlace" select="$si//*[@xml:id = substring-after(current()/@ref, '#')]"/>
                <xsl:value-of select="string-join($siPlace/*[not(self::note)], ' | ')"/>
                <xsl:if test="$siPlace/note"> <xsl:for-each select="$siPlace/note">
                    <xsl:apply-templates select="current()"/>
                    <xsl:if test="@resp"><xsl:text>—</xsl:text>
                        <xsl:sequence select="dm:respHandler(@resp)"/></xsl:if>
                </xsl:for-each>
                </xsl:if>
                
            </span></xsl:if>
        </span>
    </xsl:template>
    
    <xsl:template match="editor | persName | rs[@type='person'] | sp | author">
        <span class="context" title="person">
            <xsl:apply-templates/>
            
            <xsl:if test="($si//*[@xml:id = substring-after(current()/@ref, '#')] | $si//*[@xml:id = substring-after(current()/@who, '#')] | $si//*[@xml:id = substring-after(current()/@corresp, '#')]) and not(ancestor::note)"> 
                <span class="si">
                    <xsl:variable name="siPers" select="$si//*[@xml:id = substring-after(current()/@ref, '#')] | $si//*[@xml:id = substring-after(current()/@who, '#')] | $si//*[@xml:id = substring-after(current()/@corresp, '#')]"/>
                    
                    <xsl:choose>
                        <xsl:when test="$siPers//forename">  <xsl:value-of select="$si//*[@xml:id = substring-after(current()/@ref, '#')]//forename[1]"/>
                            <xsl:text> </xsl:text>
                            <xsl:if test="$siPers//forename[position() gt 1]"><xsl:value-of select="string-join($siPers//forename[position() gt 1], ' ')"/><xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="count($siPers//surname) gt 1"> <xsl:value-of select="string-join($siPers//surname[2] | surname[@type='maiden'], ' ')"/><xsl:text> </xsl:text></xsl:if>
                            
                            <xsl:value-of select="string-join($siPers//surname[1] | surname[@type='married'], ' ')"/>
                            <xsl:if test="$siPers//roleName">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="string-join($siPers//roleName, ', ')"/>
                            </xsl:if>
                            
                            <xsl:if test="$siPers/persName[forename]/following-sibling::persName">
                                <xsl:text>, or: </xsl:text>
                                <xsl:value-of select="string-join($siPers/persName[forename]/following-sibling::persName, ', ')"/>
                            </xsl:if>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of select="string-join($siPers/persName, ' ')"/>
                            
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                    <xsl:if test="$siPers/birth"><xsl:text> | Born: </xsl:text>
                        <xsl:value-of select="string-join($siPers/birth/@*, '-')"/>
                        
                        <xsl:if test="$siPers/birth/placeName">
                            <xsl:text> in </xsl:text>
                            <xsl:value-of select="$siPers/birth/placeName"/>
                        </xsl:if>
                        
                        <xsl:text>. Died: </xsl:text>
                        <xsl:value-of select="string-join($siPers/death/@*, '-')"/>
                        
                        <xsl:if test="$siPers/death/placeName">
                            <xsl:text> in </xsl:text>
                            <xsl:value-of select="$siPers/death/placeName"/>
                        </xsl:if>
                        <xsl:text>. </xsl:text>
                    </xsl:if>
                    <xsl:if test="$siPers/note">
                        <xsl:for-each select="$siPers/note">
                            <br/><xsl:apply-templates select="current()"/>
                            <xsl:if test="@resp"> 
                                <xsl:text>—</xsl:text>
                                <xsl:sequence select="dm:respHandler(@resp)"/>
                            </xsl:if>
                        </xsl:for-each>
                        
                    </xsl:if>     
                    
                </span>
            </xsl:if>
        </span>
    </xsl:template>
    
    <xsl:template match="orgName | rs[@type='org']">
        <span class="context" title="org">
            <xsl:apply-templates/>
            
            <xsl:if test="$si//*[@xml:id = substring-after(current()/@ref, '#')] and not(ancestor::note)"> <span class="si">
                <xsl:variable name="siOrg" select="$si//*[@xml:id = substring-after(current()/@ref, '#')]"/>
                <xsl:value-of select="string-join($siOrg/orgName, ' | ')"/>
                <xsl:if test="$siOrg/note">
                    <xsl:for-each select="$siOrg/note">  
                        <br/>
                        <xsl:apply-templates select="current()"/>
                        <xsl:text>—</xsl:text>
                        <xsl:if test="@resp"> <xsl:sequence select="dm:respHandler(@resp)"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </span></xsl:if>
        </span>
    </xsl:template>
    
    
    
    <xsl:template match="body//title | body//bibl">
        <span class="context" title="title"><xsl:apply-templates/>
            <xsl:if test="($si//*[@xml:id = substring-after(current()/@ref, '#')] | $si//*[@xml:id = substring-after(current()/@corresp, '#')]) and not(ancestor::note)"> <span class="si">
                <xsl:variable name="siBibl" select="$si//*[@xml:id = substring-after(current()/@ref, '#')] | $si//*[@xml:id = substring-after(current()/@corresp, '#')]"/>
                <xsl:if test="$siBibl/title"><xsl:value-of select="string-join($siBibl/title, ', ')"/>
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:if test="$siBibl/bibl">
                    <xsl:value-of select="string-join($siBibl/bibl/title, ', ')"/>
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$siBibl/author/text()">
                        <xsl:value-of select="string-join($siBibl//author, ', ')"/>
                        <xsl:text>. </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="AuthorLookup" select="$siBibl//author/@ref"/> 
                        
                        <xsl:if test="$si//*[@xml:id= substring-after($AuthorLookup, '#')]/persName[forename]">
                            <xsl:value-of select="$si//*[@xml:id= substring-after($AuthorLookup, '#')]/persName/forename[1]"/>
                            <xsl:text> </xsl:text>
                            <xsl:if test="$si//*[@xml:id= substring-after($AuthorLookup, '#')]/persName/forename[position() gt 1]"><xsl:value-of select="string-join($si//*[@xml:id= substring-after($AuthorLookup, '#')]/persName/forename[position() gt 1], ' ')"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                            
                            <xsl:if test="$si//*[@xml:id= substring-after($AuthorLookup, '#')]/persName/surname[position() gt 1]">
                                
                                <xsl:value-of select="string-join($si//*[@xml:id= substring-after($AuthorLookup, '#')]/persName/surname[position() gt 1], ' ')"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                            <xsl:value-of select="$si//*[@xml:id= substring-after($AuthorLookup, '#')]/persName/surname[1]"/>
                            <xsl:text>. </xsl:text>
                            
                        </xsl:if>               
                        <xsl:if test="$si//*[@xml:id= substring-after($AuthorLookup, '#')]/persName[not(forename)]">
                            <xsl:value-of select="$si//*[@xml:id= substring-after($AuthorLookup, '#')]/persName"/><xsl:text>. </xsl:text>
                            
                        </xsl:if>
                        
                    </xsl:otherwise> 
                    
                </xsl:choose>
                
                <xsl:if test="$siBibl/pubPlace">
                    <xsl:value-of select="$siBibl/pubPlace"/>
                    <xsl:text>: </xsl:text>
                </xsl:if>
                <xsl:if test="$siBibl/publisher">
                    <xsl:value-of select="$siBibl/publisher"/>
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:if test="$siBibl/date">
                    
                    <xsl:choose><xsl:when test="$siBibl/date/@*">
                        <xsl:value-of select="string-join($siBibl/date/@*, '-')"/><xsl:text>. </xsl:text>
                    </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$siBibl/date"/>
                            <xsl:text>. </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:if>
                
                <xsl:if test="$siBibl/note">
                    <xsl:for-each select="$siBibl/note"> <br/><xsl:value-of select="current()"/>
                        <xsl:if test="@resp">
                            <xsl:text>—</xsl:text>
                            <xsl:sequence select="dm:respHandler(@resp)"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </span></xsl:if>
        </span>
    </xsl:template>
    
    <!--2021-08-13 The next template processes markup of plants and animals from the SI -->
    <xsl:template match="name | rs[@type='animal'] | rs[@type='plant']">
        <span class="context" title="nature">
            <xsl:apply-templates/>
            <xsl:if test="$si//item[@xml:id=substring-after(current()/@ref, '#')] and not(ancestor::note)">
                <span class="si">
                    <xsl:variable name="siNature" as="element()" select="$si//item[@xml:id=substring-after(current()/@ref, '#')]"/>
                    <xsl:text>Name: </xsl:text>
                    <xsl:value-of select="$siNature/name[not(@type)] => string-join(' or ')"/>
                    <xsl:if test="$siNature/name[@type='genus']">
                        <xsl:text> | Genus: </xsl:text>
                        <xsl:value-of select="$siNature/name[@type='genus']"/>
                    </xsl:if>
                    <xsl:if test="$siNature/name[@type='family']">
                        <xsl:text> | Family: </xsl:text>
                        <xsl:value-of select="$siNature/name[@type='family']"/>
                    </xsl:if>
                    <xsl:if test="$siNature/name[@type='species']">
                        <xsl:text> | Species: </xsl:text>
                        <xsl:value-of select="$siNature/name[@type='species']"/>
                    </xsl:if>
                    <xsl:text>. </xsl:text>
                    <xsl:for-each select="$siNature/note">
                        <br/>
                        <xsl:apply-templates select="."/>
                        <xsl:if test="@resp">  
                            <xsl:text>—</xsl:text>
                            <xsl:sequence select="dm:respHandler(@resp)"/>
                        </xsl:if>
                        
                    </xsl:for-each> 
                </span>  
            </xsl:if>
        </span>
    </xsl:template>
  
    <!-- ******************************************* -->
    
    <!-- END templates for processing SI context coding. -->
    
    <!-- ******************************************* -->
  
  
    <xsl:template match="dateline">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="date">
        <span class="date" title="{string-join(@*, '-')}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="emph">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    <xsl:template match="gap | del[not(text())]">
        <span class="damage"><xsl:text>[</xsl:text><xsl:value-of select="name()"/><xsl:text>: </xsl:text>
            <xsl:if test="@quantity">
                <xsl:value-of select="@quantity"/><xsl:text> </xsl:text><xsl:value-of select="@unit"/>
                <xsl:if test="number(@quantity) gt 1 and not(matches(@unit, 's$'))"><xsl:text>s</xsl:text></xsl:if>
            </xsl:if>
            <xsl:if test="@quantity and @reason"><xsl:text>, </xsl:text></xsl:if>
            <xsl:if test="@reason"><xsl:text>reason: </xsl:text><xsl:value-of select="@reason"/></xsl:if>
            <xsl:text>.]</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="damage">
        <span class="damage">
            <xsl:text>[Damage: </xsl:text>
            <xsl:if test="@quantity">
                <xsl:value-of select="@quantity"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@unit"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:text>agent: </xsl:text>
            <xsl:value-of select="@reason | @agent"/>
            <xsl:text>.]</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="supplied">
        <span class="supplied">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="del[matches(., '\S')]">
        <span class="del"><xsl:text>&#xa0;</xsl:text><xsl:value-of select="."/></span>
        
        <!--OLD? ebb: Note problem here: If the del span self-closes because of a gap and we could not read the deleted words for whatever reason, the span self closes in the html, BUT the browser (Chrome at least) interprets this as crossing out to the end of the document! 
        Brittle solution is, this time, that I removed the self-closed span elements from the html output. 
        I need to say something, if the span is empty because of a gap, to signal that there *is* a deletion here that we could not read.
        -->
        <!--2021-08-14 ebb: Answering this by adding predicate to test for non-space characters in the text node of the del element. And revising the predicate on del in the gap + "empty del" template before this. -->
    </xsl:template>
    <xsl:template match="add">
        <xsl:choose> <xsl:when test="metamark"><xsl:apply-templates select="metamark"/><span class="add {@hand ! tokenize(., '#')[last()]}"><xsl:apply-templates select="metamark/following-sibling::*|text()"/></span>
        </xsl:when>
            <xsl:otherwise>
                <span class="add {@hand ! tokenize(., '#')[last()]}"> <xsl:apply-templates/></span>
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    <xsl:template match="hi[@rend = 'superscript']">
        <span class="above-line">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="metamark[@rend = 'caret']">
        <span class="caret">
            <xsl:text>^</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="metamark[@rend = 'waves'] | metamark[@rend = 'jerk'] | metamark[@rend = 'wave']">
        <span class="jerk">
            <xsl:text>〰</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="choice">
        <span class="sic">
            <xsl:apply-templates select="sic"/>
        </span>
        <span class="reg">
            <xsl:apply-templates select="reg"/>
        </span>
    </xsl:template>
    <xsl:template match="q | quote">
        <xsl:variable name="quote" select="'&quot;'"/>
       <xsl:choose>
           <xsl:when test="matches(., $quote)">
               <xsl:apply-templates/>
           </xsl:when>
           <xsl:otherwise> <q><xsl:apply-templates/></q>
           </xsl:otherwise>
       
       </xsl:choose>
    </xsl:template>
    <xsl:template match="text()[contains(., '--')]">
        <xsl:analyze-string select="." regex="--">
            <xsl:matching-substring>—</xsl:matching-substring>
            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>