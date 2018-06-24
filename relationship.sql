create table enrols (

	student_id integer,
	course_id integer,

	primary key(student_id,course_id),
	foreign key (student_id) references Students(id),
	foreign key course_id references Course(id)

);


create table courses (

	id integer,
	convenor integer,

	primary key (id),
	foreign key (staff_id) references Staff(id)

);

create table staffs (

	id integer,

	primary key (id)

);