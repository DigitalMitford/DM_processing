<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="3.0">

    <xsl:mode on-no-match="shallow-copy"/>
 <!--2018-02-24 ebb: This is an effort to solve a crit apparatus interface dilemma with Rienzi, when the <app> element does not contain a rdg witness for the manuscript edition. Each XPath expression below denotes a particular condition:

1. The msR is simply not present in the surrounding element at all. The surrounding element is either <stage> or <l>. There is NO MS TEXT to compare with the other witnesses in this condition. This is the case 193 times in Rienzi. In this case, DO NOTHING. 

     //body//app[not(rdg[tokenize(@wit, ' ') = '#msR'])][matches(preceding-sibling::text()[1], '^\s*$')][not(preceding-sibling::*[1]) and not(following-sibling::*[1])][matches(following-sibling::text()[1], '^\s*$')]-->

<!-- conditionPT (preceding text) 2. MS text is present as the first preceding-sibling of the app element. (This is the case 97 times in Rienzi.)
IN THIS CASE, tokenize the preceding-sibling text node on white space, and a) remove the last token in the sequence, b) put that token into an <rdg wit="#msR">, AND c) add it to the start of each <rdg>.

//body//app[not(rdg[tokenize(@wit, ' ') = '#msR'])][not(matches(preceding-sibling::text()[1], '^\s*$'))][not(preceding-sibling::*[1]) and not(following-sibling::*[1])][matches(following-sibling::text()[1], '^\s*$')]-->
       
<!-- 3. The MS text immediately preceding the app is held inside an element sibling of <app>: (This is the case 25 times).
IN THIS CASE, remove the preceding-sibling element from outside the <app> and put it inside into a new <rdg wit="#msR">, and at the start of each of the other <rdg> elements.

//body//app[not(rdg[tokenize(@wit, ' ') = '#msR'])][matches(preceding-sibling::text()[1], '^\s*$')][preceding-sibling::*[1]][matches(following-sibling::text()[1], '^\s{2,}$')]-->

<!-- 4. There is no preceding MS text, either in text or wrapped in an element, ahead of the <app>, but there is a common text node immediately following the element. (This is the case 11 times in Rienzi.) IN THIS CASE, tokenize the following-sibling text node on white space, and a) remove the first token in the sequence, and b) put that token into a new <rdg wit="#msR"> AND inside each of the other rdg elements at the end.

//body//app[not(rdg[tokenize(@wit, ' ') = '#msR'])][matches(preceding-sibling::text()[1], '^\s{2,}$')][not(preceding-sibling::*[1])][not(matches(following-sibling::text()[1], '^\s*$'))]
-->
     
<!--5. As with condition 4, there is no preceding MS text, either in text or wrapped in an element, ahead of the <app>, but there is a text wrapped in an element immediately following the <app>. This is the case four times in Rienzi:
IN THIS CASE, remove the following-sibling element from outside the <app> and add it to a new <rdg wit="#msR"> elements AND inside each of the rdg elements at the end.

//body//app[not(rdg[tokenize(@wit, ' ') = '#msR'])][matches(preceding-sibling::text()[1], '^\s{2,}$')][not(preceding-sibling::*[1])][matches(following-sibling::text()[1], '^\s*$')][following-sibling::*[1]]

 --> 
    
    <xsl:template match="body//text()[not(matches(., '^\s*$'))][following-sibling::*[1][name() = 'app' and not(rdg[tokenize(@wit, ' ') = '#msR'])]]">
        <!--MS text is present as the first preceding-sibling of the app element. (This is the case **618** times in Rienzi.)
IN THIS CASE, tokenize the preceding-sibling text node on white space, and a) remove the last token in the sequence, b) put that token into an <rdg wit="#msR">, AND c) add it to the start of each <rdg>. -->

       <xsl:variable name="tokenVar" select="tokenize(., '\s+')[last()]"/>
        <xsl:variable name="smallerString" select="substring-before(., $tokenVar)"/>
        <xsl:value-of select="$smallerString"/>
        <xsl:apply-templates select="preceding-sibling::text()"/>
        <xsl:apply-templates select="following-sibling::app[1]">
        <xsl:with-param name="tVar" select="tokenize(., '\s+')[last()]"
            tunnel="yes"/>  
        </xsl:apply-templates>
    </xsl:template>
  
        <xsl:template match="body//app[preceding-sibling::text()[1][not(matches(., '^\s*$'))][following-sibling::*[1][name() = 'app' and not(rdg[tokenize(@wit, ' ') = '#msR'])]]]">
            <xsl:param name="tVar" tunnel="yes"/>
            
            <app>
            
            <xsl:for-each select="rdg">
                <rdg wit="{current()/@wit}"><xsl:value-of select="$tVar"/><xsl:copy-of select="current()"/></rdg>
            </xsl:for-each>
                <rdg wit="#msR"><xsl:value-of select="$tVar"/></rdg>  
            </app>
        </xsl:template> 
    
    
</xsl:stylesheet>