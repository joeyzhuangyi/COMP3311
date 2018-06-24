



create or replace view Q1
as
select b.name from beers b
join brewers br on b.brewer = br.id
where br.name like '%Toohey%'
;

create or replace view Q2
as
select b.name as beer, br.name as brewer from beers b
join brewers br on b.brewer = br.id
;


create or replace view Q3
as

select br.name from likes l
join beers b on l.beer = b.id
join brewers br on b.brewer = br.id
join drinkers d on l.drinker = d.id
where l.drinker = 42 order by br.name
;

create or replace view Q4
as
select distinct count(name) as "#beer" from beers
;

create or replace view Q6
as 
select b1.name as beer1, b2.name as beer2 from beers b1
join beers b2 on b1.brewer = b2.brewer
where b1.name < b2.name
;


create or replace view Q7
as
select br.name as brewer, count(b.name) as numbeer from beers b
join brewers br on br.id = b.brewer
group by br.name order by br.name
;

create or replace view Q8
as
select brewer from Q7 order by numbeer desc limit 1
;

create or replace view Q9
as
select b.name from Q7 
join brewers br on br.name like Q7.brewer 
join beers b on b.brewer = br.id 
where numbeer = 1
;


create or replace view bar
as
select f.bar from drinkers d
join frequents f on d.id = f.drinker
where d.name = 'John'
;

create or replace view Q10 
as

select distinct br.name from bar B
join sells S on S.bar = B.bar 
join beers br on s.beer = br.id
;

create or replace view bar_drinker
as
select b.name as bar, d.name as name from bars b
join frequents f on f.bar = b.id
join drinkers d on f.drinker = d.id
;

create or replace view Q11
as
select distinct bd.bar from bar_drinker bd
where bd.name = 'John' or bd.name = 'Gernot'
;

-- alternative solution
create or replace view Q11a as
(select bar from Bar_and_drinker where drinker = 'John')
union
(select bar from Bar_and_drinker where drinker = 'Gernot')
;
-- note: the (...) are unnecessary in the above
--       I use them so that all subqueries are in (...)


-- Q12. Bars where both Gernot and John drink.

create or replace view Q12 as
(select bar from Bar_and_drinker where drinker = 'John')
intersect
(select bar from Bar_and_drinker where drinker = 'Gernot')
;

-- Q13. Bars where John drinks but Gernot doesn't

create or replace view Q13 as
(select bar from Bar_and_drinker where drinker = 'John')
except
(select bar from Bar_and_drinker where drinker = 'Gernot')

avg(price)::numeric(5,2)

create or replace view Bar_drinkers as
select b.name as bar, count(*) as ndrinkers
from   Bars b
         left outer join Frequents f on (f.bar=b.id)
         left outer join Drinkers d on (f.drinker=d.id)
group  by b.name
;























