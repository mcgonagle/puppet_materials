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


#include_once "admin.inc.php";
require_once "location.inc.php";
global $uniqueLogins;
global $paidCount;

#$admin_access_level = getAdminAccessLevel($PHP_AUTH_USER);
#if ($admin_access_level < 7 || date("H")<=5 || date("H")>17) {
#echo "This script is limited by privilege and time.  If it is between 6 pm and 5 am, this script will not run.";
#	exit;
#}

$now=date("s");
$reload=1;

// REPORT END DATE
$end_date = date("Y-m-d");
$input_end_date = date("m/d/y");
$end_date_time = date("Y-m-d H:i:s");

$end_date_now = date("Y-m-d");
$end_date_time_now = date("Y-m-d H:i:s");
$input_end_date_now = date("m/d/y");
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
$filename="weeklystats$end_date".".csv";
//  S T A R T     O F     H T M L
if ($reload == 1) {
	;
} else {
  ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<title>Weekly Statistics</title>
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
  <H1>Weekly Financial Statistics</H1>
  <table align="center" width="80%" cellspacing="2" cellpadding="2" style="border: 1px solid #000011;background: <?= $conf[locolor] ?>;">
    <tr>
      <td colspan="2" align="left"><b>Choose an end date:  (mm/dd/yy)</font></b> <br>
        <input name="input_end_date" size="20" maxlength="100" >
        <BR>
        Leave blank for today </td>
      <TD><INPUT TYPE=SUBMIT></TD>
      <td>This query takes a while (30 seconds or more), so please be patient...</td>
    </tr>
  </table>
  </form>
 </body>
</html>
<?php
}

