xquery version "3.0";
let $mitfordColl:=collection('/db/mitford/')/*
let $refs := $mitfordColl//@ref
let $corresps := $mitfordColl//@corresp
let $whos := $mitfordColl//@who
let $Allrefs := ($refs | $corresps | $whos)
let $inputRef := "#Bayley"
for $i in $Allrefs
where $i = $inputRef
return 
    
   string-join(distinct-values($i/tokenize(base-uri(), '/')[last()]), ', ')

