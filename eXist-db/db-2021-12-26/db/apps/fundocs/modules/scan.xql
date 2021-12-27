xquery version "3.0";

module namespace docs="http://exist-db.org/xquery/docs";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace dbutil="http://exist-db.org/xquery/dbutil";
import module namespace inspect="http://exist-db.org/xquery/inspection" at "java:org.exist.xquery.functions.inspect.InspectionModule";

declare namespace xqdoc="http://www.xqdoc.org/1.0";
 
declare %private function docs:create-collection($parent as xs:string, $child as xs:string) as empty-sequence() {
    let $null := xdb:create-collection($parent, $child)
    return ()
};

declare %private function docs:load-external($uri as xs:anyURI, $store as function(xs:string, element()) as empty-sequence()) {
    let $meta := inspect:inspect-module-uri($uri)
    return
        if ($meta) then
            let $xml := docs:generate-xqdoc($meta)
            let $moduleURI := $xml//xqdoc:module/xqdoc:uri
            return
                $store($uri, $xml)
        else
            ()
};

declare %private function docs:load-stored($path as xs:anyURI, $store as function(xs:string, element()) as empty-sequence()) {
    let $meta := inspect:inspect-module($path)
    return
        if ($meta) then
            let $xml := docs:generate-xqdoc($meta)
            let $moduleURI := $xml//xqdoc:module/xqdoc:uri
            return
                $store($path, $xml)
        else
            ()
};

declare %private function docs:load-external-modules($store as function(xs:string, element()) as empty-sequence()) {
    for $uri in util:mapped-modules()
    return
        docs:load-external($uri, $store),
    for $path in dbutil:find-by-mimetype(xs:anyURI("/db"), "application/xquery")
    return
        try {
            docs:load-stored($path, $store)
        } catch * {
            (: Expected to fail if XQuery file is not a library module :)
            ()
        }
};

declare %private function docs:load-internal-modules($store as function(xs:string, element()) as empty-sequence()) {
    for $moduleURI in util:registered-modules()
    let $meta := inspect:inspect-module-uri($moduleURI)
    return
        if ($meta) then
            let $xml := docs:generate-xqdoc($meta)
            return
                $store($moduleURI, $xml)
        else
            util:log("WARN", "Module not found: " || $moduleURI)
};

declare function docs:load-fundocs($target as xs:string) {
    let $dataColl := xdb:create-collection($target, "data")
    let $store := function($moduleURI as xs:string, $data as element()) {
        let $name := util:hash($moduleURI, "md5") || ".xml"
        return
        (
            xdb:store($dataColl, $name, $data),
            sm:chmod(xs:anyURI($dataColl || "/" || $name), "rw-rw-r--")
        )[2]
    }
    return (
    	docs:load-internal-modules($store),
    	docs:load-external-modules($store)
    )
};

declare function docs:generate-xqdoc($module as element(module)) {
    <xqdoc:xqdoc xmlns:xqdoc="http://www.xqdoc.org/1.0">
        <xqdoc:control>
            <xqdoc:date>{current-dateTime()}</xqdoc:date>
            <xqdoc:location>{$module/@location/string()}</xqdoc:location>
        </xqdoc:control>
        <xqdoc:module type="library">
            <xqdoc:uri>{$module/@uri/string()}</xqdoc:uri>
            <xqdoc:name>{$module/@prefix/string()}</xqdoc:name>
            <xqdoc:comment>
                <xqdoc:description>{$module/description/string()}</xqdoc:description>
                {
                    if ($module/version) then
                        <xqdoc:version>{$module/version/string()}</xqdoc:version>
                    else
                        ()
                }
                {
                    if ($module/author) then
                        <xqdoc:author>{$module/author/string()}</xqdoc:author>
                    else
                        ()
                }
            </xqdoc:comment>
        </xqdoc:module>
        <xqdoc:functions>
        {
            for $func in $module/function
            return
                <xqdoc:function>
                    <xqdoc:name>{$func/@name/string()}</xqdoc:name>
                    <xqdoc:signature>{docs:generate-signature($func)}</xqdoc:signature>
                    <xqdoc:comment>
                        <xqdoc:description>{$func/description/string()}</xqdoc:description>
                        {
                            for $param in $func/argument
                            return
                                <xqdoc:param>${$param/@var/string()}{docs:cardinality($param/@cardinality)}{" "}{$param/text()}</xqdoc:param>
                        }
                        <xqdoc:return>
                        {$func/returns/@type/string()}{docs:cardinality($func/returns/@cardinality)}{if(empty($func/returns/text())) then "" else " : " || $func/returns/text()}
        
                        </xqdoc:return>
                        {
                            if ($func/deprecated) then
                                <xqdoc:deprecated>{$func/deprecated/string()}</xqdoc:deprecated>
                            else
                                ()
                        }  
                    </xqdoc:comment>
                </xqdoc:function>
        }
        </xqdoc:functions>
    </xqdoc:xqdoc>
};

declare function docs:cardinality($cardinality as xs:string) {
    switch ($cardinality)
        case "zero or one" return "?"
        case "zero or more" return "*"
        case "one or more" return "+"
        default return ()
};

declare function docs:generate-signature($func as element(function)) {
    $func/@name/string() || "(" ||
    string-join(
        for $param in $func/argument
        return
            "$" || $param/@var/string()  || " as " || $param/@type/string() || docs:cardinality($param/@cardinality),
        ", "
    ) || 
    ")" || " as " || $func/returns/@type/string() || docs:cardinality($func/returns/@cardinality)
};