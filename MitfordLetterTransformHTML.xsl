<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
   
    <xsl:variable name="si" select="document('http://mitford.pitt.edu/si.xml')" as="document-node()+"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Digital Mitford: The Mary Russell Mitford Archive</title>
                <meta charset="UTF-8"/>
                <meta name="Description"
                    content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society."/>
                <meta name="keywords"
                    content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, TEI, Text Encoding Initiative, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar"/>
                <link rel="stylesheet" type="text/css" href="mitfordletter.css"/>
                <script type="text/javascript" src="MRMLetters.js" xml:space="preserve">...</script>
                


            </head>
            <body>

                <div id="title">
                    <h1>Digital Mitford: Letters</h1>
                    <hr/>
                </div>
                <div id="menubar">
                    <h3>Digital Mitford: The Mary Russell Mitford Archive</h3>
                    <ul> <li><a href="index.html">Welcome</a></li> 
                        <li><a href="about.html">About</a></li> 
                        <li><a href="bibliogType.html">Published Works</a></li>  <li><a href="lettersData.html">Manuscript Locations</a></li> 
                        <li> <a href="letters.html">Letters</a></li> 
                        <li><a href="visual.html">People, Places, and Networks</a></li> 
                        <li><a href="staff.html">Staff</a></li>  
                        <li><a href="workshop.html">Workshop Materials</a></li></ul>
                </div>
                
                
          
                <div id="container">
                    
                    <div id="letterHead">
                        <p class="boilerplate">
                            <span>
                                <strong>Maintained by: </strong> Elisa E. Beshero-Bondar (ebb8 at
                                pitt.edu) <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/80x15.png" /></a>
                            </span>
                            
                            <span>
                                <strong>Last modified: </strong>
                                <xsl:value-of select="current-dateTime()"/>
                            </span>
                            
                        </p> 
                        <div id="fieldset">
                            <fieldset>
                                <legend><span class="dipNorm">Our default is the Diplomatic view.<br/> Click to toggle the Normalized view</span><span class="dipNormSmall"> (shows conventional spellings;<br/> hides pagebreaks, insertion marks, and deletions):</span></legend>
                                <input type="checkbox"
                                    id="REGtoggle"
                                    style="cursor:pointer"/>
                                
                                <br/>
                            </fieldset>
                        </div>
                       
                        <xsl:apply-templates select="//teiHeader"/>
                        
                        
                       
                    </div>
                    <div id="floatright">
                       

                        <div id="letter">

                         <xsl:apply-templates select="//body"/>


                        </div>


                        <hr/>


                    </div>
                  
                    
                    
                </div>
                


            </body>
        </html>


    </xsl:template>
    
    <!--<xsl:template match="titleStmt/title">
        <h2><xsl:apply-templates/></h2>
    </xsl:template>

<xsl:template match="editor">
    <h3><xsl:text>Edited by </xsl:text><xsl:apply-templates/><xsl:text>. </xsl:text></h3>
