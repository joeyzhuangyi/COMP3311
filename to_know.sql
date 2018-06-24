avg(price)::numeric(5,2)


union, except, intersect

left outer join, join

create or replace view Q6 as
select b1.name as beer1, b2.name as beer2
from   Beers b1
         join Beers b2 on (b1.brewer=b2.brewer)
where  b1.name < b2.name
;

group by, aggregate