xquery version "3.0";

declare namespace repo="http://exist-db.org/xquery/repo";

(: The following external variables are set by the repo:deploy function :)

(: the target collection into which the app is deployed :)
declare variable $target external;

let $data := xmldb:create-collection($target, "data")
return (
    sm:chown($data, "monex"),
    sm:chgrp($data, "monex"),
    sm:chmod($data, "rw-rw----")
),
for $name in ("instances.xml", "notifications.xml")
let $res := xs:anyURI($target || "/" || $name)
return (
    sm:chown($res, "admin"),
    sm:chgrp($res, "dba"),
    sm:chmod($res, "rw-rw----")
)