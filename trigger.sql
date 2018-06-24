create trigger name
	after insert or delete or update
	on tablename
	for each row
	execute procedure updateTrigger(); 

-- Within the trigger body, the OLD and NEW keywords enable you to access columns in the rows affected by a trigger
-- In an INSERT trigger, only NEW.col_name can be used.
-- In a UPDATE trigger, you can use OLD.col_name to refer to the columns of a row before it is updated and NEW.col_name to refer to the columns of the row after it is updated.
-- In a DELETE trigger, only OLD.col_name can be used; there is no new row.

create trigger maintainVcount
	after insert or delete
	on SoldIn
	for each row 
	execute procedure changeVarieties();



create trigger triggerName
	after before insert or delete or update
	on tablename
	for each row
	execute procedure functionName();


create or replace function changeVarieties() returns trigger 
as $$

$$ language 'plpgsql';



create or replace function changeVarieties() returns trigger
as $$

begin
	if TG_OP = 'insert' then
		update Stores set varieties = varieties + 1 where id = NEW.store;
	else if TG_OP = 'delete' then
		update Stores set varieties = varieties - 1 where id = OLD.store;
	else 

	end if;
	return null;
end

$$ language 'plpgsql';


-- Trigger writing practice

create function triggerUpdateInsertDelete() returns trigger
as $$

begin
	if TG_OP = 'insert' then

		update tablename set count = count + 1 where id = NEW.id;

	else if TG_OP = 'update' then

		if (NEW.col != OLD.col) then
			update tablename set count = count + 1 where id = new.id;
		end if

	else if TG_OP = 'delete' then
		update tablename set count = count + 1 where id = NEW.id;
	end if
end

$$ language 'plpgsql';

insert into table(col1,col2,col3) values(1,2,3);
insert into table(col1,col2,col3) values(1,2,3);


insert into employees(id,name,salary) values(1,"Sean","100 000");






create trigger emp_log_mod 
	after insert
	on em_details
	for each row
	execute procedure rec_insert();

create or replace function rec_insert returns trigger 
as $$

begin
	insert into emp_log(id,name,"time") values(5,"sean","10:38"); 
end

$$ language 'plpgsql';


create trigger insert_trigger
	before insert
	on emp_details
	for each row
	execute procedure capitalizeStuff();

create or replace function capitalizeStuff() returns trigger
as $$

declare

begin

	NEW.first = ltrim(NEW.first);
	NEW.last = ltrim(NEW.last);
	NEW.field = upper(NEW.field);

	return NEW;

end
$$ language 'plpgsql';














