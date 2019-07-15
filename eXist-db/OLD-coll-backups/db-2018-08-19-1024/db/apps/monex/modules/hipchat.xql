xquery version "3.1";

module namespace hipchat="http://exist-db.org/apps/monex/hipchat";

declare namespace jmx="http://exist-db.org/jmx";

import module namespace http="http://expath.org/ns/http-client" at "java:org.exist.xquery.modules.httpclient.HTTPClientModule";
import module namespace console="http://exist-db.org/xquery/console";
import module namespace config="http://exist-db.org/apps/admin/config" at "config.xqm";

declare variable $hipchat:JSON_SERIALIZATION := 
    <output:serialization-parameters xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
        <output:method value="json"/>
    <output:indent value="yes"/>
  </output:serialization-parameters>;
 
declare variable $hipchat:CONFIG := doc($config:app-root || "/notifications.xml")//method[@uri = "http://exist-db.org/apps/monex/hipchat"];

declare function hipchat:notify($root as xs:string, $instance as element(), $status as xs:string, $data as element(),
    $attachment as element()?) {
    let $message := hipchat:short-message($data)
    for $room in $hipchat:CONFIG/room
    let $url := "https://existdb.hipchat.com/v2/room/" || $room/@id || "/notification?auth_token=" || $room/@token
    let $log := console:log($url)
    let $id := util:uuid()
    let $data :=
        map {
            "message": $message,
            "message_format": "html",
            "id": $id,
            "card": map {
                "style": "application",
                "title": "Alert for " || $data/jmx:instance,
                "description": $data/jmx:status/string(),
                "id": util:uuid(),
                "icon": map {
                    "url" : "http://exist-db.org/exist/apps/dashboard/resources/images/package.png"
                },
                "attributes": hipchat:attributes($attachment),
                "url": $room/@monex-url || "/index.html?instance=" || $data/jmx:instance
            }
        }
    let $json := serialize($data, $hipchat:JSON_SERIALIZATION)
    let $log := console:log($json)
    let $request :=
        <http:request method="POST" href="{$url}" timeout="30">
            <http:body method="text" media-type="application/json">{$json}</http:body>
        </http:request>
    let $response := http:send-request($request)
    return
        if ($response[1]/@status = "204") then
            console:log($response[1])
        else
            console:log(util:binary-to-string($response[2]))
};

declare %private function hipchat:short-message($data as element()?) {
    <span><b>Alert</b> for server <b>{$data/jmx:instance/string()}</b> on
    { format-dateTime(xs:dateTime($data/jmx:timestamp), "[FNn], [MNn] [D1o], [Y] [h00]:[m00]:[s00]") }<br/>
    <pre>{ $data/jmx:status/string() }</pre></span>
};

declare %private function hipchat:attributes($jmx as element()?) {
    if ($jmx) then
        [ 
            map {
                "label": "Active brokers",
                "value": map {
                    "label": $jmx/jmx:Database/jmx:ActiveBrokers/string(),
                    "style": "lozenge-current"
                }
            },
            map {
                "label": "Waiting threads",
                "value": map {
                    "label": string(count($jmx/jmx:WaitingThreads/jmx:row)),
                    "style": "lozenge-current"
                }
            },
            map {
                "label": "Queries",
                "value": map {
                    "label": string(count($jmx/jmx:ProcessReport/jmx:RunningQueries/jmx:row)),
                    "style": "lozenge-current"
                }
            },
            map {
                "label": "Memory used",
                "value": map {
                    "label": xs:integer($jmx//jmx:HeapMemoryUsage/jmx:used) idiv 1024 idiv 2024 || "mb",
                    "style": "lozenge-success"
                }
            },
            map {
                "label": "CPU load",
                "value": map {
                    "label": $jmx//jmx:SystemCpuLoad/string(),
                    "style": "lozenge-complete"
                }
            }
        ]
    else
        []
};