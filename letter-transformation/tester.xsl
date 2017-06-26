<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="si" select="document('http://digitalmitford.org/si.xml')"
        as="document-node()"/>
    <xsl:variable as="element(tei:p)" name="input">
        
            <tei:p>Stuff to look up, like <tei:persName ref="#MRM">Mary Russell Mitford</tei:persName>.</tei:p>

    </xsl:variable>

    <xsl:template match="tei:p">
        <tei:p>
            <xsl:apply-templates/>
        </tei:p>
    </xsl:template>

    <xsl:template match="tei:persName">
        <span class="context" title="person">
            <xsl:apply-templates/>
            <span class="note">
                <xsl:value-of select="$si//*[@xml:id = substring-after(current()/@ref, '#')]"/>
            </span>
        </span>
    </xsl:template>
    <xsl:template match="/">
      
            <xsl:apply-templates select="$input"/>
        
        
    </xsl:template>

</xsl:stylesheet>
