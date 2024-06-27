xquery version "3.0";
declare default element namespace "http://www.w3.org/2000/svg"; 
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $mitfordColl := collection ('/db/mitford');
declare variable $lettersColl := collection('/db/mitford/letters');
declare variable $letterFiles := $lettersColl/*;
declare variable $countLetterFiles := count($letterFiles);
declare variable $letterDates := $lettersColl//tei:teiHeader//tei:msDesc//tei:head/tei:date/@when;
declare variable $letterYears := $letterDates/tokenize(string(), '-')[1];

declare variable $countLD := count($letterYears);
declare variable $distinctYears := distinct-values($letterYears);
declare variable $maxYear := xs:integer(max($distinctYears));
declare variable $minYear := xs:integer(min($distinctYears));
declare variable $yearSpan := $maxYear - $minYear;
declare variable $yearInterval := 365;
declare variable $timelineLength := $yearInterval * $yearSpan;
declare variable $countSizer := 25;

declare variable $HaydonLetters := $letterFiles[descendant::tei:titleStmt/tei:title/tei:persName/@ref="#Haydon"];
declare variable $HaydonDates :=$HaydonLetters//tei:teiHeader//tei:msDesc//tei:head/tei:date/@when/string();
declare variable $HaydonStartDate := min($HaydonDates);
declare variable $HaydonEndDate := max($HaydonDates);
declare variable $HaydonMinYear := xs:integer(tokenize($HaydonStartDate, '-')[1]);
declare variable $HaydonMaxYear := xs:integer(tokenize($HaydonEndDate, '-')[1]);
declare variable $HaydonStartYear := $HaydonMinYear - $minYear;
declare variable $HaydonEndYear := $HaydonMaxYear - $minYear;
declare variable $HaydonStartDays := xs:integer(format-date(xs:date($HaydonStartDate), '[d]'));
declare variable $HaydonEndDays := xs:integer(format-date(xs:date($HaydonEndDate), '[d]')); 
declare variable $HaydonStartVal := ($HaydonStartYear * 365) + $HaydonStartDays;
declare variable $HaydonEndVal := ($HaydonEndYear * 365) + $HaydonEndDays;

declare variable $ThisFileContent := 
<svg width="500" height="3000">
    <g transform="translate(30, 100)">
 
 <!--ebb: Timeline line!-->  
<line x1="105" x2="105" y1="0" y2="{$timelineLength}" style="stroke:coral;stroke-width:30;"/>

<!--ebb: Haydon line-->
<line x1 = "180" x2="180" y1="{$HaydonStartVal}" y2="{$HaydonEndVal}" style="stroke:green; stroke-width:15;"/>
<text x="200" y="{$HaydonStartVal}">First letter: {$HaydonStartDate}</text>
<text x="200" y="{$HaydonEndVal}">Last letter: {$HaydonEndDate}</text>
<text x="200" y="{$HaydonStartVal + 300}" transform="rotate(90, 200, {$HaydonStartVal + 300})">Haydon Correspondence
</text>

{
    for $i in (0 to $yearSpan)
    let $date := $i + $minYear
    let $matchLetters := $letterDates[xs:integer(tokenize(string(), '-')[1]) = $date]
    let $countLetters := count($matchLetters)
  
        return 

  <g>
    <!--ebb: horizontal hashmark for each year-->
  <line x1="80"  y1="{$i * 365}" x2="180" y2="{$i * 365}" style="stroke:black;"/>
    <text x="30" y="{$i * 365}">{$date}</text>
  
  <!--ebb: circles for letters count-->
  <circle cx="{105}" cy="{$i*365}" r="{$countLetters}" style="fill:white;stroke:black;"/>
  <text x="-25" y="{$i * 365 + 30}">Letters coded: {$countLetters}</text>
  </g>  
}



</g>

</svg>;

let $filename := "timeline.svg"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent)
return $doc-db-uri 
(: Output at http://dxcvm10.psc.edu:8080/exist/rest/db/output/timeline.svg :) 