</xsl:template>-->
    
    <xsl:template match="titleStmt">
        <h3><xsl:apply-templates select="title"/></h3>
        <p><xsl:text>Edited by </xsl:text><xsl:apply-templates select="editor"/><xsl:text>. </xsl:text></p>
        <xsl:text>Sponsored by: </xsl:text>
        <ul>
        <xsl:for-each select="sponsor">
        <li><xsl:value-of select=".//text()"/></li>
        </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="principal"/>
    <xsl:template match="respStmt">
        <xsl:apply-templates/><xsl:text>. </xsl:text>
    </xsl:template>
    
    <xsl:template match="editionStmt">
        <p><a href="{tokenize(base-uri(.),'/')[last()]}"><xsl:apply-templates select="edition"/></a>
        <xsl:value-of select="respStmt[1]/resp[1][not(idno)]"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="respStmt[1]/resp[1]/following-sibling::orgName"/>
            <xsl:text>. </xsl:text>
            <xsl:if test="respStmt[2]">
               <xsl:value-of select="respStmt[2]/orgName"/><xsl:text> </xsl:text>
               <xsl:value-of select="respStmt[2]/orgName/following-sibling::resp/text()"/>
           </xsl:if> 
           
            <xsl:choose>
                <xsl:when test="contains(//msIdentifier/repository, 'Reading Central')"><xsl:for-each select="tokenize(respStmt/resp[idno]/idno, ', ')">       
                <a href="{current()}"><xsl:value-of select="current()"/> </a><xsl:text>, </xsl:text>
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
    
    <xsl:template match="publicationStmt">
        <p><xsl:text>Published by: </xsl:text>
        <xsl:apply-templates select="authority"/><xsl:text>, </xsl:text>
        <xsl:apply-templates select="pubPlace"/><xsl:text>: </xsl:text>
        <xsl:apply-templates select="date"/><xsl:text>. </xsl:text></p>
        <xsl:apply-templates select="availability/p"/><xsl:text> </xsl:text> 
    </xsl:template>
    
    <xsl:template match="seriesStmt">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="sourceDesc">
        <p><xsl:text>Repository: </xsl:text><xsl:apply-templates select=".//repository"/><xsl:text>. </xsl:text>
            <xsl:text>Shelf mark: </xsl:text> 
        <xsl:apply-templates select=".//idno"/></p>
        
      <xsl:apply-templates select=".//support"/>
        
        <xsl:apply-templates select=".//condition"/>
        
        <xsl:apply-templates select=".//sealDesc"/>
        
        
    </xsl:template>
    
    <xsl:template match="profileDesc">
        <p><xsl:text>Hands other than Mitford's noted on this manuscript: </xsl:text></p>
        <ul>
        <xsl:for-each select=".//handNote">
            <li><xsl:apply-templates select="."/></li>
        </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="encodingDesc">
        <xsl:apply-templates select="editorialDecl"/>
    </xsl:template>
    
    
    <xsl:template match="opener"> 
        <div id="opener">    
            <xsl:apply-templates select=".//date"/><br/>
            <xsl:apply-templates select=".//date/following-sibling::*"/><br/>
        </div>
    </xsl:template>
    
   

    <xsl:template match="body//p">
        <p><span class="prose">
            <xsl:apply-templates/></span>
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
        <xsl:apply-templates/><br/>
    </xsl:template>
    
    <xsl:template match="addrLine">
       <xsl:apply-templates/><br/> 
    </xsl:template>
    
    <xsl:template match="lb">
        <br/>
    </xsl:template>

    <xsl:template match="l">
        <span class="line" id="L{@n}">
            <xsl:value-of select="@n"/>
            <xsl:text> </xsl:text>

            <xsl:apply-templates/>
            <br/>
        </span>
    </xsl:template>

 

    <xsl:template match="hi[@rend='smallcaps']">
        <span class="smallcaps">
            <xsl:apply-templates/>
        </span>

    </xsl:template>


   

    <xsl:template match="placeName | name[@type='place']">
        <span class="context" title="place">
            <xsl:apply-templates/>
        
        <xsl:if test="$si//*[@xml:id = substring-after(current()/@ref, '#')]"><span class="si">
            <xsl:variable name="siPlace" select="$si//*[@xml:id = substring-after(current()/@ref, '#')]"/>
        <xsl:value-of select="string-join($siPlace/*, ' | ')"/>
            <xsl:text>--</xsl:text>
            <xsl:value-of select="$siPlace/note/@resp"/>
            <xsl:if test="$siPlace//geo">
                <xsl:value-of select="$siPlace//geo"/>
            </xsl:if>
         
                  
              
        </span></xsl:if>
        </span>
    </xsl:template>


<xsl:template match="pb">
   <span class="pagebreak"><xsl:text>page&#xa0;</xsl:text><xsl:value-of select="@n"/><br/></span> 
    
