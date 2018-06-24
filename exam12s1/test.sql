create view mGoal 
as
select m.id as "match",t.id as "team", count(g.id) as "goal" from matches m 
	join goals g on (m.id = g.scoredin)
	join players p on (g.scoredby = p.id)
	join teams t on (t.id = p.memberof)
	group by t.id,m.id
	order by m.id
;

create view resultt
as
select m.city, m.playedon as "date", t1.country as "team1", ifnull(mg1.goal,0), t2.country as "team2", ifnull(mg2.goal,0) from matches m 
	join involves i1 on (m.id = i1.match)
	join teams t1 on (t1.id = i1.team)
	left join mGoal mg1 on (m.id = mg1.match and t1.id = mg1.team)
	join involves i2 on (m.id = i2.match)
	join teams t2 on (t2.id = i2.team)
	left join mGoal mg2 on (m.id = mg2.match and t2.id = mg2.team)
;
