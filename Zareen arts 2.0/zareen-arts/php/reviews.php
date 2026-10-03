<?php
require "db.php";
if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $rows = $pdo->query("SELECT name,rating,comment,created_at FROM reviews WHERE approved=1 ORDER BY created_at DESC")->fetchAll();
    echo json_encode($rows); exit;
}
$data=json_decode(file_get_contents("php://input"),true);
$name=trim($data["name"]??""); $rating=(int)($data["rating"]??0); $comment=trim($data["comment"]??"");
if(!$name||$rating<1||$rating>5||!$comment){http_response_code(400);echo json_encode(["success"=>false,"message"=>"Please complete all review fields."]);exit;}
$stmt=$pdo->prepare("INSERT INTO reviews(name,rating,comment) VALUES(?,?,?)");
$stmt->execute([$name,$rating,$comment]);
echo json_encode(["success"=>true,"message"=>"Thank you. Your review has been submitted."]);
?>