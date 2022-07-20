xquery version "3.1";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare variable $ThisFileContent := 
string-join(
let $si := doc('https://digitalmitford.org/si.xml')/*
let $mitfordColl:=collection('/db/mitford/')/*
let $titles:= $mitfordColl/teiHeader//titleStmt/title
let $teamMembers := $si//div[@type='Mitford_Team']//person
let $editor := $teamMembers[@xml:id = "lmw"]
let $siEntriesByEditor := $si//*[@xml:id][descendant::*[contains(@resp, "#lmw")]]
let $siEntryTotal := $si//*[@xml:id] => count()
let $siEditorCount := $siEntriesByEditor => count()
let $SIstatementTally := concat("Lisa Wilson has contributed to ", $siEditorCount, " entries out of ", $siEntryTotal, " total entries in the Digital Mitford prosopography site index file.") 
let $percentage := $siEditorCount div $siEntryTotal * 100
let $filesIE := $mitfordColl[descendant::teiHeader//*[contains(@*, '#lmw')]]
let $titlesIE := $filesIE//titleStmt/title[1]
let $countTitlesIE := $titlesIE => count()
let $allTitlesCount := $titles => count()
let $allFilesStatementTally := concat("Lisa Wilson has contributed to ", $countTitlesIE, " files out of ", $allTitlesCount, " total filesin the Digital Mitford XML database collection.") 
let $titlesPercentage := $countTitlesIE div $allTitlesCount * 100
return $titlesIE ! string(), "&#10;") ;

let $filename := "lmwTitles.txt"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent, "text/plain")
return $doc-db-uri
(: output at :http://exist.digitalmitford.org/exist/rest/db/output/lmwTitles.txt ) :) 

       
      




