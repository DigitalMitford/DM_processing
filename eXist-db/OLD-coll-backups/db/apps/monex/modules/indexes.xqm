xquery version "3.0";

(:
    Module: Browse Indexes: See an overview of .xconf files stored in /db/system/config, 
    and browse the associated index keys.
    
    TODO: remove legacy fulltext code when it has been cut out of eXist-db 2.0
:)

module namespace indexes="http://exist-db.org/xquery/admin-interface/indexes";

declare namespace cc="http://exist-db.org/collection-config/1.0";
declare namespace range="http://exist-db.org/xquery/range";


import module namespace console="http://exist-db.org/xquery/console" at "java:org.exist.console.xquery.ConsoleModule";
import module namespace templates="http://exist-db.org/xquery/templates";

(: 
    Global variables - derived from URL parameters
:)
declare variable $indexes:start-value := 
    request:get-parameter('start-value', '');
declare variable $indexes:callback := indexes:term-callback#2;
declare variable $indexes:max-number-returned := xs:integer(request:get-parameter('max', 100));
declare variable $indexes:index := request:get-parameter('index', '');
declare variable $indexes:sortby := request:get-parameter('sortby', 'term');
declare variable $indexes:sortorder := request:get-parameter('sortorder', 'ascending');
declare variable $indexes:node-name := request:get-parameter('node-name', '');
declare variable $indexes:field := request:get-parameter("field", "");
declare variable $indexes:match := request:get-parameter('match', '');
declare variable $indexes:collection := request:get-parameter('collection', '');
declare variable $indexes:node-set := 
    if ($indexes:node-name ne '' and $indexes:collection ne '') then 
        indexes:get-nodeset-from-qname($indexes:collection, $indexes:node-name) 
    else if ($indexes:match ne '' and $indexes:collection ne '') then 
        indexes:get-nodeset-from-match($indexes:collection, $indexes:match) 
    else 
        ();
declare variable $indexes:qname := 
    if ($indexes:node-name ne '') then 
        if (not(matches($indexes:node-name, 'xml:')) and contains($indexes:node-name, ':')) then
            QName(indexes:get-namespace-uri-from-node-name($indexes:node-name, $indexes:collection), $indexes:node-name) 
        else 
            xs:QName($indexes:node-name)
    else ();
declare variable $indexes:show-keys-by := request:get-parameter('show-keys-by', '');
declare variable $indexes:index-names :=
    <code-table>
        <name>Index Types</name>
        <description>This is the list of known index types and their labels.</description>
        <items>
            <item>
                <label>Lucene</label>
                <value>lucene-index</value>        
            </item>
            <item>
                <label>NGram</label>
                <value>ngram-index</value>
            </item>
            <item>
                <label>Range</label>
                <value>range-index</value>
            </item>
            <item>
                <label>New Range</label>
                <value>new-range-index</value>
            </item>
            <item>
                <label>Legacy Fulltext</label>
                <value>legacy-fulltext-index</value>
            </item>
        </items>
    </code-table>;

declare variable $indexes:range-lookup := 
    (
        function-lookup(xs:QName("range:index-keys-for-field"), 4),
        function-lookup(xs:QName("range:index-keys-for-field"), 3)
    )[1];

(:
    Main function: outputs the page.
:)
declare function indexes:summary($node as node(), $model as map(*)) {
    let $xconfs := collection('/db/system/config/')/cc:collection[cc:index][ends-with(util:document-name(.), '.xconf')]
    return
        if (empty($xconfs)) then
            <p>No Index Configurations were found in the /db/system/config collection.</p>
        else
            (
            <p>Found index configurations for {count($xconfs)} collections:</p>,
            <ol>{
                for $xconf in $xconfs
                let $xconf-collection-name := util:collection-name($xconf)
                let $data-collection-name := substring-after(util:collection-name($xconf), '/db/system/config')
                order by $xconf-collection-name
                return
                    <li><a href="collection.html?collection={$data-collection-name}">{$data-collection-name}</a></li>
            }</ol>
            )
};

declare
    %templates:wrap
