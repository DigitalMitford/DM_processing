
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Digital Mitford: Letter View</title>
    <link rel="stylesheet" type="text/css" href="mitfordletter.css" /><script type="text/javascript" src="MRMLetters.js">/**/</script>
</head>
<body>

<?php
    require_once("config.php");
    $uri = htmlspecialchars($_GET["uri"]);
    $contents = REST_PATH . "/db/queries/letterText.xql?uri=$uri";
    $result = file_get_contents($contents);
    echo $result;
?>
</body>
</html>
