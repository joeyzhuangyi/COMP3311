#!/srvr/cs3311psql/lib/php525/bin/php
<?

require("db.php");

if ($argv < 2 || !is_numeric($argv[1])) exit("wrong input");

$sid = $argv[1];

$db = dbConnect("dbname=a2");

$string1 = "select id from people p where p.unswid = %d";

$q1 = mkSQL($string1,$sid);

$r1 = dbOneValue($db,$q1);

if (empty($r1)) exit("empty brah\n");

$string2 = "select p.id,p.name,p.email,c.name as origin from people p join countries c on p.origin = c.id where p.unswid=%d";
$q2 = mkSQL($string2,$sid);

$r2 = dbOneTuple($db,$q2);

$output = array(
	"id" => $sid,
	"name" => $r2['name'],
	"email" => $r2['email'],
	"country" => $r2['origin']
);

foreach($output as $key => $val) {
	echo $key . "   " . $val . "\n";
}


?>