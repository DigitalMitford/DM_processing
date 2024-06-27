xquery version "3.1";
import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";


declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html5";
declare option output:media-type "text/html";

$config:DEFAULT-REPO