function indexes:current-collection($node as node(), $model as map(*)) {
    <a href="collection.html?collection={$indexes:collection}">{$indexes:collection}</a>
};

declare
    %templates:wrap
function indexes:current-index($node as node(), $model as map(*)) {
    indexes:index-name-to-label($indexes:index) || " Index on " || ($indexes:node-name, $indexes:match)[1]
};

(:
    Transforms an index definition into an HTML table.
:)
declare function indexes:xconf-to-table($node as node(), $model as map(*)) as item()* {
    let $data-collection-name := $indexes:collection
    let $xconf-collection-name := concat('/db/system/config', $data-collection-name)
    let $xconf := collection('/db/system/config')/cc:collection[util:collection-name(.) = $xconf-collection-name]
    let $resource := $xconf-collection-name || '/' || xmldb:get-child-resources($xconf-collection-name)[ends-with(., '.xconf')]
    let $link := templates:link-to-app("http://exist-db.org/apps/eXide", "index.html?open=" || $resource)
    return
        <div>
            <h1>Index Configuration for {$data-collection-name}</h1>
            <p>
                <a href="{$link}" target="eXide" class="eXide-open" data-exide-open="{$resource}">Open .xconf file in eXide</a>
            </p>
            {if (xmldb:collection-available($data-collection-name)) then () else <p>(no data)</p>}
            <table class="table table-bordered browse" cellpadding="2">
                <tr>
                    <th>Item Indexed</th>
                    <th>Index</th>
                    <!--th>Instances</th-->
                    <th>Show Index Keys By</th>
                </tr>
                {
                for $entry in ( indexes:analyze-legacy-fulltext-indexes($xconf),
                    indexes:analyze-lucene-indexes($xconf),
                    indexes:analyze-range-indexes($xconf),
                    indexes:analyze-ngram-indexes($xconf),
                    if (exists($indexes:range-lookup)) then (
                        indexes:analyze-new-range-indexes($xconf),
                        indexes:analyze-new-range-index-fields($xconf)
                    ) else
                        ()
                )
                let $item := $entry/td[1]
                let $index := $entry/td[2]
                (: order by $index, $item :)
                return $entry
                }
            </table>
        </div>
};

