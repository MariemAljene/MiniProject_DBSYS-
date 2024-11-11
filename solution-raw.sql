--First Query 
Select p AS publication_type , COUNT(*) AS totalByGroup FROM pub GROUP BY p ;  
--Result 
 --publication_type | totalbygroup
------------------+--------------
 --article          |      3645597
 --book             |        20853
-- incollection     |        70652
 --inproceedings    |      3561274
 --mastersthesis    |           27
 --phdthesis        |       136925
 --proceedings      |        59721
 --www              |      3620544
--(8 rows)  

--Second Query 
select distinct(p) as publicationtypes
from pub
where k LIKE 'conf%'; 
--Result 
--publicationtypes
------------------
--article
 --proceedings
 --incollection
 --inproceedings
 --book
--(5 rows)

--Third Query
SELECT f.p
FROM field f
JOIN pub p ON f.k = p.k
GROUP BY f.p
HAVING COUNT(DISTINCT p.p) = (SELECT COUNT(DISTINCT p) FROM pub); 
--Result 
-- p
--------
 --author
 --ee
 --note
 --title
-- year
--(5 rows) 

--Fourth Query 

select f.p
from field f, pub p
where f.k = p.k
group by f.p
having count(distinct p.p) <= 1; 

--Result
 --   p
---------
-- address
-- chapter
--(2 rows)
