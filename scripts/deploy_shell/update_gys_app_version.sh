#!/usr/bin/env php
<?php

$serverName = "10.5.7.52";
$userName = "root";
$password = "mysoft7.52";
$database = "saas_common";
$port = "3306";

$mysqli = new mysqli($serverName, $userName, $password, $database, $port);

if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    die();
}

$sql = <<<sql
    UPDATE
        app_version
    SET
        web_version_code = ?,
	web_update_type = ?
    WHERE
        app_type = 2
sql;

if (!($stmt = $mysqli->prepare($sql))) {
    echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
    die();
}

$config = file_get_contents("/www/target/jenkins/workspace/b2btst2_app_gys_frontend/mobilefrontend/dist/test/config.js");
preg_match_all("/[\"']?(version|updateType)[\"']?:(\s+)?[\"']?([\w\.]+)[\"']?/", $config, $match);

$result = [];
foreach($match[1] as $key => $item){
    $result[$item] = $match[3][$key];
}
if(!array_key_exists('version', $result) || !array_key_exists('updateType', $result)){
    echo '更新失败:版本号或更新类型不存在!' . "\n";
    var_dump($result);
    die();
}

if (!$stmt->bind_param("ss", $result['version'], $result['updateType'])) {
    echo "Binding parameters failed: (" . $stmt->errno . ") " . $stmt->error;
    die();
}

if (!$stmt->execute()) {
    echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
    die();
}

$stmt->close();
