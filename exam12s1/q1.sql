-- COMP3311 12s1 Exam Q1
-- The Q1 view must have attributes called (team,matches)

drop view if exists Q1;
create view Q1
as

select country, count(*) from teams t join involves i on (t.id = i.team) group by country;

;

select teams.country,count(*) from involves join teams on (teams.id = involves.team) group by teams.id;