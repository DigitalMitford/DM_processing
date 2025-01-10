xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare variable $surname := request:get-parameter('surname', 'Mitford');
let $si := doc('http://digitalmitford.org/si.xml')
(:  :let $mitfordFiles:=collection('/db/mitford')/*  :)
let $match := $si//person[descendant::surname = $surname]
for $m in $match

return
    <ul>
    <li>{$m/persName[1]}</li>
   <li>{$m//note}</li>
   </ul>





 

