xquery version "3.0";

import module namespace app="http://exist-db.org/apps/admin/templates" at "app.xql";

declare namespace jmx="http://exist-db.org/jmx";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db.org/apps/admin/config" at "config.xqm";
import module namespace console="http://exist-db.org/xquery/console";


declare function local:run-timeline($header, $select, $start, $end){
    let $node := <test/>
    let $map := map {}
    let $instance := "history.state.gov"
    let $type := "lines,lines"
    let $labels := "1,2"
    return (
        console:log("Starting " || $header),
        let $tbegin := util:system-dateTime()
        let $result := app:timeline($node,$map,$instance, $select,$labels,$type,$start,$end)
        let $tend := util:system-dateTime()
        return "" || $header || " -- " || string(seconds-from-duration($tend - $tbegin))
    )
};

declare function local:run-default-timeline($gid, $start, $end){
    let $node := <test/>
    let $map := map {}
    let $instance := "history.state.gov"
    return (
        console:log("Starting " || $gid),
        let $tbegin := util:system-dateTime()
        let $result := app:default-timeline($node, $map, $instance, $gid, $start, $end)
        let $tend := util:system-dateTime()
        return "" || $gid || " -- " || string(seconds-from-duration($tend - $tbegin))
    )
};

declare function local:test-timeline(){
    let $select0 := "1"
    let $h0 := "dummy 1"

    let $select1 := "$jmx/jmx:ProcessReport/jmx:RecentQueryHistory/avg(jmx:row/jmx:mostRecentExecutionDuration)"
    let $h1 := "avg"

    let $select2 := "$jmx/jmx:Database/jmx:ActiveBrokers"
    let $h2 := "brokers"

    return 
        (
            local:run-timeline($h0, $select0, $start, $end),
            local:run-timeline($h1, $select1, $start, $end),
            local:run-timeline($h2, $select2, $start, $end),
            ()
        )
};

declare function local:test-timeline-from-html(){
    let $select0 := "1"
    let $h0 := "trivial1"

    let $select1 := "$jmx/jmx:Database/jmx:ActiveBrokers, $jmx/jmx:ProcessReport/jmx:RunningQueries/count(./jmx:row)"
    let $h1 := "ActiveBrokers,count(RunningQueries)"

    let $select2 := "$jmx/jmx:LockManager/jmx:WaitingThreads/count(./jmx:row)"
    let $h2 := "count(WaitingThreads)"

    let $select3 := "$jmx/jmx:OperatingSystemImpl/jmx:ProcessCpuLoad,$jmx/jmx:OperatingSystemImpl/jmx:SystemCpuLoad"
    let $h3 := "ProcessCpuLoad,SystemCpuLoad"

    let $select4 := "$jmx/jmx:MemoryImpl/jmx:HeapMemoryUsage/jmx:used,$jmx/jmx:MemoryImpl/jmx:HeapMemoryUsage/jmx:committed"
    let $h4 := "HeapMemoryUsage/used,HeapMemoryUsage/committed"

    let $select5 := "$jmx/jmx:ProcessReport/jmx:RecentQueryHistory/max(jmx:row/jmx:mostRecentExecutionDuration), $jmx/jmx:ProcessReport/jmx:RecentQueryHistory/avg(jmx:row/jmx:mostRecentExecutionDuration)"
    let $h5 := "max duration,avg duration"


    return 
        (
            local:run-timeline($h0, $select0, $start, $end),
            local:run-timeline($h1, $select1, $start, $end),
            local:run-timeline($h2, $select2, $start, $end),
            local:run-timeline($h3, $select3, $start, $end),
            local:run-timeline($h4, $select4, $start, $end),
            local:run-timeline($h5, $select5, $start, $end),
            ()
        )
};

declare function local:test-timeline-from-html-splitted(){

    let $select0 := "1"
    let $h0 := "trivial '1'"

    let $select1a := "$jmx/jmx:Database/jmx:ActiveBrokers"
    let $h1a := "ActiveBrokers"

    let $select1b := "$jmx/jmx:ProcessReport/jmx:RunningQueries/count(./jmx:row)"
    let $h1b := "count(RunningQueries)"

    let $select2 := "$jmx/jmx:LockManager/jmx:WaitingThreads/count(./jmx:row)"
    let $h2 := "count(WaitingThreads)"

    let $select3a := "$jmx/jmx:OperatingSystemImpl/jmx:ProcessCpuLoad"
    let $h3a := "ProcessCpuLoad"

    let $select3b := "$jmx/jmx:OperatingSystemImpl/jmx:SystemCpuLoad"
    let $h3b := "SystemCpuLoad"

    let $select4a := "$jmx/jmx:MemoryImpl/jmx:HeapMemoryUsage/jmx:used"
    let $h4a := "HeapMemoryUsage/used"

    let $select4b := "$jmx/jmx:MemoryImpl/jmx:HeapMemoryUsage/jmx:committed"
    let $h4b := "HeapMemoryUsage/committed"

    let $select5a := "$jmx/jmx:ProcessReport/jmx:RecentQueryHistory/max(jmx:row/jmx:mostRecentExecutionDuration)"
    let $h5a := "max duration"

    let $select5b := "$jmx/jmx:ProcessReport/jmx:RecentQueryHistory/avg(jmx:row/jmx:mostRecentExecutionDuration)"
    let $h5b := "avg duration"


    return (
        local:run-timeline($h0, $select0, $start, $end),
        local:run-timeline($h1a, $select1a, $start, $end),
        local:run-timeline($h1b, $select1b, $start, $end),
        local:run-timeline($h2, $select2, $start, $end),
        local:run-timeline($h3a, $select3a, $start, $end),
        local:run-timeline($h3b, $select3b, $start, $end),
        local:run-timeline($h4a, $select4a, $start, $end),
        local:run-timeline($h4b, $select4b, $start, $end),
        local:run-timeline($h5a, $select5a, $start, $end),
        local:run-timeline($h5b, $select5b, $start, $end),
        ()
    )
};


declare function local:test-default-timeline(){
    let $list := ("brokers-graph", "threads-graph", "cpu-graph", "memory-graph", "slow-queries-graph")
    for $gid in $list
    return
        local:run-default-timeline($gid, $start, $end)
};

(: TEST TIME INTERVALS
 : provided as global variables
 :)
(: 7d with typical data :)
(: declare variable $start := "2015-07-01T00:00:00.000Z":)
(: declare variable $end := "2015-07-07T23:59:59.999Z":)
    
(: 14d period with typical data :)
declare variable $start := "2015-06-25T00:00:00.000Z";
declare variable $end := "2015-07-08T23:59:59.999Z";

(:  MAIN :)


(:local:test-timeline(),:)
(:local:test-timeline-from-html(),:)
(:local:test-timeline-from-html-splitted(),:)
local:test-default-timeline(),
()
