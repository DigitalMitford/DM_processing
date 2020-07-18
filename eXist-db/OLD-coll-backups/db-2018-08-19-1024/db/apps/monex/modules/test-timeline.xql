xquery version "3.0";

import module namespace app="http://exist-db.org/apps/admin/templates" at "app.xql";

declare namespace jmx="http://exist-db.org/jmx";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db.org/apps/admin/config" at "config.xqm";
import module namespace console="http://exist-db.org/xquery/console";


declare function local:test-timeline-brokers($node,$map,$instance,$type,$start,$end){
    let $select := "$jmx/jmx:Database/jmx:ActiveBrokers, $jmx/jmx:ProcessReport/jmx:RunningQueries/count(./jmx:row)"
    let $labels := "Active brokers, Running queries"
    return 
        app:timeline($node,$map,$instance, $select,$labels,$type,$start,$end)
};

declare function local:test-timeline-cpu($node,$map,$instance,$type,$start,$end){
    let $select := "$jmx/jmx:OperatingSystemImpl/jmx:ProcessCpuLoad, $jmx/jmx:OperatingSystemImpl/jmx:SystemCpuLoad"
    let $labels := "Process CPU Load, System CPU Load"
    return 
        app:timeline($node,$map,$instance, $select,$labels,$type,$start, $end)
};
declare function local:test-timeline-recentqueries($node,$map,$instance,$type,$start,$end){
    let $select := "$jmx/jmx:ProcessReport/jmx:RecentQueryHistory/max(jmx:row/jmx:mostRecentExecutionDuration), $jmx/jmx:ProcessReport/jmx:RecentQueryHistory/avg(jmx:row/jmx:mostRecentExecutionDuration)"
    let $labels := "Slowest Query, Average Query"
    return 
        app:timeline($node,$map,$instance, $select,$labels,$type,$start, $end)
};




declare function local:test-timeline(){
    let $node := <test/>
    let $map := map {}
    let $instance := "history.state.gov"
    let $type := "lines,lines"
    (:
    let $start := " 2015-06-29T10:00:00.000Z"
    let $end := " 2015-06-29T13:57:00.000Z"
    
    let $start := "2015-06-29T09:00:00.000Z"
    let $end := "2015-06-29T13:57:00.000Z"
    :)
    let $start := "2015-06-29T00:00:00.000Z"
    let $end := "2015-06-29T16:59:00.000Z"

    (:
    # 1435586160031
    :)

    return 
        (
            console:log("starting: duration: " || $start || "-" || $end),
            local:test-timeline-brokers($node,$map,$instance,$type,$start,$end),
            (: local:test-timeline-cpu($node,$map,$instance,$type,$start,$end) :)
            local:test-timeline-recentqueries($node,$map,$instance,$type,$start,$end),
            console:log("end")
        )
};

declare function local:test-xpath-expression-with-eval($instance){
        let $jmx := collection($config:data-root || "/" || $instance)/jmx:jmx[jmx:Database]
        return 
            if ($jmx) 
                then (util:eval("$jmx//jmx:ProcessCpuLoad",false()))
                else ("error")
    
};

declare function local:test-xpath-expression-without-eval($instance){
        let $jmx := collection($config:data-root || "/" || $instance)/jmx:jmx[jmx:Database]
        return 
            $jmx//jmx:ProcessCpuLoad
};

local:test-timeline()



(:   :local:test-xpath-expression-without-eval("history.state.gov") :)


    

