xquery version "3.0";

(:~
: User: joern
: Date: 07.04.17
: Time: 11:44
: To change this template use File | Settings | File Templates.
:)

import module namespace packages="http://exist-db.org/apps/existdb-packages" at "packages.xqm";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html5";
declare option output:media-type "text/html";

<repo-packages>
{
    let $packages := packages:get-local-packages()
    for $p in $packages
        order by lower-case(data($p/repo-title))
        return $p
}
</repo-packages>
