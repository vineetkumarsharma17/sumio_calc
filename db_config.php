<?php
$servername = "localhost";
$username = "u865000035_vsafe_user";
$password = "B5espk938j@123";
$dbname = "u865000035_vsafe";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
?>