<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="3.0">

    <xsl:mode on-no-match="shallow-copy"/>
    <!--2018-05-28 ebb: In the comments below, "singleton app" is what we need to deal with: an app that has only one rdg element inside. It's not highlighting variation effectively in our HTML transformation, so we need to expand its scope and give it another rdg to compare to.
    
   Currently, I am worried about how I'm processing the tvar parameter. In the latest iteration, elements preceding apps are being trimmed out but not ported in, so something's up with some params tunneling. -->
    <!--2018-05-28 ebb: This is mostly not working. I'm duplicating a bunch of perfectly good apps with double witnesses, and in the singleton apps, I am trimming words out but not patching them in. This might be salvagable, but maybe back to drawing board. -->
    <!--2018-05-27 ebb: This is an adaptation of the Rienzi ID transformation (made 2018-02-24), designed to solve a crit apparatus interface dilemma in the markup of the plays, when the <app> element does not contain a rdg witness for the manuscript edition, or does not represent all the witnesses. In adapting this for Charles 1, I'm adapting for a play with only TWO witnesses, EITHER of which might be missing in an app.
        
        
        Each XPath expression below denotes a particular condition.

1. There is only one witness present in the surrounding element. In this case, DO NOTHING. 

     //body//app[count(rdg) = 1][matches(preceding-sibling::text()[1], '^\s*$')][not(preceding-sibling::*[1]) and not(following-sibling::*[1])][matches(following-sibling::text()[1], '^\s*$')]
    -->

<!-- conditionPT (preceding text) 2. Text common to either witness is present as the first preceding-sibling of the app element. 
        
IN THIS CASE, tokenize the preceding-sibling text node on white space, and a) remove the last token in the sequence, b) put that token into an <rdg wit="{$unrepWit}">, AND c) add it to the start of each <rdg>.

//body//app[count(rdg) = 1][not(matches(preceding-sibling::text()[1], '^\s*$'))][not(preceding-sibling::*[1]) and not(following-sibling::*[1])][matches(following-sibling::text()[1], '^\s*$')]
    -->
       
<!-- 3. The MS text immediately preceding the app is held inside an element sibling of <app> (and the element sibling is NOT another <app>.
IN THIS CASE, remove the preceding-sibling element from outside the <app> and put it inside into a new <rdg wit="{$wit}">, and at the start of each of the other <rdg> elements.

//body//app[count(rdg) = 1][matches(preceding-sibling::text()[1], '^\s*$')][preceding-sibling::*[not(name()='app')][1]][matches(following-sibling::text()[1], '^\s{2,}$')]
    -->

<!-- 4. There is no preceding text common to either witness, either in text or wrapped in an element, ahead of the <app>, but there is a common text node immediately following the element. 
    IN THIS CASE, tokenize the following-sibling text node on white space, and a) remove the first token in the sequence, and b) put that token into a new <rdg wit="{$wit}"> AND inside each of the other rdg elements at the end.

//body//app[count(rdg) = 1][matches(preceding-sibling::text()[1], '^\s{2,}$')][not(preceding-sibling::*[1])][not(matches(following-sibling::text()[1], '^\s*$'))]
-->
     
<!--5. As with condition 4, there is no preceding MS text, either in text or wrapped in an element, ahead of the <app>, but there is a text wrapped in an element immediately following the <app>. This is the case four times in Rienzi:
IN THIS CASE, remove the following-sibling element from outside the <app> and add it to a new <rdg wit="{$wit}"> elements AND inside each of the rdg elements at the end.

//body//app[count(rdg) = 1][matches(preceding-sibling::text()[1], '^\s{2,}$')][not(preceding-sibling::*[1])][matches(following-sibling::text()[1], '^\s*$')][following-sibling::*[1]]

6. The witness contains only a <pb> element. In this case, transform so as to not reproduce the <app> but transform pb with its associated witness in this form (following Rienzi):
<pb edRef="#pubC1" n="vi"/>

//body//app[count(rdg) = 1]/rdg/pb[matches(preceding-sibling::text()[1], '^\s*$') and matches(following-sibling::text()[1], '^\s*$')]
 --> 
<xsl:variable name="wit">
    <xsl:for-each select="//listWit/witness/@xml:id">
        <xsl:value-of select="concat('#', current())"/>
    </xsl:for-each>
