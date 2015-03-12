<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <xsl:output method="xml" encoding="utf-8" indent="yes"
        doctype-system="about:legacy-compat"/>
    
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Digital Mitford: Staff</title>
                <meta name="Description" content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society."/>
                <meta name="keywords" content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar"/>
                <link rel="stylesheet" type="text/css" href="mitfordMain.css"/>
                <script type="text/javascript" src="imagerotat.js" xml:space="preserve">***</script>
                
                
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
                        <dl>
                            <xsl:apply-templates select="//listPerson[@type='Mitford_Team']/person[.//roleName[not(matches(., 'Consult'))][matches(., 'Editor')]]">
                                <xsl:sort select=".//surname"/>
                            </xsl:apply-templates>   
                            
                            
   
                        </dl>
                            
                            <h3>Consulting Editors: Data Visualization Group</h3>

                            <dl>
                                
                                <xsl:apply-templates select="//listPerson[@type='Mitford_Team']/person[.//roleName[matches(., 'Data')]]">
                                    <xsl:sort select=".//surname"/>
                                </xsl:apply-templates>  
                                
                                
                            </dl>
                            
                            <h3>Student Assistants</h3>
                            <dl>
                                
                                <xsl:apply-templates select="//listPerson[@type='Mitford_Team']/person[.//roleName[matches(., 'Assistant')]]">
                                    <xsl:sort select=".//surname"/>
                                </xsl:apply-templates>  
                                
                                
                            </dl>
                            <h3>Advisory Board</h3>
                            <dl>
                                <xsl:apply-templates select="//listPerson[@type='Mitford_Team']/person[.//roleName[matches(., 'Advisory')]]">
                                    <xsl:sort select=".//surname"/>
                                </xsl:apply-templates>  
                                
                            </dl>
                        <h3>Consultants</h3>
                            <dl>
                                <xsl:apply-templates select="//listPerson[@type='Mitford_Team']/person[.//roleName[not(matches(., 'Data'))][matches(., 'Consult')]]">
                                    <xsl:sort select=".//surname"/>
                                </xsl:apply-templates>  
                                
                            </dl>
                        </div>
            
                    </div>
                </div>
            </body>
            
        </html>
    </xsl:template>
    
    <xsl:template match="listPerson[@type='Mitford_Team']/person">
              
     <dt>  <xsl:choose><xsl:when test="persName/ptr">
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
         <xsl:value-of select="string-join(persName/roleName[matches(., 'Princ')] | persName/roleName[matches(., 'Found')], ', ')"/>
         
     </xsl:if>
     
     </dt>
           
           <xsl:if test="note"><dd>
               <xsl:apply-templates select="note"/>
               
           </dd>
           </xsl:if>
  
    </xsl:template>
    
    
    
    
    
    <xsl:template match="title">
        <i><xsl:apply-templates/></i>
    </xsl:template>
    
    <xsl:template match="note//ptr">
        
        <a href="{@target}"><xsl:apply-templates select="@target"/></a>
    </xsl:template>

    
</xsl:stylesheet>