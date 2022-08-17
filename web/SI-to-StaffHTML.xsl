<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="yes" 
        include-content-type="no" indent="yes"/>
   
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Digital Mitford: Staff</title>
                <meta name="Description" content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society."/>
                <meta name="keywords" content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <link rel="stylesheet" type="text/css" href="mitfordMain.css"/>
                <script type="text/javascript" src="mrmStaff.js" xml:space="preserve">***</script>
                
                
            </head>
            <body>  
                
                
                <xsl:comment>#include virtual="mitfordMainMenu.html" </xsl:comment>
               <h1>Digital Mitford Staff</h1>
                    
                
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
                            
                        <h3>Editors</h3>
                            <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[persName[not(roleName[@type='sectionEditor' or @type='retired' or matches(., 'Consult')])]][persName/roleName[matches(., 'Editor')]]">
                                <xsl:sort select="descendant::surname[1]"/>
                            </xsl:apply-templates>   

                            <h3>Consulting Editors: Data Visualization Group</h3>
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[descendant::roleName[matches(., 'Data')]]">
                                    <xsl:sort select="descendant::surname[1]"/>
                                </xsl:apply-templates>  
                            
                            
                        <h3>Active Consultants and Assistants</h3>
                                
                                
                            <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[persName/roleName[matches(., 'Active')]]">
                                <xsl:sort select="descendant::surname[1]"/>
                            </xsl:apply-templates>  
                            
                                
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person/persName[descendant::roleName[matches(., 'Assistant')]]">
                                    <xsl:sort select="descendant::surname[1]"/>
                                </xsl:apply-templates>  
                                
                                
                            
                            <h3>Advisory Board</h3>
                           
                                <xsl:apply-templates select="//listPerson[@sortKey='Mitford_Team']/person[descendant::roleName[matches(., 'Advisory')]]">
                                    <xsl:sort select="descendant::surname[1]"/>
                                </xsl:apply-templates>  
                            
                            <h3>Past Editors, Advisors, and Active Consultants</h3>
                            <xsl:text>These advisors, editors, and students from past years each made substantial contributions to the development of our project: </xsl:text>
                            
                            <xsl:apply-templates select="//div[@type='Past_Editors']/listPerson[@sortKey='Past_Editors']/person[persName[descendant::roleName[matches(., 'Advisor')]]]">
                                <xsl:sort select="descendant::surname[1]"/>
                            </xsl:apply-templates>  
                            
                            <xsl:apply-templates select="//div[@type='Past_Editors']/listPerson[@sortKey='Past_Editors']/person[persName[descendant::roleName[matches(., 'Editor')]]]">
                                <xsl:sort select="descendant::surname[1]"/>
                            </xsl:apply-templates>  
                            <xsl:apply-templates select="//div[@type='Past_Editors']/listPerson[@sortKey='Past_Editors']/person[persName[descendant::roleName[matches(., 'Active')]]]">
                                <xsl:sort select="descendant::surname[1]"/>
                            </xsl:apply-templates>  
                            
                            
                            
                        <h3>Consultants</h3>
                            <xsl:text>The following scholars who have each played some small but significant part in the project: </xsl:text>
                            
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
                        <xsl:comment>#include virtual="licenseSoftware.html" </xsl:comment>
                       
                    </div>
                    
                </div>
            </body>
            
        </html>
    </xsl:template>
    <xsl:template match="listPerson[@sortKey='Mitford_Team' or @sortKey='Past_Editors']/person[persName/roleName[matches(., 'Active') or matches(., 'Editor') or matches(., 'Advisor') or matches(., 'Data')]]">
        <span class="entry"><span class="head">
            <xsl:choose><xsl:when test="persName/ptr">
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
            <xsl:if test="persName/roleName[matches(., 'Found')]"> <xsl:text>, </xsl:text>     
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
   <!-- <xsl:template match="listPerson[@sortKey='Mitford_Team' or @sortKey='Past_Editors']/person[persName/roleName[matches(., 'Active') or matches(., 'Editor') or matches(., 'Advisor')]]">
              
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
    </xsl:template>-->
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