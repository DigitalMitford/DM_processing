<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    
  <!--ebb: 2015-08-19: Updated per Saxonica's recommendation. 
     

  omit-xml-declaration="yes" Use this if I care about the W3C Validator response, which will say the pages are
  not valid HTML if they begin with an xml declaration meta-tag. If I want to parse this as html/text, I do want
  to omit-xml-declaration, yes. 
  
  indent="yes"  vs. indent="no" : This affects the human-readability of my output! indent="no"
  produces an enormous long line of text. If I output as XML this is the only way to prevent added spacing issues with
  the stretching nested spans problem (parent spans are too long when child spans are hidden; but the difference disappears on mouseover
  making the lines of text wiggle.)
  
     The attribute  html-version="5.0" seems not to be necessary!
       
       
   
  -->  
    
    <xsl:strip-space elements="*"/>
    
   
    <xsl:variable name="si" select="document('http://digitalmitford.org/si.xml')" as="document-node()+"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Digital Mitford: The Mary Russell Mitford Archive</title>
             <!--   <meta charset="UTF-8"/>-->
                <meta name="Description"
                    content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society."/>
                <meta name="keywords"
                    content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, TEI, Text Encoding Initiative, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar"/>
                <link rel="stylesheet" type="text/css" href="mitfordAnnotText.css"/>
                <script type="text/javascript" src="MRMAnnotText.js">/**/</script>
                <!--ebb8 2015-08-19: Removed this attribute: 
                    xml:space="preserve" 
                    because the W3C Validator says it's not valid.
                    But is it necessary for my JavaScript to function?-->


            </head>
            <body>

                <div id="title">
                   <xsl:apply-templates select="//titleStmt" mode="titleBar"/>
                    <hr/>
                   <div id="boilerplate"> <p class="boilerplate">
                        <span>
                            <strong>Maintained by: </strong> Elisa E. Beshero-Bondar (ebb8 at
                            pitt.edu) <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/80x15.png" /></a>
                        </span>
                        
                        <span>
                            <strong>Last modified: </strong>
                            <xsl:value-of select="current-dateTime()"/>
                        </span>
                       <span><a href="{tokenize(base-uri(), '/')[last()]}">TEI original of this HTML view.</a></span> 
                        
                    </p> </div>
                
 
                    
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
                </div>
            
                
                
          
                <div id="container">
                    
                  <xsl:apply-templates select="//titleStmt" mode="intHead"/>
            
                         <xsl:apply-templates select="//body"/>


                        </div>


                        <hr/>


            </body>
        </html>


    </xsl:template>
    
    <!--<xsl:template match="titleStmt/title">
        <h2><xsl:apply-templates/></h2>
    </xsl:template>

<xsl:template match="editor">
    <h3><xsl:text>Edited by </xsl:text><xsl:apply-templates/><xsl:text>. </xsl:text></h3>
