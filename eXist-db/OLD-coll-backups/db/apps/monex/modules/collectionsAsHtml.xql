xquery version "3.0";

declare namespace browser="browser";
declare option exist:serialize "method=html media-type=text/html omit-xml-declaration=no indent=yes";


declare function browser:ls($collection as xs:string) as element()* {
  if (xmldb:collection-available($collection)) then
    (         
      for $child in xmldb:get-child-collections($collection)
        let $path := concat($collection, '/', $child)
        order by $child 
        return
            <option value="{$path}">{$child}</option>
    )
  else ()    
};

let $collection := request:get-parameter('coll', '/db/apps')
return
    <select id="collection" path="{$collection}">
        <option selected="true" value="/db/apps">all apps</option>
        <optgroup label="eXist Apps">
            {browser:ls($collection)}
        </optgroup>
    </select> 