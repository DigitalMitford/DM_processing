xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
(: Goal: Want to grab contents of @ref attributes, and network based on who is addressed in the same files. We need plain text output for this, divided by tab separators:)
 (:Cardinality may be an issue when we tie things together :)

declare variable $ThisFileContent:=

string-join(
let $si:=doc('/db/si.xml')/*
let $mitfordColl:=collection('/db/mitford/')/*

let $people := $mitfordColl//text//persName/@ref/string()

let $tokenPeople :=
    for $p in $people[contains(., ' ')]
    return $p

let $brokenTokenPeople := 
   for $TP in $tokenPeople
   where contains($TP, ' #')
    return tokenize(translate($TP, '#', ''), ' ')
let $distinctBTP := distinct-values($brokenTokenPeople)

let $snowflakes := $people[not(contains(., ' '))]
let $distinctSnowFlakes := distinct-values($snowflakes)  
let $cleanedupSnowFlakes:=
    for $DSF in $distinctSnowFlakes
     return translate($DSF, '#', '')
     
let $node1 := ($distinctBTP, $cleanedupSnowFlakes)

for $n1 in $node1

let $SIcondition := 
    if ($si//person/@xml:id = $n1) then "Match"
    else "No Match"

let $SIcat := 
    if ($si//person/@xml:id = $n1) then $si//person[@xml:id = $n1]/parent::*/@sortKey/string()
    else "No Match"
    
let $SIsex := 
    if ($si//person[@sex]/@xml:id = $n1) then $si//person[@xml:id = $n1]/@sex/string()
    else if ($si//person[not(@sex)]/@xml:id = $n1) then "missing @sex"
    else "No Match"
(:ebb: When Cytoscape imports these SI columns in its node table, it's building that node table from node 1 and node 2, and somehow not all nodes get a value for the SI columns here, though they appear with the TSV correlated to node 1. Would it be better to import this info in the context of node 2? Do *both* sets of nodes need it?:)
    
let $fileMatch := $mitfordColl[.//text//persName/@ref[substring-after(string(), '#') = $n1]]    
for $f in $fileMatch
let $fileTitle := $f//titleStmt/title[1]/normalize-space(string())

let $SIeditorScreen :=
    if ($f//text//persName[contains(@ref, $n1)][ancestor::note[not(contains(@resp, "MRM"))]]) then "EDITOR-NOTE"
    else if ($f//text//persName[contains(@ref, $n1)][ancestor::note[contains(@resp, "MRM")]]) then "MRM-NOTE"
    else "MAIN_TEXT"


let $otherPeople := $f//text//persName[not(contains(@ref, $n1))]/@ref/string()


let $tokenOtherPeople :=
    for $op in $otherPeople[contains(., ' ')]
    return $op

let $brokenTokenOtherPeople := 
   for $TOP in $tokenOtherPeople
   where contains($TOP, ' #')
    return tokenize(translate($TOP, '#', ''), ' ')
let $distinctBTOP := distinct-values($brokenTokenOtherPeople)

let $otherSnowFlakes := $otherPeople[not(contains(., ' '))]
let $distinctOtherSnowFlakes := distinct-values($otherSnowFlakes)  
let $cleanedupOtherSnowFlakes:=
    for $DOSF in $distinctOtherSnowFlakes
     return translate($DOSF, '#', '')
     
let $node2 := ($distinctBTOP, $cleanedupOtherSnowFlakes)
for $n2 in $node2
let $SIcondition_n2 := 
    if ($si//person/@xml:id = $n2) then "Match"
    else "No Match"

let $SIcat_n2 := 
    if ($si//person/@xml:id = $n2) then $si//person[@xml:id = $n2]/parent::*/@sortKey/string()
    else "No Match"
    
let $SIsex_n2 := 
    if ($si//person[@sex]/@xml:id = $n2) then $si//person[@xml:id = $n2]/@sex/string()
    else if ($si//person[not(@sex)]/@xml:id = $n2) then "missing @sex"
    else "No Match"

return concat($n1, "&#x9;", $SIcondition, "&#x9;", $SIcat, "&#x9;", $SIsex, "&#x9;", $fileTitle, "&#x9;", $SIeditorScreen, "&#x9;", $n2, "&#x9;", $SIcondition_n2, "&#x9;", $SIcat_n2, "&#x9;", $SIsex_n2), "&#10;")
;

let $filename := "MRMSocialNet.tsv"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent, "text/plain")
return $doc-db-uri
(: output at :http://dxcvm10.psc.edu:8080/exist/rest/db/output/MRMSocialNet.tsv ) :) 