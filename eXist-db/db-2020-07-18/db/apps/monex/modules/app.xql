xquery version "3.0";

module namespace app="http://exist-db.org/apps/admin/templates";

declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace prof="http://exist-db.org/xquery/profiling";
declare namespace jmx="http://exist-db.org/jmx";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace json="http://www.json.org";


(: import module namespace console="http://exist-db.org/xquery/console" at "java:org.exist.console.xquery.ConsoleModule"; :)
import module namespace scheduler="http://exist-db.org/xquery/scheduler" at "java:org.exist.xquery.modules.scheduler.SchedulerModule";
import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db.org/apps/admin/config" at "config.xqm";

declare variable $app:OPTIMIZATIONS :=
    <optimizations>
        <opt n="0">No index</opt>
        <opt n="1">Basic</opt>
        <opt n="2">Full</opt>
    </optimizations>;

declare variable $app:get-scheduled-jobs := function-lookup(xs:QName("scheduler:get-scheduled-jobs"), 0);

declare variable $app:jmx-token :=
    try {
        util:import-module(xs:anyURI("http://exist-db.org/xquery/console"), "console", xs:anyURI("java:org.exist.console.xquery.ConsoleModule")),
        function-lookup(xs:QName("console:jmx-token"), 0)()
    } catch * {
        false()
    };

declare variable $app:default-timeline-xpaths := map { 
    "brokers-graph" := ("$jmx//jmx:ActiveBrokers", "count($jmx//jmx:RunningQueries/jmx:row)"),
    "threads-graph" := ("count($jmx//jmx:WaitingThreads/jmx:row)"),
    "cpu-graph" := ("$jmx//jmx:ProcessCpuLoad", "$jmx//jmx:SystemCpuLoad"), 
    "memory-graph" := ("$jmx//jmx:HeapMemoryUsage/jmx:used", "$jmx//jmx:HeapMemoryUsage/jmx:committed"), 
    "slow-queries-graph" := ("max($jmx//jmx:mostRecentExecutionDuration)",
            "avg($jmx//jmx:mostRecentExecutionDuration)")
    (: full path is $jmx/jmx:ProcessReport/jmx:RecentQueryHistory/jmx:row/jmx:mostRecentExecutionDuration :)
};

declare variable $app:default-timeline-labels := map {
    "brokers-graph" := ("Active brokers", "Running queries"),
    "threads-graph" := ("Waiting Threads"),
    "cpu-graph" := ("Process CPU Load", "System CPU Load"), 
    "memory-graph" := ("Used Memory", "Committed Memory"), 
    "slow-queries-graph" := ("Slowest Query", "Average Query")
};

declare variable $app:default-timeline-type := "lines";


declare function app:scheduler-enabled($node as node(), $model as map(*)) {
    if (exists($app:get-scheduled-jobs)) then
        ()
    else
        $node
};

declare function app:java-version ($node as node(), $model as map(*)) as node()? {
let $version := util:system-property("java.version")
return
  <td>{$version}</td>  
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
            {
                if ($current/poll/@store = ("yes", "true")) then
                    <ul>
                        <li><a href="timelines.html?instance={$current/@name}">Timelines</a></li>
                    </ul>
                else
                    ()
            }
        </li>
};

declare
    %templates:wrap
    %templates:default("instance", "localhost")
