-- COMP3311 12s1 Exam Q3
-- The Q3 view must have attributes called (team,players)

drop view if exists Q3;
create view Q3
as

select t.country, count(*) from teams t 
	join players p on (p.memberOf = t.id)
	where p.id not in (select scoredBy from goals)
	group by t.country order by count(*) desc limit 1

;



select t.country,count(*) 
from teams t 
join players p on (p.memberOf = t.id) 
where p.id not in (select scoredBy from goals) 
group by t.id order by count(*) desc limit 1;









































































