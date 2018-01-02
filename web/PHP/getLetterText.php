
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Digital Mitford: Letter View</title>
    <link rel="stylesheet" type="text/css" href="mitfordletter.css" /><script type="text/javascript" src="MRMLetters.js">/**/</script>
</head>
<body>
<div id="nav_wide">
    <div id="menu">
        <ul id="siteMenu">
            <li class="title"><span class="mainTitle">Digital Mitford:</span><br/> <span class="subTitle">The Mary Russell Mitford Archive</span></li>
            <li class="mainMenu">
                <ul class="mainMenu">
                    <li class="section" id="home">
                       <a href="index.html">Main Home</a>
                    </li>
                    <li class="section" id="letters">
                       <ul class="subSec">
                           <li class="subMenu"><a href="letters.html">Letters Main</a></li>           
                           <li class="subMenu"><a href="lettersInterface.php">Choose a new letter</a></li>
                           <li> <a href="<?php
                               require_once("config.php");
                               $uri = htmlspecialchars($_GET["uri"]);
                               $contents = REST_PATH . "/db/mitford/letters/$uri";
                               echo $contents;
                               ?>
">TEI encoding of this letter</a></li>
                       </ul>
                    </li>
                   <li class="section" id="Bib"><!--Bibliography &amp; MSS-->
                    <ul class="subSec">
                        <li class="subMenu"><a href="bibliogType.html">Bibliography</a></li>
                        <li class="subMenu"><a href="lettersData.html">Manuscript Locations</a></li>
                        
                    </ul>
                </li>
                </ul>
            </li>
        </ul>
  </div>
</div>   

<?php
    require_once("config.php");
    $uri = htmlspecialchars($_GET["uri"]);
    $contents = REST_PATH . "/db/queries/letterText.xql?uri=$uri";
    $result = file_get_contents($contents);
    echo $result;
?>
</body>
</html>
