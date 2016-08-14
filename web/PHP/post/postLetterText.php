
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Document View</title>
    <link rel="stylesheet" type="text/css" href="mitfordletter.css" /><script type="text/javascript" src="MRMLetters.js" xml:space="preserve">...</script>

</head>
<body>
<h1>Document View</h1>
<hr/>
<?php
    require_once("config.php");
    $uri = htmlspecialchars($_POST['uri']);
//ebb: with this, I generate an HTML page with the h1 element, and evidently part of my XQuery script is firing,
// but evidently failing to retrieve the "uri" parameter, because I generate PART of the transformed XSLT file but the letter
// is missing! The XSLT is evidently firing to produce the basic template of the page but fails to retrieve and transform the XML file.
// If I change this to $_GET, I do successfully retrieve the XML file, and its URL appears in the browser.
/*
    This has the same problem as postLetterList.php; you should omit the GET query string from the URL when you use POST
    $contents = REST_PATH . "/db/queries/letterText.xql?uri=$uri";
*/
    $contents = REST_PATH . "/db/queries/letterText.xql";
    $data = array('type' => 'input', 'uri' => $uri);
    $options = array(
    'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => http_build_query($data)
    )
);
    $context = stream_context_create($options);
    $result = file_get_contents($contents, false, $context);
    echo $result;
?>
</body>
</html>
