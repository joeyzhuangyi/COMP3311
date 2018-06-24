-- COMP3311 18s1 Prac 06 Exercise
-- Written by: YOUR NAME (April 2018)


-- AllRatings view 

create or replace view AllRatings(taster,beer,brewer,rating)
as
	select T.given as taster, B.name as beer, BR.name as brewer, R.score as rating from Ratings R 
	join Taster T on R.taster = T.id
	join Beer B on R.beer = B.id  
	join brewer BR on B.brewer = Br.id 
	order  by T.given, R.score desc
;


-- John's favourite beer

-- select beer,brewer from allratings where taster = 'John' order by rating desc limit 1;

create or replace view JohnsFavouriteBeer(brewer,beer)
as
	select BR.name as brewer, B.name as beer from Ratings R
	join Taster T on T.id = R.taster
	join Beer B on B.id = R.beer
	join brewer Br on B.brewer = BR.id
	where given = 'John'
	order by R.score DESC limit 1;
;


-- X's favourite beer

create type BeerInfo as (brewer text, beer text);

create or replace function FavouriteBeer(taster text) returns setof BeerInfo
as $$
	select brewer,beer from allratings where taster = $1 order by rating desc limit 1

$$ language sql
;

create or replace function FavouriteBeer(text) returns setof BeerInfo
as $$
select brewer,beer
from   AllRatings
where  taster = $1 and
       rating = (select max(rating) from AllRatings
       		 where  taster = $1)
$$ language sql
;


-- Beer style

create or replace function BeerStyle(brewer text, beer text) returns text
as $$
	select Bs.name as style from beerstyle BS 
	join beer B on B.style=BS.id 
	join Brewer BR on BR.id = B.brewer 
	where lower(B.name)=lower($2) and lower(BR.name)=lower($1)
$$ language sql
;

create or replace function BeerStyle1(brewer text, beer text) returns text
as $$
begin
	... replace this by your PLpgSQL code ...
end;
$$ language plpgsql
;


-- Taster address

create or replace function TasterAddress(taster text) returns text
as $$
	select case
	when L.state is null then L.country
	when L.country is null then L.state
	else L.state||', '||L.country 
	end
	from taster T
	join location L on t.livesin = L.id
	where lower(t.given) = lower($1)
$$ language sql
;

select loc.state||', '||loc.country
	from   Taster t, Location loc
	where  t.given = $1 and t.livesIn = loc.id


select L.state||', '||L.country from taster T
join location L on t.livesin = L.id;

create or replace function TasterAddress(taster text) returns text
as $$
begin
	... replace this by your PLpgSQL code ...
end;
$$ language plpgsql
;


-- BeerSummary function

create or replace function BeerDisplay_Sean(_beer text, _rating float, _taster text) returns text
as $$
begin
	return E'\n' ||
	'beer: ' || _beer || E'\n'
	'rating ' || _rating || E'\n'
	'taster ' || _taster || E'\n';
end;
$$ language plpgsql;


create or replace function 
	BeerSummary() returns text
as $$
declare
	r 		record;
	_out	text := '';
	_curbeer text:= '';
	_taster text;
	_sum 	integer;
	_count	integer;
begin
	for r in select * from AllRatings order by beer, taster
	loop
		if (r.beer <> _curbeer) then
			if (_curbeer <> '') then
				out := out || BeerDisplay_Sean(_curbeer,_count/_sum,_taster);
			end if;
			_curbeer = r.beer;
			_sum = 0; _count = 0; _taster = '';
		end if;
		_sum := sum +r.rating;
		_count := count +1;
		_taster := _taster ||','|| r.taster;
	end loop;
	-- finish off the last beer
	out := out || beerDisplay(curbeer,sum/count,tasters);
	return out;
end
$$ language plpgsql;


-- Concat aggregate

create or replace function
appendText(finalString text, term text) returns text
as $$
begin

	if finalString = '' then
		return term;
	else
		return finalString || ',' || term;
	end if;

end;
$$ language plpgsql;

create aggregate concat (text)
(
	stype     = text,
	initcond  = '' ,
	sfunc     = appendText
);


-- BeerSummary view

create or replace view BeerSummary(beer,rating,tasters)
as
	select * from (select beer, to_char(avg(rating),'9.9') as rating,concat(taster) as taster from allratings group by beer) as Table1 order by Table1.rating desc
;


-- TastersByCountry view

create or replace view TastersByCountry(country,tasters)
as
	... replace by SQL your query using concat() and Taster ...
;
