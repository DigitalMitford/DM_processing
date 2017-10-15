<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>   
    
   
    <pattern>
        <let name="si" value="doc('http://digitalmitford.org/si.xml')//@xml:id"/> 
       
            <rule context="@ref | @corresp | @resp">
                
                <let name="tokens" value="for $w in tokenize(., '\s+') return substring-after($w, '#')"/>
                <assert test="every $token in $tokens satisfies $token = //tei:text//@xml:id | $si">
                    The attribute of @ref or @corresp (after the hasthtag, #) must match a defined @xml:id in this file. 
                    And did you remember to start with a hashtag when pointing to an xml:id? 
                </assert>                
            </rule>
            
            
           <!-- <assert test="substring-after(., '#') = //tei:text//@xml:id | $si">
                
                The attribute of @ref or @corresp (after the hashtag, #) must match a defined @xml:id in this file or the main site index file.. 
            </assert>
         
            <assert test="starts-with(., '#')">
                The attribute values of @ref, @resp, and @corresp must start with a hashtag.
            </assert>
            -->  
    </pattern>
    <pattern>
        <rule context="@sex">
            <report test="matches(., '\d') or matches(., ',')">
                We are no longer using the ISO numerical codes for sex, and this attribute may not contain commas. Change this code to a letter, one (or more) of the following approved values: m, f, m f, and u. If indicating multiple values, separate each with just a white space.
            </report>
            
        </rule>
        
    </pattern>
    
    <pattern>
        <rule context="tei:text//@xml:id">
            <report test="matches(., '\s+')">
                @xml:id values may NOT contain white spaces!
            </report>   
           <report test="starts-with(., '#')">
               @xml:id values may NOT begin with a hashtag.
           </report>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="tei:text//tei:div/*">
            <assert test="@sortKey = ('Mitford_Team', 'archives', 'Past_Assistants', 'Past_Editors', 'histOrgs', 'histPersons', 'fictOrgs', 'archOrgs', 'archPersons', 'fictPersons', 'histPlaces', 'fictPlaces', 'animals', 'plants', 'histEvents', 'art', 'ref_19thc', 'per_19thc', 'literary', 'MRM_Schol', 'other_current_Schol')">
                You must include an @sortKey on a list element, and it needs to be one of the legal values!
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:TEI"> 
            <assert test="count(distinct-values(//@sortKey)) eq count(//*[@sortKey])">
                There must not be any duplicate @sortkey values in the site index! 
            </assert></rule>
        
    </pattern>
    
    
</schema>