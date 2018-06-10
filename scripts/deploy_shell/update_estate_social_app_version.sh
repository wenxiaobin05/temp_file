#!/usr/bin/env php
<?php

$serverName = "10.5.7.52";
$userName = "root";
$password = "mysoft7.52";
$database = "cy_app";
$port = "3306";

$mysqli = new mysqli($serverName, $userName, $password, $database, $port);

if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    die();
}

$sql = <<<sql
    INSERT INTO uuc_app_version_patch
    (
        version,
        download_url,
        is_upgrade,
        is_del,
        created_by
    )
    VALUES
    (
        ?,
        "http://jcs.b2btst5.win/app/hotupdate/kfs.zip",
        ?,
        2,
        "admin"
    )
sql;

if (!($stmt = $mysqli->prepare($sql))) {
    echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
    die();
}

$config = file_get_contents("/www/target/jenkins/workspace/b2btst5_estate_social_app/estateSocialFrontend/dist/test/config.js");
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
$result['is_upgrade'] = 1;
if($result['updateType'] == "2") {
    $result['is_upgrade'] = 2;
}

if (!$stmt->bind_param("ss", $result['version'], $result['is_upgrade'])) {
    echo "Binding parameters failed: (" . $stmt->errno . ") " . $stmt->error;
    die();
}

if (!$stmt->execute()) {
    echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
    die();
}

$stmt->close();
