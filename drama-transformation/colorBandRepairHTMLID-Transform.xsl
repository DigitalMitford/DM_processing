<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"  xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="3.0">
    <!--2016-11-30 ebb: Stylesheet to add a colspan to widen table cells when a row doesn't contain a complete set. This is producing munged output. -->
 <xsl:mode on-no-match="shallow-copy"/>
    
 <xsl:variable name="tCellCount" select="count(//thead/tr/th) + 1"/>
    
 <xsl:template match="tbody/tr">
    <xsl:choose> <xsl:when test="count(td) lt $tCellCount">
        <tr class="{@class}"><xsl:choose> <xsl:when test="td[position() ne last()]/@class">
       <xsl:for-each select="td[position() ne last()]">
            <td class="{@class}"><xsl:value-of select="."/></td>
        </xsl:for-each>
        
        </xsl:when>
        <xsl:otherwise><td><xsl:value-of select="td[position() ne last()]"/></td></xsl:otherwise></xsl:choose>
         
         <xsl:choose><xsl:when test="td[last()]/@class"><td class="{td[last()]/@class}" colspan="{$tCellCount - count(td)}"><xsl:value-of select="td[last()]"/></td></xsl:when>
         <xsl:otherwise>
             <td colspan="{$tCellCount - count(td)}"><xsl:value-of select="td[last()]"/></td>
         </xsl:otherwise>
         </xsl:choose></tr>
     </xsl:when>
    <xsl:otherwise>
       <tr class="{@class}"><xsl:apply-templates/></tr>
    </xsl:otherwise>
    </xsl:choose>
        
 </xsl:template>
    
</xsl:stylesheet>