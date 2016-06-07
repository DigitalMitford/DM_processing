xquery version "3.0";

module namespace app="http://exist-db.org/apps/admin/templates";

declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace prof="http://exist-db.org/xquery/profiling";
declare namespace scheduler="http://exist-db.org/xquery/scheduler";
declare namespace jmx="http://exist-db.org/jmx";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db.org/apps/admin/config" at "config.xqm";
import module namespace console="http://exist-db.org/xquery/console";

declare variable $app:OPTIMIZATIONS :=
    <optimizations>
        <opt n="0">No index</opt>
        <opt n="1">Basic</opt>
        <opt n="2">Full</opt>
    </optimizations>;

declare variable $app:get-scheduled-jobs := function-lookup(xs:QName("scheduler:get-scheduled-jobs"), 0);

declare function app:scheduler-enabled($node as node(), $model as map(*)) {
    if (exists($app:get-scheduled-jobs)) then
        ()
    else
        $node
};

declare
    %templates:wrap
    %templates:default("instance", "localhost")
function app:get-instance($node as node(), $model as map(*), $instance as xs:string) {
    $instance
};

declare
    %templates:default("instance", "localhost")
function app:instances($node as node(), $model as map(*), $instance as xs:string) {
    for $current in collection($config:app-root)//instance
    return
        <li class="{if ($instance = $current/@name) then 'active' else ''}">
            <a href="index.html?instance={$current/@name}">
                <i class="fa fa-angle-double-right"/>
                {$current/@name/string()}
            </a>
        </li>
};

declare
    %templates:wrap
    %templates:default("instance", "localhost")
