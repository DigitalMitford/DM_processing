<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <html>
            <head><title>Digital Mitford Coding School - Site Index: Occupation Info </title></head>
            <body>
                <h1>SECTION ONE - DISTINCT VALUES</h1>
                <h2>Distinct Occupations: Historical People/Organizations ONLY</h2>
                <h3>Number of hits: <xsl:value-of select="count(distinct-values(//div[@type='historical_people']//occupation))"></xsl:value-of></h3>
                <h2>Alphabetically Sorted</h2>
                <ol><xsl:for-each select="distinct-values(//div[@type='historical_people']//occupation[normalize-space()])">
                    <xsl:sort order="ascending" case-order="lower-first"/>
                    <li><xsl:value-of select="normalize-space(current())"/></li>     
                </xsl:for-each></ol>
                <hr/>
                <h2>Totals per Value</h2>
                <xsl:variable name="values" select="//div[@type='historical_people']//occupation"/>
                <ol><xsl:for-each select="distinct-values(//div[@type='historical_people']//occupation)">
                    <xsl:sort select="count($values[. = current()])" order="descending"/>
                    <li><xsl:value-of select="normalize-space(current())">                        
                    </xsl:value-of>                        
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="count($values[. = current()])"/>
                        
                    </li>
                </xsl:for-each>
                </ol>
                <hr/>
                <hr/>
                <h1>SECTION TWO - MISSING/NO OCCUPATION ELEMENT</h1>
                <h2>(Taken from div type="historical_people" ONLY)</h2>
                <h2>The org elements DO NOT CONTAIN an occupation element.</h2>
                <hr/>
                <h2>Person Elements With No Occupation Element<br/>(Listed by xml:id)</h2>
                <h3>Number of hits: <xsl:value-of select="count(//listPerson[@sortKey='histPersons']//person[not(occupation)])"></xsl:value-of></h3>
                <ol><xsl:for-each select="//listPerson[@sortKey='histPersons']//person[not(occupation)]">
                    <li><xsl:value-of select="current()/@xml:id"/></li>
                </xsl:for-each></ol>
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>