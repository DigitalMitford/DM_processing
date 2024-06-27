xquery version "3.1";

(:~
 : XQSuite tests for the templating library.
 :
 : @author eXist-db Project
 : @version 1.0.0
 : @see http://exist-db.org
 :)

module namespace tt = "http://exist-db.org/templating/tests";

import module namespace templates="http://exist-db.org/xquery/html-templating";


declare namespace test="http://exist-db.org/xquery/xqsuite";

(:~
 : template with
 : - calls to functions annotated wit %templates:wrap
 : - nested template function calls
 : - and templates:each
 :)
declare variable $tt:template :=
    <html>
        <body data-template="tt:tf" class="body" data-extra="7">
            <ul>
                <li data-template="templates:each" data-template-from="data" data-template-to="item"
                    data-extra="23" class="item">
                    <span data-template="tt:n" data-extra="42" class="value"></span>
                </li>
            </ul>
        </body>
    </html>
;

declare variable $tt:data := 
    <data>
        <a n="1" />
        <a n="3" />
        <b n="2" />
        <c n="str" />
    </data>
;

(:~
 : minimum configuration to allow testing in XQSuite
 : as request:* is not bound to anything in this context
 :)
declare variable $tt:config-xqsuite-default := map {
    $templates:CONFIG_PARAM_RESOLVER : tt:resolver#1
};

(: templating configuration :)
declare variable $tt:config-filter := map {
    $templates:CONFIG_PARAM_RESOLVER : tt:resolver#1,
    $templates:CONFIG_FILTER_ATTRIBUTES : true()
};

(: templating configuration :)
declare variable $tt:config-no-filter := map {
    $templates:CONFIG_PARAM_RESOLVER : tt:resolver#1,
    $templates:CONFIG_FILTER_ATTRIBUTES : false()
};

(: parameters cannot be resolved with default resolver in XQSuite context :)
declare function tt:resolver ($m) { () };

declare function tt:lookup ($fn as xs:string, $arity as xs:integer) as function(*)? {
    function-lookup(xs:QName($fn), $arity)
};

(: helper function to test for the existence of data-attributes 
 : used in templating
 :)
declare
    %private
function tt:get-template-attribute-values ($xml as node()) {
    $xml//@*[starts-with(local-name(.), $templates:ATTR_DATA_TEMPLATE)]/string()
};

declare
    %private
function tt:get-extra-data-attribute-values ($xml as node()) {
    $xml//@data-extra/string()
};

declare
    %private
function tt:get-class-attribute-values ($xml as node()) {
    $xml//@class/string()
};

(:
 : ---------------------------
 : TEMPLATING
 : --------------------------- 
 :
 : templating functions for testing
 : Since functions annotated with %templates:replace do control the output
 : they are also in charge with to filter it. This is usually not necessary
 : as the output does not contain any data-templates-* attributes. 
 :)

declare
    %templates:wrap
function tt:tf ($node as node(), $model as map(*)) {
    count($model("data")),
    templates:process($node/node(), $model)
};

declare
    %templates:wrap
function tt:n ($node as node(), $model as map(*)) {
    $model("item")/@n/string()
};

(: ---------------------------
 : TESTS
 : --------------------------- :)

declare
    %test:assertEmpty
function tt:attributes-filtered-c() {
    templates:apply(
        $tt:template, tt:lookup#2,
        map { 'data': $tt:data//c }, 
        $tt:config-filter
    )
    => tt:get-template-attribute-values()
};

declare
    %test:assertEmpty
function tt:attributes-filtered-a() {
    templates:apply(
        $tt:template, tt:lookup#2,
        map { 'data': $tt:data//a }, 
        $tt:config-filter
    )
    => tt:get-template-attribute-values()
};

declare
    %test:assertEquals("7", "23", "42", "23", "42")
function tt:attributes-filtered-a-extra() {
    templates:apply(
        $tt:template, tt:lookup#2,
        map { 'data': $tt:data//a }, 
        $tt:config-filter
    )
    => tt:get-extra-data-attribute-values()
};

declare
    %test:assertEquals("body", "item", "value", "item", "value")
function tt:attributes-filtered-a-class() {
    templates:apply(
        $tt:template, tt:lookup#2,
        map { 'data': $tt:data//a }, 
        $tt:config-filter
    )
    => tt:get-class-attribute-values()
};

declare
    %test:assertEquals("tt:tf", "templates:each", "data", "item", "tt:n")
function tt:attributes-unfiltered-c() {
    templates:apply(
        $tt:template, tt:lookup#2,
        map { 'data': $tt:data//c }, 
        $tt:config-no-filter
    )
    => tt:get-template-attribute-values()
};

declare
    %test:assertEquals("tt:tf", "templates:each", "data", "item", "tt:n", "templates:each", "data", "item", "tt:n")
function tt:attributes-unfiltered-a() {
    templates:apply(
        $tt:template, tt:lookup#2,
        map { 'data': $tt:data//a },
        $tt:config-no-filter
    )
    => tt:get-template-attribute-values()
};

declare
    %test:assertEquals("tt:tf", "templates:each", "data", "item", "tt:n", "templates:each", "data", "item", "tt:n")
function tt:attributes-unfiltered-by-default() {
    templates:apply(
        $tt:template, tt:lookup#2,
        map { 'data': $tt:data//a },
        $tt:config-xqsuite-default
    )
    => tt:get-template-attribute-values()
};
