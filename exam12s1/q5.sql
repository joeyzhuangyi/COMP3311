-- COMP3311 12s1 Exam Q5
-- The Q5 view must have attributes called (team,reds,yellows)

drop view if exists Q5;
create view Q5
as
select x.country, ifnull(y.red,0) as red, ifnull(x.yellow,0) as yellow from (
select t.id, t.country, count(*) as yellow, c.cardType from cards c 
	join players p on (p.id = c.givenTo)
	join teams t on (t.id = p.memberOf)
	where c.cardType = 'yellow'
	group by t.country
) x left join 

(
select t.id, t.country, count(*) as red, c.cardType from cards c 
	join players p on (p.id = c.givenTo)
	join teams t on (t.id = p.memberOf)
	where c.cardType = 'red'
	group by t.country
) y 
on (x.id=y.id)
;

























































































































select x.country, ifnull(y.red,0) as red, ifnull(x.yellow,0) as yellow from (
select t.country,count(*) as yellow from teams t 
join players p on (t.id = p.memberOf)
join cards c on (p.id = c.givenTo)
where c.cardType = 'yellow'
group by t.id
) x 
left join 

(select t.country,count(*) as red from teams t 
join players p on (t.id = p.memberOf)
join cards c on (p.id = c.givenTo)
where c.cardType = 'red'
group by t.id
) y
on (x.country = y.country)
;

















