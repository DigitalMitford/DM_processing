declare default element namespace "http://www.tei-c.org/ns/1.0";
(: Goal: Want to grab contents of @ref attributes, and network based on who is addressed in the same files. We need plain text output for this, divided by tab separators:)
 (:Cardinality is an issue: when we tie things together, we need output of the same kind to be coordinated by its position, line-by-line.:)

let $mitfordColl:=collection('mitford')/*
(:When running XQuery in oXygen, you save a collection as a file folder on your local computer, 
open an XQuery document, and save it one directory ABOVE the directory you are querying. Then 
you basically make a relative file path one step down into the folder, as I did here. No slash marks.:)

let $si := doc('http://mitford.pitt.edu/si.xml')
(:This is for looking up values in the Mitford site index. I need to look up matching attribute values in my
site index, posted on the web. You can do that in XQuery! :)

let $titles:= $mitfordColl/teiHeader//titleStmt/title

for $f in $mitfordColl
let $people := $f//text//persName[substring-after(@ref, '#') = $si//*/@xml:id]/@ref
(:ebb: I added the predicate on persName in order to eliminate any persName elements with out-of-date @ref attributes. This way, the only output I'll get for people will be those that are currently signalled in the site index. The problem with this is, it's kind of a brittle solution for the time being to make sure I have good data for a network analysis. my output will be incomplete for referencing EVERY person we have marked, until our markup is up to date. To make sure my network analysis is based on good data, I need to make sure the pile of files I am querying is absolutely current and all its attribute values are up-to-date! On a big collaborative project, this can be a real challenge, and it's important to leave lots of notes and comments as reminders!:)
let $distinctPeeps := distinct-values($people)

for $p in $distinctPeeps
let $pSi := $si//*[@xml:id = substring-after($p, '#')]
let $pType := $pSi/ancestor::div/@type/string()
(:Node 1 in my network analysis is set by $p. Then $pType will be a set of descriptions on $p, to say what kind of node it is (historical person or fictional character, etc.) :)

let $filePeep:= $f[.//text//persName/@ref = $p]//titleStmt/title/normalize-space(string())
(:This variable, $filePeep, defines the Edges in my network analysis:)

let $otherPeeps := $f[.//text//persName/@ref = $p]//text//persName[not(@ref = $p)][substring-after(@ref, '#') = $si//*/@xml:id]/@ref
let $distOthers := distinct-values($otherPeeps)
for $o in $distOthers
(:This last taking of distinct-values() condenses my output one last time, so I eliminate duplicate references to the same other people in a letter. $o is Node 2 in my network analysis:)

let $oSi := $si//*[@xml:id = substring-after($o, '#')]
let $oType := $oSi/ancestor::div/@type/string() 
(:This makes me one last column of descriptors on node 2: defining whether these are historical characters or fictional people.:)

(:2014-11-15 ebb: The return statement below, with concat(string-join((*), *), "*") works consistently in XQuery 3.0 AND earlier versions. I was having problems with an earlier form of this return statement with a complex double-nested string-join argument. You can make double-nested string-join() returns in earlier versions of XQuery, but the cardinality of the output was an issue with the way I first set up mine, to distinguish between all the output in its entirety, and line-by-line output. concat with string-join() works best for this. :)

return 
concat(string-join((substring-after($p, "#"), $pType, $filePeep, substring-after($o, "#"), $oType), "&#x9;"), "&#10;")
 