(:
    Shows the index keys on a given nodeset or QName
:)
declare function indexes:show-index-keys($node as node(), $model as map(*)) {
    let $query-start-time := util:system-time()
    let $keys := 
        (: legacy fulltext index use the text:index-terms() function :)
        if ($indexes:index eq 'legacy-fulltext-index') then
            text:index-terms($indexes:node-set, $indexes:start-value, $indexes:callback, $indexes:max-number-returned)
        (: range indexes can use util:index-keys() without specifying the index :)
        else if ($indexes:index eq 'range-index') then
            if (util:index-type($indexes:node-set) eq 'xs:string') then 
                util:index-keys($indexes:node-set, $indexes:start-value, $indexes:callback, $indexes:max-number-returned)
            else 
                let $start-value := 
                    if (util:index-type($indexes:node-set) eq 'xs:double') then 
                        if ($indexes:start-value castable as xs:double) then xs:double($indexes:start-value) else xs:double(0)
                    else if (util:index-type($indexes:node-set) eq 'xs:float') then 
                        if ($indexes:start-value castable as xs:float) then xs:float($indexes:start-value) else xs:float(0)
                    else if (util:index-type($indexes:node-set) eq 'xs:decimal') then 
                        if ($indexes:start-value castable as xs:decimal) then xs:decimal($indexes:start-value) else xs:decimal(0)
                    else if (util:index-type($indexes:node-set) eq 'xs:boolean') then 
                        if ($indexes:start-value castable as xs:boolean) then xs:boolean($indexes:start-value) else xs:boolean(0)
                    else if (util:index-type($indexes:node-set) eq 'xs:dateTime') then 
                        if ($indexes:start-value castable as xs:dateTime) then xs:dateTime($indexes:start-value) else xs:dateTime('0001-01-01T00:00:00-00:00')                  
                    else if (util:index-type($indexes:node-set) eq 'xs:date') then 
                        if ($indexes:start-value castable as xs:date) then xs:date($indexes:start-value) else xs:date('0001-01-01')                  
                    else 
                        if ($indexes:start-value castable as xs:integer) then xs:integer($indexes:start-value) 
                    else 0
                return util:index-keys($indexes:node-set, $start-value, $indexes:callback, $indexes:max-number-returned)
        (: all other indexes need to specify the index in the 5th parameter of util:index-keys() :)
        else
            let $index := if ($indexes:index = "new-range-index") then "range-index" else $indexes:index
            let $log := console:log("start-value: " || $indexes:start-value)
            return
                switch ($indexes:show-keys-by)
                    case "field" return
                        if (function-arity($indexes:range-lookup) = 4) then
                            collection($indexes:collection)/$indexes:range-lookup($indexes:field, $indexes:start-value, $indexes:callback, 
                                $indexes:max-number-returned)
                        else
                            collection($indexes:collection)/$indexes:range-lookup($indexes:field, $indexes:callback, $indexes:max-number-returned)
                    case "node" return
                        util:index-keys($indexes:node-set, $indexes:start-value, $indexes:callback, $indexes:max-number-returned, $index)
                    default return
                        util:index-keys-by-qname($indexes:qname, $indexes:start-value, $indexes:callback, $indexes:max-number-returned, $index)
    let $log := util:log("DEBUG", concat("INDEXES index type:    ", $indexes:index))
    let $log := util:log("DEBUG", concat("INDEXES qname     :    ", $indexes:qname))
    
    (:  Reminder for sorting:
           term = $key/td[1]
           frequency := xs:integer($key/td[2])
           documents := xs:integer($key/td[3])
           position := xs:integer($key/td[4])
    :)
    
    let $sorted-keys :=
        if ($indexes:sortby eq 'term') then 
            if ($indexes:sortorder eq 'ascending') then
                for $key in $keys order by $key/td[1] ascending return $key
            else
                for $key in $keys order by $key/td[1] descending return $key
        else if ($indexes:sortby eq 'frequency') then 
            if ($indexes:sortorder eq 'ascending') then
                for $key in $keys order by xs:integer($key/td[2]) ascending, $key/td[1] ascending return $key
            else
                for $key in $keys order by xs:integer($key/td[2]) descending, $key/td[1] ascending return $key
        else if ($indexes:sortby eq 'documents') then 
            if ($indexes:sortorder eq 'ascending') then
                for $key in $keys order by xs:integer($key/td[3]) ascending, $key/td[1] ascending return $key
            else
                for $key in $keys order by xs:integer($key/td[3]) descending, $key/td[1] ascending return $key
        else if ($indexes:sortby eq 'position') then 
            if ($indexes:sortorder eq 'ascending') then
                for $key in $keys order by xs:integer($key/td[4]) ascending return $key
            else
                for $key in $keys order by xs:integer($key/td[4]) descending return $key
        else $keys
    
    let $query-end-time := util:system-time()
    let $query-duration := ($query-end-time - $query-start-time) div xs:dayTimeDuration('PT1S')

    return
    
        <div>
            <h1>{indexes:index-name-to-label($indexes:index)} Index on {($indexes:field, $indexes:node-name, $indexes:match)[1]}</h1>
            <p>{count($keys)} keys returned in {$query-duration}s</p>
            <p>Keys for the {indexes:index-name-to-label($indexes:index)} index defined on "{string-join(($indexes:field, $indexes:node-name, $indexes:match), '')}" in the <a href="{concat('collection.html?collection=', $indexes:collection)}">{$indexes:collection}</a> collection, by {$indexes:show-keys-by}.</p>
            <form method="get" class="form-horizontal" action="{indexes:remove-parameter-names('start-value')}" role="form">
                <div class="form-group">
                    <label for="max" class="col-sm-2 control-label">Max number returned:</label>
                    <div class="col-sm-4">
                        <select id="max" name="max" class="form-control">{
                            for $number in (10, 100, 1000, 10000)
                            return
                                <option value="{$number}">{if ($number eq $indexes:max-number-returned) then attribute selected {'selected'} else ()}{$number}</option>
                        }</select>
                    </div>
                </div>                
                <div class="form-group">
                    <label class="col-sm-2 control-label" for="start-value">Find terms starting with:</label>
                    <div class="col-sm-4">
                        <span class="input-group">
                            <input id="start-value" name="start-value" type="text" class="form-control" value="{$indexes:start-value}"/>
                            {
                                if ($indexes:start-value ne '') then 
                                    <span class="input-group-btn">
                                        <a href="{indexes:remove-parameter-names('start-value')}" class="btn btn-default" title="Clear search">
                                            <span class="glyphicon glyphicon-remove-circle"/>
                                        </a> 
                                    </span>
                                else 
                                    ()
                            }
                            <span class="input-group-btn">
                                <button type="submit" class="btn btn-primary" title="Submit">
                                    <span class="glyphicon glyphicon-search"/></button>
                            </span>
                        </span>
                        {
                        for $param in request:get-parameter-names()[not(. = ('max', 'start-value'))]
                        return 
                            <input type="hidden" id="{$param}" name="{$param}" value="{request:get-parameter($param, '')}"/>
                        }
                    </div>
                </div>
            </form>
            <table class="table table-bordered table-striped">
                <tr>{
                    for $column in ('term', 'frequency', 'documents', 'position')
                    return
                        <th><a href="{indexes:set-sortorder($column)}">{$column} {indexes:sort-direction-indicator($column)}</a></th>
                }</tr>
                { $sorted-keys }
            </table>
        </div>
};

