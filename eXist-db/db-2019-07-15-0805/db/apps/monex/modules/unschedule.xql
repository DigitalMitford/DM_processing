xquery version "3.0";

import module namespace scheduler="http://exist-db.org/xquery/scheduler" at "java:org.exist.xquery.modules.scheduler.SchedulerModule";
import module namespace config="http://exist-db.org/apps/admin/config" at "config.xqm";

let $jobs := scheduler:get-scheduled-jobs()
for $job in $jobs//scheduler:job[starts-with(@name, "jmx:")]
let $result :=
    scheduler:delete-scheduled-job($job/@name)
return
    ()