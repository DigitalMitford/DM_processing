xquery version "3.1";

(:~
 : HTML templating module
 :
 : @version 2.1
 : @author Wolfgang Meier
 : @contributor Adam Retter
 : @contributor Joe Wicentowski
:)
module namespace templates="http://exist-db.org/xquery/html-templating";

import module namespace inspect="http://exist-db.org/xquery/inspection" at "java:org.exist.xquery.functions.inspect.InspectionModule";
import module namespace map="http://www.w3.org/2005/xpath-functions/map";
import module namespace request="http://exist-db.org/xquery/request";
import module namespace session="http://exist-db.org/xquery/session";
import module namespace util="http://exist-db.org/xquery/util";

declare namespace expath="http://expath.org/ns/pkg";

declare variable $templates:CONFIG_STOP_ON_ERROR := "stop-on-error";
declare variable $templates:CONFIG_APP_ROOT := "app-root";
declare variable $templates:CONFIG_ROOT := "root";
declare variable $templates:CONFIG_FN_RESOLVER := "fn-resolver";
declare variable $templates:CONFIG_PARAM_RESOLVER := "param-resolver";
declare variable $templates:CONFIG_FILTER_ATTRIBUTES := "filter-atributes";

declare variable $templates:CONFIGURATION := "configuration";
declare variable $templates:CONFIGURATION_ERROR := QName("http://exist-db.org/xquery/html-templating", "ConfigurationError");
declare variable $templates:NOT_FOUND := QName("http://exist-db.org/xquery/html-templating", "NotFound");
declare variable $templates:TOO_MANY_ARGS := QName("http://exist-db.org/xquery/html-templating", "TooManyArguments");
declare variable $templates:PROCESSING_ERROR := QName("http://exist-db.org/xquery/html-templating", "ProcessingError");
declare variable $templates:TYPE_ERROR := QName("http://exist-db.org/xquery/html-templating", "TypeError");
declare variable $templates:MAX_ARITY := 20;

declare variable $templates:ATTR_DATA_TEMPLATE := "data-template";

(:~
 : Start processing the provided content. Template functions are looked up by calling the
 : provided function $resolver. The function should take a name as a string
 : and return the corresponding function item. The simplest implementation of this function could
 : look like this:
 :
 : <pre>function($functionName as xs:string, $arity as xs:integer) { function-lookup(xs:QName($functionName), $arity) }</pre>
 :
 : @param $content the sequence of nodes which will be processed
 : @param $resolver a function which takes a name and returns a function with that name
 : @param $model a sequence of items which will be passed to all called template functions. Use this to pass
 : information between templating instructions.
:)
declare function templates:apply($content as node()+, $resolver as function(xs:string, xs:integer) as item()?, $model as map(*)?) {
    templates:apply($content, $resolver, $model, ())
};

