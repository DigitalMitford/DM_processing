<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" omit-xml-declaration="yes"/>
    
    <!--<xsl:strip-space elements="*"/>-->
 <xsl:variable name="currWit">     <xsl:text>#msC1</xsl:text>
 </xsl:variable>   
   
    <xsl:variable name="si" select="document('../SI_dev/si.xml')" as="document-node()+"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Digital Mitford Dramas: <xsl:apply-templates select="tokenize(//titleStmt/title, '\W')[1]"/></title>
                <!--<meta charset="UTF-8"/>-->
                <meta name="Description"
                    content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society."/>
                <meta name="keywords"
                    content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, TEI, Text Encoding Initiative, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar"/>
                <link rel="stylesheet" type="text/css" href="mitfordDrama.css"/>
               
                <script type="text/javascript" src="MRMPlays.js">/**/</script>
                
            </head>
            <body>
                <xsl:comment>#include virtual="mitfordMainMenu.html" </xsl:comment>
            
                <div id="container">
            
<h1><xsl:apply-templates select="//titleStmt//title"/></h1>
                       
<section id="front">
    <h2><xsl:text>Edited by </xsl:text><xsl:apply-templates select="//editor"/></h2>
                            <xsl:apply-templates select="//notesStmt"/>
 
    <p>This critical edition compares the following versions of the play:</p>
    <xsl:apply-templates select="//listWit" mode="listWit"/>
    <p>You are viewing a representation of the <xsl:apply-templates select="//listWit/witness[@xml:id = substring-after($currWit, '#')]"/> <a href="{tokenize(base-uri(), '/')[last()]}">View the encoding of this edition in TEI P5.</a>
    </p>
  
<!--2018-02-16 ebb: The next two apply-templates statements are distinct to the ms version of Chas I -->                           <xsl:apply-templates select="//div[@type='msLCplaysentrypage']"/>
                            <xsl:apply-templates select="//div[@type='msLClettertransmittal']"/>
                            
 <xsl:apply-templates select="//div[@type='dedication']"/>
      <!--OMIT in MS version: <xsl:apply-templates select="//div[@type='preface']"/>
      -->
                            
<xsl:apply-templates select="//div[@type='prologue']"/>
         <xsl:apply-templates select="//div[@type='cast']"/>  
    <xsl:apply-templates select="//div[@type='set']"/>