</xsl:variable>
    <xsl:variable name="wits">
        <xsl:value-of select="string-join($wit, '_')"/>
    </xsl:variable>
    
    <xsl:template match="body//app[count(rdg) = 1]">
        <xsl:param name="tVar" tunnel="yes"/> 
        <xsl:param name="AfterVar" tunnel="yes"/>
        <xsl:variable name="witnessValue" select="rdg/@wit"/>
        <xsl:variable name="unrepWit">
            <xsl:value-of select="for $i in //listWit/witness/@xml:id return $i[not(. = substring-after($witnessValue, '#'))]"/>
        </xsl:variable>
         <xsl:choose>  
             <!--Test 1: no text or elements fore or aft of the singleton app, AND it doesn't just contain a pb child. Just copy it over. -->
             <xsl:when test="matches(preceding-sibling::text()[1], '^\s*$') and not(preceding-sibling::*) and not(following-sibling::*) and matches(following-sibling::text()[1], '^\s*$') and not(rdg/pb[matches(preceding-sibling::text()[1], '^\s*$') and matches(following-sibling::text()[1], '^\s*$')])">
       <xsl:copy-of select="."/>         
             </xsl:when>
             <!--Test 2: There's text immediately ahead of the singleton app. -->
             <xsl:when test="not(matches(preceding-sibling::text()[1], '^\s*$')) and string-length($tVar) gt 0 and not(rdg/pb[matches(preceding-sibling::text()[1], '^\s*$') and matches(following-sibling::text()[1], '^\s*$')])">              
                <app>
               
                   <rdg wit="{$unrepWit}"><xsl:value-of select="$tVar"/></rdg>
              
<xsl:variable name="currWit">
       <xsl:value-of select="$tVar"/><xsl:value-of select="current()"/>
