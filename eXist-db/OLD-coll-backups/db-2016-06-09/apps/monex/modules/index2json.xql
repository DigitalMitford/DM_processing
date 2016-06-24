xquery version "3.0";
declare namespace json="http://www.json.org";
declare option exist:serialize "method=json media-type=text/javascript";

let $col := request:get-parameter("col", ())
return 
<collection>
    <name>eXist-db Visualizer</name>
    <children>{
        util:index-keys(
            collection($col), (), 
            function($key, $count) {
                
                            <json:value>
                                <name>{$key}</name>
                                <size json:literal="true">{$count[2]}</size>
                            </json:value>
            }, -1, "structural-index")
        }
</children>
</collection>