<?

	$db = dbConnect("asg1");

	$q = "select ....";

	$r = dbQuery($db,$q);

	while ($t = dbNext($r)) {
		$sum = $t['a'] + $t['b'];
	}

# System catalog
	# Store info about tables, Schemata, Columns, Table_constraints, Views

	# some basic info: 
		# table_type = BASE_TABLE
		# table_schema = public


?>

<!-- 

select t.table_name, c.column_name from information_schema.tables t join information_schema.columns c on (c.table_name = t.table_name) where ...;


create or replace view mySchema()
as select table_name, concat(column_name) from table_1 group by table_name order by table_name;


create or replace function myTable(_table text) return text
as $$

begin
	return "CREATE TABLE " || _table;
end

$$ language plpgsql; 


create or replace funtion F1() return setof Population
as $$
declare
	r record
	nr integer
	res Population
begin
	for r in select... from ...
	loop
		q = 'select.. from ' || r.table_name
		execute p into nr

		res.a := r.table_name
		res.b := nr


		return next res

		
	end loop
end
$$ language plpgsql;

-->

