xquery version "3.0";
import module namespace test="http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";
import module namespace console="http://exist-db.org/xquery/console";

console:log("executing test suite"),
test:suite(
    inspect:module-functions(xs:anyURI("test-app.xql"))
),
console:log("finished test suite")