else { // ($reload == "1")

$dblink = mysql_connect($conf['dbslave1'],$conf['wwwdbuser'],$conf['dbpass']); 
mysql_select_db('manhunt', $dblink) or die("Unable to use database: manhunt");

function get_query($query,$db){
    global $dblink; 
	mysql_select_db('manhunt', $dblink) or die("Unable to use database: manhunt");
	if (!($result = mysql_query($query, $dblink))) {
		echo "FAILED trying to find (net) MANHUNT.$db:  $query\n\n". mysql_error() ;
	}
	if (!($fields = mysql_num_fields($result))) {
		echo "FAILED GETTING FIELDS:\n\n".  mysql_error() ;
	}
	$toreturn = array($result,$fields);
	return $toreturn;
}

# displays row 1, then row 2.  
function display_vert($query,$db) {  
        $output = "";
        $returned = get_query($query,$db);
        $result = $returned[0];
        $fields = $returned[1];
        while($row = mysql_fetch_array($result)){
        $i = 0;
        while ($i<$fields) {
                if ($i != 0){ $output.= ","; }
                        if ($row[$i]) {
                                $output.= $row[$i];
                        }
                        $i++;
                        $ouptput .= "\n";
                } # finished all fields in 1 row
                $output .= "\n";
        } # finished going through all rows
        return $output;
} # end display_vert

# displays col 1, then col 2.  
function display_horiz($query,$db) {
    $output = '';
    $returned = get_query($query,$db);
    $result = $returned[0];
    $fields = $returned[1];
    $max_row = mysql_num_rows($result);

    # STORE THE ANSWERS
    $row_count = 0;
    $nums = '';
        while($row_count<$max_row){
                $row = mysql_fetch_array($result);
                $i = 0;
                while ($i<$fields) {
                        $nums[$row_count][$i] = $row[$i];
                        $i++;
                } # end going through fields in 1 row
                $row_count++;
        } # end going through rows

# NOW DISPLAY THE ANSWERS
    $i = 0;
    while ($i<$fields) {
      $row_count = 0;
      while($row_count<$max_row){
        if ($row_count != 0){ $output.= ","; }
        $output.= $nums[$row_count][$i];
        $row_count++;
      } # end going through 1 column
    $output.= $nums[$row_count][$i];
    $i++;
    $output .= "\n";
    } # end going through all columns
    $output .= "\n";
    return $output;
} # end display_horiz


function printPaidMembers($paidCount,$country) {
        global $Countries;
        $line1='';
        $line2='';
        foreach ($paidCount as $key => $value)  {
                if (!strpos($key,'code')) {
                        if ($country == substr($key,0,2)) {
                                if (substr($key,3) == "") {
                                        $line1 .= "Other";
                                } else {
                                        $line1 .= substr($key,3).",";
                                }
                                $line2 .= "$value,";
                        }
                }
        }
        echo $Countries[$country]['country_name'] . " - Paid Members for week ending $input_end_date\n".$line1."\n".$line2."\n\n";
}

function unique_logins ($country_code,$db){
        global $end_date;
        global $input_end_date;
        global $end_date_time;
        global $Countries;

         $queryLoginNet="SELECT r.state AS state, COUNT(u.uid)
                FROM Reports AS r LEFT JOIN Users AS u on (r.state_code=u.state_code
                and u.status NOT IN ('delete','hold')
                AND DATE_SUB(u.lastLogin,interval 6 hour)>=DATE_SUB('$end_date',INTERVAL 6 DAY)
                AND u.lastLogin<='$end_date_time') WHERE r.country_code='$country_code'
                GROUP BY r.state_code ORDER BY r.state_code";

        $db='net';
        $output = $Countries[$country_code]['country_name'] . " - Unique Logins MANHUNT.net week ending\n$input_end_date\n".display_horiz($queryLoginNet,$db);
        return $output;
}

# SET UP QUERIES

$Countries = get_countries();
foreach ($Countries as $country=>$country_array) {
	$getStates = "select state_code,state_abbr from States_$country;";
	# go through each member of PaidState, find the getState they're in, and add 1 to the count.
	$returned = get_query($getStates,'net');
	$getStatesresult = $returned[0];
	while($row = mysql_fetch_array($getStatesresult)){
		# makes an array with key = abbr, value = code
		$paidCount[$country."_".$row[1].'code'] = $row[0];
		$paidCount[$country."_".$row[1]] = 0;
	}
} # end going through each country

/*
        get an array of states/countries (for counting),
        with one element for each user, for countries with entries in the Reports table
*/
$getPaidStates="select r.state,u.country from Users u inner join Reports r using (state_code) where type='paid'";
$returned=get_query($getPaidStates,'net');
$paidStatesresult=$returned[0];
while ($row = mysql_fetch_array($paidStatesresult)){
    $key = $row[1]."_".$row[0];
    $paidCount[$key]++;
}

$queryTotalPaidMembers="select count(*) from Bill_Sales where (typesale='pos' AND startDate<='$end_date_time' AND endDate>='$end_date_time')";
$totalPaidMembers.= "Total Paid Members for MANHUNT.net as of $end_date_time\n";
$db='net';
$totalPaidMembers.=display_horiz($queryTotalPaidMembers,$db);

$queryRevenue="SELECT currency,SUM(total)
FROM Bill_Sales
WHERE typesale='pos'
AND startDate>DATE_SUB('$sun_end_date',INTERVAL 7 DAY) AND startDate<='$sun_end_date'
GROUP BY currency ORDER BY currency DESC;";

$revenue.= "Revenue for week ending\n$sun_end_date\n";
$db='net';
$revenue.=display_horiz($queryRevenue,$db);

foreach (array_keys($Countries) as $oneCountry) {
        $uniqueLogins[$oneCountry] = unique_logins($oneCountry,$db);
}

$queryLoginNetTotal="SELECT r.country_code AS country, COUNT(u.uid)
	FROM Reports AS r LEFT JOIN Users AS u USING (state_code)
	WHERE u.status NOT IN ('delete','hold')
	AND DATE_SUB(u.lastLogin,interval 6 hour)>=DATE_SUB('$end_date',INTERVAL 6 DAY) 
	AND u.lastLogin<='$end_date_time'  
	GROUP BY r.country_code ORDER BY r.country_code DESC;";
$loginNetTotal.= "Country Total Unique Logins MANHUNT.net week ending\n$input_end_date\n";
$db='net';
$loginNetTotal .= display_horiz($queryLoginNetTotal,$db);

$queryNewNet="SELECT r.country_code,COUNT(u.uid),r.state 
	FROM Reports r LEFT JOIN Users u ON (u.state_code=r.state_code and 
	u.status NOT IN ('delete','hold') 
	AND created<='$end_date_time6' AND created>DATE_SUB('$end_date_time6',interval 7 day) )
	GROUP BY r.country,r.state ORDER BY CAST(r.country as char),r.state_code;";

printPaidMembers($paidCount,'us');
echo "\n";
echo $revenue;
echo "\n";
echo $totalPaidMembers;
echo "\n";
echo $uniqueLogins['us'];
echo "\n";
echo $loginNetTotal;
echo "\n";

foreach (array_keys($uniqueLogins) as $oneCountry) {
        if ($oneCountry == "us") {
                continue;
        }
        echo $uniqueLogins[$oneCountry];
        echo "\n";
        printPaidMembers($paidCount,$oneCountry);
        echo "\n";
}

echo "\n";
}
?>
