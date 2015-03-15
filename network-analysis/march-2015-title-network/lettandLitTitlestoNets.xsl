<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="text"/>
    <xsl:strip-space elements="bibl title persName placeName rs"/>
    
    <xsl:variable name="si" select="document('http://mitford.pitt.edu/si.xml')" as="document-node()+"/>
    
    <xsl:variable name="lettersLit" select="collection('lettersPlusLit')"/>
    
    <xsl:template match="/">
    <xsl:apply-templates select="$lettersLit//body//title"/>   
        
    </xsl:template>
    
    <xsl:template match="title">
        
        <xsl:variable name="Node1Edge">
            <xsl:value-of select="translate((tokenize((@ref, normalize-space(current()))[1], '#')[last()]), '&quot;' ,'')"/>
        <xsl:text>&#x9;</xsl:text>
            <xsl:choose>
                <xsl:when test="$si//bibl[@xml:id = substring-after(current()/@ref, '#')]/author[@ref='#MRM'] | $si//bibl[@xml:id = current()/@ref]/author[@ref='#MRM']">
                <xsl:text>MRM-authored</xsl:text>
            </xsl:when>    
                <xsl:otherwise>
                    <xsl:text>Other-authored</xsl:text>
                </xsl:otherwise>

            </xsl:choose>
            <xsl:text>&#x9;</xsl:text>
        <xsl:choose><xsl:when test="ancestor::note">
            <xsl:text>note</xsl:text>
        </xsl:when>
            <xsl:otherwise>
                <xsl:text>main</xsl:text>
            </xsl:otherwise></xsl:choose>
        <xsl:text>&#x9;</xsl:text>
        
        <xsl:apply-templates select="tokenize(./base-uri(), '/')[last()]"/>
        <xsl:text>&#x9;</xsl:text>
        </xsl:variable>
        
        <xsl:for-each select="ancestor::body//title[not(. = current())]">
            <xsl:value-of select="$Node1Edge"/>    
            
            
         <!--ebb 2015-03-14: I removed this because some of the bibl elements are wrapping large chunks of text.  
             
             <xsl:choose>
                <xsl:when test="not(@ref) and ./parent::bibl">
                    <xsl:value-of select="normalize-space(./parent::bibl)"/>
                    
                </xsl:when>
                
              <xsl:otherwise>  <xsl:value-of select="tokenize((@ref,normalize-space(.))[1], '#')[last()]"/></xsl:otherwise>
            </xsl:choose>-->
            
            <xsl:choose>
                <xsl:when test=".[not(@ref)][./preceding-sibling::*[1] ne title][./parent::bibl]">
                    <xsl:value-of select="normalize-space(./preceding-sibling::*[1])"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(translate(., '&quot;', ''))"/>
                </xsl:when>
                
                <xsl:otherwise>  <xsl:value-of select="translate(tokenize((@ref,normalize-space(.))[1], '#')[last()], '&quot;', '')"/></xsl:otherwise>
            </xsl:choose>
            
            
            
            <xsl:text>&#x9;</xsl:text>
            <xsl:choose><xsl:when test="current()/ancestor::note">
                <xsl:text>note</xsl:text>
            </xsl:when>
                <xsl:otherwise>
                    <xsl:text>main</xsl:text>
                </xsl:otherwise></xsl:choose>
            <xsl:text>&#10;</xsl:text>
            
        </xsl:for-each>
       
    </xsl:template>
    
    
</xsl:stylesheet>