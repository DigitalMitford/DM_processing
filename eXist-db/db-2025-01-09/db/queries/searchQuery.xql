xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";
let $mitfordColl:=collection('/db/mitford/letters')/*
let $searchQuery := $mitfordColl//tei:text//*[@* = "#Nooth_C"]/parent::*
let $baseURI := $searchQuery ! base-uri()
return $searchQuery