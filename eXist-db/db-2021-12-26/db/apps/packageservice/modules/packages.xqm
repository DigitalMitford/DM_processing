xquery version "3.1";

module namespace packages="http://exist-db.org/apps/existdb-packages";

import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";
import module namespace functx = "http://www.functx.com";
import module namespace semver = "http://exist-db.org/xquery/semver";

declare namespace json="http://www.json.org";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace rest="http://exquery.org/ns/restxq";
declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace http="http://expath.org/ns/http-client";


declare option output:method "html5";
declare option output:media-type "text/html";

declare variable $packages:configuration := doc($config:app-root || "/configuration.xml");

declare variable $packages:DEFAULTS := doc($config:app-root || "/defaults.xml")/apps;
declare variable $packages:ADMINAPPS := ["dashboard","backup"];
declare variable $packages:HIDE := ("dashboard");

(:~
 : fetch the complete list of locally installed applications and libaries
 :)
declare function packages:get-local-packages(){
    packages:get-local-applications() | packages:get-local-libraries()
};


(:~
 : fetch the list of locally installed applications
 :)
declare function packages:get-local-applications(){
    packages:get-local("application")
};

(:~
 : fetch the list of locally installed libraries
 :)
declare function packages:get-local-libraries(){
    packages:get-local("library")
};

(:~
 : fetches all remote packages from public repo and filters out packages that are already in the list
 : of local packages. In case there's a version that is newer in the repository list it will be marked with
 : the attriburtes 'available' and 'installed'.
 :)
