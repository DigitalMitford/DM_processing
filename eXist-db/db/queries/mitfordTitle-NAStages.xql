xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
(: Goal: Want to grab contents of @ref attributes, and network based on who is addressed in the same files. We need plain text output for this, divided by tab separators:)
 (:Cardinality may be an issue when we tie things together :)

declare variable $ThisFileContent:=

string-join(
let $si:=doc('/db/si.xml')/*
let $mitfordColl:=collection('/db/mitford/')/*

let $titles := ($mitfordColl//text//title/@ref/string(), $mitfordColl//text//bibl/@corresp/string())

let $tokenTitles :=
    for $t in $titles[contains(., ' ')]
    return $t

let $brokenTokenTitles := 
   for $TT in $tokenTitles
   where contains($TT, ' #')
    return tokenize(translate($TT, '#', ''), ' ')
let $distinctBTT := distinct-values($brokenTokenTitles)

let $snowflakes := $titles[not(contains(., ' '))]
let $distinctSnowFlakes := distinct-values($snowflakes)  
let $cleanedupSnowFlakes:=
    for $DSF in $distinctSnowFlakes
     return translate($DSF, '#', '')
     
let $node1 := ($distinctBTT, $cleanedupSnowFlakes)

for $n1 in $node1

let $SIcondition := 
    if ($si//*/@xml:id = $n1) then "Match"
    else "No Match"

let $SIcat := 
    if ($si//*/@xml:id = $n1) then $si//*[@xml:id = $n1]/parent::*/@sortKey/string()
    else "No Match"
    
let $SIdate := 
    if ($si//*[date/@when]/@xml:id = $n1) then $si//*[@xml:id = $n1]/date[1]/@sex/string()
    else if ($si//*[date[not(@when)]]/@xml:id = $n1) then $si//*[@xml:id = $n1]/date/string()
    else "No Match"
    
let $fileMatch := $mitfordColl[.//text//*/@*[substring-after(string(), '#') = $n1]]    
for $f in $fileMatch
let $fileTitle := $f//titleStmt/title[1]/normalize-space(string())

let $SIeditorScreen :=
    if ($f//text//*[contains(@*, $n1)][ancestor::note[not(contains(@resp, "MRM"))]]) then "EDITOR-NOTE"
    else if ($f//text//*[contains(@*, $n1)][ancestor::note[contains(@resp, "MRM")]]) then "MRM-NOTE"
    else "MAIN_TEXT"

let $otherTitles := ($f//text//title[not(contains(@ref, $n1))]/@ref/string(), $f//text//bibl[not(contains(@corresp, $n1))]/@corresp/string())

let $tokenOtherTitles :=
    for $ot in $otherTitles[contains(., ' ')]
    return $ot

let $brokenTokenOtherTitles := 
   for $TOT in $tokenOtherTitles
   where contains($TOT, ' #')
    return tokenize(translate($TOT, '#', ''), ' ')
let $distinctBTOT := distinct-values($brokenTokenOtherTitles)

let $otherSnowFlakes := $otherTitles[not(contains(., ' '))]
let $distinctOtherSnowFlakes := distinct-values($otherSnowFlakes)  
let $cleanedupOtherSnowFlakes:=
    for $DOSF in $distinctOtherSnowFlakes
     return translate($DOSF, '#', '')
     
let $node2 := ($distinctBTOT, $cleanedupOtherSnowFlakes)
for $n2 in $node2
let $SIcondition_n2 := 
    if ($si//*/@xml:id = $n2) then "Match"
    else "No Match"

let $SIcat_n2 := 
    if ($si//*/@xml:id = $n2) then $si//*[@xml:id = $n2]/parent::*/@sortKey/string()
    else "No Match"
    
let $SIdate_n2 := 
     if ($si//*[date/@when]/@xml:id = $n2) then $si//*[@xml:id = $n2]/date[1]/@sex/string()
    else if ($si//*[date[not(@when)]]/@xml:id = $n2) then $si//*[@xml:id = $n2]/date/string()
    else "No Match"

return concat($n1, "&#x9;", $SIcondition, "&#x9;", $SIcat, "&#x9;", $SIdate, "&#x9;", $fileTitle, "&#x9;", $SIeditorScreen, "&#x9;", $n2, "&#x9;", $SIcondition_n2, "&#x9;", $SIcat_n2, "&#x9;", $SIdate_n2), "&#10;")
;

let $filename := "MRMTitleNet.tsv"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent, "text/plain")
return $doc-db-uri
(: output at :http://dxcvm10.psc.edu:8080/exist/rest/db/output/MRMSocialNet.tsv ) :) 