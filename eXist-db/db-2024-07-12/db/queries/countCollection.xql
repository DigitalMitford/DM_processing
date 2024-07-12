xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
let $si:=doc('/db/si.xml')/*
let $mitfordColl:=collection('/db/mitford/')/*
let $mitfordLetters := collection('/db/mitford/letters/')/*
let $mitfordliterary := collection('/db/mitford/literary/')/*
return concat(count($mitfordColl), ', letters: ', count($mitfordLetters), ', literary: ', count($mitfordliterary))
