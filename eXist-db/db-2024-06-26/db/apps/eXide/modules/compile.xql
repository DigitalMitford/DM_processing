xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";
(: For oXygen: declare option saxon:output "method=text"; :)
declare variable $mitfordColl := collection ('/db/mitford');
declare variable $lettersColl := collection('/db/mitford/letters');
declare variable $literaryColl := collection('/db/mitford/literary');
declare variable $sonnetsFile := doc('/db/mitford/literary/1827Sonnets_REV.xml');
declare variable $sonnetPoems := $sonnetsFile//tei:div[@type='section'];
(:   :for $s in $sonnetPoems
let $sNumber := $s/@n ! string()
let $filetype := "sonnet"
let $sTitle := $s//tei:head/tei:title ! normalize-space()
let $namedEnts := $s//*/@ref ! normalize-space() => distinct-values()
let $nameTags := $s//*[@ref] ! name() => distinct-values() :)

let $Ents := $sonnetPoems//tei:lg//@ref ! normalize-space() => distinct-values() => sort()
(:   :for $e in $Ents
   let $sonnets := $sonnetPoems[descendant::*/@ref ! normalize-space() = $e]
   let $sonnetNums := $sonnets/@n ! normalize-space() :)
   (: for $n in $sonnetNums :)
   let $lookupFiles := ($lettersColl)[descendant::*/@ref ! normalize-space() = $Ents]
   let $lookupURIs := $lookupFiles ! base-uri(.) 
   return $Ents
  
   (: return $e || '&#x9;' || $n ||  :)

