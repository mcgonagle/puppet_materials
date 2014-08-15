<?php

$this_include_path = get_cfg_var("include_path");
if (($this_include_path != "") && ($this_include_path != NULL)) {
        ini_set("include_path",$this_include_path);
} else {
        if (isset($_SERVER['DOCUMENT_ROOT'])) {
                if (is_dir($_SERVER['DOCUMENT_ROOT'] . "../phplib")) {
                        ini_set("include_path",$_SERVER['DOCUMENT_ROOT'] . "../phplib");
                } else {
                        print "no include path found: phplib cannot be located<BR>\n";
                        die();
                }
        } else {
                if (is_dir("../../phplib")) {
                        ini_set("include_path","../../phplib");
                } else {
                        print "no include path (../../phplib) found: cannot be located<BR>\n";
                        die();
                }
        }
}

$auto_prepend_file = get_cfg_var("auto_prepend_file");
if (($auto_prepend_file == "") || ($auto_prepend_file == NULL)) {
        if (file_exists("/etc/manhunt/admin/siteconfig.inc.php")) { // QA
                ini_set ("auto_prepend_file", "/etc/manhunt/admin/siteconfig.inc.php");
                include_once("/etc/manhunt/admin/siteconfig.inc.php");
        } else if (file_exists("/etc/manhunt/siteconfig.inc.php")) { // WWW1: Live ADMIN
                ini_set ("auto_prepend_file", "/etc/manhunt/siteconfig.inc.php");
                include_once("/etc/manhunt/siteconfig.inc.php");
        } else if (file_exists("../../phplib/siteconfig.inc.php")) { // last chance
                ini_set ("auto_prepend_file", "../../phplib/siteconfig.inc.php");
                include_once("../../phplib/siteconfig.inc.php");
        } else {
                print "Could not find siteconfig file.\n";
                die();
        }
}

require_once "location.inc.php";
global $uniqueLogins;
global $paidCount;

$reload=1;
$now=date("s");

// REPORT END DATE
// If an end date has not been specified, default to the current time
    $end_date = date("Y-m-d");
    $input_end_date = date("m/d/y");
    $end_date_time = date("Y-m-d H:i:s");

# SET UP STATES_EN BECAUSE IT'S NOT ON ADMIN.MANHUNT.NET
$States_en['JA012'] = 'Hokkaido';
$States_en['JA003'] = 'Aomori';
$States_en['JA016'] = 'Iwate';
$States_en['JA024'] = 'Miyagi';
$States_en['JA002'] = 'Akita';
$States_en['JA045'] = 'Yamagata';
$States_en['JA008'] = 'Fukushima';
$States_en['JA014'] = 'Ibaraki';
$States_en['JA039'] = 'Tochigi';
$States_en['JA010'] = 'Gunma';
$States_en['JA035'] = 'Saitama';
$States_en['JA004'] = 'Chiba';
$States_en['JA041'] = 'Tokyo';
$States_en['JA019'] = 'Kanagawa';
$States_en['JA029'] = 'Niigata';
$States_en['JA043'] = 'Toyama';
$States_en['JA015'] = 'Ishikawa';
$States_en['JA006'] = 'Fukui';
$States_en['JA047'] = 'Yamanashi';
$States_en['JA026'] = 'Nagano';
$States_en['JA009'] = 'Gifu';
$States_en['JA038'] = 'Shizuoka';
$States_en['JA001'] = 'Aichi';
$States_en['JA023'] = 'Mie';
$States_en['JA036'] = 'Shiga';
$States_en['JA022'] = 'Kyoto';
$States_en['JA033'] = 'Osaka';
$States_en['JA013'] = 'Hyogo';
$States_en['JA028'] = 'Nara';
$States_en['JA044'] = 'Wakayama';
$States_en['JA042'] = 'Tottori';
$States_en['JA037'] = 'Shimane';
$States_en['JA031'] = 'Okayama';
$States_en['JA011'] = 'Hiroshima';
$States_en['JA046'] = 'Yamaguchi';
$States_en['JA040'] = 'Tokushima';
$States_en['JA017'] = 'Kagawa';
$States_en['JA005'] = 'Ehime';
$States_en['JA020'] = 'Kochi';
$States_en['JA007'] = 'Fukuoka';
$States_en['JA034'] = 'Saga';
$States_en['JA027'] = 'Nagasaki';
$States_en['JA021'] = 'Kumamoto';
$States_en['JA030'] = 'Oita';
$States_en['JA025'] = 'Miyazaki';
$States_en['JA018'] = 'Kagoshima';
$States_en['JA032'] = 'Okinawa';

    $end_date_now = date("Y-m-d");
    $input_end_date_now = date("m/d/y");
    $end_date_time_now = date("Y-m-d H:i:s");
    $end_date_now = "2006-10-23";
    $input_end_date_now = "10/23/2006";
    $end_date_time_now = "2006-10-23 11:00:00";
# next day at 6 am
$end_date_time6 = date("Y-m-d H:i:s", strtotime($input_end_date)+60*60*30);
$sun_end_date=$end_date;
$dow = date("w", strtotime($sun_end_date));
while ($dow!=0) {
  $sun_end_date=date("Y-m-d",strtotime($sun_end_date)-60*60*24);
  $dow = date("w", strtotime($sun_end_date));
}

