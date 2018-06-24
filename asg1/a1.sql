-- COMP3311 18s1 Assignment 1
-- Written by YOUR_NAME (YOUR_STUDENT_ID), April 2018

-- Q1: ...

create or replace view Q1(unswid, name)
as
select unswid,name from People where id in (select distinct student from course_enrolments where student in (select student from course_enrolments group by student having count(student) > 65)) order by unswid
;

-- Q2: ...

create or replace view Q2(nstudents, nstaff, nboth)
as
select
(select count(id) from people where(id in (select id from students))) as nstudents,
(select count(id) from people where(id in (select id from staff))) as nstaff,
(select count(id) from people where(id in (select id from staff) and id in (select id from students))) as nboth
;

-- Q3: ...

create or replace view Q3(name, ncourses)
as

select name,ncourses from people PPL inner join (select staff, count(staff) as ncourses from course_staff where role = (select id from staff_roles where name='Course Convenor') group by staff order by ncourses DESC limit 1) table2 on PPL.id = table2.staff
;

-- Q4: ...

create or replace view Q4a(id)
as
select unswid from People PPL where id in (select student from program_enrolments PE inner join programs P on PE.program = P.id where (P.id = 6355 or P.id = 554) and PE.semester=(select id from semesters where year=2005 and term='S2')) 
;


create or replace view Q4b(id)
as

select unswid from People PPL where id in (select student from program_enrolments where id in (select partof from stream_enrolments where stream in (select id from streams where code = 'SENGA1')) and semester = (select id from semesters where year=2005 and term='S2')) order by id
;

create or replace view Q4c(id)
as
select unswid from People PPL where id in (select student from program_enrolments where program in (select id from programs where offeredby = 89) and semester = (select id from semesters where year=2005 and term='S2')) order by id
;

... one SQL statement, possibly using other views defined by you ...
;

-- Q5: ...

-- step_1: find all org that is a committe from orgunits
-- step_2: find where all that org facultyOf
-- step_3: count them, find max, find the name of that max faculty

-- create or replace view idOfFaculty(id)
-- as
-- select newTable.id
-- from (select facultyOf(ou.id) as id
-- from orgunits OU
-- where ou.utype = 9) newTable
-- join orgunits OU on OU.id = newTable.id
-- where newTable.id is not null
-- group by newTable.id order by count(newTable.id) DESC limit 1
-- ;


create or replace view Q5(name)
as

select name from orgunits where id = (
select faculty.id
from (select facultyOf(ou.id) as id
from orgunits OU
where ou.utype = 9) faculty
join orgunits OU on OU.id = faculty.id
where faculty.id is not null
group by faculty.id order by count(faculty.id) DESC limit 1)
;

-- Q6: ...

create or replace function Q6(integer) returns text
as
$$
select name from people where id = $1 or unswid = $1
$$ language sql
;


-- Q7: ...
-- find course, find staff with role = course convenor
create or replace function Q7(text)
	returns table (course text, year integer, term text, convenor text)
as $$

select cast(S.code as text), cast(Sem.year as integer), cast(Sem.term as text), cast(P.name as text)
from subjects S 
join courses C on S.id = C.subject
join course_staff CS on CS.course = C.id
join semesters Sem on Sem.id = C.semester
join people P on CS.staff = P.id 
where CS.role = (select id from staff_roles where name='Course Convenor') and S.code = $1

$$ language sql
;





-- Q8: ...

create or replace function Q8(integer)
	returns setof NewTranscriptRecord
as $$

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
    where  p.unswid = $1;
    if (not found) then
            raise EXCEPTION 'Invalid student %',$1;
    end if;
        for rec in
                select su.code,
                         substr(t.year::text,3,2)||lower(t.term),
                         pr.code,
                         substr(su.name,1,20),
                         e.mark, 
                         e.grade, 
                         su.uoc
                from   People p
                         join Students s on (p.id = s.id)
                         join Course_enrolments e on (e.student = s.id)
                         join Courses c on (c.id = e.course)
                         join Subjects su on (c.subject = su.id)
                         join Semesters t on (c.semester = t.id)
                         join program_enrolments pe on (pe.semester = t.id and pe.student = p.id)
                         join programs pr on (pe.program = pr.id)

                where  p.unswid = $1
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
                rec := (null,null,null,'No WAM available',null,null,null);
        else
                wam := wsum / UOCtotal;
                rec := (null,null,null,'Overall WAM',wam,null,UOCpassed);
        end if;
        -- append the last record containing the WAM
        return next rec;
