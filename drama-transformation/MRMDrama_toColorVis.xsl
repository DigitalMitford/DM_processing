<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml" xpath-default-namespace="http://elisa.newtfire.org"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>   
    <xsl:variable name="Rienzi" select="document('Rienzi.xml')" as="document-node()"/>
    <xsl:variable name="witInfo" select="$Rienzi//tei:listWit/tei:witness"/>
    <xsl:variable name="witId" select="$Rienzi//tei:listWit/tei:witness/@xml:id"/>

    <xsl:template match="/">
        <html><head><title>Rienzi: Genetic Survey</title>
            <meta name="Description" content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society." />
            <meta name="keywords" content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, TEI, Text Encoding Initiative, genetic edition, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar" />
            <link rel="stylesheet" type="text/css" href="mitfordGenVis.css" /><script type="text/javascript" src="MRMGenVis.js">/**/</script>
        </head>
        <body>
            <h1>Mitford’s <i>Rienzi</i>: A Genetic Survey</h1>
            <p>A visual survey and interface for examining alterations to Mary Russell Mitford’s historical tragedy of <i>Rienzi</i>. This illustration and interface serves to highlight the passages in the play that transformed, and offers a genetic survey of how the text transformed by considering four separate editions of the text in comparison with each of the others. The visualization and interface here are drawn from Eric Hood’s TEI edition of <i>Rienzi</i>, working with the TEI apparatus markup of all variant passages in the four editions.</p>
            <p>The four editions represented here are:</p>
            <ul>
               <xsl:for-each select="$witInfo">
                   <li><strong><xsl:value-of select="@xml:id"/></strong>: <xsl:value-of select="current()"/></li>
               </xsl:for-each> 
            </ul>
            <p>We calculated Levenshtein edit distances for each locus in the play that featured variance, whether a paragraph in the preface, the stage directions, or  within lines of speeches. Levenshtein edit distance is a measure of how different two strings of text are from one another, counting any alteration as 1. (Thus, the difference between <q>newt,</q> and <q>next!</q> equals 2.) We then plotted a visual summary of each unit paragraph, line, and stage direction as a row in the table below. When a unit did not feature any variance, we plotted a uniform black row, but when variance appeared, we present a visual plot to summarize how much varied between each of the six possible combinations: 1) ms to 1828, 2) ms to 1837, 3) ms to 1854, 4) 1828 to 1837, 5) 1828 to 1854, and 6) 1837 to 1854. We divided values by ranges, based on the average and maximum values of all Levenshtein measures. These varied from 1 to 2654 characters, and their average was 9. We applied the following color values based on ranges and quantities of variants to show minor to major variation based on the following scale:</p>
            <ol>
                <li>black: No difference (plotted to show relative distance of variant loci in the text)</li>
                <li>pale blue: 4,020 variants that differ between 1 and 2 characters difference</li>
<li>pale green: 574 variants differing between 2 and 5 characters</li>  
                <li>yellow: 158 variants differing between 5 and 10 characters</li>
                <li>orange: 315 variants differing between 10 and 20 characters</li>
                <li>red: 536 variants of more than 20 characters of difference.</li>
            </ol>
   <p>On mouseover of a given row featuring variants, a previously-concealed table row drops down beneath it revealing variant texts at that location.</p>
            <table>
                <tr><xsl:for-each select="//tr[@id='head']/th">
                    <th><xsl:value-of select="."/></th>   
                </xsl:for-each>
                </tr>  
              <xsl:apply-templates select="//tr[not(@id='head')]"/>
              
             </table>
        </body>      
        </html>
    </xsl:template>
    <xsl:template match="tr">
        <xsl:if test="td[2] != 'natch'"><tr class="{@title}"><xsl:apply-templates select="td"/></tr></xsl:if>
        
    </xsl:template>
    <xsl:template match="td">
        <xsl:choose>
            <xsl:when test="matches(., '[A-z]+')"><td><xsl:apply-templates/></td></xsl:when>
        <xsl:otherwise>
            <xsl:if test="number() = 0">
                <td class="black"><span class="hidNo"><xsl:value-of select="."/></span></td>
            </xsl:if>
            <xsl:if test="number() gt 0 and number() lt 2"><td class="blue"><span class="hidNo"><xsl:value-of select="."/></span></td></xsl:if>
        <xsl:if test="number() gt 2 and number() lt 5">
            <td class="green"><span class="hidNo"><xsl:value-of select="."/></span></td></xsl:if>
            
            <xsl:if test="number() gt 5 and number() lt 10">
                <td class="yellow"><span class="hidNo"><xsl:value-of select="."/></span></td></xsl:if>    
            <xsl:if test="number() gt 10 and number() lt 20">
                <td class="orange"><span class="hidNo"><xsl:value-of select="."/></span></td></xsl:if>
            <xsl:if test="number() gt 20">
                <td class="red"><span class="hidNo"><xsl:value-of select="."/></span></td></xsl:if>
            
        
        
        </xsl:otherwise></xsl:choose>
    </xsl:template>

</xsl:stylesheet>
