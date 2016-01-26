<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>

<!--2016-01-24 ebb: This identity transformation is to move ref elements that are in the wrong place in a si-Add file.-->
    
    <xsl:strip-space elements="*"/>
    <!--ebb: This is needed to remove white space that will sit in place of the element tags we're about to remove. -->


    <xsl:mode on-no-match="shallow-copy"/>
 
  <xsl:template match="ref[not(parent::note)]">
      <note><ref target="{@target}"/></note>
      
  </xsl:template>

</xsl:stylesheet>
