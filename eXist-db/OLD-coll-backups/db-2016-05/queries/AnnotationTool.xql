xquery version "3.0";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace local = "http://newtfire.org";

declare variable $mitford := collection ('/db/mitford');
declare variable $MissJames := $mitford//tei:TEI//tei:text//tei:p//*[@ref="#James_Miss"];
(: Some "unknown knowns": #Byron, #Scott_Wal, #Austen_Jane, #Napoleon :)
(: Output at http://localhost:8080/exist/rest/db/output/AnnotationTool.html :)
declare variable $siteindexID := doc('/db/si.xml')//@xml:id;

(:ebb: Thanks to Martin Holmes for guidance with these functions. :)
declare function local:getRefsForCat($catNames as xs:string+, $refList as element()*, $label as xs:string) as element()
{element {$label}{
 $refList[local-name()=$catNames or @type=$catNames]  } 
}; 
declare function local:getTopThree($cats as element()+) as element()+ {
   let $count := count($cats/*)
   order by $count descending
    return $cats[position() lt 4]

};
declare function local:getTopThreeRefs($catResults as element()+, $treeMatches as element()+, $label as xs:string) as element()+
{element {$label}
{for $catResult at $pos in $catResults
let $names := distinct-values(($catResult//@ref, $catResult//@corresp))
(:  order by count($catResult//*) descending:) 
return 
  
    <table border="1" id="{$catResult/name()}">
    <th style="color:red;">{$catResult/name()}</th>
    <th style="color:red;">Canonical Name</th>
      <th style="color:red;"/> 
      <th style="color:red;">Alternative Names</th>
      <th style="color:red;">Project Files</th>
     {
    let $allofThem :=
     
      for $name in $names  
 let $nameMatch := $catResult//*[@* = $name]
 let $countMatch := count($nameMatch)
 (:let $sortSeq := for $n at $pos in $name
     order by $countMatch descending
     return $pos:)
 order by $countMatch descending 

return 
  
 <tr><td class="count">Count: {$countMatch}</td> 
     <!--<rect x="{$sortSeq + $spacerInner}" y="100" height="-{$countMatch}" width="3" style="fill:#cfc;"/>-->
      <!--$pos will currently cause the three rectangles to stack-->
  
       <td class="canonName">{$siteindexID[. = substring-after($name, '#')]/parent::*/*[1]/string()}</td>
       <td class="SInote">{$siteindexID[. = substring-after($name, '#')]/parent::*//note/string()}</td>
       <td class="altName">{string-join(distinct-values($nameMatch/string()), ', ')}</td>


 <td class="URI">{let $treeURI := for $treeMatch in $treeMatches
where $name eq ($treeMatch/@ref | $treeMatch/@corresp)
return $treeMatch/tokenize(base-uri(), '/')[last()]
    
    return string-join(distinct-values($treeURI), ', ')}
    
    </td>
         </tr>

     
     for $item in $allofThem[position() lt 4]
   return $item

     }
  </table> 
   
}


};
declare variable $ThisFileContent :=
<html>
    <head><title>Annotation Development Tool</title></head>
    <body>
<h1>Annotation Development Tool</h1>
<h2>Top Three Co-Cited Categories and Top Three Co-Cited Names Within Each Category</h2>
<!--<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">-->

        {
         let $MJcoCited := $MissJames/ancestor::tei:p//*[@ref | @corresp] except $MissJames 
        let $MJcoCitURLs := $MJcoCited/tokenize(base-uri(), '/')[last()]
      
       let $MJPersons := local:getRefsForCat(('persName', 'person'), $MJcoCited, 'people')
       let $MJOrgs := local:getRefsForCat(('orgName', 'org'), $MJcoCited, 'organizations')
       let $MJPlaces := local:getRefsForCat(('placeName', 'place'), $MJcoCited, 'places')
      let $MJTitles := local:getRefsForCat(('bibl', 'title', 'art', 'fict', 'song'), $MJcoCited, 'works')
      let $MJLetters := local:getRefsForCat(('letter'), $MJcoCited, 'letters')
      let $MJEvents := local:getRefsForCat(('event'), $MJcoCited, 'events')
      let $MJPlants := local:getRefsForCat(('plant'), $MJcoCited, 'plants')
      
      let $topThree := local:getTopThree(($MJPersons, $MJOrgs, $MJPlaces, $MJTitles, $MJLetters, $MJEvents, $MJPlants))
  
     let $topThreeRefs := local:getTopThreeRefs($topThree, $MJcoCited, 'g')
     return $topThreeRefs
        }
      <!-- </svg>-->
        </body>
        </html>;
    

let $filename := "AnnotationTool.html"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent)
return $doc-db-uri
 
    

