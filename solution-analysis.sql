--First Query 
select   author.authorName , count(*) as total
from  author 
join authored on author.authorId = authored.authorId
join publication on authored.pubId = publication.pubId
where publication.year >=  2010
group by author.authorName 
order by total desc 
limit 15;

---Result
 ---     authorname      | total
----------------------+-------
 ---H. Vincent Poor      |  2326
--- Dacheng Tao          |  1905
 ---Yang Liu             |  1903
 ---Mohamed-Slim Alouini |  1848
 ---Zhu Han 0001         |  1844
 ---Wei Wang             |  1839
 ---Wei Zhang            |  1795
 ---Yu Zhang             |  1726
 ---Lei Wang             |  1609
 ---Philip S. Yu         |  1607
 ---Dusit Niyato         |  1552
 ---Wei Li               |  1500
 ---Jing Wang            |  1489
 ---Xin Wang             |  1476
 ---Wei Liu              |  1452
(15 rows)

--Second Query 
select   author.authorName , count(*) as total
from author
 join authored on author.authorId = authored.authorId
join publication on authored.pubId = publication.pubId
join inproceedings on publication.pubId = inproceedings.inproceedingsId
group by author.authorName
order by total desc
limit 15 ; 
--Result 
  --  authorname      | total
----------------------+-------
 --H. Vincent Poor      |   969
 --Philip S. Yu         |   698
 --Wei Zhang            |   686
 --Mohamed-Slim Alouini |   679
 --Wei Wang             |   659
 --Zhu Han 0001         |   650
 --Yang Liu             |   647
 --Dacheng Tao          |   635
 --Lajos Hanzo          |   630
 --Yu Zhang             |   586
 --Lei Wang             |   579
 --Xin Wang             |   561
 --Witold Pedrycz       |   559
 --Luc Van Gool         |   546
 --Yi Zhang             |   528
--(15 rows)

--Third Query  
--for Sigmod conference
select  author.authorName , count(*) as total
from author join authored on author.authorId = authored.authorId
join publication on authored.pubId = publication.pubId
where publication.pubKey LIKE  'conf/sigmod%'
group by author.authorName
order by total desc 
limit 15;

--Result 
 --       authorname        | total
-------------------------+-------
 --Surajit Chaudhuri       |    63
 --Divesh Srivastava       |    63
 --H. V. Jagadish          |    55
 --Tim Kraska              |    50
 --Michael J. Franklin     |    48
 --Michael Stonebraker     |    48
 --Jeffrey F. Naughton     |    47
 --Beng Chin Ooi           |    47
 --Michael J. Carey 0001   |    47
 --Guoliang Li 0001        |    43
 --Carsten Binnig          |    43
 --Samuel Madden 0001      |    43
 --Donald Kossmann         |    41
 --Jiawei Han 0001         |    41
 --Raghu Ramakrishnan 0001 |    41
--(15 rows)


 ----for VLDB conference
select    author.authorName , count(*) as total
from author join authored on author.authorId = authored.authorId
join publication on authored.pubId = publication.pubId
where publication.pubKey like 'conf/vldb%'
group by author.authorName
order by total desc 
limit 20 ;


--Result
 --      authorname        | total
-------------------------+-------
 --H. V. Jagadish          |    35
 --Raghu Ramakrishnan 0001 |    30
 --David J. DeWitt         |    29
 --Michael Stonebraker     |    28
 --Jeffrey F. Naughton     |    27
 --Hector Garcia-Molina    |    27
 --Rakesh Agrawal 0001     |    27
 --Surajit Chaudhuri       |    26
 --Michael J. Carey 0001   |    26
 --Divesh Srivastava       |    25
 --Christos Faloutsos      |    25
 --Gerhard Weikum          |    25
 --Alfons Kemper           |    23
 --Michael J. Franklin     |    22
 --Nick Koudas             |    22
 --Abraham Silberschatz    |    22
 --Philip A. Bernstein     |    21
 --Jiawei Han 0001         |    21
 --Philip S. Yu            |    21
 --Jennifer Widom          |    20
