<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">

    <xsl:output method="text" encoding="utf-8"/>
    <xsl:strip-space elements="persName forename surname"/>


    <xsl:template match="/">
        <xsl:apply-templates select="//listPerson[@type = 'Mitford_Team']"/>
    </xsl:template>

    <xsl:template match="listPerson[@type = 'Mitford_Team']">

        <xsl:for-each select="person">

            <xsl:value-of select="@xml:id"/>
            <xsl:text>&#x9;</xsl:text>
            <!--This should be a tab character-->

            <xsl:apply-templates select="persName/surname"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="string-join(persName/forename, ' ')"/>
            <xsl:text> </xsl:text>
            

            <xsl:text>&#x9;</xsl:text>


            <xsl:value-of select="persName/roleName[last()]"/>
            <xsl:text>&#x9;</xsl:text>


            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>

    </xsl:template>


</xsl:stylesheet>
