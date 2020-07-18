xquery version "3.0";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $ThisFileContent :=
(: Output at http://digitalmitford.org:8899/exist/rest/db/output/TopTenPeople.html :)
<html>
<head><title>Top Ten Most Referenced People in the Digital Mitford Project</title></head>
<body>
    <table>
        <tr>
            <th>Person (@ref attribute)</th><th>Files</th>
            </tr>
        
{
let $coll := collection('/db/mitford')/*
let $docBodies := $coll//tei:body
let $docTitles := $coll//tei:teiHeader//tei:titleStmt/tei:title/string()
let $allPeeps := $docBodies//tei:persName/@ref/string()
let $distinctPeeps := distinct-values($allPeeps)
for $peep in $distinctPeeps
let $FilesHoldingPeep := $docBodies[.//tei:persName[@ref = $peep]]/tokenize(base-uri(), '/')[last()]
where count($FilesHoldingPeep) gt 15
order by count($FilesHoldingPeep) descending 
return 
    
    <tr>
        
        <td>{tokenize($peep, '#')[last()]}</td>
       <td>
           <table>
           {for $File in $FilesHoldingPeep
           return
               <tr>
               <td>{$File}</td>
               </tr>
           }
           </table>
       </td>
    
    </tr>
}

</table>
</body>
</html>;

let $filename := "TopTenPeople.html"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent)
return $doc-db-uri

