xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare variable $mitford := collection ('/db/mitford');
declare variable $MissJames := $mitford//TEI//text//p//*[@ref="#James_Miss"];  
declare variable $ThisFileContent :=
<html>
    <head><title>Sample Co-Citation Counts from the Digital Mitford Project</title></head>
    <body>
        <table border='1'>
             <tr>
                <th>People</th>
                <th>Count</th>
                <th>URI</th>
            </tr>
         {
         let $MJpeople as attribute(ref)* := 
            $MissJames/ancestor::p//persName/@ref[not(. eq '#James_Miss')] | 
            $MissJames/ancestor::p//rs[@type="person"]/@ref[not(. eq '#James_Miss')]
         let $MJpeeps := distinct-values($MJpeople)
         
         let $stuff :=
             for $peep in $MJpeeps
             let $peepOccurrences :=
                $mitford//p[descendant::*[@ref eq '#James_Miss'] and descendant::*[@ref eq $peep]]/descendant::*[@ref eq $peep]
             let $peepCount := count($peepOccurrences)
             let $urls := for $url in distinct-values($peepOccurrences/tokenize(base-uri(),'/')[last()]) order by $url return $url
             order by $peepCount descending
             return 
                <tr>
                    <td>{$peep}</td>
                    <td>{count($peepOccurrences)}</td>
                    <td><ul>{for $url in $urls return <li>{$url}</li>}</ul></td>
                </tr>
         for $item in $stuff[position() lt 4]
         return $item
     }</table>
     <br/>
     <hr/>
     <br/>
     <table border='1'>
             <tr>
                <th>Titles of Publications or Works of Art</th>
                <th>Count</th>
                <th>URI</th>
            </tr>
         {
         let $MJtitles as attribute(ref)* := 
            $MissJames/ancestor::p//bibl/@corresp | 
            $MissJames/ancestor::p//title/@ref
         let $MJworks := distinct-values($MJtitles)
         
         let $stuff :=
             for $work in $MJworks
             let $workOccurrences :=
                $mitford//p[descendant::*[@ref eq '#James_Miss'] and descendant::*[@* eq $work]]/descendant::*[@* eq $work]
             let $workCount := count($workOccurrences)
             let $urls := for $url in distinct-values($workOccurrences/tokenize(base-uri(),'/')[last()]) order by $url return $url
             order by $workCount descending
             return 
                <tr>
                    <td>{$work}</td>
                    <td>{count($workOccurrences)}</td>
                    <td><ul>{for $url in $urls return <li>{$url}</li>}</ul></td>
                </tr>
         for $item in $stuff[position() lt 4]
         return $item
     }</table>
       <br/>
     <hr/>
     <br/>
     <table border='1'>
             <tr>
                <th>Places</th>
                <th>Count</th>
                <th>URI</th>
            </tr>
         {
         let $MJplaces as attribute(ref)* := 
            $MissJames/ancestor::p//placeName/@ref | 
            $MissJames/ancestor::p//rs[@type="place"]/@ref
         let $MJlocales := distinct-values($MJplaces)
         
         let $stuff :=
             for $locale in $MJlocales
             let $localeOccurrences :=
                $mitford//p[descendant::*[@ref eq '#James_Miss'] and descendant::*[@ref eq $locale]]/descendant::*[@ref eq $locale]
             let $localeCount := count($localeOccurrences)
             let $urls := for $url in distinct-values($localeOccurrences/tokenize(base-uri(),'/')[last()]) order by $url return $url
             order by $localeCount descending
             return 
                <tr>
                    <td>{$locale}</td>
                    <td>{count($localeOccurrences)}</td>
                    <td><ul>{for $url in $urls return <li>{$url}</li>}</ul></td>
                </tr>
         for $item in $stuff[position() lt 4]
         return $item
     }</table>
</body>
</html>;

let $filename := "tester.html"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent)
return $doc-db-uri


