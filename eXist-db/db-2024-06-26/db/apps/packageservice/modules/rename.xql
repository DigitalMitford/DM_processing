xquery version "3.1";

import module namespace packages="http://exist-db.org/apps/existdb-packages" at "packages.xqm";

declare function local:rename-elements($input as node(), $prefix as xs:string) as node() {
let $current-element-name := name($input)
return
   (: we create a new element with a name and a content :)
   element
        {
            'repo-' || $current-element-name
        }
        { (: the element content is created here :)
        $input/@*, (: copy all attributes :)
        for $child in $input/node()
         return
            if ($child instance of element())
               then local:rename-elements($child, $prefix)
               else $child
        }
};


let $pkgs := packages:public-repo-contents(())
let $prefix := "repo-"
return
    for $pkg in $pkgs
    return
        local:rename-elements($pkg, $prefix)
