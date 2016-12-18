xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
(: Goal: Want to grab contents of @ref attributes, and network based on who is addressed in the same files. We need plain text output for this, divided by tab separators:)
 (:Cardinality is an issue! When we tie things together :)

declare variable $ThisFileContent:=

string-join(
let $si := doc('/db/si.xml')/*
let $mitfordColl:=collection('/db/mitford/')/*
let $titles:= $mitfordColl/teiHeader//titleStmt/title
for $f in $mitfordColl
let $people := $f//text//persName/substring-after(@ref, '#')
let $distinctPeeps := distinct-values($people)

for $p in $distinctPeeps
let $siPeep := $si//*[@xml:id = $p]
let $filePeep:= $f[.//text//persName/@ref=$p]
let $fileTitle: = $f[.//text//persName/@ref = $p]//titleStmt/title/normalize-space(string())



let $otherPeeps := $filePeep//text//persName[not(@ref = $p)]/substring-after(@ref, '#')
let $countOP := count($otherPeeps)
let $distOthers := distinct-values($otherPeeps)
for $o in $distOthers
(:This last taking of distinct-values() condenses my output one last time, so I eliminate duplicate references to the same other people in a letter. :)
return 
concat($p, "&#x9;", $fileTitle, "&#x9;", $o) ,"&#10;");

let $filename := "MRMPeepNet.tsv"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent, "text/plain")
return $doc-db-uri
(: output at :http://dxcvm10.psc.edu:8080/exist/rest/db/output/MRMPeepNet.tsv ) :)        
      




