-- COMP3311 12s1 Exam Q2
-- The Q2 view must have one attribute called (player,goals)

drop view if exists Q2;
create view Q2
as

select p.name, count(*) 
	from players p 
	join goals g on (p.id = g.scoredBy) 
	where rating = 'amazing' 
	group by p.name having count(*) > 1;

;

select p.name,  count(*) 
from goals g 
join players p on (g.scoredby = p.id) 
where rating = 'amazing' 
group by p.id 
having count(*) > 1;