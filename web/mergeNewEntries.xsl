<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>
    <!--2016-01-24 ebb: This stylesheet is designed to merge entries from a particular newEntriesFile into the existing site index, adding new entries into the appropriate lists,
    and updating old entries with new versions. When updating, it surrounds the original entries in comment tags, and uses serialize() to maintain the element structure of the original
    site index entry should we need it. Thanks to djb for valuable assistance while developing this. -->
    
    <!--2016-01-24 ebb: Add and alter the way we're sorting entries! -->
   
    <xsl:strip-space elements="*"/>
    <!--ebb: This is needed to remove white space that will sit in place of the element tags we're about to remove. -->
    <xsl:variable name="si" select="doc('si-Add-LMW.xml')"/>
    <xsl:variable name="siId" select="//@xml:id"/>
    <xsl:variable name="newEntriesFile" select="doc('si-Add_LMW_2.xml')"/>
    <xsl:variable name="newEntries" select="$newEntriesFile//*[@xml:id][not(@xml:id = $siId)]"/>
    <xsl:variable name="union" select="$si | $newEntriesFile"/>

    
    <xsl:template match="fileDesc" mode="teiHeader"> 
       <fileDesc>
           <xsl:copy-of select="//editionStmt/preceding-sibling::*"/>
           <editionStmt>
               <edition>
                   <xsl:text> Site Index for the Digital Mitford project. Date: </xsl:text>
                   <xsl:value-of select="current-dateTime()"/>
                   <xsl:text>. Extracted by Elisa Beshero-Bondar.
        Count of all @xml:ids in the current file: </xsl:text>
                   <xsl:value-of select="count($siId) + count($newEntries)"/>
                   <xsl:text>. First digital edition in TEI P5, launched on 19 August 2013.</xsl:text>
               </edition>
           </editionStmt>
           <xsl:copy-of select="//editionStmt/following-sibling::*"/>
      
       </fileDesc>
      
    </xsl:template>

    <xsl:template match="processing-instruction()">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="/">
      <xsl:apply-templates select="processing-instruction()"/>
        
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
     
           <teiHeader>
            <xsl:apply-templates select="$si//fileDesc" mode="teiHeader"/>
         <xsl:copy-of select="$si//fileDesc/following-sibling::*"/>
           </teiHeader>
           <text> <body><xsl:for-each-group select="$union//text//div" group-by="@type">
                <div type="{current-grouping-key()}">
                    <!-- now inside a <div> of a particular @type -->
                    <xsl:for-each-group select="current-group()/*" group-by="name()">
                        <xsl:element name="{current-grouping-key()}">
                            <!-- now inside a list of a particular sort -->
                            <xsl:for-each-group select="current-group()/*" group-by="@xml:id">
                                <xsl:choose>
                                    <xsl:when test="count(current-group()) gt 1">
                                        <xsl:comment>FLAG: ORIGINAL ENTRY <xsl:sequence exclude-result-prefixes="#all" select="serialize(current-group()[base-uri() = $si/base-uri()])" /></xsl:comment>
                                        <xsl:copy-of
                                            select="current-group()[base-uri() != $si/base-uri()]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="current-group()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:for-each-group>
                </div>
            </xsl:for-each-group></body></text>
        </TEI>
    </xsl:template>

    <!--  <xsl:template match="listPerson">
        <listPerson type="{@type}">
            <xsl:apply-templates select="person">
                <xsl:sort select="lower-case(@xml:id)"/>
            </xsl:apply-templates>
        </listPerson>
    </xsl:template>

    <xsl:template match="listOrg">
        <listOrg type="{@type}">
            <xsl:apply-templates select="org">
                <xsl:sort select="lower-case(@xml:id)"/>
            </xsl:apply-templates>
        </listOrg>
    </xsl:template>

    <xsl:template match="listPlace">
        <listPlace type="{@type}">
            <xsl:apply-templates select="place">
                <xsl:sort select="lower-case(@xml:id)"/>
            </xsl:apply-templates>
        </listPlace>
    </xsl:template>

    <xsl:template match="listEvent">
        <listEvent>
            <xsl:apply-templates select="event">
                <xsl:sort select="lower-case(@xml:id)"/>
            </xsl:apply-templates>
        </listEvent>
    </xsl:template>

    <xsl:template match="list[@type='art']">

        <list type="art">
            <item/>
            <xsl:apply-templates select="figure">
                <xsl:sort select="lower-case(@xml:id)"/>
            </xsl:apply-templates>
        </list>
    </xsl:template>

    <xsl:template match="listBibl">
       <listBibl type="{@type}">
            <xsl:apply-templates select="bibl">
                <xsl:sort select="lower-case(@xml:id)"/>
            </xsl:apply-templates>
       </listBibl>
    </xsl:template>
-->
</xsl:stylesheet>
