<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="text"/>

    <!--<xsl:strip-space elements="*"/>-->

    <xsl:variable name="witId" select="//listWit/witness/@xml:id"/>

    <xsl:template match="/">
        <xsl:text>Location</xsl:text><xsl:text>&#x9;</xsl:text>
        <xsl:for-each select="//listWit/witness">
            <xsl:apply-templates select="@xml:id"/><xsl:text>&#x9;</xsl:text>
            
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text> 
        <xsl:apply-templates select="//text//div//p | //text//div//l | //text//div//stage"/>
    </xsl:template>
   <xsl:template match="p | l | stage">
       <xsl:choose>
           <xsl:when test="not(.//app)">
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
               <xsl:text>&#x9;</xsl:text> 
       <xsl:for-each select="$witId">
                      <xsl:text>natch&#x9;</xsl:text>
                  </xsl:for-each>
                  <xsl:text>&#10;</xsl:text> 
                 </xsl:when>
           <xsl:otherwise>
               <xsl:apply-templates select="//app"/>
           </xsl:otherwise>
       </xsl:choose>
       
   </xsl:template>
    <xsl:template match="*[.//app]">
        <xsl:apply-templates select=".//app"/>
    </xsl:template>
    <xsl:template match="app">
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
        <xsl:text>&#x9;</xsl:text> <!--This should be a tab character-->

            <xsl:for-each select="$witId">
                   <!-- <xsl:variable name="string">-->
                        <xsl:value-of
                            select="$rdg[contains(@wit, current())]/normalize-space(string())"/><xsl:text>&#x9;</xsl:text>
                    <!--</xsl:variable>
                    <xsl:value-of select="string-length($string)"/>-->
                   <!--DELETED STRINGS: Note: Eric's code sometimes closes up the <del/> as self-closing, so check this for errors against ms. <xsl:if test="$rdg[contains(@wit, current())]/del">
                        <xsl:text>, deleted: </xsl:text>
                        <xsl:variable name="delString">
                            <xsl:value-of
                                select="$rdg[contains(@wit, current())]/del/normalize-space(string())"
                            />
                        </xsl:variable>
                        <xsl:value-of select="string-length($delString)"/>
                    </xsl:if>-->
                
            </xsl:for-each>
        <xsl:text>&#10;</xsl:text> 



    </xsl:template>



</xsl:stylesheet>
