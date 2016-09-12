<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat" omit-xml-declaration="yes"/> 
   
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Digital Mitford: Staff</title>
                <meta name="Description" content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society."/>
                <meta name="keywords" content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar"/>
                <link rel="stylesheet" type="text/css" href="mitfordMain.css"/>
                <script type="text/javascript" src="mrmStaff.js" xml:space="preserve">***</script>
                
                
            </head>
            <body>  
                
                <div id="title"><h1>Digital Mitford Staff</h1>
                    <hr/></div> 
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
                    <div id="images">
                        <img src="" id="rotator" alt="Mary Russell Mitford"/>
                    </div>
                    <div id="floatright">
                        <p class="boilerplate"><span><strong>Maintained by: </strong> Elisa E. Beshero-Bondar (ebb8 at
                            pitt.edu) <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/80x15.png" /></a></span><span><strong>Last modified:
                            </strong><xsl:value-of select="current-date()"/></span></p>
                        
                        <div id="editors">
                        <h3>Editors:</h3>
                        
                            <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[.//roleName[not(matches(., 'Consult'))][matches(., 'Editor')]]">
                                <xsl:sort select=".//surname"/>
                            </xsl:apply-templates>   
                            
                            
   
                        
                            
                            <h3>Consulting Editors: Data Visualization Group</h3>

                           
                                
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[.//roleName[matches(., 'Data')]]">
                                    <xsl:sort select=".//surname"/>
                                </xsl:apply-templates>  
                                
                                
                            
                            
                            <h3>Student Assistants</h3>
                           
                                
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[.//roleName[matches(., 'Assistant')]]">
                                    <xsl:sort select=".//surname"/>
                                </xsl:apply-templates>  
                                
                                
                            
                            <h3>Advisory Board</h3>
                           
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[.//roleName[matches(., 'Advisory')]]">
                                    <xsl:sort select=".//surname"/>
                                </xsl:apply-templates>  
                                
                            
                        <h3>Consultants</h3>
                            
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[.//roleName[not(matches(., 'Data'))][matches(., 'Consult')]]">
                                    <xsl:sort select=".//surname"/>
                                </xsl:apply-templates>  
                            
                            <h4>Past helpers with the project</h4>
                            <xsl:variable name="assistantsPast" select="//listPerson[@sortKey='Past_Assistants']/person[.//roleName[matches(., 'Assistant')]]"/>
                             <xsl:text>Thanks to the following students from SUNY Potsdam and UCLA who helped us with this project in the past: </xsl:text> <!--<xsl:value-of select="concat($assistantsPast//forename, ' ', $assistantsPast//surname)"/>-->
                         <xsl:for-each select="$assistantsPast">
                             <xsl:sort select=".//surname[1]"/>
                            <xsl:choose><xsl:when test="not(position() = last())"><xsl:value-of select="concat(.//forename[1], ' ', .//surname[1])"/>
                            <xsl:text>, </xsl:text></xsl:when>
                            <xsl:otherwise><xsl:text>and </xsl:text>
                                <xsl:value-of select="concat(.//forename[1], ' ', .//surname[1])"/>
                            </xsl:otherwise>
                            </xsl:choose>
                            
                         </xsl:for-each>
                       <xsl:text>. </xsl:text>
                            
                        </div>
            
                    </div>
                </div>
            </body>
            
        </html>
    </xsl:template>
    
    <xsl:template match="listPerson[@sortKey='Mitford_Team']/person">
              
     <span class="entry">  <span class="head"><xsl:choose><xsl:when test="persName/ptr">
             <a href="{persName/ptr/@target}"><xsl:apply-templates select="string-join(persName/forename, ' ')"/><xsl:text> </xsl:text>
             <xsl:apply-templates select="persName/surname"/>
            
             </a></xsl:when>
         <xsl:otherwise>
             <xsl:value-of select="string-join(persName/forename, ' ')"/><xsl:text> </xsl:text>
             <xsl:apply-templates select="persName/surname"/>
              
            
         </xsl:otherwise>
         </xsl:choose>
             <xsl:text>, </xsl:text>
           <xsl:apply-templates select="string-join(.//affiliation, ', ')"/>
     
     <xsl:if test="persName/roleName[matches(., 'Princ')] | persName/roleName[matches(., 'Found')]">
         <xsl:text>, </xsl:text>
         <xsl:value-of select="string-join(persName/roleName[matches(., 'Princ')] | persName/roleName[matches(., 'Found')] | persName/roleName[matches(., 'Bib')], ', ')"/>
        
     </xsl:if>
         <xsl:if test="note/text()">
             <span class="arrow">&#x21b4;</span>
         </xsl:if>
     
     </span>
     
   
           
           <xsl:if test="note/text()">
        
               <span class="more">
               <xsl:apply-templates select="note"/>
               </span>
           
           </xsl:if>
  
     </span>
    </xsl:template>
    
    
    
    
    
    <xsl:template match="title">
        <i><xsl:apply-templates/></i>
    </xsl:template>
    
    <xsl:template match="note//ptr">
        
        <a href="{@target}"><xsl:apply-templates select="@target"/></a>
    </xsl:template>
    
    <xsl:template match="note//ref">
        <a href="{@target}"><xsl:apply-templates/></a>
        
    </xsl:template>

    
</xsl:stylesheet>