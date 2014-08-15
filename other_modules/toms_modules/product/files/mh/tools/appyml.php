<?php
  /*
   appyml.php
   This file Autogenerated for <%= fqdn %> by puppet. Hand edits considered harmful.

   $Id: appyml.php,v 1.1 2009/10/15 16:09:51 wflynn Exp $

   Wflynn 10/09

   PHP file to print out contents of app.yml
   Logic ganked from debuginfobasic.php
  */
$APP_YML_INFO_FILE = 'app.yml';
$APP_YML_FE_FILE_PATH = '/usr/local/src/manhunt/apps/frontend/config/'.$APP_YML_INFO_FILE;
$APP_YML_ADMIN_FILE_PATH = '/usr/local/src/manhunt/apps/admin/config/'.$APP_YML_INFO_FILE;
if (file_exists($APP_YML_FE_FILE_PATH)) {
  echo "<b><pre>";
  $infoFile = file($APP_YML_FE_FILE_PATH);
  foreach ($infoFile as $line) {
    echo "$line";
  }
  echo "</pre></b><br />";
 }elseif (file_exists($APP_YML_ADMIN_FILE_PATH)) {
   echo "<b><pre>";
   $infoFile = file($APP_YML_ADMIN_FILE_PATH);
   foreach ($infoFile as $line) {
     echo "$line";
   }
   echo "</pre></b><br />";
  } else {
  echo "</pre></b><h1>NOT FOUND</H1><br />";
 }