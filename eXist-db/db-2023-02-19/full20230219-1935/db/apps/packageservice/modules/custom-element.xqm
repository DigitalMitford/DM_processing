xquery version "3.1";

module namespace ce="http://exist-db.org/apps/custom-elements";

declare function ce:convert-to-custom-element($input as node(), $prefix as xs:string, $ignores as item()*) as node(){
    let $current-element-name := name($input)
    return
       (: we create a new element with a name and a content :)
       element
            {
                $prefix || $current-element-name
            }
            { (: the element content is created here :)
            $input/@*, (: copy all attributes :)
            for $child in $input/node()
                let $childname := name($child)
             return
                if ($child instance of element()) then
                    if(not($ignores = $childname)) then
                        ce:convert-to-custom-element($child, $prefix,$ignores)
                    else
                        $child
               else
                    $child
            }
};
