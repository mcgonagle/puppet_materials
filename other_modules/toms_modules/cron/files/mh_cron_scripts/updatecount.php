<?
/*
 $Id: updatecount.php,v 1.2 2009/04/20 17:26:44 rbraun Exp $
 Managed by puppet

	This page should produce NO OUTPUT!
*/

// CONNECT TO THE DATABASE

$dblink = mysql_connect($conf['dbhost'],'apache','LQSyM') or die ("Connection Failed.");
mysql_select_db($conf['db']) or die  ("Unable to use database.");

$dblink4 = mysql_connect('admindb01','apache','LQSyM') or die ("Connection Failed.");

// #########################################

include_once "postal.inc.php";
include_once "location.inc.php";


// #########################################
// Check if too many people logged in already, and logout the limited members.
$query = "SELECT uid FROM Sessions WHERE logout=0 ORDER BY lastLogin";
$result = mysql_query($query, $dblink);
$num = mysql_num_rows($result);

// Populate an array with the values
$val = array();
for ($i=0; $i<$num; $i++) {
	$row = mysql_fetch_array($result);
	$val[] = $row[0];
}
reset($val);

// #########################################
// THROTTLE: LOGOUT NON-PAID MEMBERS OVER LIMIT
echo $conf['maxusers'];
if ($num > $conf['maxusers']) {
	$over = $num - $conf['maxusers'];
	mysql_query("UPDATE Sessions SET logout=1 WHERE type!='paid' AND uid!=0 AND logout!=1 ORDER BY lastLogin LIMIT $over", $dblink);
}

// #########################################


// New High Score...
$query = "SELECT COUNT(DISTINCT uid) FROM Sessions";
if ($debug) echo "$query <br>\n";
$result = mysql_query($query, $dblink);
$row = mysql_fetch_array($result);

$totalads = $row[0];

$query4 = "SELECT COUNT(*) FROM manhunt_v4.presence";
$result = mysql_query($query4, $dblink4);
$row = mysql_fetch_array($result);

$totalads += $row[0];

if($debug) echo "Total Ads: $totalads<br>\n";

$query = "SELECT highScore, highToday FROM HighScores WHERE state='**'";
$result = mysql_query($query, $dblink);
$row = mysql_fetch_array($result);

if ($row[0] < $totalads) {
	mysql_query("UPDATE HighScores SET highScore=$totalads, currentDay=now() WHERE state='**'", $dblink);
}

if ($row[1] < $totalads) {
	mysql_query("UPDATE HighScores SET highToday=$totalads WHERE state='**'", $dblink);
}


// Open the temp file...
$string = "<?
/* *******************************************************
	This is a generated file.  Do not edit by hand.
	Do not include in the CVS repository.

	It is used by the site to show the current number
	of users online - broken down by state.
******************************************************* */

";

$fp = fopen("/mnt/manhunt/other/common/onlineTotals.inc.php.tmp", "w+");

fwrite($fp, $string);

fwrite($fp, "\$onlineTotal['**'] = $totalads;\n\n");

// Loop thru the states...
$Countries = get_countries();
foreach ($Countries as $country => $country_a) {
	$States = postal_get_states($country);
	foreach ($States as $id=>$val) {
		if ($debug) echo "Checking $id: ";
		$query = "SELECT COUNT(DISTINCT uid) FROM Sessions WHERE state_code='$id'";
		$result = mysql_query($query, $dblink);
		$row = mysql_fetch_array($result);
		$onlineads[$id] = $row[0];

		if ($debug) echo "$onlineads[$id]<br>\n";
		
		fwrite($fp, "\$onlineTotal['$id'] = $onlineads[$id];\n");
	
		// Check if this is a new high score...
		$result = mysql_query("SELECT highScore, highToday FROM HighScores WHERE state_code='$id'", $dblink);
		$row = mysql_fetch_array($result);
		if ($row['highScore'] < $onlineads[$id]) {
			mysql_query("UPDATE HighScores SET highScore=$onlineads[$id], currentDay=now() WHERE state_code='$id'", $dblink);
		}
		if ($row['highToday'] < $onlineads[$id]) {
			mysql_query("UPDATE HighScores SET highToday=$onlineads[$id] WHERE state_code='$id'", $dblink);
		}
		mysql_query("UPDATE HighScores SET online=$onlineads[$id] WHERE state_code='$id'", $dblink);
	}
}

// Overwrite the online file...
fwrite($fp, "\n");
fclose($fp);
copy ("/mnt/manhunt/other/common/onlineTotals.inc.php.tmp", "/mnt/manhunt/other/common/onlineTotals.inc.php");

if ($debug) echo "<hr>Script Complete";
