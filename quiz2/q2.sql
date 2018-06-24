
create table R (a integer, b varchar(10), c numeric(4,2));
create table S (b varchar(10), d integer);

insert into R values(1,'first',3.14);
insert into R values(2,'second',2.18);
insert into R values(3,'third',1.5);
insert into R values(4,'fourth',3.14);

insert into S values('first',2);
insert into S values('third',3);
insert into S values('fifth',4);