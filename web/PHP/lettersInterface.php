
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Digital Mitford: The Mary Russell Mitford Archive</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="Description" content="Supported by the University of Pittsburgh at Greensburg and the Mary Russell Mitford Society."/>
    <meta name="keywords" content="Mitford, Mary Russell Mitford, Digital Mitford, Digital Mary Russell Mitford, Digital Mary Russell Mitford Archive, Mitford Archive, digital edition, electronic edition, electronic text, Romanticism, Romantic literature, Victorianism, Victorian literature, humanities computing, electronic editing, Beshero-Bondar"/>
    <link rel="stylesheet" type="text/css" href="mitfordVisual.css"/>
    <script type="text/javascript" src="letterList.js">/**/</script>


</head>
<body>

<?php include("mitfordMainMenu.html"); ?>

<div id="container">


   <div id="lettersContent"> 
        <h2>Mitford’s Letters</h2>



        <h3>Letters interface</h3>
        <p>This interface represents our encoding so far of a selection of letters held in the Reading Central Library and the John Rylands Library from the years 1819-1825, years that the Mitford team has identified as pivotal in the shaping of Mitford’s literary career as she began developing her plays and short fiction. The editions displayed here are <em>active work in progress</em>, in a reasonably complete form suitable for reading but possibly requiring corrections or additional work. As we add newly coded letters and file corrections to our database, the list of available material and the editions of letters will update here. Click (or tap) on a year below to view the available letters.</p>
        <ul>
<?php
    require_once("config.php");
    $contents = REST_PATH . "/db/queries/letterDates.xql";
    $result = file_get_contents($contents);
    echo $result;
?>
</ul>
        <p>Please note that the letters represented here may not be in a complete, finalized state, but we present them here as an aid to the community and to the team itself as we continue our work. Currently links to manuscript images will not yet work as we're working on a good way to select and include the photo facsimiles that we are permitted to publish here. If you discover other errors in the interface or in the encoding, please <a href="mailto:ebb8@pitt.edu">contact us</a>; we appreciate your help!</p>

   </div>
    <?php include("licenseSoftware.html"); ?>
</div>

</body>
</html>
