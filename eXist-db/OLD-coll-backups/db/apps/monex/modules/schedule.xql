xquery version "3.0";

import module namespace scheduler="http://exist-db.org/xquery/scheduler" at "org.exist.xquery.modules.scheduler.SchedulerModule";
import module namespace config="http://exist-db.org/apps/admin/config" at "config.xqm";

for $instance in collection($config:app-root)//instance
let $cron := ($instance/@cron, "0 * * * * ?")[1]
let $params :=
    <parameters>
        <param name="name" value="{$instance/@name}"/>
        <param name="operation" value="ping"/>
        <param name="app-root" value="{$config:app-root}"/>
        <param name="data-root" value="{$config:data-root}"/>
    </parameters>
let $result :=
    scheduler:schedule-xquery-cron-job($config:app-root || "/modules/job.xql", 
        $cron, "jmx:" || $instance/@name, $params)
return
    ()