declare function packages:get-remote(){
    let $local := packages:get-local-packages()
    let $repo := packages:public-repo-contents(())

    let $result :=
        for $app in $repo
            let $e := if(exists($local/@url[. = $app/name])) then
                            if (packages:is-newer($app/version/string(), $local[@url = $app/name]/repo-version)) then
                                element { node-name($app) } {
                                    attribute available { $app/version/string() },
                                    attribute installed { $local[repo-abbrev = $app/abbrev]/repo-version/string() },
                                    $app/@*,
                                    $app/*
                                }
                            else
                                ()
                        else
                            $app
            order by lower-case($app/title)
            return $e
    return $result
};


(:
declare function packages:get-remote-packages(){

    :)
(: todo: include libs not just apps :)(:

    let $apps := packages:public-repo-contents(packages:installed-apps("application"))
    let $allowed-apps :=
        for $app in $apps
            let $db-path := "/db/" || substring-after(data($app/url),"/exist/")

            order by upper-case($app/title/text())
            return
                 if(sm:has-access(xs:anyURI($db-path),"r-x")) then
                     $app
                 else ()

    return
        if($allowed-apps) then(
            $allowed-apps
        )
        else (
            <no-packages>You do not have sufficient priviledges to view packages</no-packages>
        )
};
:)

declare function packages:get-repo-locations(){
    data($packages:configuration//repository)
};


(:~
 : returns a list of locally installed apps of a given type ('application' or 'library'). It is checked
 : wether the calling user has to the given package.
 :)
(: should be private but there seems to be a bug :)

declare function packages:get-local($type as xs:string){
(:    let $log := util:log("info", "user: " || sm:id()//sm:real/sm:username/string()):)

    let $apps :=  packages:installed-apps($type)
    let $allowed-apps :=
         for $app in $apps
         (: todo: this path matching is hardly good enough i guess - how to do better? :)
             let $db-path := "/db/" || substring-after(data($app/url),"/exist/")

             let $groups := sm:get-user-groups(sm:id()//sm:real/sm:username/string())

             order by upper-case($app/repo-title/text())
             return
                 if(sm:has-access(xs:anyURI($db-path),"r-x")) then $app
                 else ()

    return
        if($allowed-apps) then(
            $allowed-apps
        )
        else (
            <no-packages>You do not have sufficient priviledges to view packages</no-packages>
        )
};


(: should be private but there seems to be a bug :)
declare function packages:installed-apps($type as xs:string) as element(repo-app)* {

    (:let $path := functx:substring-before-last(request:get-uri(),'/existdb-packages'):)
    let $path := request:get-context-path() || substring-after($config:app-root,'/db')
    return
    packages:scan-repo(
        function ($app, $expathXML, $repoXML) {
            if ($repoXML//repo:type = $type) then
                let $app-url :=
                    if ($repoXML//repo:target) then
                        let $target :=
                            if (starts-with($repoXML//repo:target, "/")) then
                                replace($repoXML//repo:target, "^/.*/([^/]+)", "$1")
                            else
                                $repoXML//repo:target
                        return
                            replace(
                                request:get-context-path() || "/" || request:get-attribute("$exist:prefix") || "/" || $target || "/",
                                "/+", "/"
                            )
                    else
                        ()


                let $icon :=
                    let $iconRes := repo:get-resource($app, "icon.png")
                    let $iconSvg := repo:get-resource($app, "icon.svg")
                    let $hasIcon := exists($iconRes) or exists($iconSvg)
                    return
                        $hasIcon

                let $src :=
                  if ($icon) then $path || '/package/icon?package=' || $app
                  else $path || '/resources/images/package.png'

                (: check if package-url is present in readonly section of configuration.xml :)
                let $readonly := data($expathXML//@name) = $config:SETTINGS//package

                return
                    <repo-app url="{$expathXML//@name}"
                              abbrev="{$expathXML//@abbrev/string()}"
                              type="{$repoXML//repo:type/text()}"
                              version="{$expathXML//expath:package/@version/string()}"
                              status="installed"
                              path="{$app-url}"
                              readonly="{$readonly}">
                        <repo-icon src="{$src}">&#160;</repo-icon>
                        <repo-type>{$repoXML//repo:type/text()}</repo-type>
                        {
                            if (string-length($expathXML//expath:title/text()) != 0) then
                                <repo-title>{$expathXML//expath:title/text()}</repo-title>
                            else
                                <repo-title>unknown title</repo-title>

                        }
                        {
                            if(string-length($expathXML//expath:package/@version/string()) != 0) then
                                <repo-version>{$expathXML//expath:package/@version/string()}</repo-version>
                            else
                                <repo-version>unknown</repo-version>
                        }
                        {
                            if (string-length($app-url) != 0) then
                            <repo-url>{$app-url}</repo-url>
                            else ()
                        }

                        {
                            if(string-length($expathXML//@name/string()) != 0) then
                                <repo-name>{$expathXML//@name/string()}</repo-name>
                            else
                                <repo-name>unknown name</repo-name>
                        }
                        {
                            if(string-length($repoXML//repo:description/text()) != 0) then
                                <repo-description>{$repoXML//repo:description/text()}</repo-description>
                            else ()
                        }
                        <repo-authors>
                        {
                            for $author in $repoXML//repo:author
                            let $author := if (string-length($author/text()) != 0) then
                                <repo-author>{$author/text()}</repo-author>
                            else ()
                            return
                                $author
                        }
                        </repo-authors>
                        {
                            if(string-length($expathXML//@abbrev/string()) != 0) then
                                <repo-abbrev>{$expathXML//@abbrev/string()}</repo-abbrev>
                            else ()
                        }
                        {
                        if(string-length($repoXML//repo:website/text()) != 0) then
                            <repo-website>{$repoXML//repo:website/text()}</repo-website>
                        else ()
                        }
                        {
                            if(string-length($repoXML//repo:license/text()) != 0) then
                                <repo-license>{$repoXML//repo:license/text()}</repo-license>
                            else ()
                        }
                    </repo-app>
            else
                ()
        }
    )
};



(: should be private but there seems to be a bug :)
declare function packages:scan-repo($callback as function(xs:string, element(), element()?) as item()*) {
    for $app in repo:list()
    let $expathMeta := packages:get-package-meta($app, "expath-pkg.xml")
    let $repoMeta := packages:get-package-meta($app, "repo.xml")
    return
        $callback($app, $expathMeta, $repoMeta)
};

(: should be private but there seems to be a bug :)
declare function packages:get-package-meta($app as xs:string, $name as xs:string) {
    let $data :=
        let $meta := repo:get-resource($app, $name)
        return
            if (exists($meta)) then util:binary-to-string($meta) else ()
    return
        if (exists($data)) then
            try {
                parse-xml($data)
            } catch * {
                <meta xmlns="http://exist-db.org/xquery/repo">
                    <description>Invalid repo descriptor for app {$app}</description>
                </meta>
            }
        else
            ()
};

(: should be private but there seems to be a bug :)
declare function packages:public-repo-contents($installed as element(repo-app)*) {
    try {
        let $url := $config:DEFAULT-REPO || "/public/apps.xml?version=" || packages:get-version() ||
            "&amp;source=" || util:system-property("product-source")
        (: EXPath client module does not work properly. No idea why. :)
        let $request :=
            <http:request method="get" href="{$url}" timeout="10">
                <http:header name="Cache-Control" value="no-cache"/>
            </http:request>
        let $data := http:send-request($request)
        let $status := xs:int($data[1]/@status)
        return
            if ($status != 200) then
                response:set-status-code($status)
            else
                for-each($data[2]//app, function($app as element(repo-app)) {
                    (: Ignore apps which are already installed :)
                    if ($app/name = $installed/@url) then
                        (: todo: change newer check to use the url instead of abbrev to compare :)
                        if (packages:is-newer($app/version/string(), $installed[@url = $app/name]/version)) then
                            element { node-name($app) } {
                                attribute available { $app/version/string() },
                                attribute installed { $installed[abbrev = $app/abbrev]/version/string() },
                                $app/@*,
                                $app/*
                            }
                        else
                            ()
                    else
                        $app
                })
    } catch * {
        util:log("ERROR", "Error while retrieving app packages: " || $err:description)
    }
};

(: should be private but there seems to be a bug :)
declare function packages:get-version() {
    (util:system-property("product-semver"), util:system-property("product-version"))[1]
};

(: should be private but there seems to be a bug :)
declare function packages:required-version($required as element(requires)) {
    string-join((
        if ($required/@semver-min) then
            " > " || $required/@semver-min
        else
            (),
        if ($required/@semver-max) then
            " < " || $required/@semver-max
        else
            (),
        if ($required/@version) then
            " " || $required/@version
        else
            ()
    ))
};

(: should be private but there seems to be a bug :)
declare function packages:is-newer($available as xs:string, $installed as xs:string) as xs:boolean {
    semver:gt($available, $installed, true())
};

declare function packages:packages-as-json($packages as element()*){
    for $p in $packages
        let $abbrev := data($p/@abbrev)
        let $authors := $p/repo-authors
        let $description := data($p/repo-description)
        let $icon := data($p/repo-icon/@src)
        let $name := data($p/repo-name)
        let $path := data($p/@path)
        let $readonly := data($p/@readonly)
        let $status := data($p/@status)
        let $title := data($p/repo-title)
        let $type := data($p/@type)
        let $url := data($p/@url)
        let $version := data($p/@version)
        let $website := data($p/repo-website)
        order by lower-case(data($p/repo-title))
        return map {
            "abbrev": $abbrev,
            "authors": array {
                for $a in $authors
                let $author := data($a/repo-author)
                return $author
            },
            "description": $description,
            "icon": $icon,
            "name": $name,
            "path": $path,
            "readonly": $readonly,
            "status": $status,
            "title": $title,
            "type": $type,
            "url": $url,
            "version": $version,
            "website": $website
        }
};