// string for end_date
$end_date_string = date($date_format, strtotime($end_date));
$filename="newads$end_date".".csv";
//  S T A R T     O F     H T M L
if ($reload==1) {
#  header("Content-type: application/vnd.ms-excel");
#  header("Content-Disposition: csv; filename=$filename");
#  header("Pragma: no-cache");
#  header("Expires: 0");
#echo "<title>Weekly Statistics: New Ads</title>";
#echo "<PRE>";
}
else {
  ?>

  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
  <html><title>Weekly Statistics</title>
  <head>
<style type="text/css">
.header {
	background: <?= $conf["locolor"] ?>;
	color: #cccccc;
	font-family: arial;
	font-size: 14px;
	font-weight: bold;
	cursor: pointer;
}
.qstatus {
    position: absolute;
    top: 0px;
    left: 10px;
    color: #cccccc;
    font-size: 14px;
    background: #314e6c;
    border: 2px #aaaaaa outset;
    visibility: hidden;
    padding: 3px;
    width: 190px;
}
</style>
</head>

<body bgcolor="<?=$conf["bgcolor"]?>" text="#cccccc">
<div id="query_status" class="qstatus"><img src="/images/indicator.gif" alt="loading..." style="padding-top: 4px;padding-left: 2px;border: none;">&nbsp;&nbsp;<span id="status_span"></span></div>

<?php
flush();
}

if ($reload!=1) {
  ?>
  <form method="post" name="form">
  <input type="hidden" name="reload" value="1">
<H1>Weekly New Ads Statistics</H1>
  <table align="center" width="80%" cellspacing="2" cellpadding="2" style="border: 1px solid #000011;background: <?= $conf[locolor] ?>;">
  <tr>
  <td colspan="2" align="left">
  <b>Choose an end date:  (mm/dd/yy)</font></b>
  <br>
  <input name="input_end_date" size="20" maxlength="100" >
  <BR>Leave blank for today
  </td><TD><INPUT TYPE=SUBMIT></TD><td>This query takes a while (30 seconds or more), so please be patient...</td>
  </tr>
  </table>
  </form>
</body>
</html>
<?php
}

else {
// for test
//    $jpdblink = get_adminread_dblink();
// for production
      $jpdblink = mysql_connect($conf['jpdbhost'],$conf['wwwdbuser'],$conf['dbpass']);
      mysql_select_db('manhunt_jp', $jpdblink) or die("Unable to use database: manhunt_jp");

function get_query ($query,$db){
    global $jpdblink;
    if ($db=='jp') { 
    if (!($result = mysql_query($query, $jpdblink))) {echo "FAILED trying to find MANHUNT.$db:  $query\n\n". mysql_error() ; }
       }
    if (!($fields = mysql_num_fields($result))) {echo "FAILED GETTING FIELDS:\n\n".  mysql_error() ; }
   $toreturn=array($result,$fields);
   return $toreturn;
}

# displays row 1, then row 2.  
function display_vert($query,$db) {  
    $output='';
    $returned=get_query($query,$db);
    $result=$returned[0];
    $fields=$returned[1];
    while($row = mysql_fetch_array($result)){
      $i=0;
      while ($i<$fields) {
      if ($i!=0){ $output.= ","; }
        if ($row[$i]) { 
          $output.= $row[$i];
          }
      $i++;
      $ouptput.="\n";
      } # finished all fields in 1 row
    $output.= "\n";
    } # finished going through all rows
    return $output;
} # end display_vert

# displays col 1, then col 2.  
function display_horiz($query,$db) {
    $output='';
    $returned=get_query($query,$db);
    $result=$returned[0];
    $fields=$returned[1];
    $max_row=mysql_num_rows($result);

    # STORE THE ANSWERS
    $row_count=0;
    $nums='';
    while($row_count<$max_row){
     $row = mysql_fetch_array($result);
     $i=0;
      while ($i<$fields) {
        $nums[$row_count][$i]=$row[$i];
        $i++;
        } # end going through fields in 1 row
    $row_count++;
    } # end going through rows

# NOW DISPLAY THE ANSWERS
    $i=0;
    while ($i<$fields) {
      $row_count=0;
      while($row_count<$max_row){
        if ($row_count!=0){ $output.= ","; }
        $output.= $nums[$row_count][$i]; 
        $row_count++;
      } # end going through 1 column 
    $output.= $nums[$row_count][$i];
    $i++;
    $output.="\n";
    } # end going through all columns
    $output.="\n";
    return $output;
} # end display_horiz

# SET UP QUERIES

foreach ($States_en as $id=>$statename) {
if ($queryNewJp) { $queryNewJp.=" union "; }
  $queryNewJp.="SELECT '$States_en[$id]',COUNT(uid) AS cnt
  FROM Users
  WHERE created<'$end_date_time6' AND
  created>=DATE_ADD(DATE_SUB('$end_date',INTERVAL 6 DAY),INTERVAL 6 HOUR)
  AND state='$id'";
}

foreach ($States_en as $id=>$statename) {
if ($queryUniqJp) { $queryUniqJp.=" union "; }
  $queryUniqJp.="SELECT '$States_en[$id]',COUNT(uid) AS cnt
  FROM Users
  WHERE lastLogin<'$end_date_time6' AND
  lastLogin>=DATE_ADD(DATE_SUB('$end_date',INTERVAL 6 DAY),INTERVAL 6 HOUR)
  AND state='$id'";
}


$jpProfiles.= "New Ads MANHUNT.jp week ending\n$input_end_date\n";
$db='jp';
$jpProfiles.=display_horiz($queryNewJp,$db);

echo $jpProfiles;
echo "\n\n";

$jpUniqueLogins.= "Unique Logins MANHUNT.jp week ending\n$input_end_date\n";
$db='jp';
$jpUniqueLogins.=display_horiz($queryUniqJp,$db);

echo $jpUniqueLogins;
echo "\n\n";

} 
?>

