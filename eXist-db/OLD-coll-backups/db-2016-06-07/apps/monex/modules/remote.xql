xquery version "3.0";

import module namespace config="http://exist-db.org/apps/admin/config" at "config.xqm";
import module namespace http="http://expath.org/ns/http-client";

let $instances := collection($config:app-root)//instance
let $name := request:get-parameter("name", ())
let $operation := request:get-parameter("operation", ())
let $instance := $instances[@name = $name]
let $baseURL :=
    if ($operation) then
        $instance/@url || "/status?operation=" || $operation || "&amp;token=" || $instance/@token
    else
        $instance/@url || 
        "/status?c=instances&amp;c=processes&amp;c=locking&amp;c=memory&amp;c=caches&amp;c=system&amp;token=" ||
        $instance/@token
let $extraParams :=
    string-join(
        for $param in request:get-parameter-names()
        where not($param = ("name", "operation"))
        return
            $param || "=" || request:get-parameter($param, ()),
        "&amp;"
    )
let $url := 
    if ($extraParams != "") then 
        $baseURL || "&amp;" || $extraParams
    else
        $baseURL
let $request :=
    <http:request method="GET" href="{$url}" timeout="30"/>
let $response := http:send-request($request)
return
    if ($response[1]/@status = "200") then
        $response[2]
    else (
        response:set-status-code(500),
        $response[1]/@message/string()
    )