function app:instances-data($node as node(), $model as map(*), $instance as xs:string) {
    let $instances := (
        <instance name="localhost" url="local" token="{$app:jmx-token}"/>,
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

declare function app:btn-tare($node as node(), $model as map(*)) {
    if (session:get-attribute("tare")) then
        <a href="?action=clear-tare" class="btn btn-default">
            <span class="glyphicon glyphicon-remove"/> Clear Tare
        </a>
    else
        <a href="?action=tare" class="btn btn-default">
            <span class="glyphicon glyphicon-record"/> Tare
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
        case "tare" return
            (
                session:set-attribute("tare", system:trace()),
                system:clear-trace()
            )
        case "clear-tare" return
            (
                session:remove-attribute("tare"),
                system:clear-trace()
            )
        default return
            (),
    let $tare := session:get-attribute("tare")
    let $trace := system:trace()
    let $adjusted-trace := 
        if (exists($tare)) then 
            (
                app:adjust-trace($trace, $tare),
                system:clear-trace()
            )
        else 
            $trace
    return
        (
            map {
                "trace" := $adjusted-trace
            }
            (:,
            if (exists($tare)) then console:log(<log><raw-trace>{$trace}</raw-trace><adjusted>{$adjusted-trace}</adjusted><tare>{$tare}</tare></log>) else () :)
        )
};

declare function app:adjust-trace($trace, $tare) {
    (: the following modules generate side effects that are not necessarily caught by the "tare", 
       so we will filter them out from the trace :)
    let $sources-to-suppress := 
        (
            (: this module :)
            "/db/apps/monex/modules/app.xql",
            (: login-related comparisons :)
            "/db/apps/eXide/controller.xql",
            "jar:file:/Applications/eXist-db.app/Contents/Resources/eXist-db/lib/extensions/exist-modules.jar!/org/exist/xquery/modules/persistentlogin/login.xql"
        )
    
    (: begin adjusting trace :)
    
    (: 1. queries :)
    let $trace-queries := $trace//prof:query[not(starts-with(@source, $sources-to-suppress))]
    let $tare-queries := $tare//prof:query
    let $adjusted-queries := 
        for $query in $trace-queries
        let $match := $tare-queries[@source = $query/@source]
        return
            if ($match) then
                let $adjusted-calls := ($query/@calls - $match/@calls)
                let $adjusted-elapsed := $query/@elapsed - $match/@elapsed
                return
                    if ($adjusted-calls gt 0) then 
                        <prof:query source="{$query/@source}" calls="{$adjusted-calls}" elapsed="{$adjusted-elapsed}"/>
                    else
                        ()
            else
                $query

    (: 2. functions :)
    let $trace-functions := $trace//prof:function[not(starts-with(@source, $sources-to-suppress))]
    let $tare-functions := $tare//prof:function
    let $adjusted-functions := 
        for $function in $trace-functions
        let $match := $tare-functions[@source = $function/@source][@name = $function/@name]
        return
            if ($match) then
                let $adjusted-calls := ($function/@calls - $match/@calls)
                let $adjusted-elapsed := $function/@elapsed - $match/@elapsed
                return
                    if ($adjusted-calls gt 0) then 
                        <prof:function name="{$function/@name}" source="{$function/@source}" calls="{$adjusted-calls}" elapsed="{$adjusted-elapsed}"/>
                    else
                        ()
            else
                $function

    (: 3. indexes :)
    let $trace-indexes := $trace//prof:index[not(starts-with(@source, $sources-to-suppress))]
    let $tare-indexes := $tare//prof:index
    let $adjusted-indexes :=
        for $index in $trace-indexes
        let $match := $tare-indexes[@source = $index/@source]
        return
            if ($match) then
                let $adjusted-calls := ($index/@calls - $match/@calls)
                let $adjusted-elapsed := $index/@elapsed - $match/@elapsed
                return
                    if ($adjusted-calls gt 0) then 
                        <prof:index source="{$index/@source}" type="{$index/@type}" calls="{$adjusted-calls}" elapsed="{$adjusted-elapsed}" optimization="{$index/@optimization}"/>
                    else
                        ()
            else
                $index
    return
        <prof:calls>{$adjusted-queries, $adjusted-functions, $adjusted-indexes}</prof:calls>
        
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
                <td>{app:truncate-source($query/@source)}</td>
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
                <td>{app:truncate-source($func/@source)}</td>
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
                <td>{app:truncate-source($index/@source)}</td>
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

declare function app:form-action-to-current-url($node as node(), $model as map(*)) {
    <form action="{request:get-uri()}">{
        $node/attribute()[not(name(.) = 'action')],
        $node/node()
    }</form>
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

declare %private function app:truncate-source($source as xs:string) {
    if (string-length($source) gt 60) then
        let $analyze := analyze-string($source, "^(.*/)([^/]+)$")
        let $path := $analyze//fn:group[1]
        let $filename := $analyze//fn:group[2]
        return
            <span title="{$source}">{substring($path, 1, 60 - string-length($filename)) || '[...]' || $filename}</span>
    else
        $source
};


(: Takes start & end parameters as strings and returns start & end time points as xs:dateTime.
 : The function returns a sequence of exactly 2 values: ($start, $end). :)
declare function app:process-time-interval-params($pstart as xs:string, $pend as xs:string) as xs:dateTime+ {
    let $end := if($pend != "") then xs:dateTime($pend) else current-dateTime()
    let $start := if($pstart != "") then xs:dateTime($pstart) else ($end - xs:dayTimeDuration('P1D'))
    return ($start, $end)
};

(: Returns the set of JMX recordes from the given time period.
 : A session-scope cache is used to keep the most recent results in memory. :)
declare function app:jmxs-for-time-interval($instance as xs:string, $start as xs:dateTime, $end as xs:dateTime) {
    let $lock := doc($config:app-root || "/timeline-cache-lock.xml") return
    util:exclusive-lock($lock, (
        let $cached-timeline-start := session:get-attribute("cached-timeline-start")
        let $cached-timeline-end := session:get-attribute("cached-timeline-end")
        return
            if($cached-timeline-start = $start and $cached-timeline-end = $end)
            then (
                session:get-attribute("cached-timeline-jmxs")
            ) else (
                let $jmxs := collection($config:data-root || "/" || $instance)/jmx:jmx[jmx:Database]
                        [xs:dateTime(jmx:timestamp) ge $start][xs:dateTime(jmx:timestamp) le $end]
                return (
                    session:set-attribute("cached-timeline-jmxs", $jmxs),
                    session:set-attribute("cached-timeline-start", $start),
                    session:set-attribute("cached-timeline-end", $end),
                    $jmxs
                )
            )
    ))
};

(: Executes the given timeline queries and returns unprocessed results.
 : Sequences of equal length and corresponding order should be passed as xpaths, labels, and types arguments. :)
declare function app:make-timeline($instance as xs:string, $xpaths as xs:string+, $labels as xs:string+, $types as xs:string+, $start as xs:dateTime, $end as xs:dateTime) as item()* {
    let $jmxs := app:jmxs-for-time-interval($instance, $start, $end)
    return
        if ($jmxs) then
            <result>
            {
                let $timestamps := (for $jmx in $jmxs return app:time-to-milliseconds(xs:dateTime($jmx/jmx:timestamp)))
                for $xpath at $n in $xpaths
                let $expression := "for $jmx in $jmxs return number((("|| $xpath ||"),0)[1])"
                let $values := util:eval($expression, true())
                return
                    <json:value json:array="true">
                        <label>{$labels[$n]}</label>
                        <data> 
                        {
                            for $val at $pos in $values
                            let $time := $timestamps[$pos]
                            order by $time ascending
                            return
                                <json:value json:array="true">
                                    <json:value json:literal="true">{$time}</json:value>
                                    <json:value json:literal="true">{$val}</json:value>
                                </json:value>
                        }
                        </data>
                        {
                        element { $types[$n] } {
                            <show>true</show>
                        }   }
                    </json:value>
            }
            </result>
        else
            attribute data-data { "[]" }
};

(: Timeline for predefined standard graphs. :)
declare
    %templates:wrap
    %templates:default("instance", "localhost")
    %templates:default("start", "")
    %templates:default("end", "")
function app:default-timeline($node as node(), $model as map(*), $instance as xs:string, $gid, $start as xs:string, $end as xs:string) {
    let $timespec := app:process-time-interval-params($start, $end)
    let $xpaths := $app:default-timeline-xpaths($gid)
    let $labels := $app:default-timeline-labels($gid)
    let $types := for $i in (1 to count($xpaths)) return $app:default-timeline-type
    return
        app:make-timeline($instance, $xpaths, $labels, $types, $timespec[1], $timespec[2])
};

declare function app:serialize-to-json($result) {
  attribute data-data {
        serialize($result,
            <output:serialization-parameters>
                <output:method>json</output:method>
            </output:serialization-parameters>
        )
    }  
};

(: General timeline function for non-standard queries. :)
declare
    %templates:wrap
    %templates:default("instance", "localhost")
    %templates:default("start", "")
    %templates:default("end", "")
function app:timeline($node as node(), $model as map(*), $instance as xs:string, $select as xs:string, $labels as xs:string, $type as xs:string, $start as xs:string, $end as xs:string) {
    let $labels := tokenize($labels, "\s*,\s*")
    let $xpaths := tokenize($select, "\s*,\s*")
    let $types := tokenize($type, "\s*,\s*")

    let $timespec := app:process-time-interval-params($start, $end)
    let $result := app:make-timeline($instance, $xpaths, $labels, $types, $timespec[1], $timespec[2])
    return
        if($result)
        then
            attribute data-data {
                serialize($result, 
                    <output:serialization-parameters>
                        <output:method>json</output:method>
                    </output:serialization-parameters>
                )
            }
        else
            attribute data-data { "[]" }
};

declare
    %templates:wrap
    %templates:default("instance", "localhost")
function app:load-record($node as node(), $model as map(*), $instance as xs:string, $timestamp as xs:long) {
    let $date := app:milliseconds-to-time($timestamp)
    let $jmx := collection($config:data-root || "/" || $instance)/jmx:jmx[jmx:timestamp = $date]
    return
        serialize($jmx)
};

declare
    %templates:wrap
function app:timestamp($node as node(), $model as map(*), $timestamp as xs:long) {
    app:milliseconds-to-time($timestamp)
};

declare function app:time-navigation-back($node as node(), $model as map(*), $instance as xs:string, $timestamp as xs:long) {
    let $date := app:milliseconds-to-time($timestamp)
    let $jmx := 
        (
            for $rec in collection($config:data-root || "/" || $instance)/jmx:jmx[jmx:timestamp < xs:dateTime($date)]
            order by xs:dateTime($rec/jmx:timestamp)
            return
                $rec
        )
        [last()]
    return
        element { node-name($node) } {
            $node/@*,
            attribute href { "?timestamp=" || app:time-to-milliseconds(xs:dateTime($jmx/jmx:timestamp)) || 
                "&amp;instance=" || $instance },
            templates:process($node/*, $model)
        }
};

declare function app:time-navigation-forward($node as node(), $model as map(*), $instance as xs:string, $timestamp as xs:long) {
    let $date := app:milliseconds-to-time($timestamp)
    let $jmx :=
        (
            for $rec in collection($config:data-root || "/" || $instance)/jmx:jmx[jmx:timestamp > xs:dateTime($date)]
            order by xs:dateTime($rec/jmx:timestamp)
            return
                $rec
        )
        [1]
    return
        element { node-name($node) } {
            $node/@*,
            attribute href { "?timestamp=" || app:time-to-milliseconds(xs:dateTime($jmx/jmx:timestamp)) || 
                "&amp;instance=" || $instance },
            templates:process($node/*, $model)
        }
};

declare function app:time-to-milliseconds($dateTime as xs:dateTime) {
    let $diff := $dateTime - xs:dateTime("1970-01-01T00:00:00Z")
    return
        (days-from-duration($diff) * 60 * 60 * 24 +
        hours-from-duration($diff) * 60 * 60 +
        minutes-from-duration($diff) * 60 +
        seconds-from-duration($diff)) * 1000
};

declare function app:milliseconds-to-time($timestamp as xs:long) as xs:dateTime {
    let $days := xs:int($timestamp div 1000 div 24 div 60 div 60)
    let $remainder := $timestamp - ($days * 24 * 60 * 60 * 1000)
    let $hours := xs:int($remainder div 1000 div 60 div 60)
    let $remainder := $remainder - ($hours * 60 * 60 * 1000)
    let $minutes := xs:int($remainder div 1000 div 60)
    let $remainder := $remainder - ($minutes * 60 * 1000)
    let $seconds := xs:int($remainder div 1000)
    let $millis := format-number($remainder - ($seconds * 1000), "000")
    return
        xs:dateTime("1970-01-01T00:00:00Z") + 
        xs:dayTimeDuration("P" || $days || "DT" || $hours || "H" || $minutes || "M" || $seconds || "." || $millis || "S")
};

declare function app:edit-source($node as node(), $model as map(*), $instance as xs:string, $timestamp as xs:long) as node()* {
    let $date := app:milliseconds-to-time($timestamp)
    let $doc := collection($config:data-root || "/" || $instance)/jmx:jmx[jmx:timestamp = xs:dateTime($date)]
    let $link := templates:link-to-app("http://exist-db.org/apps/eXide", "index.html?open=" || document-uri(root($doc)))
    return
        element { node-name($node) } {
            attribute href { $link },
            attribute target { "eXide" },
            attribute class { $node/@class || " eXide-open" },
            attribute data-exide-open { document-uri(root($doc)) },
            $node/node()
        }
};
