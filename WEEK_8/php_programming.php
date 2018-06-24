db = connect_to_dbms(DBname,User/Password);
query = build_SQL("sql_statement_template",values);
results = execute_query(db,query);
while (more_tuples_in(results))
{
tuple = fetch_row_from(results);
// do something with values in tuple ...
}


db = connect_to_dbms(username,password);

quey = build_SQL("sql statement", values);

results = execute_query(db, query);

while () {
	
	tuple = fetch_row_from(results);
	// do something with it 

}
