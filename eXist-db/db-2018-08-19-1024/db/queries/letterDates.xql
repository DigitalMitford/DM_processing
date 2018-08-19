xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
let $mitfordColl:=collection('/db/mitford/letters')/*
let $letterYears := $mitfordColl//sourceDesc/msDesc//head/date/substring-before(@when, '-')
let $dletterYrs := distinct-values($letterYears)
for $dly in $dletterYrs
let $letterTitles := $mitfordColl//sourceDesc/msDesc//head[date[normalize-space(substring-before(@when, '-'))[string-length(.) gt 0] = $dly]]
where string-length(normalize-space($dly)) gt 0 
order by $dly
return 
    
    <li xmlns="" id="{$dly}" class="year">{$dly}
    <ul class="letterList">{
for $LT in $letterTitles
let $ld := $LT/ancestor::teiHeader//sourceDesc/msDesc//head/date/normalize-space(@when)
order by $ld
return 
   <li xmlns="" class="letter"><a href="getLetterText.php?uri={tokenize($LT/base-uri(), '/')[last()]}">{$LT/replace(.,'\W+$','')}</a></li>
    }
        </ul>
    </li>





