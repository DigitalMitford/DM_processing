(:
 :  eXide - web-based XQuery IDE
 :
 :  Copyright (C) 2011 Wolfgang Meier
 :
 :  This program is free software: you can redistribute it and/or modify
 :  it under the terms of the GNU General Public License as published by
 :  the Free Software Foundation, either version 3 of the License, or
 :  (at your option) any later version.
 :
 :  This program is distributed in the hope that it will be useful,
 :  but WITHOUT ANY WARRANTY; without even the implied warranty of
 :  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 :  GNU General Public License for more details.
 :
 :  You should have received a copy of the GNU General Public License
 :  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 :)
xquery version "3.0";

import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";

declare function local:get-run-path($path) {
    let $appRoot := repo:get-root()
    return
        replace(
            if (starts-with($path, $appRoot)) then
                request:get-context-path() || "/" || request:get-attribute("$exist:prefix") || "/" ||
                substring-after($path, $appRoot)
            else
                request:get-context-path() || "/rest" || $path,
            "/{2,}", "/"
        )
};

let $path := request:get-parameter("path", ())
let $download := request:get-parameter("download", ())
let $indent := request:get-parameter("indent", true()) cast as xs:boolean
let $expand-xincludes := request:get-parameter("expand-xincludes", false()) cast as xs:boolean
let $omit-xml-declaration := request:get-parameter("omit-xml-decl", true()) cast as xs:boolean
let $mime := xmldb:get-mime-type($path)
let $isBinary := util:is-binary-doc($path)
(: Disable betterFORM filter :)
let $attribute := request:set-attribute("betterform.filter.ignoreResponseBody", "true")
let $header := response:set-header("Content-Type", if ($mime) then $mime else "application/binary")
let $header := response:set-header("X-Link", local:get-run-path($path))
let $header2 :=
    if ($download) then
        response:set-header("Content-Disposition", concat("attachment; filename=", replace($path, "^.*/([^/]+)$", "$1")))
    else
        ()
return
    if (config:access-allowed($path, sm:id()//sm:real/sm:username/string())) then
        if ($isBinary) then
            let $data := util:binary-doc($path)
            return
                response:stream-binary($data, $mime, ())
        else
            if (doc-available($path)) then
                (
                    (: workaround until https://github.com/eXist-db/exist/issues/2394 is resolved :)
                    util:declare-option(
                        "exist:serialize", 
                        "indent=" 
                            || (if ($indent) then "yes" else "no")
                            || " expand-xincludes=" 
                            || (if ($expand-xincludes) then "yes" else "no")
                            || " omit-xml-declaration=" 
                            || (if ($omit-xml-declaration) then "yes" else "no")
                    ),
                    doc($path)
                )
            else
                response:set-status-code(404)
    else
        response:set-status-code(404)
