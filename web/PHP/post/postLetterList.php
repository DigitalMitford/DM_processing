
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Read a document</title>
    <link rel="stylesheet" type="text/css" href="mitfordVisual.css"/>
</head>
<body>
<h1>Choose a document to read from the list below</h1>
<hr/>
<form action='postLetterText.php' method="post">
<select id='uri' name='uri'>
<?php
    require_once("config.php");
    $year = htmlspecialchars($_POST['year']);

//ebb: when I change this to $_POST, I generate an HTML page with the h1 element, but no PHP generated output.
//djb: it should be $_GET because it's being called from getYears.html with a GET URL
/*
    This includes a GET string, which you don't want if you're making a POST call
    $url = REST_PATH . "/db/queries/postLetterList.xql?year=$year";
*/
    $url = REST_PATH . "/db/queries/postLetterList.xql";
    $data = array('type' => 'input', 'year' => $year);
    $options = array(
    'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => http_build_query($data)
    )
);
    $context = stream_context_create($options);
    $result = file_get_contents($url, false, $context);
    echo $result;
?>
</select>

    <input type="submit" value="Submit Letter Selection" id="submit"/>
</form>
</body>
</html>
