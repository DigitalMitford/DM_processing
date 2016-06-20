<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>


    <xsl:strip-space elements="*"/>
<!--ebb: This is needed to remove white space that will sit in place of the element tags we're about to remove. -->
    
    <xsl:variable name="witness"
        select="//front/descendant::witness/@xml:id"/>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    
   <!-- <xsl:template match="//body//div/p">
            <p n="{count(preceding::p)+1}">
                <xsl:apply-templates/>
            </p>
    
    </xsl:template>-->
    
    <xsl:template match="app/rdg[contains(@wit, '#msR') and not(matches(@wit, 'R\d{4}'))]"/>
    
    <xsl:template match="app">
        <xsl:apply-templates/>
    </xsl:template>
    <!--ebb: This preserves the children of the app without the tags themselves. -->   
   

    <xsl:template match="app/rdg[contains(@wit, '#R1828')]">
       <xsl:apply-templates/>
   </xsl:template>
        
    
   
   
    
</xsl:stylesheet>