(:
    Helper function: Callback function called used in indexes:show-index-keys() for util:index-keys()
:)
declare function indexes:term-callback($term as xs:string, $data as xs:int+) as element() {
    <tr>
        <td>{$term}</td>
        <td>{$data[1]}</td>
        <td>{$data[2]}</td>
        <td>{$data[3]}</td>
    </tr>
};

(:
    Analyzes the Lucene indexes in an index definition
:)
declare function indexes:analyze-lucene-indexes($xconf) {
    let $index-label := indexes:index-name-to-label('lucene-index')
    let $lucene := $xconf/cc:index/cc:lucene 
    return if (not($lucene) or not($lucene/cc:text)) then () else 
        (
        (: TODO: complete report of default/other Lucene analyzers :)
        (:let $analyzers := $lucene/cc:analyzer
        return 
            if ($analyzers) then 
                (
                <tr colspan="2"><td>Lucene Analyzers</td></tr>
                ,
                for $node in $analyzers
                return
                    if (not($node/@id)) then
                        <tr colspan="2"><td><em>default:</em> {concat(' ', $node/@class/string())}</td></tr>
                    else
                        <tr colspan="2"><td><strong>{$node/@id/string()}:</strong> {concat(' ', $node/@class/string())}</td></tr>
                )
            else ()
        ,:)
        let $texts := $lucene//cc:text
        return
            (
            for $text in $texts
            let $qname := if ($text/@qname) then $text/@qname/string() else ()
            let $match := if ($text/@match) then $text/@match/string() else ()
            let $analyzer := if ($text/@analyzer) then $text/@analyzer/string() else ()
            let $collection := substring-after(util:collection-name($text), '/db/system/config')
(:            let $nodeset := if ($qname) then indexes:get-nodeset-from-qname($collection, $qname) else indexes:get-nodeset-from-match($collection, $match):)
            return
                <tr>
                    <td>
                        {if ($qname) then $qname else $match} 
                        {if ($text/@boost) then concat(' (boost: ', $text/@boost/string(), ')') else ()}
                        {if ($text/cc:ignore) then (<br/>, concat('(ignore: ', string-join(for $ignore in $text/cc:ignore return $ignore/@qname/string(), ', '), ')')) else ()}</td>
                    <td>{$index-label} {if ($qname) then ' QName' else ' Match'} {if ($analyzer) then concat(' (', $analyzer, ')') else ' (default analyzer)' (: TODO: complete report of default/other Lucene analyzers :)}</td>
                    <!--td>{count($nodeset)}</td-->
                    <td>{
(:                        if (empty($nodeset)) then ():)
(:                        else:)
                            (
                            <a href="index-keys.html{indexes:replace-parameters((
                                if ($qname) then concat('node-name=', $qname) else concat('match=', $match)
                                , 
                                concat('collection=', $collection)
                                ,
                                'index=lucene-index'
                                ,
                                'show-keys-by=qname'
                            ))}">QName</a>
                            , 
                            ', '
                            ,
                            <a href="index-keys.html{indexes:replace-parameters((
                                if ($qname) then concat('node-name=', $qname) else concat('match=', $match)
                                , 
                                concat('collection=', $collection)
                                ,
                                'index=lucene-index'
                                ,
                                'show-keys-by=node'
                            ))}">Node</a>
                            )
                    }</td>
                </tr>
            )
        )
};

