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
                       
                        
                        <div id="editors">
                            <h3>Project Directors</h3>
                            
                            <!--<xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[descendant::roleName[@type='lead']]">
                     <xsl:sort select=".//surname"/>      
                   </xsl:apply-templates>-->
                            <xsl:for-each select="//listPerson[@sortKey='Mitford_Team']/person/descendant::roleName[@type='lead']">
                   <h4><xsl:value-of select="current()"/></h4>
                               <xsl:apply-templates select="current()/ancestor::person"/>
                            </xsl:for-each>
                            <h3>Section Editors</h3>
                            <xsl:for-each select="//listPerson[@sortKey='Mitford_Team']/person/descendant::roleName[@type='sectionEditor']">
                                <xsl:sort select="current()"/>
                                <h4><xsl:value-of select="current()"/></h4>
                                <xsl:apply-templates select="current()/ancestor::person"/>
                            </xsl:for-each>
                            
                        <h3>Editors:</h3>
                            <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[(descendant::roleName[not(@type='grad')])[1][not(@type='lead') and not(@type='sectionEditor')]][descendant::roleName[position() lt 3][not(@type='sectionEditor')]][descendant::roleName[matches(., 'Editor') and not(matches(., 'Consult'))]]">
                                <xsl:sort select="descendant::surname[1]"/>
                            </xsl:apply-templates>   

                            <h3>Consulting Editors: Data Visualization Group</h3>
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[descendant::roleName[matches(., 'Data')]]">
                                    <xsl:sort select="descendant::surname[1]"/>
                                </xsl:apply-templates>  
                                
                                
                            
                            
                            <h3>Student Assistants</h3>
                           
                                
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[descendant::roleName[matches(., 'Assistant')]]">
                                    <xsl:sort select="descendant::surname[1]"/>
                                </xsl:apply-templates>  
                                
                                
                            
                            <h3>Advisory Board</h3>
                           
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[descendant::roleName[matches(., 'Advisory')]]">
                                    <xsl:sort select="descendant::surname[1]"/>
                                </xsl:apply-templates>  
                                
                            
                        <h3>Consultants</h3>
                            <xsl:text>Thanks to the following scholars who have each played some small but significant part in the project: </xsl:text>
                            
                                <xsl:variable name="consultants" select="//listPerson[@sortKey='Mitford_Team']/person[descendant::roleName[not(matches(., 'Data'))][matches(., 'Consult')]]"/>
                                    <xsl:for-each select="$consultants">
                                        <xsl:sort select="descendant::surname[1]"/>
                                        <xsl:choose><xsl:when test="not(position() = last())"><xsl:value-of select="concat(string-join(descendant::forename, ' '), ' ', descendant::surname[1])"/>
                                            <xsl:text>, </xsl:text></xsl:when>
                                            <xsl:otherwise><xsl:text>and </xsl:text>
                                                <xsl:value-of select="concat(.//forename[1], ' ', .//surname[1])"/>
                                            </xsl:otherwise>
                                        </xsl:choose>                                
                                    </xsl:for-each>
                            <xsl:text>. </xsl:text>
                            
                            <h3>Past student assistants</h3>
                            <xsl:variable name="assistantsPast" select="//listPerson[@sortKey='Past_Assistants']/person[descendant::roleName[matches(., 'Assistant')]]"/>
                             <xsl:text>Thanks to the following students from SUNY Potsdam and UCLA who helped us with this project in the past: </xsl:text> <!--<xsl:value-of select="concat($assistantsPast//forename, ' ', $assistantsPast//surname)"/>-->
                         <xsl:for-each select="$assistantsPast">
                             <xsl:sort select="descendant::surname[1]"/>
                            <xsl:choose><xsl:when test="not(position() = last())"><xsl:value-of select="concat(.//forename[1], ' ', .//surname[1])"/>
                            <xsl:text>, </xsl:text></xsl:when>
                            <xsl:otherwise><xsl:text>and </xsl:text>
                                <xsl:value-of select="concat(string-join(descendant::forename), ' ', .//surname[1])"/>
                            </xsl:otherwise>
                            </xsl:choose>
                            
                         </xsl:for-each>
                       <xsl:text>. </xsl:text>
                            
                        </div>
                        <p class="boilerplate"><span><strong>Maintained by: </strong> Elisa E. Beshero-Bondar (ebb8 at
                            pitt.edu) <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/80x15.png" /></a></span><span><strong>Last modified:
                            </strong><xsl:value-of select="current-date()"/></span></p>
                    </div>
                    
                </div>
            </body>
            
        </html>
    </xsl:template>
    <xsl:template match="listPerson[@sortKey='Mitford_Team']/person[descendant::roleName[@type]]">
        <span class="entry"><span class="head"><xsl:choose><xsl:when test="persName/ptr">
            <a href="{persName/ptr/@target}"><xsl:apply-templates select="string-join(persName/forename, ' ')"/><xsl:text> </xsl:text>
                <xsl:apply-templates select="persName/surname"/>
                
            </a></xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string-join(persName/forename, ' ')"/><xsl:text> </xsl:text>
                <xsl:apply-templates select="persName/surname"/>
            </xsl:otherwise>
        </xsl:choose>
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="string-join(descendant::affiliation, ', ')"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="persName/roleName[matches(., 'Found')]"/>

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
    <xsl:template match="listPerson[@sortKey='Mitford_Team']/person[not(descendant::roleName[@type])]">
              
     <span class="entry">  <span class="head"><xsl:choose><xsl:when test="persName/ptr">
             <a href="{persName/ptr/@target}"><xsl:apply-templates select="string-join(persName/forename, ' ')"/><xsl:text> </xsl:text>
             <xsl:apply-templates select="persName/surname"/>
            
             </a></xsl:when>
         <xsl:otherwise>
             <xsl:value-of select="string-join(persName/forename, ' ')"/><xsl:text> </xsl:text>
             <xsl:apply-templates select="string-join(persName/surname, ' ')"/>
         </xsl:otherwise>
         </xsl:choose>
             <xsl:text>, </xsl:text>
           <xsl:apply-templates select="string-join(descendant::affiliation, ', ')"/>
     
     <xsl:if test="persName/roleName[matches(., 'Found')] | persName/roleName[@type]">
         <xsl:text>, </xsl:text>
         <xsl:value-of select="persName/roleName[matches(., 'Found')]"/>
        
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
  <xsl:template match="p"><!--ebb: Watch for this: Currently none of the bio staff has p elements in their bio notes -->
       <xsl:apply-templates/><br/>
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