</section>
        <section id="play">
            <xsl:apply-templates select="//body"/>
        </section>                    
                            
                        <hr/>
                </div>
                <div id="menubar">
                    
                    
                    <div id="playMeta">
                        
                        <div id="fieldset">
                            <fieldset>
                                <legend><span class="dipNorm">Our default is the Diplomatic view.<br/> Click to toggle the Normalized view</span><span class="dipNormSmall"> (shows conventional spellings;<br/> hides pagebreaks, insertion marks, and deletions):</span></legend>
                                <input type="checkbox"
                                    id="REGtoggle"
                                    style="cursor:pointer"/>
                                
                                <br/>
                            </fieldset>
                        </div>
                        
                        <!--<xsl:apply-templates select="//teiHeader"/>-->
                        
                        
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
                        
                        
                        
 <!--experimental internal Drama menu -->                       
                        <h3>Digital Mitford: The Mary Russell Mitford Archive</h3>
                        <h4>Literary Works | Dramas</h4>
                        <ul><li>Headnote: <xsl:apply-templates select="tokenize(//titleStmt/title, '\W')"/></li>
                        </ul>
                        
                        <h4>Main Site Menu:</h4>
                        <ul> <li><a href="index.html">Welcome</a></li> 
                            <li><a href="about.html">About</a></li> 
                            <li>Literary Works</li>
                            <li> <a href="letters.html">Letters</a></li>
                            <li><a href="bibliogType.html">Bibliography of Publications</a></li>  
                            <li><a href="lettersData.html">Manuscript Locations</a></li>
                            <li><a href="visual.html">People, Places, and Networks</a></li> 
                            <li><a href="staff.html">Staff</a></li>  
                            <li><a href="workshop.html">Workshop Materials</a></li></ul>
                        
                        
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
        <h3><xsl:text>Edited by </xsl:text><xsl:apply-templates select="editor"/><xsl:text>. </xsl:text></h3>
       <!--2018-02-16 ebb: Editing this out as irrelevant for individual documents. <xsl:text>Sponsored by: </xsl:text>
        <ul>
        <xsl:for-each select="sponsor">
        <li><xsl:value-of select=".//text()"/></li>
        </xsl:for-each>
        </ul>-->
    </xsl:template>
    
    <xsl:template match="principal"/>
    <xsl:template match="respStmt">
        <xsl:apply-templates/><xsl:text>. </xsl:text>
    </xsl:template>
    
    <xsl:template match="editionStmt">
        <p><a href="{tokenize(base-uri(.),'/')[last()]}"><xsl:apply-templates select="edition"/></a>
       <!--2016-06-20 ebb: This part isn't needed for Rienzi, but check the other dramas! 
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
            
            <xsl:text>. </xsl:text>-->
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
    
    <xsl:template match="msDesc">
        <p><xsl:text>Repository: </xsl:text><xsl:apply-templates select=".//repository"/><xsl:text>. </xsl:text>
            <xsl:text>Shelf mark: </xsl:text> 
        <xsl:apply-templates select="descendant::idno"/></p>
        
      <p><xsl:apply-templates select="descendant::support"/></p>
        
        <p><xsl:apply-templates select="descendant::condition"/></p>
        
       <p><xsl:apply-templates select="descendant::sealDesc"/></p>
        
        
    </xsl:template>
    
    <!--2016-06-20 ebb: The profileDesc might be applicable for the ms editions: look into it! NA for Rienzi
        <xsl:template match="profileDesc">
        <p><xsl:text>Hands other than Mitford's noted on this manuscript: </xsl:text></p>
        <ul>
        <xsl:for-each select=".//handNote">
            <li><xsl:apply-templates select="."/></li>
        </xsl:for-each>
        </ul>
    </xsl:template>-->
    
    <xsl:template match="encodingDesc">
        <xsl:apply-templates select="editorialDecl"/>
    </xsl:template>
    
   <xsl:template match="listWit" mode="listWit">
       <ul>
           <xsl:for-each select="witness">
               <li><xsl:apply-templates select="."/></li> 
           </xsl:for-each>    
       </ul>   
   </xsl:template>
    <xsl:template match="head[not(parent::div[@type='ms_insertion'])]">
        <h2><xsl:apply-templates/></h2>
    </xsl:template> 
    <xsl:template match="head[parent::div[@type='ms_insertion']]">
        <!--2018-05-27 ebb: This is for the passage marked for insertion in the Charles 1 ms. I think it should be styled like a stage direction since it sits in a similarly "meta" position in relation to the lines of the play, and I'd like to be visible in the output.  -->
        <span class="stage"><xsl:apply-templates/></span>
    </xsl:template> 
    
    <xsl:template match="div[@type='preface']"> 
         <h2>Preface</h2><xsl:text> </xsl:text><xsl:value-of select="@n"/>
           <xsl:apply-templates/> 
    </xsl:template>
 
    
    <xsl:template match="div[@type='cast']">
        <xsl:apply-templates select="head"/>
        <table>
            <tr>
                <th><span class="castGroup">Role</span></th><xsl:if test="descendant::actor[not(descendant::app)] or descendant::actor[descendant::app[rdg[@wit=$currWit]]]"><th>Actor</th></xsl:if>
            </tr>
            <xsl:apply-templates select="castList"/>  
        </table>
    </xsl:template>
    
    <xsl:template match="castList">
        <xsl:apply-templates/>
    </xsl:template>
   
   <xsl:template match="castItem">

      
       <xsl:if test="not(descendant::role//app) or descendant::app[(rdg[@wit=$currWit])]"><tr>
           <td><xsl:if test="role"><span class="role"><xsl:apply-templates select="role"/></span></xsl:if>
                
               <xsl:apply-templates select="roleDesc"/></td>
           <xsl:if test="actor[not(descendant::app)] or actor[descendant::app[rdg[@wit=$currWit]]]"> <td><xsl:apply-templates select="actor/node()"/></td></xsl:if>
       </tr></xsl:if>
   </xsl:template>
    <xsl:template match="castGroup">
        <xsl:if test="not(descendant::role//app) or descendant::app[(rdg[@wit=$currWit])]"><tr>
            <td><span class="castGroup"><xsl:apply-templates select="role"/><xsl:text>&#x9;</xsl:text>
                                   <xsl:apply-templates select="roleDesc"/></span></td>
        </tr>        
       <tr>
          <td> <table><xsl:apply-templates select="castItem"/></table></td>
       </tr>
       
        </xsl:if>    
    </xsl:template>
    
    
    <xsl:template match="stage">
        <span class="stage"><xsl:apply-templates/></span>    
    </xsl:template>
    
    <xsl:template match="div[@type='act']">
       <div class="act">
    <xsl:apply-templates/>
       </div>
    </xsl:template>
    
    <xsl:template match="div[@type='scene']">
        <div class="scene">
    <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="sp">
        <xsl:apply-templates/>
        <!--2018-03-01: We seem to be missing the processing of stage directions within sp elements, so I'm adding a general apply-templates after the processing of speakers, and an xsl:if in front -->
        <!--2018-05-27 ebb: Commenting this out b/c it's not the right strategy. A general apply-templates should handle everything within <sp>: <xsl:if test="speaker[preceding-sibling::*]">
            <xsl:apply-templates select="speaker/preceding-sibling::*"/>
        </xsl:if>
        <span class="speaker"><xsl:apply-templates select="speaker"/></span>
    <xsl:apply-templates select="speaker/following-sibling::*"/>-->
    </xsl:template>
    <xsl:template match="speaker">
        <span class="speaker"><xsl:apply-templates/></span>
    </xsl:template>
    
   <!--2018-02-17 ebb: template rule draft to try to suppress lg, l, and head elements from being processed when they are ONLY present in the NOT current witness:-->
    <xsl:variable name="suppressFactor" select="not(ancestor::rdg[@wit=$currWit]) and not(ancestor::app[rdg[@wit=$currWit]]) and not(descendant::app[rdg[@wit=$currWit] and count(rdg) = 1])"/>
    <!--head[$suppressFactor]  | l[$suppressFactor] | sp[$suppressFactor] | speaker[$suppressFactor] | stage[$suppressFactor] | div[$suppressFactor] -->
    <xsl:template match="*[$suppressFactor]"/>
    <xsl:template match="lg">
        <span class="lg"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="l[not(ancestor::rdg[@wit!=$currWit]) and not(descendant::app[rdg[@wit!=$currWit] and not(rdg[@wit=$currWit])])]">
        <span class="line" id="L{count(preceding::l) + 1}">
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>
            <span class="lineNum"><xsl:value-of select="count(preceding::l) + 1"/></span>  
        </span>
    </xsl:template>
  
    

    <xsl:template match="text//p">
        <p><span class="prose">
            <xsl:apply-templates/></span>
        </p>
    </xsl:template>
    
    <xsl:template match="lb">
        <br/>
    </xsl:template>

    <xsl:template match="hi[@rend='smallcaps']">
        <span class="smallcaps">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="placeName | name[@type='place']">
        <xsl:choose><xsl:when test="not(ancestor::app)"> <span class="context" title="place">
            <xsl:apply-templates/>
            <xsl:variable name="siPlace" select="$si//*[@xml:id = substring-after(current()/@ref, '#')]"/>
  
            <xsl:if test="$si//*[@xml:id = substring-after(current()/@ref, '#')] and not(ancestor::app)"><span class="si">           
        <xsl:value-of select="string-join($siPlace/*, ' | ')"/>
            <xsl:text>—</xsl:text>
            <xsl:value-of select="$siPlace/note/@resp"/>
            <xsl:if test="$siPlace//geo">
                <xsl:value-of select="$siPlace//geo"/>
            </xsl:if>           
        </span></xsl:if>
           <!--2016-02-16 ebb: Think about how to process this: We want to set an asterisk or signal after the surrounding app is processed, and probably want to handle this (and other such cases) in the template rule on app. <xsl:when test="$si//*[@xml:id = substring-after(current()/@ref, '#')] and ancestor::app">-->
                               
            <!--</xsl:when>-->
        
        </span></xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


