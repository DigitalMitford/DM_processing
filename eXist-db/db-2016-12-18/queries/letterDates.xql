xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
let $mitfordColl:=collection('/db/mitford/letters')/*
let $letterYears := $mitfordColl//sourceDesc/msDesc//head/date/substring-before(@when, '-')
let $dletterYrs := distinct-values($letterYears)
for $dly in $dletterYrs
where string-length(normalize-space($dly)) gt 0 
order by $dly
return 
    
    <li xmlns=""><a href="getLetterList.php?year={$dly}">{$dly}</a></li>