</xsl:template>-->
    
    <xsl:template match="titleStmt" mode="titleBar">
        <h1><xsl:apply-templates select="title"/></h1>
        <h2><xsl:text>by </xsl:text><xsl:apply-templates select="author"/><xsl:text>. </xsl:text></h2>
        
    </xsl:template>
    
    <xsl:template match="titleStmt" mode="intHead">
        <h3>Digital Mitford Headnote: DRAFT</h3>
      
    <!--    <xsl:text>Sponsored by: </xsl:text>
        <ul>
        <xsl:for-each select="sponsor">
        <li><xsl:value-of select=".//text()"/></li>
        </xsl:for-each>
        </ul>-->
    </xsl:template>
    
   
    
   
    
  
    
  
    
   

    <xsl:template match="body//p">
        <p><span class="prose">
            <xsl:apply-templates/></span>
        </p>
    </xsl:template>
    
  

   
    
    <xsl:template match="lb">
        <br/>
    </xsl:template>

    <xsl:template match="l">
        <xsl:choose><xsl:when test="@n">
        <span class="line" id="L{@n}">
            <xsl:value-of select="@n"/>
            <xsl:text> </xsl:text>

            <xsl:apply-templates/>
            <br/>
        </span></xsl:when>
        <xsl:otherwise>
            
            <span class="line" id="L{count(preceding::l)+1}">
                <xsl:value-of select="@n"/>
                <xsl:text> </xsl:text>
                
                <xsl:apply-templates/>
                <br/>
            </span>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

 

    <xsl:template match="hi[@rend='smallcaps']">
        <span class="smallcaps">
            <xsl:apply-templates/>
        </span>

    </xsl:template>


   

    <xsl:template match="placeName | name[@type='place']">
      <!-- <xsl:variable name="dv" select="distinct-values(placeName)"/>
      <xsl:for-each select="(.[matches(., $dv)])[1]">-->
        <span class="place">
            
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
      <!--</xsl:for-each>-->
        
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
        
        
      <!--<xsl:variable name="dv2" select="distinct-values(persName)"/>
        <xsl:for-each select="(.[.=$dv2])[1]">-->
        <!--ebb: I want to select the first distinct use of a particular name and wrap it in spans. The above
            expression doesn't work at all and is suppressing each persName.-->
        
        <span class="person"><xsl:apply-templates/>
       
        <xsl:if test="$si//*[@xml:id = substring-after(current()/@ref, '#')] | $si//*[@xml:id = substring-after(current()/@who, '#')] | $si//*[@xml:id = substring-after(current()/@corresp, '#')]"> 
           <span class="si">
               <xsl:variable name="siPers" select="$si//*[@xml:id = substring-after(current()/@ref, '#')] | $si//*[@xml:id = substring-after(current()/@who, '#')] | $si//*[@xml:id = substring-after(current()/@corresp, '#')]"/>
         <b>   
         <xsl:choose>
             <xsl:when test="$siPers//forename">  <xsl:value-of select="$si//*[@xml:id = substring-after(current()/@ref, '#')]//forename[1]"/>
            <xsl:text> </xsl:text>
            <xsl:if test="$siPers//forename[position() gt 1]"><xsl:value-of select="string-join($siPers//forename[position() gt 1], ' ')"/><xsl:text> </xsl:text></xsl:if>
            <xsl:if test="count($siPers//surname) gt 1"> <xsl:value-of select="string-join($siPers//surname[2] | surname[@type='maiden'], ' ')"/><xsl:text> </xsl:text></xsl:if>
            
            <xsl:value-of select="string-join($siPers//surname[1] | surname[@type='married'], ' ')"/>
                 <xsl:if test="$siPers//roleName">
                     <xsl:text>, </xsl:text>
                     <xsl:value-of select="string-join(distinct-values($siPers//roleName/text()[1]), ', ')"/>
                 </xsl:if>
                 
                 <xsl:if test="count($siPers//roleName/date) gt 1">
                    <xsl:value-of select="string-join($siPers//roleName/date, ' and ')"/> 
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
         </b>
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
        <xsl:if test="$siPers//note[@resp]">
            <xsl:text>--</xsl:text>
             <xsl:value-of select="$siPers//note/@resp"/></xsl:if>
        
     </xsl:if> 
              
    
        </span>
       </xsl:if>
        </span>
        <!--</xsl:for-each>-->
    </xsl:template>

    <xsl:template match="orgName | rs[@type='org']">
        <span class="org">
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
        <span class="rs">
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
        <xsl:if test="./text()"><span class="title"><xsl:apply-templates/>
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
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="quote[not(count(.//l) gt 1)] | q">
        <xsl:text>“</xsl:text><xsl:apply-templates/><xsl:text>”</xsl:text>
        
    </xsl:template>

<xsl:template match="date">
        <span class="date" title="{string-join(@*, '-')}">
            <xsl:apply-templates/>
        </span>
    
  
    </xsl:template>

  <xsl:template match="emph">
      <em><xsl:apply-templates/></em> 
  </xsl:template>
    
   
    
    <xsl:template match="hi[@rend='superscript']">
        <span class="above-line"><xsl:apply-templates/></span>
    </xsl:template>
    
  
    
    <xsl:template match="choice">
        <span class="sic"><xsl:apply-templates select="sic"/></span>
        <span class="reg"><xsl:apply-templates select="reg"/></span>
       
    </xsl:template>
    
   
</xsl:stylesheet>

