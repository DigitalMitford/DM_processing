
<ul>
<?php
    require_once("config.php");
    $year = htmlspecialchars($_GET["year"]);
    $contents = REST_PATH . "/db/queries/letterList.xql?year=$year";
    $result = file_get_contents($contents);
    echo $result;
?>
</ul>

