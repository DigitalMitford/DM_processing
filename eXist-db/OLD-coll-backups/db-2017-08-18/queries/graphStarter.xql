xquery version "3.0";
declare default element namespace "http://www.w3.org/2000/svg"; 
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $mitfordColl := collection ('/db/mitford');
declare variable $lettersColl := collection('/db/mitford/letters');
declare variable $literaryColl := collection('/db/mitford/literary');

let $literaryFiles := $literaryColl/*
let $litExceptOV := $literaryColl/*[descendant::tei:titleStmt/tei:title[not(contains(., "Our Village"))]]
let $countLitEOV := count($litExceptOV)
let $litTitles := $litExceptOV//tei:titleStmt/tei:title[1]
let $spacer := 10


for $lit in $litExceptOV
let $title := $lit//tei:titleStmt/tei:title[1]/string()
let $peeps := $lit//tei:body//tei:persName
let $distinctPeeps := distinct-values($peeps)
let $countdistinctPeeps := count($distinctPeeps)

return 
  

(:  :declare variable $ThisFileContent :=  :)

<svg width="{$countLitEOV * $spacer}" height="200">
    <g transform="translate(30, 200)">
 
 


</g>

</svg>

(:  ;

let $filename := "timeline.svg"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent)
return $doc-db-uri 
(: Output at http://dxcvm10.psc.edu:8080/exist/rest/db/output/timeline.svg :) 
 : :)