(20 rows) 
--Fourth Query
--First Part  
SELECT author.authorName
FROM author
JOIN authored ON author.authorId = authored.authorId
JOIN publication ON authored.pubId = publication.pubId
GROUP BY author.authorName
HAVING COUNT(CASE WHEN publication.pubkey LIKE 'conf/sigmod%' THEN 1 END) >= 18
   AND COUNT(CASE WHEN publication.pubkey LIKE 'conf/pods%' THEN 1 END) = 0;

--Result 
-------------------------------------------------------------------------------------------
 --Arun Kumar 0001
 --Badrish Chandramouli
 --Barzan Mozafari
 --Bin Cui 0001
-- Carsten Binnig
-- David B. Lomet
 --Donald Kossmann
 --Elke A. Rundensteiner
 --Eugene Wu 0002
 --Feifei Li 0001
 --Gao Cong
-- Gautam Das 0001
 --Guoliang Li 0001
 --Hans-Arno Jacobsen
 --Ihab F. Ilyas
 --Immanuel Trummer
 --Ion Stoica
 --Jeffrey Xu Yu
 --Jian Pei
 --Jiawei Han 0001
 --Jignesh M. Patel
 --Jim Gray 0001
 --Jingren Zhou
 --Jun Yang 0001
 --Kevin Chen-Chuan Chang
 --Lei Chen 0002
 --Michael Stonebraker
 --Mourad Ouzzani
 --Nan Tang 0001
 --Peter A. Boncz
 --Samuel Madden 0001
 --Sihem Amer-Yahia
 --Sourav S. Bhowmick
 --Stratos Idreos
 --Tilmann Rabl
 --Tim Kraska
 --Volker Markl
 --Xiaokui Xiao
--(43 rows)

--Second Part
SELECT author.authorName
FROM author
JOIN authored ON author.authorId = authored.authorId
JOIN publication ON authored.pubId = publication.pubId
GROUP BY author.authorName
HAVING COUNT(CASE WHEN publication.pubkey LIKE 'conf/sigmod%' THEN 1 END) = 0
   AND COUNT(CASE WHEN publication.pubkey LIKE 'conf/pods%' THEN 1 END) >= 8;
 
--Result 
      authorname
-----------------------
 --Andreas Pieris
 --David P. Woodruff
 --Giuseppe De Giacomo
 --Jef Wijsen
 --Martin Grohe
 --Nicole Schweikardt
 --Nofar Carmeli
 --Rasmus Pagh
 --Stavros S. Cosmadakis
 --Thomas Schwentick
(10 rows)

--Extra credit  
-- Drop the table if it already exists before creating a new one
DROP TABLE IF EXISTS CalculateAuthorPublicationByDecade;
CREATE TABLE CalculateAuthorPublicationByDecade AS 
SELECT authored.authorId,
    FLOOR(publication.year / 10) * 10 AS start_year,
    FLOOR(publication.year / 10) * 10 + 9 AS end_year,
    COUNT(*) AS publication_count
FROM  publication
JOIN  authored ON publication.pubId = authored.pubId
WHERE  publication.year % 10 = 0  
GROUP BY authored.authorId, start_year;
SELECT 
    start_year, 
    end_year, 
    authorId, 
    publication_count AS max_publication_count
FROM CalculateAuthorPublicationByDecade
WHERE  (start_year, publication_count) 
IN 
(SELECT start_year,MAX(publication_count) 
FROM CalculateAuthorPublicationByDecade
GROUP BY start_year)
ORDER BY start_year, max_publication_count desc; 
DROP TABLE IF EXISTS CalculateAuthorPublicationByDecade;
--result
-- start_year | end_year | authorid | max_publication_count
------------+----------+----------+-----------------------
--       1940 |     1949 |  1349441 |                     3
--       1950 |     1959 |  1172726 |                     4
--       1960 |     1969 |  1015685 |                     4
--       1960 |     1969 |  1211887 |                     4
--       1960 |     1969 |  2737382 |                     4
--       1960 |     1969 |   299463 |                     4
--       1960 |     1969 |   416333 |                     4
--       1960 |     1969 |  1183629 |                     4
--       1970 |     1979 |  3075676 |                    18
--       1980 |     1989 |  1101451 |                    21
--       1990 |     1999 |  3261983 |                    27
--       2000 |     2009 |   398116 |                   139
--       2010 |     2019 |    82071 |                    78      
--       2020 |     2029 |  1138020 |                   262
--(15 rows)