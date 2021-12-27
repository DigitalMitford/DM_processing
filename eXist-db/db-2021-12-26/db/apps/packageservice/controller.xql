xquery version "3.0";

declare namespace json="http://www.json.org";
declare namespace control="http://exist-db.org/apps/dashboard/controller";

import module namespace login-helper="http://exist-db.org/apps/dashboard/login-helper" at "modules/login-helper.xql";

import module namespace packages="http://exist-db.org/apps/existdb-packages" at "modules/packages.xqm";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

declare variable $login := login-helper:get-login-method();

request:set-attribute("betterform.filter.ignoreResponseBody", "true"),
if(starts-with($exist:path,"/packages/local")) then
        try {
            let $loggedIn := $login("org.exist.login",  (), true())
            let $user := request:get-attribute("org.exist.login.user")
            return
                if ($user and sm:is-dba($user)) then (
                    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                        (:<forward url="{$exist:controller}/modules/local-packages.xql"></forward>:)
                        <forward url="{$exist:controller}/modules/local-packages.xql"></forward>
                    </dispatch>
                )
                else (
                    response:set-status-code(403)
                )
        } catch * {
            response:set-status-code(403)
        }

else if(starts-with($exist:path,"/packages/apps")) then
        try {
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                (:<forward url="{$exist:controller}/modules/local-apps.xql"></forward>:)
                <forward url="{$exist:controller}/modules/local-apps.xql"></forward>
            </dispatch>
        } catch * {
            response:set-status-code(500)
        }

else if(starts-with($exist:path,"/packages/remote")) then
        try {
            let $loggedIn := $login("org.exist.login",  (), true())
            let $user := request:get-attribute("org.exist.login.user")
            return
                if ($user and sm:is-dba($user)) then (
                    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                        (:<forward url="{$exist:controller}/modules/remote-packages.xql"></forward>:)
                        <forward url="{$exist:controller}/modules/remote-packages.xql"></forward>
                    </dispatch>
                )
                else (
                    response:set-status-code(403)
                )
        } catch * {
            response:set-status-code(403)
        }
else if(starts-with($exist:path,"/packages/action")) then
        try {
            let $loggedIn := $login("org.exist.login",  (), true())
            let $user := request:get-attribute("org.exist.login.user")
            return
                if ($user and sm:is-dba($user)) then (
                    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                        <forward url="{$exist:controller}/modules/install.xql"></forward>
                    </dispatch>
                )
                else (
                    response:set-status-code(403)
                )
        } catch * {
            response:set-status-code(403)
        }

else if(starts-with($exist:path,"/package/icon")) then
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/get-icon.xql"></forward>
        </dispatch>
else if(starts-with($exist:path,"/packages/public-url")) then
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/get-public-url.xql"></forward>
        </dispatch>
else if(starts-with($exist:path, "/resources")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>
else
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/no-service.html"></forward>
    </dispatch>
