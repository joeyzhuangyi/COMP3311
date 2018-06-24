

-- WEEK 5:
-- 	Writing function
-- 	sql revision

-- Function can return: 
-- 	atomic values
-- 	tuple, example create Pair as (x integer, y integer)
-- 	set of atomic values (column in a table)
-- 	set of tuples (a table)


-- Function not referencing database is immutable

------------------------------------------
while (cond) loop
	operation..
	...
	...
end loop;
------------------------------------------

return next _i;
return next _p;


create or replace function
	add2_sql (a integer, b integer) returns integer
as $$

	select a + b;

$$ language 'sql';

# run: select * from add2_sql(2,3);

create or replace function
	add2_plpgsql (a integer, b integer) returns integer
as $$
begin
	
	return a+b;

end;
$$ language 'plpgsql';

# run: select * from add2_plpgsql(2,3); 

create type Pair as (x integer, y integer);

create or replace function
	createPair (x integer) returns Pair
as $$
declare
	_p Pair;

begin
	_p.x := x;
	_p.y := x*x*x;
	return _p;
end;
$$ language 'plpgsql';


create or replace function
	seq (x integer) returns setof integer
as $$
declare
	i integer;
begin
	i:= 1;

	while (i <= hi) loop
		return next i;
		i := i + 1;
	end loop;
	return;
end;
$$ language 'plpgsql';



create or replace function
	squares(x integer, y integer)
as $$
declare
	i integer;
	p Pair;
begin
	
	i := x;
	while (i <= y) loop
		p.x := i;
		p.y := i*i;
		return next p;
		i:= i + 1;

	end loop;
	return;

end;
$$ language 'plpgsql';



create or replace function
	squares(x integer, y integer) returns setof Pair
as $$
declare
	i integer;
	_p Pair;
begin
	
	for i in x..y loop
		_p.x := i;
		_p.y := i*i;
		return next _p;
	end loop;
	return;

end;
$$ language 'plpgsql';


create type department_school as (id integer, utype text, name text);

create or replace function
	department_of(id_tofind integer) returns table (id integer, utype text, name text)
as $$
declare
	_utype integer;
begin
	
	for id,_utype,name in  
	select O.id, O.utype ,O.name from orgunits O
	where id_tofind = O.id 
	loop
		utype := (select OT.name from orgunit_types OT where OT.id = _utype);
		return next; 
	end loop;
	return;

end;
$$ language 'plpgsql';







create or replace function
	pizzaWith(_topping text) returns setof text
as $$
declare
	_p Pizza;
begin
	
	for _p in  
		select p.* from pizzas P 
		join toppings T on P.topping = T.id
		where T.name = _topping
	loop

		return next _p.name; 
	end loop;
	return;

end;
$$ language 'plpgsql';



























































