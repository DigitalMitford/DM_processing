xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare variable $mitford := collection ('/db/mitford');
let $rsTypes := $mitford//rs/@type
let $distinctrTypes := distinct-values($rsTypes)
for $dT in $distinctrTypes
let $match := $mitford//rs[@type eq $dT]
let $baseuri := distinct-values($match/tokenize(base-uri(), '/')[last()])
let $countmatch := count($match)
order by $countmatch descending
return concat($dT, ": ", $countmatch, ": ", string-join($baseuri, ', '), '.&#10;')