<!--2016-06-20: only use this for page breaks in the 1828 Rienzi
        <xsl:template match="pb">
   <span class="pagebreak"><xsl:text>page&#xa0;</xsl:text><xsl:value-of select="@n"/><br/></span> 
    
</xsl:template>-->
    
    <xsl:template match="notesStmt//note">
        <p><xsl:apply-templates/></p>
    </xsl:template>

    <xsl:template match="note[not(ancestor::notesStmt) and not(ancestor::note)]">
        <span id="Note{count (preceding::note) + 1}" class="anchor">[<xsl:value-of
                select="count (preceding::note)+ 1"/>] <span class="note"
                id="n{count (preceding::note) + 1}">
                <xsl:apply-templates/><xsl:text>&#8212;</xsl:text>
                    <xsl:value-of select="@resp"/>
            </span>
        </span>
    </xsl:template>
    <xsl:template match="note[ancestor::note]">
        <span class="embedded_note">
                <xsl:apply-templates/><xsl:text>&#8212;</xsl:text>
                <xsl:value-of select="@resp"/>
            </span>
    </xsl:template>

   <!-- <xsl:template match="rs">
        <span class="{@type}">
                    <xsl:apply-templates/>
            
        </span>
    </xsl:template>-->

   <!--2016-06-21 ebb: temporarily suspending the following SI processing templates because it takes a LONG time to process in oXygen!
       <xsl:template match="persName | rs[@type='person'] |  author">
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
         <xsl:text>-\-</xsl:text>
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
                    <xsl:text>-\-</xsl:text>
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
                    <xsl:text>-\-</xsl:text>
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
                    <xsl:text>-\-</xsl:text>
                    <xsl:value-of select="$siBibl//note/@resp"/>
               
            </xsl:if>
        </span></xsl:if>
        </span>
    </xsl:template>
