xquery version "3.0";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html5";
declare option output:media-type "text/html";

let $mitfordColl:=collection('/db/mitford/letters')/*
let $letterYears := $mitfordColl//tei:sourceDesc/tei:msDesc//tei:head/tei:date/substring-before(@when, '-')
let $dletterYrs := distinct-values($letterYears)
for $dly in $dletterYrs
let $letterTitles := $mitfordColl//tei:sourceDesc/tei:msDesc//tei:head[tei:date[normalize-space(substring-before(@when, '-'))[string-length(.) gt 0] = $dly]]/ancestor::tei:teiHeader//tei:titleStmt/tei:title
where string-length(normalize-space($dly)) gt 0 
order by $dly
return 
    
    <li id="{$dly}" class="year">{$dly}
    <ul class="letterList">{
for $LT in $letterTitles
let $ld := $LT/ancestor::tei:teiHeader//tei:sourceDesc/tei:msDesc//tei:head/tei:date/normalize-space(@when)
order by $ld
return 
   <li class="letter"><a href="getLetterText.php?uri={tokenize($LT/base-uri(), '/')[last()]}">{$LT/normalize-space()}</a></li>
    }
        </ul>
    </li>





