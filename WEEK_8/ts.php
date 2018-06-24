#!/srvr/cs3311psql/lib/php525/bin/php
<?
require("db.php");

if ($argc < 2 || !is_numeric($argv[1])) exit("Usage: ts SID\n");
$sid = $argv[1];

$db = dbConnect("dbname=a2");

$qry = <<<xxSQLxx
select p.id, p.name
from   Students s, People p
where  p.unswid = %d and s.id = p.id
xxSQLxx;

echo mkSQL($qry,$sid),"\n";

$tuple = dbOneTuple($db, mkSQL($qry,$sid));
if (empty($tuple)) exit("Invalid SID: $sid\n");
list($pid,$name) = $tuple;

echo "Transcript for $name ($sid)\n\n";

$qry = <<<xxSQLxx
select s.code, s.name as title, t.year, t.term, e.mark, e.grade, s.uoc
from   Course_enrolments e
         join Courses c on (e.course = c.id)
         join Subjects s on (c.subject = s.id)
         join Semesters t on (c.semester = t.id)
		 join people p on (p.id = e.student)
where p.id = %d
xxSQLxx;

$res = dbQuery($db,mkSQL($qry,$pid));
if (dbNResults($res) == 0) exit("No courses studied\n");

while ($t = dbNext($res))
{
	$sess   = sprintf("%02d%s", $t["year"]%100, strtolower($t["term"]));
	$course = "$t[code] $t[title]";
	$mark = $t['mark'];
	$grade = $t['grade'];
	$uoc = $t['uoc'];
	
	$out  = sprintf("%4s %-40.40s %4s %4s %4s",$sess,$course,$mark,$grade,$uoc);
	

	// if (is_null($t["mark"]))
	// 	$out .= sprintf("%5s",".");
	// else
	// 	$out .= sprintf("%5d",$t["mark"]);
	// if (is_null($t["grade"]))
	// 	$out .= sprintf("%5s",".");
	// else
	// 	$out .= sprintf("%5s",$t["grade"]);
	// if (is_null($t["grade"]))
	// 	$out .= sprintf("%5s",".");
	// elseif (passed($t["grade"]))
	// 	$out .= sprintf("%5d",$t["uoc"]);
	// else
	// 	$out .= sprintf("%5d",0);
	//completed

	echo "$out\n";
}

function passed($grade)
{
	$passes = array("PS","CR","DN","HD","PC","A","B","C","SY");
	return in_array($grade, $passes);
}
?>