xquery version "3.0";

module namespace site="http://exist-db.org/apps/site-utils";

import module namespace apputil="http://exist-db.org/xquery/apps";
import module namespace request="http://exist-db.org/xquery/request";
import module namespace templates="http://exist-db.org/xquery/templates";

declare namespace expath="http://expath.org/ns/pkg";

declare variable $site:NOT_FOUND := xs:QName("site:NOT_FOUND");

(: 
 : Templating function: expand all links in the HTML fragment below $node. Within an href attribute,
 : you can use a template "{package}" to direct the user at a page inside a different app package.
 : For example href="{demo}/examples/index.html" would be expanded to an URL pointing into the
 : "demo" package.
 :)
declare %templates:wrap function site:expand-links($node as node(), $model as map(*), $base as xs:string?) {
    let $processed := templates:process($node/node(), $model)
    for $node in $processed
    return
        site:expand-links($node, $base)
};

declare %private function site:expand-links($node as node(), $base as xs:string?) {
    if ($node instance of element()) then
        let $href := $node/@href | $node/@src
        return
            if ($href) then
                let $expanded :=
                    if (starts-with($href, "/") and not(starts-with($href, request:get-context-path()))) then
                        request:get-context-path() || $href
                    else
                        try {
                            site:expand-link($href, $base)
                        } catch * {
                            request:get-context-path() || "/404.html"
                        }
                return
                    element { node-name($node) } {
                        attribute { node-name($href) }{ $expanded },
                        $node/@* except $href, $node/node()
                    }
            else
                element { node-name($node) } {
                    $node/@*, for $child in $node/node() return site:expand-links($child, $base)
                }
    else
        $node
};

declare %private function site:expand-link($href as xs:string, $base as xs:string?) {
    if (matches($href, "^\{[^\{\}]+\}")) then
        let $replacement :=
            let $arg := replace($href, "^\{([^\{\}]+)\}.*", "$1")
            let $name := if (contains($arg, "|")) then substring-before($arg, "|") else $arg
            let $app := apputil:resolve-abbrev($name)
            let $fallback := substring-after($arg, "|")
            return
                if ($app) then
                    concat(request:get-context-path(), request:get-attribute("$exist:prefix"), "/", $app)
                else if ($fallback) then
                    $base || $fallback
                else
                    error($site:NOT_FOUND, "Not found", $name)
        return
            replace($href, "^\{([^\{\}]+)\}", $replacement)
    else
        $href
};