(:~
 : Start processing the provided content. Template functions are looked up by calling the
 : provided function $resolver. The function should take a name as a string
 : and return the corresponding function item. The simplest implementation of this function could
 : look like this:
 :
 : <pre>function($functionName as xs:string, $arity as xs:integer) { function-lookup(xs:QName($functionName), $arity) }</pre>
 :
 : @param $content the sequence of nodes which will be processed
 : @param $resolver a function which takes a name and returns a function with that name
 : @param $model a sequence of items which will be passed to all called template functions. Use this to pass
 : information between templating instructions.
 : @param $configuration a map of configuration parameters. For example you may provide a
 :  'parameter value resolver' by mapping $templates:CONFIG_PARAM_RESOLVER to a function
 :  whoose job it is to provide values for templated parameters. The function signature for
 :  the 'parameter value resolver' is f($param-name as xs:string) as item()*
:)
declare function templates:apply($content as node()+, $resolver as function(xs:string, xs:integer) as item()?, $model as map(*)?,
    $configuration as map(*)?) {
    let $_model := if (exists($model)) then $model else map {}
    let $configuration :=
        if (exists($configuration)) then
            map:merge((
                $configuration,
                map:entry($templates:CONFIG_FN_RESOLVER, $resolver),
                if (map:contains($configuration, $templates:CONFIG_PARAM_RESOLVER)) then
                    ()
                else
                    map:entry($templates:CONFIG_PARAM_RESOLVER, templates:lookup-param-from-restserver#1)
            ))
        else
            templates:get-default-config($resolver)
    let $__model := map:merge(($_model, map:entry($templates:CONFIGURATION, $configuration)))
    for $root in $content
    return
        templates:process($root, $__model)
};

declare %private function templates:get-default-config($resolver as function(xs:string, xs:integer) as item()?) as map(*) {
    map {
        $templates:CONFIG_FN_RESOLVER : $resolver,
        $templates:CONFIG_PARAM_RESOLVER : templates:lookup-param-from-restserver#1
    }
};

declare %private function templates:first-result($fns as function() as item()**) {
    if(empty($fns))then
        ()
    else
        let $result := $fns[1]() return
            if(exists($result))then
                $result
            else
                templates:first-result(subsequence($fns, 2))
};

declare %private function templates:lookup-param-from-restserver($var as xs:string) as item()* {
    templates:first-result((
        function() { request:get-parameter($var, ()) },
        function() { session:get-attribute($var) },
        function() { request:get-attribute($var) }
    ))
};

(:~
 : Continue template processing on the given set of nodes. Call this function from
 : within other template functions to enable recursive processing of templates.
 :
 : @param $nodes the nodes to process
 : @param $model a sequence of items which will be passed to all called template functions. Use this to pass
 : information between templating instructions.
:)
declare function templates:process($nodes as node()*, $model as map(*)) {
    let $config := templates:get-configuration($model, "")
    for $node in $nodes
    return
        typeswitch ($node)
            case document-node() return
                for $child in $node/node() return templates:process($child, $model)
            case element() return
                let $dataAttr := $node/@data-template
                return
                    if ($dataAttr) then
                        templates:call($dataAttr, $node, $model)
                    else
                        let $instructions := templates:get-instructions($node/@class)
                        return
                            if ($instructions) then
                                for $instruction in $instructions
                                return
                                    templates:call($instruction, $node, $model)
                            else
                                element { node-name($node) } {
                                    $node/@*, for $child in $node/node() return templates:process($child, $model)
                                }
            default return
                $node
};

declare %private function templates:get-instructions($class as xs:string?) as xs:string* {
    for $name in tokenize($class, "\s+")
    where templates:is-qname($name)
    return
        $name
};

declare %private function templates:get-configuration($model as map(*), $func as xs:string) {
    if (map:contains($model, $templates:CONFIGURATION)) then
        $model($templates:CONFIGURATION)
    else
        error($templates:CONFIGURATION_ERROR, "Configuration map not found in model. Tried to call: " || $func)
};

declare %private function templates:call($classOrAttr as item(), $node as element(), $model as map(*)) {
    let $parameters :=
        typeswitch ($classOrAttr)
            case attribute() return
                templates:parameters-from-attr($node)
            default return
                let $paramStr := substring-after($classOrAttr, "?")
                return
                    templates:parse-parameters($paramStr)
    let $func :=
        typeswitch ($classOrAttr)
            case attribute() return
                $classOrAttr/string()
            default return
                if (contains($classOrAttr, "?")) then
                    substring-before($classOrAttr, "?")
                else
                    $classOrAttr
    let $config := templates:get-configuration($model, $func)
    let $call := templates:resolve($func, $config($templates:CONFIG_FN_RESOLVER))
    return
        if (exists($call)) then
            templates:call-by-introspection($node, $parameters, $model, $call)
        else if ($model($templates:CONFIGURATION)($templates:CONFIG_STOP_ON_ERROR)) then
            error($templates:NOT_FOUND,
                "No template function found for call " || $func ||
                " (Max arity of " || $templates:MAX_ARITY ||
                " has been exceeded in searching for this template function." ||
                " If needed, adjust $templates:MAX_ARITY in the templates.xql module.)")
        else
            (: Templating function not found: just copy the element :)
            element { node-name($node) } {
                $node/@*, for $child in $node/node() return templates:process($child, $model)
            }
};

declare %private function templates:call-by-introspection($node as element(), $parameters as map(xs:string, xs:string), $model as map(*),
    $fn as function(*)) {
    let $inspect := inspect:inspect-function($fn)
    let $fn-name := prefix-from-QName(function-name($fn)) || ":" || local-name-from-QName(function-name($fn))
    let $param-lookup :=  templates:get-configuration($model, $fn-name)($templates:CONFIG_PARAM_RESOLVER)
    let $args := templates:map-arguments($inspect, $parameters, $param-lookup)
    return
        templates:process-output(
            $node,
            $model,
            apply($fn, array:join(([ $node, $model ], $args))),
            $inspect
        )
};

declare %private function templates:process-output($node as element(), $model as map(*), $output as item()*,
    $inspect as element(function)) {
    let $wrap :=
        $inspect/annotation[ends-with(@name, ":wrap")]
            [@namespace = "http://exist-db.org/xquery/html-templating"]
    return
        if ($wrap) then
            element { node-name($node) } {
                templates:filter-attributes($node, $model),
                templates:process-output($node, $model, $output)
            }
        else
            templates:process-output($node, $model, $output)
};

declare %private function templates:process-output($node as element(), $model as map(*), $output as item()*) {
    typeswitch($output)
        case map(*) return
            templates:process($node/node(), map:merge(($model, $output)))
        default return
            $output
};

declare %private function templates:map-arguments($inspect as element(function), $parameters as map(xs:string, xs:string), $param-lookup as function(xs:string) as item()*)
as array(*)* {
    let $args := $inspect/argument
    return
        if (count($args) > 2) then
            for $arg in subsequence($args, 3)
            return
                [ templates:map-argument($arg, $parameters, $param-lookup) ]
        else
            []
};

declare %private function templates:map-argument($arg as element(argument), $parameters as map(xs:string, xs:string), $param-lookup as function(xs:string) as item()*)
    as item()* {
    let $var := $arg/@var
    let $type := $arg/@type/string()

    let $looked-up-param := $param-lookup($var)
    let $param-from-context :=
        if(exists($looked-up-param))then
            $looked-up-param
        else
            $parameters($var)

    let $param :=
        if (exists($param-from-context)) then
            $param-from-context
        else
            templates:arg-from-annotation($var, $arg)
    let $data :=
        try {
            templates:cast($param, $type)
        } catch * {
            error($templates:TYPE_ERROR, "Failed to cast parameter value '" || $param || "' to the required target type for " ||
                "template function parameter $" || $var || " of function " || ($arg/../@name) || ". Required type was: " ||
                $type || ". " || $err:description)
        }
    return
        $data
};

declare %private function templates:arg-from-annotation($var as xs:string, $arg as element(argument)) {
    let $anno :=
        $arg/../annotation[ends-with(@name, ":default")]
            [@namespace = "http://exist-db.org/xquery/html-templating"]
            [value[1] = $var]
    for $value in subsequence($anno/value, 2)
    return
        string($value)
};

declare %private function templates:resolve($func as xs:string, $resolver as function(xs:string, xs:integer) as function(*)) {
    templates:resolve(2, $func, $resolver)
};

declare %private function templates:resolve($arity as xs:integer, $func as xs:string,
    $resolver as function(xs:string, xs:integer) as function(*)) {
    let $fn := $resolver($func, $arity)
    return
        if (exists($fn)) then
            $fn
        else if ($arity ge $templates:MAX_ARITY) then
            ()
        else
            templates:resolve($arity + 1, $func, $resolver)
};

declare %private function templates:parameters-from-attr($node as node()) {
    map:merge(
        for $attr in $node/@*[starts-with(local-name(.), $templates:ATTR_DATA_TEMPLATE)]
        return
            map:entry(
                replace(local-name($attr), $templates:ATTR_DATA_TEMPLATE || "\-(.*)$", "$1"),
                $attr/string()
            )
    )
};

declare %private function templates:parse-parameters($paramStr as xs:string?) as map(xs:string, xs:string) {
    map:merge(
        for $param in tokenize($paramStr, "&amp;")
        let $key := substring-before($param, "=")
        let $value := substring-after($param, "=")
        where $key
        return
            map:entry($key, $value)
    )
};

declare %private function templates:is-qname($class as xs:string) as xs:boolean {
    matches($class, "^[^:]+:[^:]+")
};

declare %private function templates:cast($values as item()*, $targetType as xs:string) {
    for $value in $values
    return
        if ($targetType != "xs:string" and string-length($value) = 0) then
            (: treat "" as empty sequence :)
            ()
        else
            switch ($targetType)
                case "xs:string" return
                    string($value)
                case "xs:integer" return
                    xs:integer($value)
                case "xs:int" return
                    xs:int($value)
                case "xs:long" return
                    xs:long($value)
                case "xs:decimal" return
                    xs:decimal($value)
                case "xs:float" case "xs:double" return
                    xs:double($value)
                case "xs:date" return
                    xs:date($value)
                case "xs:dateTime" return
                    xs:dateTime($value)
                case "xs:time" return
                    xs:time($value)
                case "element()" return
                    parse-xml($value)/*
                case "text()" return
                    text { string($value) }
                default return
                    $value
};

declare function templates:get-app-root($model as map(*)) as xs:string? {
    $model($templates:CONFIGURATION)($templates:CONFIG_APP_ROOT)
};

declare function templates:get-root($model as map(*)) as xs:string? {
    let $appRoot := templates:get-app-root($model)
    let $root := $model($templates:CONFIGURATION)($templates:CONFIG_ROOT)
    return
        if ($root) then $root else $appRoot
};

(:-----------------------------------------------------------------------------------
 : Standard templates
 :-----------------------------------------------------------------------------------:)

(:~
 : @deprecated use lib:include instead
 :)
declare function templates:include($node as node(), $model as map(*), $path as xs:string) {
    let $appRoot := templates:get-app-root($model)
    let $root := templates:get-root($model)
    let $path :=
        if (starts-with($path, "/")) then
            (: Search template relative to app root :)
            concat($appRoot, "/", $path)
        else if (matches($path, "^https?://")) then
            (: Template is loaded from a URL, this template even if a HTML file, must be
               returned with mime-type XML and be valid XML, as it is retrieved with fn:doc() :)
            $path
        else
            (: Locate template relative to HTML file :)
            concat($root, "/", $path)
    return
        templates:process(doc($path), $model)
};

declare function templates:surround($node as node(), $model as map(*), $with as xs:string, $at as xs:string?,
    $using as xs:string?, $options as xs:string?) {
    let $appRoot := templates:get-app-root($model)
    let $root := templates:get-root($model)
    let $path :=
        if (starts-with($with, "/")) then
            (: Search template relative to app root :)
            concat($appRoot, $with)
        else if (matches($with, "^https?://")) then
            (: Template is loaded from a URL, this template even if a HTML file, must be
               returned with mime-type XML and be valid XML, as it is retrieved with fn:doc() :)
            $with
        else
            (: Locate template relative to HTML file :)
            concat($root, "/", $with)
    let $content :=
        if ($using) then
            doc($path)//*[@id = $using]
        else
            doc($path)
    return
        if (empty($content)) then
            if ($model($templates:CONFIGURATION)($templates:CONFIG_STOP_ON_ERROR)) then
                error($templates:PROCESSING_ERROR, "surround: template not found at " || $path)
            else
                templates:process($node/node(), $model)
        else
            let $model := templates:surround-options($model, $options)
            let $merged := templates:process-surround($content, $node, $at)
            return
                templates:process($merged, $model)
};

declare %private function templates:surround-options($model as map(*), $optionsStr as xs:string?) as map(*) {
    if (exists($optionsStr)) then
        map:merge((
            $model,
            for $option in tokenize($optionsStr, "\s*,\s*")
            let $keyValue := tokenize($option, "\s*=\s*")
            return
                if (exists($keyValue)) then
                    if (count($keyValue) = 1) then
                        map:entry($keyValue, true())
                    else
                        map:entry($keyValue[1], $keyValue[2])
                else
                    ()
        ))
    else
        $model
};

declare %private function templates:process-surround($node as node(), $content as node(), $at as xs:string) {
    typeswitch ($node)
        case document-node() return
            for $child in $node/node() return templates:process-surround($child, $content, $at)
        case element() return
            if ($node/@id eq $at) then
                element { node-name($node) } {
                    $node/@*, $content/node()
                }
            else
                element { node-name($node) } {
                    $node/@*, for $child in $node/node() return templates:process-surround($child, $content, $at)
                }
        default return
            $node
};

declare function templates:each($node as node(), $model as map(*), $from as xs:string, $to as xs:string) {
    for $item in $model($from)
    return
        element { node-name($node) } {
            templates:filter-attributes($node, $model),
            templates:process($node/node(), map:merge(($model, map:entry($to, $item))))
        }
};

declare function templates:filter-attributes($node as node(), $model as map(*)) {
    if ($model?($templates:CONFIGURATION)?($templates:CONFIG_FILTER_ATTRIBUTES))
    then $node/@*[not(starts-with(local-name(.), $templates:ATTR_DATA_TEMPLATE))]
    else $node/@*
};

declare function templates:if-parameter-set($node as node(), $model as map(*), $param as xs:string) as node()* {
    let $values := templates:get-configuration($model, "templates:if-parameter-set")($templates:CONFIG_PARAM_RESOLVER)($param)
    return
        if (exists($values) and string-length(string-join($values)) gt 0) then
            templates:process($node/node(), $model)
        else
            ()
};

declare function templates:if-parameter-unset($node as node(), $model as item()*, $param as xs:string) as node()* {
    let $values := templates:get-configuration($model, "templates:if-parameter-unset")($templates:CONFIG_PARAM_RESOLVER)($param)
    return
        if (empty($values) or string-length(string-join($values)) eq 0) then
            templates:process($node/node(), $model)
        else
            ()
};

(: NOTE: to be moved to separate module because:
    1) HTTP Attribute is specific to Java Servlets
    2) Limits use to specifics to REST Server and URL Rewrite!
    If desirable for use from REST Server should be implemented elsewhere, perhaps in a module that includes the templates module?!?
:)
declare function templates:if-attribute-set($node as node(), $model as map(*), $attribute as xs:string) {
    let $isSet :=
        (exists($attribute) and request:get-attribute($attribute))
    return
        if ($isSet) then
            templates:process($node/node(), $model)
        else
            ()
};

declare function templates:if-model-key-equals($node as node(), $model as map(*), $key as xs:string, $value as xs:string) {
    let $isSet := $model($key) = $value
    return
        if ($isSet) then
            templates:process($node/node(), $model)
        else
            ()
};

(:~
 : Evaluates its enclosed block unless the model property $key is set to value $value.
 :)
declare function templates:unless-model-key-equals($node as node(), $model as map(*), $key as xs:string, $value as xs:string) {
    let $isSet := $model($key) = $value
    return
        if (not($isSet)) then
            templates:process($node/node(), $model)
        else
            ()
};

(:~
 : Evaluate the enclosed block if there's a model property $key equal to $value.
 :)
declare function templates:if-module-missing($node as node(), $model as map(*), $uri as xs:string, $at as xs:string) {
    try {
        util:import-module($uri, "testmod", $at)
    } catch * {
        (: Module was not found: process content :)
        templates:process($node/node(), $model)
    }
};

(:~
    Processes input and select form controls, setting their value/selection to
    values found in the request - if present.
 :)
declare function templates:form-control($node as node(), $model as map(*)) as node()* {
    let $control := local-name($node)
    return
        switch ($control)
        case "form" return
            element { node-name($node) }{
                $node/@* except $node/@action,
                attribute action { templates:get-configuration($model, "templates:form-control")($templates:CONFIG_PARAM_RESOLVER)("form-action") },
                for $n in $node/node()
                return templates:form-control($n, $model)
            }
        case "input" return
            let $type := $node/@type
            let $name := $node/@name
            let $value := templates:get-configuration($model, "templates:form-control")($templates:CONFIG_PARAM_RESOLVER)($name)
            return
                if (exists($value)) then
                    switch ($type)
                        case "checkbox" 
                        case "radio" return
                            element { node-name($node) } {
                                $node/@* except $node/@checked,
                                if ($node/@value = $value or $value = "true") then
                                    attribute checked { "checked" }
                                else
                                    (),
                                $node/node()
                            }
                        default return
                            element { node-name($node) } {
                                $node/@* except $node/@value,
                                attribute value { $value },
                                $node/node()
                            }
                else
                    $node
        case "select" return
            let $value := templates:get-configuration($model, "templates:form-control")($templates:CONFIG_PARAM_RESOLVER)($node/@name/string())
            return
                element { node-name($node) } {
                    $node/@*,
                    for $option in $node/*[local-name(.) = "option"]
                    return
                        if (empty($value)) then
                            $option
                        else
                            element { node-name($option) } {
                                $option/@* except $option/@selected,
                                if ($option/@value = $value or $option/string() = $value) then
                                    attribute selected { "selected" }
                                else
                                    (),
                                $option/node()
                            }
                }
        default return
            $node
};

declare function templates:error-description($node as node(), $model as map(*)) {
    let $input := templates:get-configuration($model, "templates:form-control")($templates:CONFIG_PARAM_RESOLVER)("org.exist.forward.error")
    return
        element { node-name($node) } {
            $node/@*,
            try {
                parse-xml($input)//message/string()
            } catch * {
                $input
            }
        }
};

declare function templates:copy-node($node as element(), $model as item()*) {
    element { node-name($node) } {
        $node/@*,
        templates:process($node/*, $model)
    }
};