-->
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
    <xsl:template match="salute">
        <p><xsl:apply-templates/></p>
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
    
    <xsl:template match="q">
        <span class="q"><xsl:apply-templates/></span>
    </xsl:template>
    
   

   <xsl:template match="app[rdg[@wit=$currWit]]">
        <xsl:choose>
            <xsl:when test="count(rdg) gt 1"><span class="app"><xsl:apply-templates select="rdg[@wit=$currWit]"/>
       <xsl:if test="rdg[@wit!=$currWit]"> <span class="var"><xsl:for-each select="rdg[@wit!=$currWit]">
        <xsl:apply-templates select="."/>
        </xsl:for-each>
        </span></xsl:if>
        </span></xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
        </xsl:choose>
        </xsl:template>
    <!--2018-02-16 ebb: NOTE: The next template rule says, if the current witness is ENTIRELY MISSING, don't output anything.-->
    <xsl:template match="app[not(rdg[@wit=$currWit])]">
      <!--  <xsl:text>Placeholder text: This is not represented in the witness you are viewing.</xsl:text>-->
    </xsl:template>
    <xsl:template match="rdg[@wit!=$currWit]">
        <span class="wit"><span class="witLabel"><xsl:value-of select="@wit"/><xsl:text>: </xsl:text></span><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="rdg[@wit=$currWit]">
       <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>

