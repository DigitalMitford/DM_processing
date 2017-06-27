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
                <h2>Distinct Occupations: ENTIRE FILE</h2>
                <!--2017-06-27 ebb: I'm thinking you may have saved your REVISED sorting XSLT outside the repo, because this looks like your first version. (There are no xsl:sort elements in here.) You should run normalize-space() to help remove a lot of white-spaces from some of these!-->
                <h3>Number of hits: <xsl:value-of select="count(distinct-values(//occupation))"></xsl:value-of></h3>
                <ol><xsl:for-each select="distinct-values(//occupation)">
                    <li><xsl:value-of select="current()"/></li>     
                </xsl:for-each></ol>
                <!--ebb: You output was coming out not well formed because list items need a wrapper element in HTML: either ol or ul (for ordered/numbered list vs. unordered/bulleted list). I've gone ahead and made this a numbered list by setting the wrapper element on the outside of the xsl:for-each loop that's generating your lists (here and below). -->
                <hr/>
                <h2>Distinct Occupations: Historical People/Organizations ONLY</h2>
                <h3>Number of hits: <xsl:value-of select="count(distinct-values(//div[@type='historical_people']//occupation))"></xsl:value-of></h3>
               <ol><xsl:for-each select="distinct-values(//div[@type='historical_people']//occupation)">
                   <!--ebb: To do an xsl:sort from the most- to least-used occupation value, you need to do a for-each just as you're doing, but you need to sort based on a count of how often *each member in the list* is used in the XML tree. To double check it's working, you may want to output the count for each list item. It would work something like this:
                  <xsl:for-each select="distinct-values(//div[@type='historical_people']//occupation)">
                  <li><xsl:value-of select="current()">
                  <xsl:sort select="count(//occupation[text() = current()])" order="descending"/>
                  </xsl:value-of>, 
                  <xsl:value-of select="count(//occupation[. = current()])"/>
                  
                  </li>
               See if that works, and beware of my code here: I wrote it out without testing it or doing much lookup: You want to double-check my syntax and my count() expression to see if they really work.   
                   
                   -->
                    <li><xsl:value-of select="current()"/></li>     
                </xsl:for-each></ol>
                <hr/>
                <hr/>
                <h1>SECTION TWO - MISSING/NO OCCUPATION ELEMENT</h1>
                <h2>(Taken from div type="historical_people" ONLY)</h2>
                <h2>The org elements DO NOT CONTAIN an occupation element.</h2>
                <hr/>
                <h2>Person Elements With No Occupation Element<br/>(Listed by xml:id)</h2>
                <h3>Number of hits: <xsl:value-of select="count(//listPerson[@sortKey='histPersons']//person[not(occupation)])"></xsl:value-of></h3>
                <xsl:for-each select="//listPerson[@sortKey='histPersons']//person[not(occupation)]">
                    <li><xsl:value-of select="current()/@xml:id"/></li>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>