(:
    Analyzes the legacy fulltext indexes in an index definition
:)
declare function indexes:analyze-legacy-fulltext-indexes($xconf) {
    let $collection := substring-after(util:collection-name($xconf), '/db/system/config')
    let $index := 'legacy-fulltext-index'
    let $index-label := indexes:index-name-to-label($index)
    let $fulltext := $xconf/cc:index/cc:fulltext
    let $creates := $fulltext/cc:create
    let $default-none := $fulltext/@default eq 'none'
    let $attributes-none := $fulltext/@attributes eq 'false'
    
    let $no-fulltext := if ( not($fulltext) or ($default-none and $attributes-none and not($creates)) ) then '(disabled)' else ()
    return 
        if ($no-fulltext) then
            <tr>
                <td>-</td>
                <td>{concat($index-label, ' ', $no-fulltext)}</td>
                <!--td>-</td-->
                <td>-</td>
            </tr>
        else if (not($default-none) and not($attributes-none)) then
            <tr>
                <td>All Elements and Attributes!</td>
                <td>{$index-label}</td>
                <!--td>{count(collection($collection)//*)} elements and {count(collection($collection)//@*)} attributes</td-->
                <td>(Too many to display)</td>
            </tr>(: is it feasible to display all qnames/nodes here? :)
        else (: if ($creates) then :)
            (
            for $create in $creates
            let $qname := $create/@qname/string()
            let $mixed := $create/@mixed/string()
            return
                <tr>
                    <td>{$qname}</td>
                    <td>{$index-label} {if ($mixed) then '(mixed)' else ()}</td>
                    <!--td>{count(util:eval(concat('collection(', $collection, ')//', $qname)))}</td-->
                    <td><a href="index-keys.html{indexes:replace-parameters((
                            (:if ($qname) then:) concat('node-name=', $qname) (:else concat('match=', $match):)
                            , 
                            concat('collection=', $collection)
                            ,
                            'index=legacy-fulltext-index'
                            ,
                            'show-keys-by=node'
                        ))}">Node</a></td>
                </tr>
            ,
            let $only-elements-disabled := if ($fulltext/@default eq 'none' and $fulltext/@attributes ne 'no') then '(elements disabled)' else ()
            let $only-attribs-disabled := if ($fulltext/@default ne 'none' and $fulltext/@attributes eq 'no') then '(attributes disabled)' else ()
            return
            if ($only-elements-disabled) then
                <tr>
                    <td>All Attributes! {$only-elements-disabled}</td>
                    <td>{$index-label}</td>
                    <!--td>{count(collection($collection)//@*)} attributes</td-->
                    <td>(Too many to display)</td>
                </tr>(: is it feasible to display all qnames/nodes here? :)
            else if ($only-attribs-disabled) then 
                <tr>
                    <td>All Elements! {$only-attribs-disabled}</td>
                    <td>{$index-label}</td>
                    <!--td>{count(collection($collection)//*)} elements</td-->
                    <td>(Too many to display)</td>
                </tr>(: is it feasible to display all qnames/nodes here? :)
            else ()
            )
};

(:
    Analyzes the range indexes in an index definition
:)
declare function indexes:analyze-range-indexes($xconf) {
    let $index-label := indexes:index-name-to-label('range-index')
    let $ranges := $xconf/cc:index/cc:create 
    return 
        if (not($ranges) or empty($indexes:range-lookup)) then 
            () 
        else 
            for $range in $ranges
            let $qname := $range/@qname/string()
            let $match := $range/@path/string()
            let $type := $range/@type/string()
            let $collection := substring-after(util:collection-name($range), '/db/system/config')
(:            let $nodeset := if ($qname) then indexes:get-nodeset-from-qname($collection, $qname) else indexes:get-nodeset-from-match($collection, $match):)
            return
                <tr>
                    <td>{if ($qname) then $qname else $match}</td>
                    <td>{$index-label} {if ($qname) then ' QName' else ' Path'} ({$type})</td>
                    <!--td>{count($nodeset)}</td-->
                    <td>{
(:                        if (empty($nodeset)) then ():)
(:                        else:)
                            <a href="index-keys.html{indexes:replace-parameters((
                                if ($qname) then concat('node-name=', $qname) else concat('match=', $match)
                                , 
                                concat('collection=', $collection)
                                ,
                                'index=range-index'
                                ,
                                'show-keys-by=node'
                            ))}">Node</a>
                    }</td>
                </tr>
};

