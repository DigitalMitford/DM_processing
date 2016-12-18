xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare variable $uri := request:get-parameter("uri", "1819-05-30_Elford.xml");
declare variable $letterFileName := concat('/db/mitford/letters/',$uri);
let $letter := doc($letterFileName)/*
return transform:transform($letter, doc('/db/xslt/MitfordLetterTransformPHP.xsl'), ())