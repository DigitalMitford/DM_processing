xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace local = "http://newtfire.org";

declare variable $mitford := collection ('/db/mitford');
declare variable $MissJames := $mitford//TEI//text//p//*[@ref="#James_Miss"];  
declare function local:getRefsForCat($catNames as xs:string+, $refList as element()*) as element()*{
 $refList[local-name()=$catNames or @type=$catNames]   
    
};

declare variable $ThisFileContent :=
<html>
    <head><title>Top Three Categories of Co-Occurrence with Miss James from the Digital Mitford Project</title></head>
    <body>
        <table border='1'>
             <tr>
                <th>Co-occurrences</th>
                <th>Count</th>
                <th>URI</th>
            </tr>
         {
        let $MJcoCited := $MissJames/ancestor::p//*[@ref | @corresp] except $MissJames 
        let $coCitCatElNames := $MJcoCited[not(@type)]/name() 
        let $coCitCatRsTypes :=$MJcoCited[@type]/@type 
        let $Cats := distinct-values($coCitCatElNames | $coCitCatRsTypes)
    
    declare 
            
          
       (:  let $MJpeeps := distinct-values($MJpeople)
         let $countcoPers := count($MJcocitPeeps) :)
         
            (:ebb 2015-10-24: We need to get the rs @type to output the category of rs and group with these somehow. 
            If it's an rs @type="person" or persName, group these together as the same category and count them together. First of all, what are the various values of @type when it's in play? Where does @type contain a portion of another element's name? Group the @type="stringMatch" with the matching element, and count these together as belonging to the same category.
            :)
        
         let $stuff :=
             for $cat in $Cats
             let $catOccurrences :=
                $mitford//p[descendant::*[@ref eq '#James_Miss'] and descendant::*[name() eq $cat]]/descendant::*[name() eq $cat]
             let $catCount := count($catOccurrences)
             let $urls := for $url in distinct-values($catOccurrences/tokenize(base-uri(),'/')[last()]) order by $url return $url
             order by $catCount descending
             return 
                <tr>
                    <td>{$cat}</td>
                    <td>{count($catOccurrences)}</td>
                    <td><ul>{for $url in $urls return <li>{$url}</li>}</ul></td>
                </tr>
         for $item in $stuff[position() lt 4]
         return $item
     }</table>
     <br/>
     <hr/>
     <br/>
    
</body>
</html>;

let $filename := "coOccurs.html"
let $doc-db-uri := xmldb:store("/db/output", $filename, $ThisFileContent)
return $doc-db-uri


