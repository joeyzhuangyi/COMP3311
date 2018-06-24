






create or replace view Q1(nacc) as
select count(acctime) from accesses where acctime::text like '%03-02%'
;

create or replace view Q2(nsearches) as 
select page, params from Accesses where page::text like '%messageboard%' and params like'%search%'
;

create or replace view Q3(hostname) as 
select distinct h.hostname as hostname from hosts h 
join sessions s on s.host = h.id
where h.hostname::text like 'tuba%cse.unsw.edu.au' and not s.complete 
;

create or replace view Q4(min,avg,max) as
select
(select min(nbytes) from Accesses) as min,
(select avg(nbytes)::integer from Accesses) as avg,
(select max(nbytes) from Accesses) as max
;

create view Q4 as
select min(nbytes) as min, avg(nbytes) as avg, max(nbytes) as max
from   Accesses;

create or replace view Q5 as
select count(*) as nhosts from hosts h
join sessions s on s.host = h.id
where h.hostname like '%cse.unsw.edu.au'
;

create or replace view Q6 as
select count(*) as nhosts from hosts h
join sessions s on s.host = h.id
where h.hostname not like '%cse.unsw.edu.au'
;


create or replace view Q7 as 
	select session, count(*) as length from accesses group by session order by length desc limit 1
;

create view Q8 as
select page, count(*) as freq
from   Accesses
group by page
order by count(*) desc
;

-- Q9: frequency of module accesses
-- This is NOT a proper solution
-- SQLite doesn't have the right string functions to solve this problem

create view ModuleAccess as
select session, seq, page as module
from   Accesses;

create view Q9 as
select module, count(*) as freq
from   ModuleAccess
group by module
order by count(*) desc
;

-- Q10: "sessions" which have no page accesses

create view Q10 as
select id as session
from   Sessions s
where  not exists (select * from Accesses where session=s.id);


-- Q11: hosts which are not the source of any sessions

create view Q11 as
select h.hostname as unused
from   Hosts h left outer join Sessions s on (h.id=s.host)
group  by h.hostname
having count(s.id) = 0;















q4: select min(nbytes), round(avg(nbytes),0), max(nbytes) from accesses;



















































