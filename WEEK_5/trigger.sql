

-- WEEK 5:


triggers = event-driven programming on db, 
trigger contain a function, that is invoked when certain events happen, for example: insert, delete, checking constraints

write a function nvarieties to count number of diffrent pizza in a store

if we run this nvarieties for every single store, after an event has happen, it would be very expensive

Solution: 

alter table Stores add column varieties integer;

update Stores set varieties = nvarieties(id)

create or replace function
	changeVarieties() return trigger
as $$
begin
	if TG_OP = 'INSERT' then

		update Stores
		set varieties = varieties + 1
		where id = NEW.Store;

	elsif TG_OP ='DELETE' then

		update Stores
		set varieties = varieties -1
		where id = OLD.Store;

	else

		raise exception 'changeVarieties() failed';

	endif;

	return null;
end;
$$ language 'plpgsql';

delete from SoldIn where pizza = 28 and store = 100;
insert into SoldIn values (29,100,1000); 















CREATE FUNCTION percentage_change_func(_asset_symbol text)
  RETURNS TABLE(asset_date date, price numeric, pct_change numeric) AS
$func$
DECLARE
   last_price numeric;
BEGIN

FOR asset_date, price IN
   SELECT a.asset_date, a.price
   FROM   asset_histories a
   WHERE  a.asset_symbol = _asset_symbol 
   ORDER  BY a.asset_date  -- traverse ascending
LOOP
   pct_change := price / last_price; -- NULL if last_price is NULL
   RETURN NEXT;
   last_price := price;
END LOOP;

END
$func$ LANGUAGE plpgsql STABLE

















































