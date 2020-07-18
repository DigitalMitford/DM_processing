xquery version "1.0";

declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace xf="http://www.w3.org/2002/xforms";

import module namespace config="http://exist-db.org/apps/xsltforms-demo/config" at "config.xqm";

(:~
: Here $node is the document or XML fragment to work on, $new-node is the new element to insert, $element-name-to-check is which other element to use as a reference for inserting $new-node, and $location gives the option of inserting $new-node before, after, or as the first or last child of $element-name-to-check. $location accepts four values: 'before', 'after', 'first-child', and 'last-child' (if another value is given, $element-name-to-check is removed).
:
: @author Jens Østergaard Petersen
: @param $node The XML document or fragment that one wishes to insert elements into.
: @param $new-node The element to insert.
: @param $element-name-to-check The element in $node in relation to which to insert $new-node.
: @param $location The location one wishes to insert $new-node in relation to $element-name-to-check. 
    The options are "before", "after", "first-child" and "last-child". 
: @return $node with $new-node inserted in the $location in relation to $element-name-to-check  
:)
declare function local:insert-element($node as node()?, $new-node as node(), 
    $element-name-to-check as xs:string, $location as xs:string) { 
        if (local-name($node) eq $element-name-to-check)
        then
            if ($location eq 'before')
            then ($new-node, $node) 
            else 
                if ($location eq 'after')
                then ($node, $new-node)
                else
                    if ($location eq 'first-child')
                    then element { node-name($node) } { 
                        $node/@*
                        ,
                        $new-node
                        ,
                        for $child in $node/node()
                            return 
                                (:local:insert-element($child, $new-node, $element-name-to-check, $location):)
                                $child
                    }
                    else
                        if ($location eq 'last-child')
                        then element { node-name($node) } { 
                            $node/@*
                            ,
                            for $child in $node/node()
                                return 
                                    (:local:insert-element($child, $new-node, $element-name-to-check, $location):)
                                    $child 
                            ,
                            $new-node
                        }
                        else () (:The $element-to-check is removed if none of the four options are used.:)
        else
            if ($node instance of element()) 
            then
                element { node-name($node) } { 
                    $node/@*
                    , 
                    for $child in $node/node()
                        return 
                            local:insert-element($child, $new-node, $element-name-to-check, $location) 
             }
         else $node
};

let $form-name := request:get-parameter("form", "")
let $form-entry := doc(concat($config:app-data, "/", 'examples.xml'))//example[document-name eq $form-name]
let $form-path := concat($config:app-data, '/', $form-name)
let $data-file-name := $form-entry/data-file/text()
let $data-file-path := concat($config:app-data, '/', $data-file-name)
let $form-description := <div class="description">{$form-entry/description}</div>
return
    if ($form-name)
    then 
        let $form-doc := doc($form-path)/html:html
        
        let $css-to-be-added := doc(concat($config:app-data, "/css.xml"))
        let $form-doc := local:insert-element($form-doc, $css-to-be-added, 'head', 'last-child') 
        
        let $eXide-button-data-file-path :=
        if ($data-file-name)
        then
            <div xmlns="http://www.w3.org/1999/xhtml" class="source">
            <div class="toolbar">
                    <a class="btn" href="/exist/apps/eXide/index.html?open={$data-file-path}" target="eXide" data-type="XML"
                        title="Opens the code in eXide.">Open data file in eXide</a>
                </div>
            </div>
            else ()
        let $form-doc := 
            if ($data-file-name)
            then
                local:insert-element($form-doc, $eXide-button-data-file-path, 'body', 'first-child')
            else
                $form-doc

        let $eXide-button-form-path :=
            <div xmlns="http://www.w3.org/1999/xhtml" class="source">
            <div class="toolbar">
                    <a class="btn" href="/exist/apps/eXide/index.html?open={$form-path}" target="eXide" data-type="XML"
                        title="Opens the form in eXide.">Open form in eXide</a>
                </div>
            </div>
        let $form-doc := local:insert-element($form-doc, $eXide-button-form-path, 'body', 'first-child') 
        
        let $form-doc := 
            if ($form-description)
            then local:insert-element($form-doc, $form-description, 'body', 'last-child')
            else $form-doc
        
        let $form-doc := local:insert-element($form-doc, $form-description, 'iframe', 'remove')
        
        let $dummy := request:set-attribute("betterform.filter.ignoreResponseBody", "true")
        let $xslt-pi := processing-instruction xml-stylesheet {'type="text/xsl" href="/exist/rest/db/apps/xsltforms/xsltforms.xsl"'}
        let $debug := processing-instruction xsltforms-options {'debug="yes"'}
            return ($xslt-pi, $debug, $form-doc)
    else ()