<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    <!--<xsl:strip-space elements="*"/>-->

    <xsl:variable name="witId" select="//listWit/witness/@xml:id"/>
        
    <xsl:template match="/">
        <html>
            <head>
                <title>Digital Mitford Dramas: Rienzi: Variation Analysis</title>
                <meta charset="UTF-8"/>
                <meta name="Description"
                    content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society."/>
                <meta name="keywords"
                    content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, TEI, Text Encoding Initiative, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar"/>
                <link rel="stylesheet" type="text/css" href="mitfordDramaVersion.css"/>
                <!--<script type="text/javascript" src="MRMLetters.js" xml:space="preserve">...</script>-->
                <script type="text/javascript" src="MRMLetters.js">/**/</script>
            </head>
            <body>

                <div id="title">
                    <h1>
                        <xsl:apply-templates select="//titleStmt/title"/>
                    </h1>
                    <hr/>
                </div>
                <div id="container">


                    <div id="witnessTable">
                        <h2>Legend</h2>
                        <table>
                            <tr>
                                <xsl:for-each select="//listWit/witness">
                                    <th>
                                        <xsl:apply-templates select="@xml:id"/>
                                    </th>
                                </xsl:for-each>
                            </tr>
                            <tr>
                                <xsl:for-each select="//listWit/witness">
                                    <td>
                                        <xsl:apply-templates/>
                                    </td>
                                </xsl:for-each>
                            </tr>

                        </table>
                    </div>
                    <hr/>

                    <table>
                        <tr>
                            <th>Location</th>
                            <xsl:for-each select="//listWit/witness">
                                <th>
                                    <xsl:apply-templates select="@xml:id"/>
                                </th>
                            </xsl:for-each>
                        </tr>

                        <xsl:apply-templates select="//app"/>
                    </table>
                </div>

            </body>
        </html>
    </xsl:template>
    <xsl:template match="app">
        <xsl:variable select="rdg" name="rdg"/>
        <tr>
            <td><xsl:value-of select="concat(ancestor::div[2][@type]/@type, ' ', ancestor::div[2][@n]/@n, ' ')"/>
                <xsl:value-of select="concat(ancestor::div[1]/@type, ' ', ancestor::div[1]/@n, ': ')"/>
                <xsl:value-of select="parent::*/parent::*/name()"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="parent::*/name()"/>
                <xsl:if test="parent::l">
                    <xsl:text> </xsl:text><xsl:value-of select="tokenize(parent::l/@xml:id, '_')[last()]"/>
                </xsl:if>
            </td>

            <xsl:for-each select="$witId"> 
                <td>
                    <xsl:variable name="string"><xsl:value-of select="$rdg[contains(@wit, current())]/normalize-space(string())"/>
                    </xsl:variable>
                    <xsl:value-of select="string-length($string)"/>
                    <xsl:if test="$rdg[contains(@wit, current())]/del"><xsl:text>, deleted: </xsl:text>
                        <xsl:variable name="delString"> <xsl:value-of select="$rdg[contains(@wit, current())]/del/normalize-space(string())"/>
                       </xsl:variable><xsl:value-of select="string-length($delString)"/>
                    </xsl:if>
                </td>
            </xsl:for-each>
               
      
        </tr>
    </xsl:template>



</xsl:stylesheet>
