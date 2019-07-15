xquery version "3.0";

import module namespace login="http://exist-db.org/xquery/login" at "resource:org/exist/xquery/modules/persistentlogin/login.xql";

declare namespace json="http://www.json.org";

declare variable $exist:root external;
declare variable $exist:prefix external;
declare variable $exist:controller external;
declare variable $exist:path external;
declare variable $exist:resource external;

if ($exist:path eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{concat(request:get-uri(), '/')}"/>
    </dispatch>
else if ($exist:path eq "/") then
    (: forward root path to index.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="index.html"/>
    </dispatch>

else if ($exist:resource eq "login") then
    let $loggedIn := login:set-user("org.exist.login", (), true())
    return
        try {
            util:declare-option("exist:serialize", "method=json"),
            <status>
                <user>{request:get-attribute("org.exist.login.user")}</user>
                <isAdmin json:literal="true">{ xmldb:is-admin-user(request:get-attribute("org.exist.login.user")) }</isAdmin>
            </status>
        } catch * {
            response:set-status-code(401),
            <status>{$err:description}</status>
        }
        
else if (ends-with($exist:resource, ".html")) then
    let $loggedIn := login:set-user("org.exist.login", (), true())
    return
        (: the html page is run through view.xql to expand templates :)
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <view>
                <forward url="{$exist:controller}/modules/view.xql">
                    <set-attribute name="$exist:prefix" value="{$exist:prefix}"/>
                    <set-attribute name="$exist:controller" value="{$exist:controller}"/>
                </forward>
            </view>
        </dispatch>

else if ($exist:resource = "reindex.xql") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        {login:set-user("org.exist.login", (), false())}
    </dispatch>
    
(: Requests for javascript libraries are resolved to the file system :)
else if (contains($exist:path, "/$shared/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="/shared-resources/{substring-after($exist:path, '/$shared/')}"/>
    </dispatch>
    
else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>