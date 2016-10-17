<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml" xpath-default-namespace="http://elisa.newtfire.org"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>   
    <xsl:variable name="LDR" select="document('LevDistsRienzi.xml')" as="document-node()"/>
    <xsl:variable name="witId" select="//listWit/witness/@xml:id"/>

    <xsl:template match="/">
        <html><head><title>Rienzi: Genetic Survey</title></head>
        <body>
            <table>
                <tr><xsl:for-each select="//tr[@id='head']/th">
                    <th><xsl:value-of select="."/></th>   
                </xsl:for-each>
                </tr>  
              <xsl:copy-of select="//tr[not(@id='head')]"/>
               <!-- <xsl:apply-templates select="//text//app"/>-->
             </table>
        </body>      
        </html>
    </xsl:template>
   <!-- <xsl:template match="app">
        <xsl:variable name="locus">
            
            <xsl:value-of
                select="concat(ancestor::div[2][@type]/@type, ' ', ancestor::div[2][@n]/@n, ' ')"/>
            <xsl:value-of
                select="concat(ancestor::div[1]/@type, ' ', ancestor::div[1]/@n, ': ')"/>
            <xsl:value-of select="parent::*/parent::*/name()"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="parent::*/name()"/>
            <xsl:if test="parent::l">
                <xsl:text> </xsl:text>
                <xsl:value-of select="tokenize(parent::l/@xml:id, '_')[last()]"/>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="$LDR//nf:tr[nf:td = $locus]">
           
                <xsl:copy-of select="$LDR//nf:tr[nf:td = $locus]" copy-namespaces="no"/>
            
        </xsl:if>-->
        
        <!--<xsl:for-each select="$LDR//nf:tr[nf:td = $locus]">
        <tr>
       <xsl:for-each select="./nf:td">
           <td><xsl:value-of select="current()"/></td>
       </xsl:for-each>
   </tr>
        </xsl:for-each>
          </xsl:template>
        -->
  
    
    
    <!--<xsl:template match="nf:tr">
        <tr>
            <xsl:apply-templates select="nf:td"/>
        </tr>
    </xsl:template>  
    <xsl:template match="nf:td">
        <td><xsl:apply-templates/></td>
    </xsl:template>-->
        
        
        
      <!--  
        <xsl:variable select="rdg" name="rdg"/>
                <xsl:value-of
                    select="concat(ancestor::div[2][@type]/@type, ' ', ancestor::div[2][@n]/@n, ' ')"/>
                <xsl:value-of
                    select="concat(ancestor::div[1]/@type, ' ', ancestor::div[1]/@n, ': ')"/>
                <xsl:value-of select="parent::*/parent::*/name()"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="parent::*/name()"/>
                <xsl:if test="parent::l">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="tokenize(parent::l/@xml:id, '_')[last()]"/>
                </xsl:if>
        <xsl:text>&#x9;</xsl:text> <!-\-This should be a tab character-\->

            <xsl:for-each select="$witId">
                   <!-\- <xsl:variable name="string">-\->
                        <xsl:value-of
                            select="$rdg[contains(@wit, current())]/normalize-space(string())"/><xsl:text>&#x9;</xsl:text>
                    <!-\-</xsl:variable>
                    <xsl:value-of select="string-length($string)"/>-\->
                   <!-\-DELETED STRINGS: Note: Eric's code sometimes closes up the <del/> as self-closing, so check this for errors against ms. <xsl:if test="$rdg[contains(@wit, current())]/del">
                        <xsl:text>, deleted: </xsl:text>
                        <xsl:variable name="delString">
                            <xsl:value-of
                                select="$rdg[contains(@wit, current())]/del/normalize-space(string())"
                            />
                        </xsl:variable>
                        <xsl:value-of select="string-length($delString)"/>
                    </xsl:if>-\->
                
            </xsl:for-each>
        <xsl:text>&#10;</xsl:text> 



    </xsl:template>
-->


</xsl:stylesheet>
