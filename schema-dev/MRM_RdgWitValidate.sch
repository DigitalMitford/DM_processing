<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>   
 
    <pattern>
        <rule context="tei:TEI//@ref | tei:TEI//@who | tei:TEI//@corresp | tei:TEI//@wit">
            <assert test="starts-with(., '#')">
                Attributes @ref, @who, @corresp and @wit must begin with a hashtag.
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="tei:TEI//@wit">
        <let name="tokens" value="for $w in tokenize(., '\s+') return substring-after($w, '#')"/>
            <assert test="every $token in $tokens satisfies $token = //tei:TEI//tei:listWit//@xml:id">
                Every reading witness (@wit) after the hashtag must match an xml:id defined in the list of witnesses in this file!
          </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="tei:TEI//@xml:id">
            <report test="matches(., '\s+')">
                @xml:id values may NOT contain white spaces!
            </report>        
        </rule>
    </pattern>
   
  
    
</schema>