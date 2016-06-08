xquery version "3.0";

module namespace app="http://exist-db.org/apps/xsltforms-demo";
declare namespace html="http://www.w3.org/1999/xhtml";

import module namespace config="http://exist-db.org/apps/xsltforms-demo/config" at "config.xqm";

(:~
 : List the examples described in examples.xml.
 : TODO: fill in more of the contents of examples.xml.
 
 : @param $node the HTML node with the class attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)

declare function app:list-examples($node as node(), $model as map(*), $group as xs:string) {    
            for $example in doc(concat($config:app-data, "/examples.xml"))//example[group eq $group]
                let $form := $example/document-name/text()
                let $title := $example/title
            return
                <li>
                    <a href="modules/form.xq?form={$form}" target="_blank">{$title/text()}</a>
                </li>    
};
