xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
let $si:=doc('/db/si.xml')/*
let $mitfordColl:=collection('/db/mitford/')/*
let $mitfordLetters := collection('/db/mitford/letters/')/*
let $mitfordliterary := collection('/db/mitford/literary/')/*
(:  :return concat(count($mitfordColl), ', letters: ', count($mitfordLetters), ', literary: ', count($mitfordliterary)):)
let $searchResults := $mitfordLetters//body//p[ft:query(., 'Much Ado')]
for $sR in $searchResults
let $baseURI := $sR/tokenize(base-uri(), '/')[last()]
return $baseURI
