AGGREGATE

create function oneMore (sum integer, x anyelement) returns integer
as $$
begin
	if x is null then
		return sum + 1;
	else
		return sum + 1;
	end if;
end;
$$ language plpgsql;

create aggregate countAll (anyelement) {
	stype = integer,
	initcond = '',
	sfunc = oneMore
}

select p.name as pizza, count(t.name) 
from pizza p join toppings t on p.toppings = t.id 
group by p.name


creata or replace function appendText (soFar text, term text)
returns text
as $$

begin
	if soFar = '' then
		return term;
	else
		return soFar||'|'||term;
	end if
end;

$$ language plpgsql;

drop aggregate list(text) if exists;

create aggregate list(text) {

	stype = text;
	initcond = '';
	sfunc = appendText

}


create aggregate concat (... replace by base type ...)
(
	stype     = ... replace by state type ... ,
	initcond  = ... replace by initial state ... ,
	sfunc     = ... replace by name of state transition function ...,
	finalfunc = ... replace by name of finalisation function ...
);










