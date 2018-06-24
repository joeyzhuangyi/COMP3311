-- COMP3311 12s1 Exam Q4
-- The Q4 view must have attributes called (team1,team2,matches)

drop view if exists Q4;
create view Q4
as
select t1.country, t2.country, count(*) from matches m 
	join involves i1 on (m.id = i1.match) 
	join teams t1 on (i1.team = t1.id)
	join involves i2 on (m.id = i2.match)
	join teams t2 on (i2.team = t2.id)
	where t1.country < t2.country
	group by t1.country,t2.country 
	having count(*) = (select count(*) from matches m 
	join involves i1 on (m.id = i1.match) 
	join teams t1 on (i1.team = t1.id)
	join involves i2 on (m.id = i2.match)
	join teams t2 on (i2.team = t2.id)
	where t1.country < t2.country
	group by t1.country,t2.country order by count(*) desc limit 1)
;

select t1.country, t2.country, count(*) as maxM
from matches m
join involves i1 on (m.id = i1.match)
join teams t1 on (i1.team = t1.id)
join involves i2 on (m.id = i2.match)
join teams t2 on (i2.team = t2.id)
where t1.country < t2.country
group by t1.country, t2.country
having maxM = (select count(*) as maxMatch
from matches m
join involves i1 on (m.id = i1.match)
join teams t1 on (i1.team = t1.id)
join involves i2 on (m.id = i2.match)
join teams t2 on (i2.team = t2.id)
where t1.country < t2.country
group by t1.country, t2.country
order by count(*) desc limit 1
)
;




























































































































