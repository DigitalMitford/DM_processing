<?php
/**
 * Created by PhpStorm.
 * User: EBB8
 * Date: 6/25/2015
 * Time: 5:44 PM
 */

$servername = "dxcvm05.psc.edu";
$username = "mitford";
$password = "r13nz1";
$database = "DigiMitford";

//Create connection
$conn = mysqli_connect ($servername, $username, $password, $database, 3306);

//mysqli_connect("localhost","my_user","my_password","my_db");

//Check connection
if (!conn || mysqli_connect_error()) {
    die ("<html><head>My SQL Test Failure</head><body>Connection failed:" . mysqli_connect_error());
}
echo("<html><head><title>Digital Mitford Project</title>
<link rel='stylesheet' type='text/css' href='mitfordtable.css' /></head>
 <body><h1>Digital Mitford: The Mary Russell Mitford Archive</h1>
<h2>Editor Assignments</h2>");

/*$order = array('Task_id', 'mitfordmsID', 'Filename', 'Editor_id', 'Role');*/
$field = $_GET['field'];

$sort = 'ASC';
if (isset($_GET['orderBy'])) {

if($_GET['orderBy']=='ASC') {
    $sort = 'DESC';
}
    else {$sort = 'ASC';}
}
if($GET['field']=='Task_id'){
    $field = "Task_id";
}
elseif ($GET['field']=='mitfordmsID'){
    $field = "mitfordmsID";
}
elseif ($GET['field']=='Filename'){
    $field = "Filename";
}
elseif ($GET['field']=='Editor_id'){
    $field = "Editor_id";
}
elseif ($GET['field']=='Role'){
    $field = "Role";
}

$sql = "SELECT Task_id, mitfordmsID, Filename, Editor_id, Role FROM assignments ORDER BY $field $sort";
$result = $conn->query($sql);
/*if( $result->num_rows > 0)*/
/*$result = mysql_query($sql) or die(mysql_error());*/
{
//make the table
echo '<table><tr><th><a href="editorAssign.php?orderBy='.$sort.'&field=Task_id">Task Id</a></th>
<th><a href="editorAssign.php?orderBy='.$sort.'&field=mitfordmsID">Mitford MS Id</a></th>
<th><a href="editorAssign.php?orderBy='.$sort.'&field=Filename">File Name</a></th>
<th><a href="editorAssign.php?orderBy='.$sort.'&field=Editor_id">Editor Id</a></th>
<th><a href="editorAssign.php?orderBy='.$sort.'&field=Role">Role</a></th>
</tr>';
//output data from each row

while( $row = $result->fetch_assoc()) {
echo "<tr><td>".$row["Task_id"]."</td>
           <td>".$row["mitfordmsID"]."</td>
           <td>".$row["Filename"]."</td>
           <td>".$row["Editor_id"]."</td>
           <td>".$row["Role"]."</td>
           </tr>";
           }
           echo "</table></body></html>";
           } /*else {
           echo "0 results";
           }*/
           $conn->close();
?>




