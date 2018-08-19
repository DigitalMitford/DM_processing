xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
let $si := doc('/db/si.xml')/*
let $mitfordColl:=collection('/db/mitford/')/*
let $titles:= $mitfordColl/teiHeader//titleStmt/title
(:  :for $i in $titles
let $uri := tokenize($mitfordColl/base-uri(), "/")[last()]
return string-join((concat($i, $uri)), " &#x9;"):)
for $f in $mitfordColl
let $people := $f//text//persName/normalize-space(substring-after(@ref, '#'))
let $distinctPeeps := distinct-values($people)

for $p in $distinctPeeps
let $siPeep := $si//*[@xml:id = $p]
let $siName :=
               if ($siPeep/persName[1][not(surname)]) 
                              then $siPeep/persName[1]/normalize-space()
         else if ($siPeep/persName[1][surname]) 
                              then concat(string-join($siPeep/persName[1]/forename, ' '), ' ', string-join($siPeep/persName[1]/surname, ' '))
                              else if ($siPeep[not(. = persName)])
                              then concat($siPeep/@xml:id, "_stubEntry")
         else concat($p, "_notSI")
         
let $notsiPeep := $p[not(. = $si//*/@xml:id)] 
return $notsiPeep
