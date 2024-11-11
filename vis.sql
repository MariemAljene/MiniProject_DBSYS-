drop table if  exists vis ;
create table vis (
    number_publications INTEGER,
    number_authors INTEGER
);
insert into vis (number_publications ,number_authors)
select k ,count(*) as number_authors 
from (
select authorId , count(*) as k from authored 
group by authorId 
 ) as nbrePub
group by k 
order by k; 
--export to csv 
\copy vis to 'vis.csv' with (format csv, header);