(:
    Analyzes the new range indexes in an index definition
:)
declare function indexes:analyze-new-range-indexes($xconf) {
    let $index-label := indexes:index-name-to-label('new-range-index')
    let $ranges := $xconf/cc:index/cc:range/cc:create[not(cc:field)]
    return if (not($ranges)) then () else 
        for $range in $ranges
        let $qname := $range/@qname/string()
        let $type := $range/@type/string()
        let $collection := substring-after(util:collection-name($range), '/db/system/config')
(:        let $nodeset := indexes:get-nodeset-from-qname($collection, $qname):)
        return
            <tr>
                <td>{$qname}</td>
                <td>{$index-label} QName ({$type})</td>
                <!--td>{count($nodeset)}</td-->
                <td>{
(:                    if (empty($nodeset)) then ():)
(:                    else:)
                        <a href="index-keys.html{indexes:replace-parameters((
                            concat('node-name=', $qname)
                            , 
                            concat('collection=', $collection)
                            ,
                            'index=new-range-index'
                            ,
                            'show-keys-by=node'
                        ))}">Node</a>
                }</td>
            </tr>
};

(:
    Analyzes the new range indexes in an index definition
:)
declare function indexes:analyze-new-range-index-fields($xconf) {
    let $index-label := indexes:index-name-to-label('new-range-index')
    let $ranges := $xconf/cc:index/cc:range/cc:create/cc:field
    return if (not($ranges)) then () else 
        for $range in $ranges
        let $name := $range/@name/string()
        let $match := $range/@match/string()
        let $type := $range/@type/string()
        let $collection := substring-after(util:collection-name($range), '/db/system/config')
(:        let $nodeset := indexes:get-nodeset-from-field($collection, $range/parent::cc:create/@qname, $match):)
        return
            <tr>
                <td>{$name}</td>
                <td>{$index-label} QName ({$type})</td>
                <!--td>{count($nodeset)}</td-->
                <td>{
(:                    if (empty($nodeset)) then ():)
(:                    else:)
                        <a href="index-keys.html{indexes:replace-parameters((
                            concat('field=', $name)
                            , 
                            concat('collection=', $collection)
                            ,
                            'index=new-range-index'
                            ,
                            'show-keys-by=field'
                        ))}">Node</a>
                }</td>
            </tr>
};

