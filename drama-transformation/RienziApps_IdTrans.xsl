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
    
    <xsl:template match="body//app[not(rdg[tokenize(@wit, ' ') = '#msR'])]">
        <xsl:param name="tVar" tunnel="yes"/> 
        <xsl:param name="AfterVar" tunnel="yes"/>
         <xsl:choose>  
             <xsl:when test="matches(preceding-sibling::text()[1], '^\s*$') and not(preceding-sibling::*) and not(following-sibling::*) and matches(following-sibling::text()[1], '^\s*$')">
       <xsl:copy-of select="."/>             
             </xsl:when>
             <xsl:when test="not(matches(preceding-sibling::text()[1], '^\s*$')) and string-length($tVar) gt 0">              
                <app>
               
                   <rdg wit="#msR"><xsl:value-of select="$tVar"/></rdg>
                    <xsl:for-each select="rdg">
                       <xsl:variable name="currWit">
                            <xsl:value-of select="$tVar"/><xsl:value-of select="current()"/>
                        </xsl:variable>
                        <xsl:comment>I AM $currWit: <xsl:value-of select="$currWit"/></xsl:comment>
                       <rdg wit="{current()/@wit}">
             <xsl:value-of select="$currWit"/></rdg>
                    </xsl:for-each>
                     
                </app>
            </xsl:when>
      <!-- <xsl:when test="matches(preceding-sibling::text()[1], '^\s*$') and preceding-sibling::*[1][name()='note' and not(matches(current()/preceding-sibling::text()[1], '^\s*$'))] and string-length($tVar) gt 0">  
                 <!-\-If there's a <note> just in front of the app -\->
                 
                 <app>
                     
                     <rdg wit="#msR"><xsl:value-of select="$tVar"/></rdg>
                     <xsl:for-each select="rdg">
                         <xsl:variable name="currWit">
                             <xsl:value-of select="$tVar"/><xsl:value-of select="current()"/>
                         </xsl:variable>
                         <xsl:comment>I AM $currWit: <xsl:value-of select="$currWit"/></xsl:comment>
                         <rdg wit="{current()/@wit}">
                             <xsl:value-of select="$currWit"/></rdg>
                     </xsl:for-each>
                     
                 </app>
             </xsl:when>-->
             <xsl:when test="matches(preceding-sibling::text()[1], '^\s*$') and preceding-sibling::*[1][not(name()='note')]">
                 
             <app>
                 <rdg wit="#msR"><xsl:copy-of select="preceding-sibling::*[1]"/></rdg>
                 <xsl:for-each select="rdg">
                     
                  <rdg wit="{current()/@wit}">
                         <xsl:copy-of select="parent::app/preceding-sibling::*[1]"/>
                             <xsl:value-of select="current()"/>
                     </rdg>
                 </xsl:for-each>
             </app>
             </xsl:when>
             <xsl:when test="matches(preceding-sibling::text()[1], '^\s{2,}$') and not(preceding-sibling::*) and not(matches(following-sibling::text()[1], '^\s*$')) and string-length($AfterVar) gt 0">
          <!--ebb: In other words, there's only text FOLLOWING this app --><app>
              <rdg wit="#msR"><xsl:value-of select="$AfterVar"/></rdg>
              <xsl:for-each select="rdg">
                  <xsl:variable name="currWit">
                      <xsl:value-of select="current()"/><xsl:value-of select="$AfterVar"/>
                  </xsl:variable>
                  <xsl:comment>I AM $currWit: <xsl:value-of select="$currWit"/></xsl:comment>
                  <rdg wit="{current()/@wit}">
                      <xsl:value-of select="$currWit"/></rdg>
              </xsl:for-each>       
          </app>    
             </xsl:when>
             <xsl:when test="matches(following-sibling::text()[1], '^\s*$') and following-sibling::*[1][not(name()='note')]">
                 
                 <app>
                     <rdg wit="#msR"><xsl:copy-of select="following-sibling::*[1]"/></rdg>
                     <xsl:for-each select="rdg">
                         
                         <rdg wit="{current()/@wit}">
                             <xsl:value-of select="current()"/>                            <xsl:copy-of select="parent::app/following-sibling::*[1]"/>
                             
                         </rdg>
                     </xsl:for-each>
                 </app>
             </xsl:when>
         <!-- <xsl:when test="matches(following-sibling::text()[1], '^\s*$') and following-sibling::*[1][name()='note' and not(matches(following-sibling::text()[1], '^\s*$'))] and string-length($AfterVar) gt 0">  
              <!-\-If there's a <note> just after the app -\-> 
                 
                 <app>
                     
                     <rdg wit="#msR"><xsl:value-of select="$AfterVar"/></rdg>
                     <xsl:for-each select="rdg">
                         <xsl:variable name="currWit">
                             <xsl:value-of select="current()"/><xsl:value-of select="$AfterVar"/>
                         </xsl:variable>
                         <xsl:comment>I AM $currWit: <xsl:value-of select="$currWit"/></xsl:comment>
                         <rdg wit="{current()/@wit}">
                             <xsl:value-of select="$currWit"/></rdg>
                     </xsl:for-each>
                     
                 </app>
             </xsl:when>-->
             
         <!--<xsl:otherwise>
                
            </xsl:otherwise>-->
         </xsl:choose>
    </xsl:template>
    
    <xsl:template match="body//text()[not(matches(., '^\s*$')) and following-sibling::*[1][name() = 'app' and not(rdg[tokenize(@wit, ' ') = '#msR'])] and not(preceding-sibling::*[1][name()='app'][not(rdg[tokenize(@wit, ' ') = '#msR'])])]">
        <xsl:variable name="tokenVar" select="tokenize(., '\s+')[last()]"/>
        <xsl:variable name="smallerString" select="substring-before(., $tokenVar)"/>
        
        <xsl:value-of select="$smallerString"/><xsl:apply-templates select="following-sibling::app[1]">
            
            <xsl:with-param name="tVar" select="$tokenVar"
                tunnel="yes"/>
            <xsl:with-param name="smString" select="$smallerString"
                tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>
    <!--processing around notes: -->
   <!-- <xsl:template match="body//text()[not(matches(., '^\s*$')) and following-sibling::*[1][name() = 'note' and following-sibling::text()[1][matches(., '^\s*$') and following-sibling::*[1][name()='app' and not(rdg[tokenize(@wit, ' ') = '#msR'])]]] and not(preceding-sibling::*[1][name()='app'][not(rdg[tokenize(@wit, ' ') = '#msR'])])]">
        <xsl:variable name="tokenVar" select="tokenize(., '\s+')[last()]"/>
        <xsl:variable name="smallerString" select="substring-before(., $tokenVar)"/>
        
        <xsl:value-of select="$smallerString"/><xsl:apply-templates select="following-sibling::app[1]">
            
            <xsl:with-param name="tVar" select="$tokenVar"
                tunnel="yes"/>
            <xsl:with-param name="smString" select="$smallerString"
                tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>-->
    
    
    
    <xsl:template match="body//text()[not(matches(., '^\s*$')) and preceding-sibling::*[1][name() = 'app' and not(rdg[tokenize(@wit, ' ') = '#msR'])] and not(following-sibling::*[1][name()='app'][not(rdg[tokenize(@wit, ' ') = '#msR'])])]">
        <xsl:variable name="tokenAftVar" select="tokenize(., '\s+')[1]"/>
        <xsl:variable name="smallerAftString" select="substring-after(., $tokenAftVar)"/>
        
        <xsl:apply-templates select="preceding-sibling::app[1]">
            <xsl:with-param name="AfterVar" select="$tokenAftVar"
                tunnel="yes"/>
        </xsl:apply-templates>
        <xsl:value-of select="$smallerAftString"/>
        <!--ebb: 
            YAY! I THINK I SOLVED THIS WITH THE NEXT TEMPLATE RULE
            THERE ARE 11 CASES WHERE APP NODES MISS #MSR AND HAVE NO PRECEDING TEXT. WHEN WE PROCESS THE TEXT NODES IN THIS RULE TO SHORTEN THEM AND TUCK THE FIRST WORD TOKEN INTO THE PRECEDING APP, WE RUN INTO A PROBLEM WHEN THE SAME TEXT NODE VARIES ON THE OTHER SIDE: THE APP IMMEDIATELY FOLLWING DOESN'T SEEM TO BE PROCESSED. THE FOLLOWING COUNTERMEASURE ISN'T WORKING TO SOLVE THE PROBLEM: DOESN'T SEEM TO DO ANYTHING: 
            <xsl:if test="following-sibling::*[1][name() = 'app' and not(rdg[tokenize(@wit, ' ') = '#msR'])]"><xsl:apply-templates select="following-sibling::app[1]"/></xsl:if>
          -->
        
    </xsl:template>
    <!--processing around notes: -->
   <!-- <xsl:template match="body//text()[not(matches(., '^\s*$')) and preceding-sibling::*[1][name() = 'note' and preceding-sibling::text()[1][matches(., '^\s*$') and preceding-sibling::*[1][name()='app' and not(rdg[tokenize(@wit, ' ') = '#msR'])]]] and not(following-sibling::*[1][name()='app'][not(rdg[tokenize(@wit, ' ') = '#msR'])])]">        
        <xsl:variable name="tokenAftVar" select="tokenize(., '\s+')[1]"/>
        <xsl:variable name="smallerAftString" select="substring-after(., $tokenAftVar)"/>
        
        <xsl:apply-templates select="preceding-sibling::app[1]">
            <xsl:with-param name="AfterVar" select="$tokenAftVar"
                tunnel="yes"/>
        </xsl:apply-templates>
        <xsl:value-of select="$smallerAftString"/>
    </xsl:template>-->
    
    
    
    <xsl:template match="body//*[not(name()='note') and not(name()='app') and matches(following-sibling::text()[1], '^\s*$') and following-sibling::*[1][name()='app'][not(rdg[tokenize(@wit, ' ') = '#msR'])]]"/>
    <xsl:template match="body//*[not(name()='note') and not(name()='app') and matches(preceding-sibling::text()[1], '^\s*$') and preceding-sibling::*[1][name()='app'][not(rdg[tokenize(@wit, ' ') = '#msR'])]]"/>
        
    <xsl:template match="body//text()[not(matches(., '^\s*$')) and preceding-sibling::*[1][name() = 'app' and not(rdg[tokenize(@wit, ' ') = '#msR'])] and following-sibling::*[1][name() = 'app' and not(rdg[tokenize(@wit, ' ') = '#msR'])]]">
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
     
     
     
   
<!--HEY!!! If there is a <note> ahead of an app (or following an app?), we need a special rule to process around it. Leave the note there, grab the preceding-sibling::text() last word, etc etc. -->     
    
    
</xsl:stylesheet>