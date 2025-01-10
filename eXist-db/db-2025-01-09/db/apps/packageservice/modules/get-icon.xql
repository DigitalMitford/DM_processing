xquery version "3.1";


let $repo := request:get-parameter("package", ())
let $iconSvg := 
    (: TODO: Replace try-catch expression with repo:resource-available 
     : when https://github.com/eXist-db/exist/issues/3904 is resolved 
     :)
    try { repo:get-resource($repo, "icon.svg") } catch * { () }
return
if(exists($iconSvg))
then response:stream-binary($iconSvg, "image/svg+xml", ())
else (
	let $icon := 
        (: TODO: Replace try-catch expression with repo:resource-available 
         : when https://github.com/eXist-db/exist/issues/3904 is resolved 
         :)
        try { repo:get-resource($repo, "icon.png") } catch * { () }
    return response:stream-binary($icon, "image/png", ())
)