(:
    Analyzes the NGram indexes in an index definition
:)
declare function indexes:analyze-ngram-indexes($xconf) {
    let $index-label := indexes:index-name-to-label('ngram-index')
    let $ngrams := $xconf/cc:index/cc:ngram
    return if (not($ngrams)) then () else
        for $ngram in $ngrams
        let $qname := $ngram/@qname/string()
        let $collection := substring-after(util:collection-name($ngram), '/db/system/config')
(:        let $nodeset := indexes:get-nodeset-from-qname($collection, $qname):)
        return
            <tr>
                <td>{$qname}</td>
                <td>{$index-label} QName</td>
                <!--td>{count($nodeset)}</td-->
                <td>{
(:                    if (not(empty($nodeset))) then :)
                        (
                        <a href="index-keys.html{indexes:replace-parameters((
                            concat('node-name=', $qname)
                            , 
                            concat('collection=', $collection)
                            ,
                            'index=ngram-index'
                            ,
                            'show-keys-by=qname'
                        ))}">QName</a>, 
                        ', '
                        ,
                        <a href="index-keys.html{indexes:replace-parameters((
                            concat('node-name=', $qname)
                            , 
                            concat('collection=', $collection)
                            ,
                            'index=ngram-index'
                            ,
                            'show-keys-by=node'
                        ))}">Node</a>
                        )
(:                     else ():)
                 }</td>
            </tr>    
};

(:
    Helper function: Returns a nodeset of instances of a node-name in a collection
:)
declare function indexes:get-nodeset-from-qname($collection as xs:string, $node-name as xs:string) as node()* {
    let $nodeset-expression := 
        concat(
            indexes:get-namespace-declaration-from-node-name($node-name, $collection)
            ,
            'collection("', $collection, '")//', $node-name
        )
    let $log := util:log("DEBUG", concat("INDEXES get-nodeset:          ", $nodeset-expression))
    return
        util:eval($nodeset-expression)
};

(:
    Helper function: Returns a nodeset of instances of a match expression in a collection
:)
declare function indexes:get-nodeset-from-match($collection as xs:string, $match as xs:string) as node()* {
    let $nodeset-expression := 
        concat(
            string-join(
                distinct-values(
                let $node-names := tokenize(replace($match, '//', '/'), '/')
                return
                    for $node-name in $node-names
                    return
                        indexes:get-namespace-declaration-from-node-name($node-name, $collection)
                ), ' ')
            ,
            'collection("', $collection, '")', $match, if (contains($match, '@')) then () else ()
        )
    return
        util:eval($nodeset-expression) 
};

(:
    Helper function: Returns a nodeset of instances of a node-name in a collection
:)
declare function indexes:get-nodeset-from-field($collection as xs:string, $parentQName as xs:string, $match as xs:string?) as node()* {
    let $nodeset-expression := 
        indexes:get-namespace-declaration-from-node-name($parentQName, $collection) ||
        'collection("' || $collection || '")//' || $parentQName
    let $nodeset-expression :=
            if ($match) then $nodeset-expression || "/" || $match else $nodeset-expression
    let $log := util:log("DEBUG", concat("INDEXES get-nodeset:          ", $nodeset-expression))
    return
        util:eval($nodeset-expression)
};

(:
    Helper function: Returns the index definition for a given collection
:)
declare function indexes:get-xconf($collection as xs:string) as document-node() {
    let $config-root := '/db/system/config'
    let $xconf-collection := concat($config-root, $collection)
    let $xconf-filename := xmldb:get-child-resources($xconf-collection)[ends-with(., '.xconf')]
    let $xconf := doc(concat($xconf-collection, '/', $xconf-filename))
    return $xconf
};