end;
$$ language plpgsql
;













-- Q9: ...

create or replace function Q9(integer)
	returns setof AcObjRecord
as $$
declare

	_gType text;
	_gDefinition text;
	_gDefBy text;
	_subjectList text[];
	_finalSubject text;
	_subject text;
	_string text;
	_bracketStr text;
	_num1 integer;
	_num2 integer;
	_i integer;
	_numArr text[];
	_j text;

	_subjectL text[];
	_code text;
	_acad_obj AcObjRecord;


begin

	_gDefinition := (select AOG.definition from acad_object_groups AOG where AOG.id = $1 ); 
	_gDefBy := (select AOG.gdefby from acad_object_groups AOG where AOG.id = $1 ); 
	_gType := (select AOG.gtype from acad_object_groups AOG where AOG.id = $1 ); 

	if (_gDefinition is null or _gDefBy <> 'pattern') then
		return;
    
  elsif (_gDefinition like '%{%}%' or _gDefinition like '%/F=%') then
    return;
    
	else

		select regexp_split_to_array(_gDefinition, ',') into _subjectList;

		foreach _subject in array _subjectList loop

      -- free elec case
			if (_subject like 'FREE%' or _subject like 'GEN%' or _subject like 'ZGEN%') then
				_acad_obj.objtype := _gType;
				_acad_obj.object := _subject;
				return next _acad_obj;

			elsif (_subject like '%[%]%') then

				_string := replace(_subject,'[',',');
                _string := replace(_string,']',',');
                _string := replace(_string,'#','%');
 
               _bracketStr := split_part(_string,',',2);

               if (_bracketStr like '%-%') then
               		_num1 := split_part(_bracketStr,'-',1)::integer;
               		_num2 := split_part(_bracketStr,'-',2)::integer;

               		for _i in _num1.._num2 loop

               			_finalSubject := replace(_string,','||_bracketStr||',',_i::text);

               			for _acad_obj.object in 
               			select distinct s.code from subjects s where s.code like _finalSubject order by s.code
               			loop
               				_acad_obj.objtype = _gType;
               				return next _acad_obj;
               			end loop;

               		end loop;

               else -- [nnnnn]
               		select regexp_split_to_array(_bracketStr, '\s*') into _numArr;

               		foreach _j in array _numArr loop

               			_finalSubject := replace(_string,','||_bracketStr||',',_j);

               			for _acad_obj.object in 
               			select distinct s.code from subjects s where s.code like _finalSubject order by s.code
               			loop
               				_acad_obj.objtype = _gType;
               				return next _acad_obj;
               			end loop;

               		end loop;

               end if; 

            elsif (_subject like '%(%)%') then

            	_code := split_part(_subject,')',2);
                _string := replace(_subject,_code,'');
                _code := replace(_code,'#','%');

                _string := replace(_string,'(','');
                _string := replace(_string,')','');


                _subjectL := regexp_split_to_array(_string,'\|');


            	foreach _j in array _subjectL loop
            	
            		_finalSubject := _j || _code;

            		for _acad_obj.object in 
               			select distinct s.code from subjects s where s.code like _finalSubject order by s.code
               			loop
               				_acad_obj.objtype = _gType;
               				return next _acad_obj;
               			end loop;

            	end loop;
            	

            else

            	_finalSubject := replace(_subject,'#','%');

            	for _acad_obj.object in 
       			select distinct s.code from subjects s where s.code like _finalSubject order by s.code
       			loop
       				_acad_obj.objtype = _gType;
       				return next _acad_obj;
       			end loop;
			end if;


		end loop;
		
	end if;


end;
$$ language plpgsql
;

create table Person (

  id text check (id ~ '[0-9]{5}'),
  name text,
  student boolean,
  degree text,
  staff boolean,
  salary float check (salary > 0) not null, 
  primary key (id)

  constraint overlappingStudentStaff check (student is null and degree is null) or 
  (staff is null and salary is null) or
  (student is not null and degree is not null) or 
  (staff is not null and salary is not null)

);

