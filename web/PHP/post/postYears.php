
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>View the years</title>
    <link rel="stylesheet" type="text/css" href="mitfordVisual.css"/>
</head>
<body>
<h1>Years</h1>
<hr/>
<p>Select a year to view of list of letters from that year</p>
<form action='postLetterList.php' method="post">
    <select id="year" name="year" title="year">
<?php
    require_once("config.php");
    $contents = REST_PATH . "/db/queries/postLetterDates.xql";
    $result = file_get_contents($contents);
    echo $result;
?>
    </select>

    <input type="submit" value="Submit Year" id="submit"/>
</form>
</body>
</html>
