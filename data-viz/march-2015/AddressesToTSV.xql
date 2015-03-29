declare default element namespace "http://www.tei-c.org/ns/1.0";
let $mitfordLetters:=collection('letters/')
let $si:=doc('http://mitford.pitt.edu/si.xml')
let $address := $mitfordLetters//address
let $recip := $address/ancestor::TEI//titleStmt/title
let $distinctAddress := distinct-values($address)
let $countDA := count($distinctAddress)
for $a in $distinctAddress
let $addrLine := $address[. = $a]/addrLine
let $addrTitle := $recip[./ancestor::TEI//text//address[. = $a]]
let $elementIn := $addrLine/*
return ($addrTitle/normalize-space(string()), '&#x9;', 'Address: ', 
for $e in $elementIn
let $noRef := $e[not(@ref)]
let $Refel := $e[@ref]
let $elRefIn := ($si//*[@xml:id= tokenize($Refel/@ref, '#')[last()]]/*[not(. = person)] |  $si//*[@xml:id= tokenize($Refel/@ref, '#')[last()]]/*[. = person]/persName[1])[1]/normalize-space(string())

return ($e/normalize-space(string()), '&#x9;', '(SInote:', $elRefIn, ')', '&#x9;'),  '&#10;'

)