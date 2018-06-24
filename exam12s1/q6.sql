-- COMP3311 12s1 Exam Q6
-- The Q6 view must have attributes called
-- (location,date,team1,goals1,team2,goals2)

drop view if exists Q6;
create view Q6(location,"date",team1,goal1,team2,goal2)
as
select m.city,m.playedon,t1.country,ifnull(ng1.numGoal,0),t2.country,ifnull(ng2.numGoal,0) 
	from matches m 
	join involves i1 on (m.id = i1.match) 
	join teams t1 on (i1.team = t1.id)
	join involves i2 on (m.id = i2.match)
	join teams t2 on (i2.team = t2.id)
	left join ngoal ng1 on (ng1.scoredin = m.id and t1.id = ng1.memberOf)
	left join ngoal ng2 on (ng2.scoredin = m.id and t2.id = ng2.memberOf)
	where t1.country < t2.country
;


create view ngoal
as
select g.scoredIn, p.memberOf, count(g.id) as numGoal from goals g join players p on (g.scoredby = p.id) group by g.scoredin,p.memberOf
;

-- Model answer

create view GoalsByTeamInMatch(match, team, goals)
as
select g.scoredIn, p.memberOf, count(g.id) from goals g join players p on (g.scoredby = p.id) group by g.scoredin,p.memberOf
;

create view TeamsInMatch(match, team, country)
as

select i.match, i.team, t.country 
from involves i 
join teams t on (i.team = t.id)

;

create view TeamScores(match, country, ngoals)
as

select tim.match, tim.country, ifnull(gtm.goals,0) 
from TeamsInMatch tim 
	left outer join GoalsByTeamInMatch gtm 
	on (tim.team = gtm.team and tim.match = gtm.match)

;

create view MatchScores(match, team1, ngoals1, team2, ngoals2)
as

select t1.match, t1.country, t1.ngoals, t2.country, t2.ngoals 
from TeamScores t1 
	join TeamScores t2 
	on (t1.match = t2.match and t1.country < t2.country)
;

create view matchStats(id,city,"date",team1,ng1,team2,ng2)
as

select m.id,m.city, m.playedon, ms.team1, ms.ngoals1, ms.team2, ms.ngoals2 
from matches m 
	join  MatchScores ms on (ms.match = m.id)

;

select * from matchStats where team1='Argentina' and team2='France' order by date;

















































create view q6_2
as
select m.city as location, m.playedOn as "date", t1.country as team1, ifnull(ng1.goal,0) as goal1, t2.country as team2, ifnull(ng2.goal,0) as goal2 from matches m 
	join involves i1 on (m.id = i1.match) 
	join teams t1 on (i1.team = t1.id)
	join involves i2 on (m.id = i2.match)
	join teams t2 on (i2.team = t2.id)
	left join ngoalss ng1 on (m.id = ng1.match and ng1.country = t1.id)
	left join ngoalss ng2 on (m.id = ng2.match and ng2.country = t2.id)
	where t1.country < t2.country
;


create view ngoalss
as
select g.scoredIn as match, p.memberOf as country, count(g.id) as goal from goals g join players p on (g.scoredby = p.id) group by g.scoredin,p.memberOf
;