(:
    Helper function: Looks in the collection.xconf's collection and index elements for namespace URIs for a given node name
:)
declare function indexes:get-namespace-uri-from-node-name($node-name, $collection) {

    let $name := if (starts-with($node-name,'@')) then
                    substring-after( substring-before($node-name, ':'), '@' )
                else
                    substring-before($node-name, ':')
    
    let $xconf := indexes:get-xconf($collection)
    let $uri := (namespace-uri-for-prefix($name, $xconf/cc:collection), namespace-uri-for-prefix($name, $xconf//cc:index))
    return
        $uri
};

(:
    Helper function: Constructs a namespace declaration for use in util:eval()
:)
declare function indexes:get-namespace-declaration-from-node-name($node-name as xs:string, $collection as xs:string) as xs:string? {
    if (not(matches($node-name, 'xml:')) and contains($node-name, ':')) then
    
        let $name := if (starts-with($node-name,'@')) then
                        substring-after( substring-before($node-name, ':'), '@' )
                    else
                        substring-before($node-name, ':')
        
        let $uri := indexes:get-namespace-uri-from-node-name($node-name, $collection)
        return
            concat('declare namespace ', $name, '="', $uri, '"; ') 
    else ()
};

(:
    Helper function: gets the label for a given index-name
:)
declare function indexes:index-name-to-label($index-name as xs:string) as xs:string {
    $indexes:index-names//item[value eq $index-name]/label/text() 
};

(:
    ====
    Helper functions for modifying the sort order used in indexes:show-index-keys() 
    ====
:)
declare function indexes:toggle-sortorder($current-sortorder) {
    indexes:toggle-sortorder($current-sortorder, ('ascending'))
};

declare function indexes:toggle-sortorder($current-sortorder, $other-new-parameters) {
    let $neworder := 
        if ($current-sortorder eq 'ascending') then
            'sortorder=descending'
        else 
            'sortorder=ascending'
    let $new-parameters := ($neworder, $other-new-parameters)
    return
        indexes:replace-parameters($new-parameters)
};

declare function indexes:set-sortorder($current-sortorder, $current-sortby, $new-sortby) {
    if ($current-sortby eq $new-sortby) then 
        indexes:toggle-sortorder($current-sortorder)
    else 
        indexes:strip-param-from-param-string(indexes:replace-parameters(concat('sortby=', $new-sortby)), 'sortorder')
};

declare function indexes:set-sortorder($new-sortby) {
    indexes:set-sortorder($indexes:sortorder, $indexes:sortby, $new-sortby)
};

declare function indexes:sort-direction-indicator($sortby as xs:string) {
    if ($sortby eq $indexes:sortby) then
        if ($indexes:sortorder eq 'ascending') then
            ' ↓'
        else
            ' ↑'
    else ()
};


(: 
    ====
    Helper functions for handling parameters 
    ====
:)
declare function indexes:remove-parameter-names($parameter-names-to-remove) {
    let $current-parameter-names := request:get-parameter-names()
    let $remaining-parameters :=
        indexes:remove-parameter-names(
            for $current-parameter-name in $current-parameter-names 
            return 
                concat($current-parameter-name, '=', request:get-parameter( $current-parameter-name, () ))
            ,
            $parameter-names-to-remove
            )
    return 
        if (exists($remaining-parameters)) then 
            concat('?', string-join($remaining-parameters, '&amp;'))
        else 
            '?'
};

declare function indexes:remove-parameter-names($current-parameters, $parameter-names-to-remove) {
    for $current-parameter in $current-parameters 
    return 
        if (substring-before($current-parameter, '=') = $parameter-names-to-remove) then
            ()
        else 
            $current-parameter
};

declare function indexes:remove-parameter-names-except($parameter-names-to-keep) {
    let $current-parameter-names := request:get-parameter-names()
    return
        indexes:remove-parameter-names($current-parameter-names[not(. = $parameter-names-to-keep)])
};

declare function indexes:replace-parameters($new-parameters) {
    let $current-parameter-names := request:get-parameter-names()
    let $current-parameters := 
        for $name in $current-parameter-names
        return concat($name, '=', request:get-parameter($name, ()))
    return
        indexes:replace-parameters($current-parameters, $new-parameters)
};

declare function indexes:replace-parameters($current-parameters, $new-parameters) {
    let $new-parameter-names := for $new-parameter in $new-parameters return substring-before($new-parameter, '=')
    let $remaining-parameters := indexes:remove-parameter-names($current-parameters, $new-parameter-names)
    let $result-parameters := for $param in ($remaining-parameters, $new-parameters) order by $param return $param
    return
        concat('?', string-join($result-parameters, '&amp;'))
};

declare function indexes:strip-param-from-param-string($param-string, $param) {
    replace($param-string, concat('&amp;?', $param, '=[^&amp;]*?&amp;?.*$'), '')
};
