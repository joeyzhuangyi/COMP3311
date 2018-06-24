db = connect_to_dbms(DBname,User/Password);
query = build_SQL("sql_statement_template",values);
results = execute_query(db,query);
while (more_tuples_in(results))
{
tuple = fetch_row_from(results);
 # do something with values in tuple ...
}



# example 

$db = dbAccess("db");
$query = "select age from students where age > 40";
$result = dbQuery($db,$query);

while ($tuple = dbNext($result)) {
	-- process
}



# example 2: efficient query

$db = dbAccess("haha");
$query =	"select id, name, course, mark from students S" .
			"join Marks M on M.student = S.id";

$result = dbQuery($db,$query);

while ($tuple = dbNext($result)) {
	-- process
}

<?
	require(myDefinition.php)
	$pagename = $_POST['name'];
	$max = $_POST['max'];
?>

<h1> This is <?=$pagename?>

<? if ($max <= 0) { ?>
<b>There are no numbers to display</b>
<? }
else {
for ($i = 0; $i <= $max; $i++)
echo "$i<br>\n";
}
?>





print "Name is $_REQUEST[name]\n";
print "Age is ".$_REQUEST['age']."\n";
print "Name: $_GET[name] Age: $_GET[age]\n";



Multi-dimensional arrays work ok (array elements can be any type)
$fruits = array ( "fruits" => array ( "a" => "orange"
, "b" => "banana"
, "c" => "apple"
)
, "numbers" => array ( 1,2,3,4,5,6 )
, "holes" => array ( "first"
, 5 => "second"
, "third"
)
);





for ($i = 0; $i < count($word); $i++)
	print "word[$i] = $word[$i]\n";
foreach ($words as $w) print "next word = $w\n";

for (reset($marks); $name = key($marks); next($marks))
	print "Mark for $name = $marks[$name]\n";

reset($marks);
while (list($name,$val) = each($marks))
	print "Mark for $name = $val\n";
	

$elem = current($vec);
while ($elem) {
	print "Next elem is $elem\n";
	$elem = next($vec);
}



$marks = array("Ann"=>95, "John"=>75, "David"=>60);

foreach ($marks as $name => $mark)
	echo "$name scored $mark%\n";
echo "Whole array: $marks\n";



-- Accesses variables called myVar0, myVar1, myVar2, ...

for ($i = 0; $i < $MAX; $i++) {
	$varname = "myVar$i";
	$value = ${$varname};
	print "Value of $varname = $value\n";
}



-- POSTGRE and PHP
pg_connect() ... connect to the database
pg_query() ... send SQL statement for processing
pg_fetch_array() ... retrieve the next result tuple
pg_num_rows() ... count # rows in result
pg_affected_rows() ... count # rows changed




-- Example 1

$unidb = pg_connect("dbName=unidb");

$query = "Select id, name from students";

$result = pg_query($unidb,$query);

if (!$result) {
	echo "something wrong";
	print pg_last_error();
}
else if (pg_num_rows($result) > 20){
	echo "big department";
}

-- Example 2

$unidb = pg_connect("dbName=unidb");

$query = "delete from enrolments where id = 3311";

$result = pg_query($unidb,$query);

if (!result) {
	print pg_last_error();
}
else {
	$nstud = pg_affected_rows($result);
}


-- Example 3

$query = "select id,name from Staff";

if ($result = pg_query($db, $query)) {
	$n = pg_num_rows($result);
	for ($i = 0; $i < $n; $i++) {
		$item = pg_fetch_row($result,$i);
		print "Name=$item[1], StaffID=$item[0]\n";
	}
}


-- Example 4
$array = pg_fetch_array($result,$i);

-- $array['name'] = name value;
-- $array['id'] = id value;






























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































