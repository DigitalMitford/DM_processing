declare default element namespace "http://www.tei-c.org/ns/1.0";
let $mitfordColl:=collection('mitford')/*
let $si := doc('http://mitford.pitt.edu/si.xml')
let $people := $mitfordColl//text//persName[substring-after(@ref, '#') = $si//*/@xml:id]/@ref
let $distinctPeeps := distinct-values($people)
for $p in $distinctPeeps
let $pSi := $si//*[@xml:id = substring-after($p, '#')]
let $pType := $pSi/ancestor::div/@type/string()
return concat(string-join((substring-after($p, "#"), $pType), "&#x9;"), "&#10;")
