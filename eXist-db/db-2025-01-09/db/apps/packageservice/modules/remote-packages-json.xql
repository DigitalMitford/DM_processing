xquery version "3.1";

(:~
: User: joern
: Date: 07.04.17
: Time: 11:45
: To change this template use File | Settings | File Templates.
:)

import module namespace packages="http://exist-db.org/apps/existdb-packages" at "packages.xqm";
import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:media-type "application/json";

let $json := array {
    let $pkgs := packages:get-remote()
    for $pkg in $pkgs
        let $path := request:get-context-path() || substring-after($config:app-root,'/db')
        let $icon :=    if (exists($pkg/icon)) then
                            $config:DEFAULT-REPO || "/public/" || $pkg/icon[1]
                        else
                            $path || "/resources/images/package.png"

        let $abbrev := data($pkg/abbrev)
        let $authors := $pkg//author

        let $available := data($pkg/@available)
        let $description := data($pkg/description)
        let $installed := data($pkg/@installed)
        let $name := data($pkg/name)
        let $type := data($pkg/type)
        let $url := data($pkg/name)
        let $version := data($pkg/version)
        let $website := data($pkg/website)
        let $license := data($pkg/license)
        let $processor := data($pkg/requires/@processor)
        let $semver-min := data($pkg/requires/@semver-min)
        let $changelog := $pkg/changelog//change
        let $others := $pkg/other/version
        let $note := data($pkg/note)

        order by $pkg/@available, lower-case($pkg/title)
        return map {
            "path": $path,
            "icon": $icon,
            "abbrev": $abbrev,
            "authors": array {
               for $a in $authors
               return data($a)
             },
             "available": $available,
             "description": $description,
             "installed": $installed,
             "name": $name,
             "type": $type,
             "url": $url,
             "version": $version,
             "website": $website,
             "license": $license,
             "requires": map{
                "processor": $processor,
                "semver-min": $semver-min
             },
             "changes": array{
                for $change in $changelog
                let $v := data($change/@version)
                order by $v descending
                return map {
                    "version": $v,
                    "change": $change
                }
             },
             "other": array{
                for $o in $others
                let $v := data($o/@version)
                let $p := data($o/@path)
                let $processor := data($o/requires/@processor)
                let $semver-min := data($o/requires/@semver-min)
                order by $v descending
                return map {
                    "version": $v,
                    "path": $p,
                    "requires":map{
                        "processor": $processor,
                        "semver-min": $semver-min
                    }
                }
             },
             "note": $note

        }
}

return $json

