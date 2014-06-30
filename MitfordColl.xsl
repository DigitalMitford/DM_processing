<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="text"/>
   <!-- <xsl:strip-space elements="persName placeName rs"/>-->

    <!--ebb: we ran this xsl file against itself. Any XML file will do to match a document template, including an XSL. This XSL requires sitting just above a directory named "coll." 30 June 2014: I notice it runs differently depending on what XML file you select to initiate the transformation. If you run from si.xml, it extracts all the xml:ids from the si.xml and then matches against the collection refs. Troubles with running from xsl to xsl: Unless you specify the $coll in the xmlid variable, it won't output the xmlids. And if you do specify $coll in the xmlid and canon name variables, the search for titles won't work. A little gimpy, but this XSLT serves to illustrate how to run XSLT on a collection.-->

    <xsl:variable name="coll" select="collection('coll')" as="document-node()+"/>
   <xsl:template match="/">
    <xsl:message select="count($coll)"/>
       
           <xsl:variable name="xmlid"><xsl:value-of select="//*/@xml:id"/>
           </xsl:variable>
       <xsl:variable name="canonName"><xsl:value-of select="//*[$xmlid]/*[1]"/></xsl:variable>
   <xsl:for-each select="$xmlid"> 
       <xsl:value-of select="$xmlid"/>
       <xsl:text>!!! &#x9;</xsl:text>
    
   <xsl:value-of select="$canonName/normalize-space()"/>
               <xsl:text>&#x9;</xsl:text>  
       <xsl:choose>
          <xsl:when test="($coll//body//*/@ref[tokenize(., '#') = $xmlid])[1]">
              
               
         <xsl:value-of select="$coll//body/ancestor::TEI//title"/>
               <xsl:text>&#x9;</xsl:text>
           </xsl:when>
           <xsl:otherwise/>
       </xsl:choose>
   </xsl:for-each>        
       
 
   </xsl:template>

    
   
   
</xsl:stylesheet>