</xsl:template>

    <xsl:template match="note">
        <span id="Note{count (preceding::note) + 1}" class="anchor">[<xsl:value-of
                select="count (preceding::note)+ 1"/>] <span class="note"
                id="n{count (preceding::note) + 1}">
                <xsl:apply-templates/><xsl:text>&#8212;</xsl:text>
                    <xsl:value-of select="@resp"/>
            </span>
        </span>
    </xsl:template>

   <!-- <xsl:template match="rs">
        <span class="{@type}">
                    <xsl:apply-templates/>
            
        </span>
    </xsl:template>-->

    <xsl:template match="persName | rs[@type='person'] | sp | author">
        <span class="context" title="person">
            <xsl:apply-templates/>
       
        <xsl:if test="$si//*[@xml:id = substring-after(current()/@ref, '#')] | $si//*[@xml:id = substring-after(current()/@who, '#')] | $si//*[@xml:id = substring-after(current()/@corresp, '#')]"> 
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
         <br/><xsl:value-of select="$siPers//note"/>
         <xsl:text>--</xsl:text>
             <xsl:value-of select="$siPers//note/@resp"/>
         
     </xsl:if>     
    
        </span>
       </xsl:if>
        </span>
    </xsl:template>

    <xsl:template match="orgName | rs[@type='org']">
        <span class="context" title="org">
            <xsl:apply-templates/>
       
        <xsl:if test="$si//*[@xml:id = substring-after(current()/@ref, '#')]"> <span class="si">
            <xsl:variable name="siOrg" select="$si//*[@xml:id = substring-after(current()/@ref, '#')]"/>
            <xsl:value-of select="string-join($siOrg/orgName, ' | ')"/>
            <xsl:if test="$siOrg//note">
                <br/><xsl:value-of select="$siOrg//note"/>
                    <xsl:text>--</xsl:text>
                    <xsl:value-of select="$siOrg/note/@resp"/>
                
            </xsl:if>
        </span></xsl:if>
        </span>
    </xsl:template>
    
    <xsl:template match="rs[not(@type='org')] | name">
        <span class="context" title="rs">
            <xsl:apply-templates/>
       
        
        <xsl:if test="$si//*[@xml:id = substring-after(current()/@ref, '#')]"><span class="si">
            <xsl:variable name="siRs" select="$si//*[@xml:id = substring-after(current()/@ref, '#')]"/>
            <xsl:value-of select="string-join($siRs/label, ' | ')"/>
            <xsl:value-of select="string-join($siRs/@*, ' - ')"/>
            <xsl:if test="$siRs/note">
                <br/><xsl:value-of select="$siRs/note"/>
                    <xsl:text>--</xsl:text>
                    <xsl:value-of select="$siRs/note/@resp"/>
                
            </xsl:if>
        </span></xsl:if>
        </span>
    </xsl:template>
    
    <xsl:template match="body//title | body//bibl">
        <span class="context" title="title"><xsl:apply-templates/>
        <xsl:if test="$si//*[@xml:id = substring-after(current()/@ref, '#')] | $si//*[@xml:id = substring-after(current()/@corresp, '#')]"> <span class="si">
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
            
            <xsl:if test="$siBibl//note">
                <br/><xsl:value-of select="$siBibl//note"/>
                    <xsl:text>--</xsl:text>
                    <xsl:value-of select="$siBibl//note/@resp"/>
               
            </xsl:if>
        </span></xsl:if>
        </span>
    </xsl:template>

<xsl:template match="date">
        <span class="date" title="{string-join(@*, '-')}">
            <xsl:apply-templates/>
        </span>
    
  
    </xsl:template>

  <xsl:template match="emph">
      <em><xsl:apply-templates/></em> 
  </xsl:template>
    
    <xsl:template match="gap">
        <span class="damage"><xsl:text>[Gap: </xsl:text>
            <xsl:if test="@quantity">
        <xsl:value-of select="@quantity"/><xsl:text> </xsl:text><xsl:value-of select="@unit"/><xsl:text>, </xsl:text></xsl:if>
            <xsl:text>reason: </xsl:text><xsl:value-of select="@reason"/><xsl:text>.]</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="damage">
        <span class="damage"><xsl:text>[Damage: </xsl:text>
            <xsl:if test="@quantity">
                <xsl:value-of select="@quantity"/><xsl:text> </xsl:text><xsl:value-of select="@unit"/><xsl:text>, </xsl:text></xsl:if>
            <xsl:text>agent: </xsl:text><xsl:value-of select="@reason | @agent"/><xsl:text>.]</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="supplied">
        <span class="supplied"><xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text></span>
    </xsl:template>
    
    <xsl:template match="del">
        <span class="del"><xsl:text>&#xa0;</xsl:text><xsl:value-of select="."/></span>
        <!--ebb: Note problem here: If the del span self-closes because of a gap and we could not read the deleted words for whatever reason, the span self closes in the html, BUT the browser (Chrome at least) interprets this as crossing out to the end of the document! 
        Brittle solution is, this time, that I removed the self-closed span elements from the html output. 
        I need to say something, if the span is empty because of a gap, to signal that there *is* a deletion here that we could not read.
        -->
    </xsl:template>
    
    <xsl:template match="add">
        <span class="add"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="hi[@rend='superscript']">
        <span class="above-line"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="metamark[@rend='caret']">
        <span class="caret"><xsl:text>&#94;</xsl:text></span>
    </xsl:template>
    
    <xsl:template match="metamark[@rend='waves'] | metamark[@rend='jerk'] | metamark[@rend='wave']">
        <span class="jerk"><xsl:text>&#x3030;</xsl:text></span>
        
    </xsl:template>
    
    <xsl:template match="choice">
        <span class="sic"><xsl:apply-templates select="sic"/></span>
        <span class="reg"><xsl:apply-templates select="reg"/></span>
       
    </xsl:template>
    
   
</xsl:stylesheet>

