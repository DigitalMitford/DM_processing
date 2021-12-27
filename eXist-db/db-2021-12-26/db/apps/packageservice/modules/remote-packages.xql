xquery version "3.1";

(:~
: User: joern
: Date: 07.04.17
: Time: 11:45
: To change this template use File | Settings | File Templates.
:)

import module namespace packages="http://exist-db.org/apps/existdb-packages" at "packages.xqm";
import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html5";
declare option output:media-type "text/html";

<repo-packages>
    {
        let $pkgs := packages:get-remote()
        return
            (: display all available updates EXCEPT for packageservice, 
             : since installing this over a live instance will crash the database! :)
            for $pkg in $pkgs[name ne "http://exist-db.org/apps/existdb-packageservice"]

            (:let $path := '/exist/' || substring-after($config:app-root,'/db/'):)
            let $path := request:get-context-path() || substring-after($config:app-root,'/db')
            let $icon :=    if (exists($pkg/icon)) then
                                $config:DEFAULT-REPO || "/public/" || $pkg/icon[1]
                            else
                                $path || "/resources/images/package.png"
            order by $pkg/@available, lower-case($pkg/title)
            return
                <repo-app url="{data($pkg/name)}"
                          abbrev="{data($pkg/abbrev)}"
                          type="{data($pkg/type)}"
                          version="{data($pkg/version)}"
                          status="available">
                    {
                        if(exists($pkg/@installed)) then
                        attribute{"class"}{"update"}
                        else()
                    }
                    <repo-icon src="{$icon}">&#160;</repo-icon>
                    <repo-type>{data($pkg/type)}</repo-type>
                    <repo-title>{data($pkg/title)}</repo-title>
                    <repo-version>{data($pkg/version)}</repo-version>
                    {
                        if(exists($pkg/@installed)) then
                            <repo-installed>{data($pkg/@installed)}</repo-installed>
                        else ()
                    }
                    {
                        if(exists($pkg/@available)) then
                            <repo-available>{data($pkg/@available)}</repo-available>
                        else()
                    }
                    <repo-name>{data($pkg/name)}</repo-name>
                    <repo-description>{data($pkg/description)}</repo-description>

                    <repo-authors>
                    {
                    for $author in $pkg//author
                    return
                        <repo-author>{data($author)}</repo-author>
                    }
                    </repo-authors>

                    <repo-abbrev>{data($pkg/abbrev)}</repo-abbrev>

                    {
                    if (exists($pkg/website)) then
                        <repo-website>{data($pkg/website)}</repo-website>
                    else ()
                    }

                    <repo-license>{data($pkg/license)}</repo-license>

                    {
                    if(exists($pkg/requires)) then
                        <repo-requires processor="{data($pkg/requires/@processor)}" semver-min="{data($pkg/requires/@semver-min)}"> </repo-requires>
                    else ()
                    }
                    {
                    if(exists($pkg/changelog)) then
                        <repo-changelog>
                            {
                            for $change in $pkg/changelog//change
                            return
                                <repo-change version="{data($change/@version)}">{$change/*}</repo-change>
                            }
                        </repo-changelog>
                    else ()
                    }
                    {
                    if(exists($pkg/other)) then
                        <repo-other>
                            {
                            for $version in $pkg/other/version
                            return
                                <repo-version version="{data($version/@version)}" path="{data($version/@path)}">
                                    {
                                    if (exists($version/requires)) then
                                        <repo-requires processor="{data($version/requires/@processor)}"></repo-requires>
                                    else ()
                                    }
                                </repo-version>
                            }
                        </repo-other>
                    else ()
                    }
                    {
                    if(exists($pkg/note)) then
                        <repo-note>{data($pkg/note)}</repo-note>
                    else ()
                    }
                </repo-app>
    }
</repo-packages>
