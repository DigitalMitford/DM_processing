<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Digital Mitford: The Mary Russell Mitford Archive</title>
                <meta name="Description"
                    content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society."/>
                <meta name="keywords"
                    content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar"/>
                <link rel="stylesheet" type="text/css" href="mitfordletter.css"/>
                <script type="text/javascript" src="MRMLetters.js" xml:space="preserve">...</script>
                


            </head>
            <body>

                <div id="title">
                    <h1>Digital Mitford: Letters</h1>
                    <hr/>
                </div>
                <div id="menubar">
                    <h2><a href="index.html">Welcome</a> | <a href="about.html">About</a> | <a
                        href="search.html">Search</a> | <a href="literature.html">Literary
                            Works</a> | <a href="letters.html">Letters</a> | <a href="visual.html"
                                >People, Places, and Networks</a> | <a href="maps.html">Maps</a> | <a
                                    href="contact.html">Contact</a> | <a href="workshop.html">Workshop
                                        Materials</a></h2>
                    
                </div>
                
                
                <hr/>
                <div id="container">
                    
                    <div id="letterHead">
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
        <a href="{base-uri(.)}"><xsl:apply-templates/></a>
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

    <xsl:template match="closer">
        <div id="closer">
            <xsl:apply-templates/>
        </div>
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
        <span class="place">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


<xsl:template match="pb">
   <span class="pagebreak"><xsl:text>page&#xa0;</xsl:text><xsl:value-of select="@n"/><br/></span> 
    
</xsl:template>

    <xsl:template match="note">
        <span id="N{count (preceding::note) + 1}" class="anchor">[<xsl:value-of
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

    <xsl:template match="persName | rs[@type='person']">
        <span class="person">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="orgName | rs[@type='org']">
        <span class="org">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

  <!--  <xsl:template match="date">
        <span class="date" id="{@when}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>-->

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
    
    <xsl:template match="body//title">
        <span class="title"><xsl:apply-templates/></span>
    </xsl:template>

</xsl:stylesheet>
