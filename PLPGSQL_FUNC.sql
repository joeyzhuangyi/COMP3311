


select rating,count(*) from ratings group by rating having count(*) > 50
;


select players,birthday from players where age(birthday) = (select min(age(birthday)) from players)
;

-- whats the average of a particular team
select country, avg(age(birthday)) from players p join team t on p.memberof = t.id group by t.country
;

-- how many match did player A played in
-- player A played for team AA, so the number of match team AA played = the number of match player A played
select count(*) from
	players p join team t on p.memberOf = t.id
	involves inv join team t on t.id = inv.team
	where p.name = 'A'
;

-- count the goal each player score
select name, count(g.id) from players p join goals g on (g.scoredby = p.id) group by name
;


select name, count(g.id) from players p left join goals g on (g.scoredby = p.id) group by name
;


-- show the players and their goals, where the goals is only type "amazing", and larger than 1

select p.name from players p join goals g on g.scoredby = p.id where g.type = 'amazing' group by p.name having count(g.id) > 1
;

select t1.country, t2.country, m.id
from match m 
join involes i1 on m.id = i1.match
join involes i2 on m.id = i2.match
join team t1 on t1.id = i1.team
join team t2 on t2.id = i2.team
where t1.country < t2.country

create or replace view viewname(arg1,arg2) as


;





create or replace function Q8(integer)
	returns setof NewTranscriptRecord
as $$
declare
	... PLpgSQL variable delcarations ...
begin
	... PLpgSQL code ...
end;
$$ language plpgsql
;



CREATE OR REPLACE FUNCTION public.test(_sid integer)
 RETURNS SETOF NewTranscriptRecord
 LANGUAGE plpgsql
AS $function$
declare
        rec NewTranscriptRecord;
        UOCtotal integer := 0;
        UOCpassed integer := 0;
        wsum integer := 0;
        wam integer := 0;
        x integer;
begin
        select s.id into x
        from   Students s join People p on (s.id = p.id)
        where  p.unswid = _sid;
        if (not found) then
                raise EXCEPTION 'Invalid student %',_sid;
        end if;
        for rec in
                select cast(su.code,char(8)),
                       	cast(substr(t.year::text,3,2)||lower(t.term),4),
                       	cast(pro.id,char(4)),
                        cast(substr(su.name,1,20),text),
                        cast(e.mark,integer), cast(e.grade,char(2)), cast(su.uoc,integer)
                from   People p
                         join Students s on (p.id = s.id)
                         join Course_enrolments e on (e.student = s.id)
                         join Courses c on (c.id = e.course)
                         join Subjects su on (c.subject = su.id)
                         join Semesters t on (c.semester = t.id)
                         join programs pro on (pro.student = s.id)
                where  p.unswid = _sid
                order  by t.starting, su.code
        loop
                if (rec.grade = 'SY') then
                        UOCpassed := UOCpassed + rec.uoc;
                elsif (rec.mark is not null) then
                        if (rec.grade in ('PT','PC','PS','CR','DN','HD','A','B','C')) then
                                -- only counts towards creditted UOC
                                -- if they passed the course
                                UOCpassed := UOCpassed + rec.uoc;
                        end if;
                        -- we count fails towards the WAM calculation
                        UOCtotal := UOCtotal + rec.uoc;
                        -- weighted sum based on mark and uoc for course
                        wsum := wsum + (rec.mark * rec.uoc);
                        -- don't give UOC if they failed
                        if (rec.grade not in ('PT','PC','PS','CR','DN','HD','A','B','C')) then
                            rec.uoc := 0;
                        end if;

                end if;
                return next rec;
        end loop;
        if (UOCtotal = 0) then
                rec := (null,null,'No WAM available',null,null,null);
        else
                wam := wsum / UOCtotal;
                rec := (null,null,'Overall WAM',wam,null,UOCpassed);
        end if;
        -- append the last record containing the WAM
        return next rec;
end;
$function$
;











CREATE OR REPLACE FUNCTION public.test(_sid integer)
 RETURNS SETOF transcriptrecord
 LANGUAGE plpgsql
AS $function$
declare
        rec TranscriptRecord;
        UOCtotal integer := 0;
        UOCpassed integer := 0;
        wsum integer := 0;
        wam integer := 0;
        x integer;
begin
        select s.id into x
        from   Students s join People p on (s.id = p.id)
        where  p.unswid = _sid;
        if (not found) then
                raise EXCEPTION 'Invalid student %',_sid;
        end if;
        for rec in
                select su.code,
                         substr(t.year::text,3,2)||lower(t.term),
                         substr(su.name,1,20),
                         e.mark, e.grade, su.uoc
                from   People p
                         join Students s on (p.id = s.id)
                         join Course_enrolments e on (e.student = s.id)
                         join Courses c on (c.id = e.course)
                         join Subjects su on (c.subject = su.id)
                         join Semesters t on (c.semester = t.id)
                where  p.unswid = _sid
                order  by t.starting, su.code
        loop
                if (rec.grade = 'SY') then
                        UOCpassed := UOCpassed + rec.uoc;
                elsif (rec.mark is not null) then
                        if (rec.grade in ('PT','PC','PS','CR','DN','HD','A','B','C')) then
                                -- only counts towards creditted UOC
                                -- if they passed the course
                                UOCpassed := UOCpassed + rec.uoc;
                        end if;
                        -- we count fails towards the WAM calculation
                        UOCtotal := UOCtotal + rec.uoc;
                        -- weighted sum based on mark and uoc for course
                        wsum := wsum + (rec.mark * rec.uoc);
                        -- don't give UOC if they failed
                        if (rec.grade not in ('PT','PC','PS','CR','DN','HD','A','B','C')) then
                            rec.uoc := 0;
                        end if;

                end if;
                return next rec;
        end loop;
        if (UOCtotal = 0) then
                rec := (null,null,'No WAM available',null,null,null);
        else
                wam := wsum / UOCtotal;
                rec := (null,null,'Overall WAM',wam,null,UOCpassed);
        end if;
        -- append the last record containing the WAM
        return next rec;
end;
$function$
;
