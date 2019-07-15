xquery version "3.0";
let $appTester := request:get-parameter("header", "index.html")
return <html>{$appTester}</html>