</xsl:variable>
                       <rdg wit="{rdg/@wit}">
                           <xsl:value-of select="$currWit"/><xsl:comment>I AM $currWit: <xsl:value-of select="$currWit"/></xsl:comment></rdg>  </app>
        </xsl:when>
 <!--Test 3: There is an element (that's neither a note nor an app) immediately preceding the singleton app. -->    
             <xsl:when test="matches(preceding-sibling::text()[1], '^\s*$') and preceding-sibling::*[1][not(name()='note') and not(name()='app')] and not(rdg/pb[matches(preceding-sibling::text()[1], '^\s*$') and matches(following-sibling::text()[1], '^\s*$')])">
                 
             <app>
                 <rdg wit="{$unrepWit}"><xsl:copy-of select="preceding-sibling::*[1]"/></rdg>    
                     
                  <rdg wit="{rdg/@wit}">
                         <xsl:copy-of select="parent::app/preceding-sibling::*[1]"/>
                             <xsl:value-of select="rdg"/>
                     </rdg>
             </app>
             </xsl:when>
             
             <!--Test 4: There's only text following the singleton app: -->                  <xsl:when test="matches(preceding-sibling::text()[1], '^\s{2,}$') and not(preceding-sibling::*) and following-sibling::node()[1] = text() and not(matches(following-sibling::text()[1], '^\s*$')) and string-length($AfterVar) gt 0 and not(rdg/pb[matches(preceding-sibling::text()[1], '^\s*$') and matches(following-sibling::text()[1], '^\s*$')])">
         <app>
              <rdg wit="{$unrepWit}">
                  <xsl:comment><xsl:text>I am the unrepresented witness: </xsl:text><xsl:value-of select="$unrepWit"/></xsl:comment>
                  <xsl:value-of select="$AfterVar"/></rdg>
         
                  <xsl:variable name="currWit">
                      <xsl:value-of select="current()"/><xsl:value-of select="$AfterVar"/>
                  </xsl:variable>
                  <xsl:comment>I AM $currWit: <xsl:value-of select="$currWit"/></xsl:comment>
                  <rdg wit="{current()/@wit}">
                      <xsl:value-of select="$currWit"/></rdg>
                     
          </app>    
             </xsl:when>
  <!--Test 5: There's a first following sibling element but no text after the singleton app. This should only fire in the event of no preceding text or element. -->           
             <xsl:when test="matches(following-sibling::text()[1], '^\s*$') and following-sibling::*[1][not(name()='note') and not(name()='app') and matches(preceding-sibling::text()[1], '^\s{2,}$') and not(preceding-sibling::*)] and not(rdg/pb[matches(preceding-sibling::text()[1], '^\s*$') and matches(following-sibling::text()[1], '^\s*$')])">
                 
                 <app>
                     <rdg wit="{$unrepWit}"><xsl:copy-of select="following-sibling::*[1]"/></rdg>
                             
                         <rdg wit="{rdg/@wit}">
                             <xsl:value-of select="rdg"/>                            <xsl:copy-of select="parent::app/following-sibling::*[1]"/>
                             
                         </rdg>
                 </app>
             </xsl:when>
             <!--Test 6: This looks for an rdg inside the singleton app and strips it of surrounding rdg and app elements. -->
             <xsl:when test="rdg/pb[matches(preceding-sibling::text()[1], '^\s*$') and matches(following-sibling::text()[1], '^\s*$')]">
       <xsl:apply-templates select="rdg/pb"/>                       
             </xsl:when>
     
         <xsl:otherwise>
               <xsl:comment>BLAAARRGH</xsl:comment> 
            </xsl:otherwise>
         </xsl:choose>
    </xsl:template>

<xsl:template match="rdg/pb">
    <pb edRef="{parent::rdg/@wit}" n="{@n}"/>
</xsl:template>
 
    <!--The next template rules create variables and tunneling parameters from text that precedes an app element that has only one rdg. The params are made available in the preceding template with the tests on the singelton app elements: they are used to add text into a new rdg wit, and divide around it. This next template creates variables and params from text that precedes an app element that has only one rdg. -->
    <xsl:template match="body//text()[not(matches(., '^\s*$')) and following-sibling::*[1][name() = 'app' and count(rdg) = 1] and not(preceding-sibling::*[1][name()='app'][not(count(rdg) = 1)])]">
        <xsl:variable name="tokenVar" select="tokenize(., '\s+')[last()]"/>
        <xsl:variable name="smallerString" select="substring-before(., $tokenVar)"/>
        
        <xsl:value-of select="$smallerString"/><xsl:apply-templates select="following-sibling::app[1]">
            
            <xsl:with-param name="tVar" select="$tokenVar"
                tunnel="yes"/>
            <xsl:with-param name="smString" select="$smallerString"
                tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>
   
    <!--Here it is the preceding-sibling::app that is the singleton. tokenAftVar means the token just after the variant app in question. It is tunneled into the apply-templates processing the first preceding-sibling::app, and the smaller string is sent around it. -->      
    <xsl:template match="body//text()[not(matches(., '^\s*$')) and preceding-sibling::*[1][name() = 'app' and count(rdg) = 1] and not(following-sibling::*[1][name()='app'][not(count(rdg) = 1)])]">
        <xsl:variable name="tokenAftVar" select="tokenize(., '\s+')[1]"/>
        <xsl:variable name="smallerAftString" select="substring-after(., $tokenAftVar)"/>
        
        <xsl:apply-templates select="preceding-sibling::app[1]">
            <xsl:with-param name="AfterVar" select="$tokenAftVar"
                tunnel="yes"/>
        </xsl:apply-templates>
        <xsl:value-of select="$smallerAftString"/>  
    </xsl:template>
<!-- Here we process an element (not a note or an app) with no text but white space between it and the singleton app. We simply remove it here so it isn't duplicated in processing inside and outside the app.-->      
    <xsl:template match="body//*[not(name()='note') and not(name()='app') and matches(following-sibling::text()[1], '^\s*$') and following-sibling::*[1][name()='app'][count(rdg) = 1]]"/>
    
    <!--This is the same as the above except it matches an element (not an app or note) and looks on the preceding-sibling:: axis and the first element it finds is a singleton app. This element, too, is suppressed.   -->
    <xsl:template match="body//*[not(name()='note') and not(name()='app') and matches(preceding-sibling::text()[1], '^\s*$') and preceding-sibling::*[1][name()='app'][count(rdg) = 1]]"/>

<!--This matches the special situation where there is a singleton app on either side of a text string. It divides that string in three parts and tunnels two of them into the appropriate xsl:apply-templates for the preceding and following singleton app siblings.-->
    <xsl:template match="body//text()[not(matches(., '^\s*$')) and preceding-sibling::*[1][name() = 'app' and count(rdg) = 1] and following-sibling::*[1][name() = 'app' and count(rdg) = 1]]">
        <xsl:variable name="tokenAftVar" select="tokenize(., '\s+')[1]"/>
        <xsl:variable name="smallerAftString" select="substring-after(., $tokenAftVar)"/>
        <xsl:variable name="tokenNextVar" select="tokenize(., '\s+')[last()]"/>
        <xsl:variable name="littleString" select="substring-before(., tokenize($tokenAftVar, '\s+')[last()])"/>
        
        <xsl:apply-templates select="preceding-sibling::app[1]">
            <xsl:with-param name="AfterVar" select="$tokenAftVar"
                tunnel="yes"/>
        </xsl:apply-templates>
        <xsl:value-of select="$littleString"/>
        <xsl:apply-templates select="following-sibling::app[1]">
        <xsl:with-param name="tVar" select="$tokenNextVar" tunnel="yes"/>
        </xsl:apply-templates>
        
    </xsl:template>
       
</xsl:stylesheet>