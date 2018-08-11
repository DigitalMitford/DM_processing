<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/> 
<sch:pattern>
    <sch:p>Identify note elements that are longer than [TOO LONG!] number of characters so exceeding the flow-length of our note box. (How long is this?) Raise a warning or an error that p breaks need to be added.
        NOTE: WE NEED CORRESPONDING XSLT ALTERATION FOR NOTE BOXES TO READ 1st Paragraph ONLY.
    </sch:p>
</sch:pattern>    
<sch:pattern>
    <sch:p>Look for strings in note elements and label elements that might want/need to be tagged for cross-referencing. </sch:p>
</sch:pattern>
<sch:pattern>
    <sch:p>Identify stub entries.</sch:p>
    <sch:rule context="*[@xml:id]">
        <sch:report test="count(child::* eq 1)" role="warning">Warning: stub element. We should flesh this out and add more information.</sch:report>
    </sch:rule>
</sch:pattern>
<sch:pattern>
    <sch:rule context="tei:person[descendant::tei:surname = //tei:surname[not(ancestor::tei:person = self::tei:person)]]">
        <sch:let name="currentContext" value="."/>
        <sch:let name="sharedSurname" value="//tei:person[not(. = $currentContext)][descendant::tei:surname = $currentContext/descendant::tei:surname]"/>
        <sch:report test="descendant::tei:forename = $sharedSurname//tei:forename" role="warning">
           Warning! Is this a duplicate entry? The person represented in this entry shares a surname and a forename with one or more other entries: <sch:value-of select="string-join($sharedSurname[descendant::tei:forename = $currentContext//tei:forename]/@xml:id, ', ')"/>
        </sch:report>
    </sch:rule>
</sch:pattern>
    <sch:pattern>
        <sch:p>This rule [TO BE DEVELOPED] will test the plausibilty of birth dates in relation to death dates.</sch:p>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="@sex">
            <sch:report test="matches(., '[0-9,]')">
                We are no longer using the ISO numerical codes for sex, and this attribute may not contain commas. Change this code to a letter, one (or more) of the following approved values: m, f, m f, and u. If indicating multiple values, separate each with just a white space.
            </sch:report>
            
        </sch:rule>
        
    </sch:pattern>


    <sch:pattern>
        <sch:rule context="tei:text//@xml:id">
            <sch:report test="matches(., '\s+')">
                @xml:id values must not contain white spaces.
            </sch:report>   
            <sch:report test="starts-with(., '#')">
                @xml:id values must not begin with a hashtag.
            </sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="tei:text//tei:div/*">
            <sch:assert test="@sortKey = ('Mitford_Team', 'archives', 'Past_Assistants', 'Past_Editors', 'histOrgs', 'histPersons', 'fictOrgs', 'archOrgs', 'archPersons', 'fictPersons', 'histPlaces', 'fictPlaces', 'animals', 'plants', 'histEvents', 'art', 'ref_19thc', 'per_19thc', 'literary', 'MRM_Schol', 'other_current_Schol')">
                You must include an @sortKey on a list element, and it needs to be one of the legal values!
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="tei:TEI"> 
            <sch:assert test="count(distinct-values(//@sortKey)) eq count(//*[@sortKey])">
                There must not be any duplicate @sortkey values in the site index! 
            </sch:assert>
        </sch:rule>  
    </sch:pattern>
    <sch:pattern>
       <!-- <sch:let name="si" value="doc('http://digitalmitford.org/si.xml')//@xml:id"/> -->
        <sch:let name="si" value="doc('../si-local.xml')//@xml:id"/>
        <sch:let name="siAddcoll" value="collection('../../../DM_SiteIndex/si-Add-Files/catalogue.xml')//@xml:id"/>
        <sch:let name="siAll" value="($si, $siAddcoll)"/>
        <sch:rule context="@ref | @corresp | @resp">
            
            <sch:let name="tokens" value="for $w in tokenize(., '\s+') return substring-after($w, '#')"/>
            <sch:assert test="every $token in $tokens satisfies $token = //tei:text//@xml:id | $si">
                Did you begin your @ref or @corresp value with a hashtag? If that's not the problem, check that the attribute of @ref or @corresp (after the hasthtag, #) matches a defined @xml:id in the site index or siAdd files. 
            </sch:assert>                
        </sch:rule>
    </sch:pattern>      
    
    
</sch:schema>