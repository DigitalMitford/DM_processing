
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>View the years</title>
    <link rel="stylesheet" type="text/css" href="mitfordVisual.css"/>
</head>
<body>

<!--ebb: NOTHING ELSE goes in the body content now EXCEPT our PHP call to the XQuery that populates our sub-list. -->
<?php
    require_once("config.php");
    $contents = REST_PATH . "/db/2021-Dig400-Examples/autoPHPGetCars.xql";
    $result = file_get_contents($contents);
    echo $result;
?>

</body>
</html>