function app:instances-data($node as node(), $model as map(*), $instance as xs:string) {
    let $instances := (
        <instance name="localhost" url="local" token="{console:jmx-token()}"/>,
        collection($config:app-root)//instance
    )
    return
        "var JMX_INSTANCES = [&#10;" ||
        string-join(
            for $instance in $instances
            let $statusRoot := collection($config:data-root)/jmx:jmx[jmx:instance = $instance/@name]
            let $status :=
                if ($statusRoot) then
                    if ($statusRoot/jmx:status = "ok") then
                        $statusRoot/jmx:SanityReport/jmx:Status/string()
                    else
                        $statusRoot/jmx:status/string()
                else
                    "Checking"
            return
                '{ name: "' || $instance/@name || 
                '", url: "' || $instance/@url || '", token: "' || $instance/@token || 
                '", status: "' || $status || '"}',
            ", "
        ),
        "&#10;];&#10;" ||
        "var JMX_INSTANCE = '" || $instance || "';&#10;" ||
        (if (exists($app:get-scheduled-jobs)) then
            "var JMX_ACTIVE = " || exists($app:get-scheduled-jobs()//scheduler:job[starts-with(@name, "jmx:")]) || ";&#10;"
        else
            "var JMX_ACTIVE = false;&#10;")
};

declare function app:btn-profiling($node as node(), $model as map(*)) {
    if (system:tracing-enabled()) then
        <a href="?action=disable" class="btn btn-default">
            <span class="glyphicon glyphicon-pause"/> Disable Tracing
        </a>
    else
        <a href="?action=enable" class="btn btn-default">
            <span class="glyphicon glyphicon-play"/> Enable Tracing
        </a>
};

declare 
    %templates:default("instance", "localhost")
function app:active-panel($node as node(), $model as map(*), $instance as xs:string) {
    let $items := templates:process($node/node(), $model)
    return
        element { node-name($node) } {
            $node/@*,
            let $panel := request:get-attribute("$exist:resource")
            for $li in $items
            let $active :=
                switch ($panel)
                    case "index.html" return
                        ($instance = "localhost" and $li/html:a/@href = "index.html") or
                        ($instance != "localhost" and $li/html:a/@href = "remotes.html")
                    case "collection.html" return 
                        $li/html:a/@href = "indexes.html"
                    default return
                        $li/html:a/@href = $panel
            return
                if ($active) then
                    <html:li class="active">
                    { $li/node() }
                    </html:li>
                else
                    $li
        }
};

declare
    %templates:wrap
function app:profile($node as node(), $model as map(*), $action as xs:string?) {
    switch ($action)
        case "clear" return
            system:clear-trace()
        case "enable" return
            system:enable-tracing(true())
        case "disable" return
            system:enable-tracing(false())
        default return
            (),
    map {
        "trace" := system:trace()
    }
};

declare
    %templates:wrap
    %templates:default("sort", "time")
function app:query-stats($node as node(), $model as map(*), $sort as xs:string) {
    if (empty($model("trace")/prof:query)) then
        <tr>
            <td colspan="3">No statistics available or tracing not enabled.</td>
        </tr>
    else
        let $queries :=
            for $query in $model("trace")/prof:query
            order by app:sort($query, $sort) descending
            return
                $query
        for $query in subsequence($queries, 1, 20)
        return
            <tr>
                <td>{app:truncate-source(replace($query/@source, "^.*/([^/]+)$", "$1"))}</td>
                <td class="trace-calls">{$query/@calls/string()}</td>
                <td class="trace-elapsed">{$query/@elapsed/string()}</td>
            </tr>
};

declare
    %templates:wrap
    %templates:default("sort", "time")
function app:function-stats($node as node(), $model as map(*), $sort as xs:string) {
    if (empty($model("trace")/prof:function)) then
        <tr>
            <td colspan="4">No statistics available or tracing not enabled.</td>
        </tr>
    else
        let $funcs :=
            for $func in $model("trace")/prof:function
            order by app:sort($func, $sort) descending
            return
                $func
        for $func in subsequence($funcs, 1, 20)
        return
            <tr>
                <td>{$func/@name/string()}</td>
                <td>{app:truncate-source(replace($func/@source, "^.*/([^/]+)$", "$1"))}</td>
                <td class="trace-calls">{$func/@calls/string()}</td>
                <td class="trace-elapsed">{$func/@elapsed/string()}</td>
            </tr>
};

declare
    %templates:wrap
    %templates:default("sort", "time")
function app:index-stats($node as node(), $model as map(*), $sort as xs:string) {
    if (empty($model("trace")/prof:index)) then
        <tr>
            <td colspan="4">No statistics available or tracing not enabled.</td>
        </tr>
    else
        let $indexes :=
            for $index in $model("trace")/prof:index
            order by app:sort($index, $sort) descending
            return
                $index
        for $index in subsequence($indexes, 1, 20)
        let $optimization := $app:OPTIMIZATIONS/opt[@n = $index/@optimization]/string()
        return
            <tr>
                <td>{app:truncate-source(replace($index/@source, "^.*/([^/]+)$", "$1"))}</td>
                <td class="trace-calls">{$index/@type/string()}</td>
                <td class="trace-calls">
                {
                    switch ($optimization)
                        case "No index" return
                            <span class="label label-danger">{$optimization}</span>
                        case "Full" return
                            <span class="label label-success">{$optimization}</span>
                        default return
                            <span class="label label-info">{$optimization}</span>
                }
                </td>
                <td class="trace-calls">{$index/@calls/string()}</td>
                <td class="trace-elapsed">{$index/@elapsed/string()}</td>
            </tr>
};

declare
    %templates:wrap
function app:current-user($node as node(), $model as map(*)) {
    let $user := request:get-attribute("org.exist.demo.login.user")
    return
        $user
};

declare function app:user-info($node as node(), $model as map(*)) {
    let $user := request:get-attribute("org.exist.login.user")
    let $name := sm:get-account-metadata($user, xs:anyURI("http://axschema.org/namePerson"))
    let $description := sm:get-account-metadata($user, xs:anyURI("http://exist-db.org/security/description"))
    return
        <p>
            { $name }
            <small>{ $description }</small>
        </p>
};

declare %private function app:sort($function as element(), $sort as xs:string) {
    if ($sort eq "name") then
        $function/@name
    else if ($sort eq "calls") then
        xs:int($function/@calls)
    else if ($sort eq "source") then
        $function/@source
    else
        xs:double($function/@elapsed)
};

declare %private function app:truncate-source($source as xs:string) as xs:string {
    if (string-length($source) gt 60) then
        substring($source, 1, 60)
    else
        $source
};