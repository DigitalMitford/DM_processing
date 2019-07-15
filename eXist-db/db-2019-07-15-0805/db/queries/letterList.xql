xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare variable $year := request:get-parameter('year', '1821');
let $mitfordLetters:=collection('/db/mitford/letters')/*
let $letterTitles := $mitfordLetters//sourceDesc/msDesc//head[date[normalize-space(substring-before(@when, '-'))[string-length(.) gt 0] = $year]]/ancestor::teiHeader//titleStmt/title
for $LT in $letterTitles
let $ld := $LT/ancestor::teiHeader//sourceDesc/msDesc//head/date/normalize-space(@when)
order by $ld
return 
   <li xmlns=""><a href="getLetterText.php?uri={tokenize($LT/base-uri(), '/')[last()]}">{$ld}: {$LT/normalize-space()}</a></li>









