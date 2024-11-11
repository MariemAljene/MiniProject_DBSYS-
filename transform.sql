DELETE FROM author;
DELETE FROM publication;
DELETE FROM article;
DELETE FROM book;
DELETE FROM incollection;
DELETE FROM inproceedings;
DELETE FROM authored;

-- For Table Author

CREATE TABLE IF NOT EXISTS distinct_authors (
    author_name TEXT
);

INSERT INTO distinct_authors (author_name)
SELECT DISTINCT field.v
FROM field
WHERE field.p = 'author';

CREATE TABLE IF NOT EXISTS author_name_url (
    authorName TEXT,
    url TEXT,
    PRIMARY KEY (authorName, url)
);

INSERT INTO author_name_url (authorName, url)
SELECT authoreName.v AS authorName, Url.v AS url 
FROM field AS authoreName
JOIN field AS Url ON authoreName.k = Url.k 
WHERE authoreName.p = 'author' AND Url.p = 'url' AND Url.k LIKE 'homepages%'
ON CONFLICT (authorName, url) DO NOTHING;

CREATE SEQUENCE authorId;

INSERT INTO author (authorId, authorName, homepage)
SELECT 
    nextval('authorId') AS authorId,  
    distinct_authors.author_name,
    COALESCE(STRING_AGG(a.url, ', '), '') AS homepage
FROM distinct_authors
LEFT JOIN author_name_url a ON distinct_authors.author_name = a.authorName
GROUP BY distinct_authors.author_name;

DROP TABLE IF EXISTS distinct_authors;
DROP TABLE IF EXISTS author_name_url;
DROP SEQUENCE IF EXISTS authorId;


--table for publication  


delete from publication;
CREATE SEQUENCE publicationId;

CREATE TABLE TitleTable (
    titleId TEXT PRIMARY KEY,
    title TEXT
);

INSERT INTO TitleTable (titleId, title)
SELECT k, v
FROM field
WHERE p = 'title'
ON CONFLICT (titleId) DO NOTHING;

CREATE TABLE YearTable (
    yearId TEXT PRIMARY KEY,
    year INT
);

INSERT INTO YearTable (yearId, year) 
SELECT k, CAST(v AS INT)
FROM field
WHERE p = 'year'
ON CONFLICT (yearId) DO NOTHING;


CREATE TABLE CombinedTable (
    titleId TEXT UNIQUE, 
    title TEXT,
    year INT
);

INSERT INTO publication (pubId ,pubkey, title, year )
SELECT    nextval('publicationId') AS pubId,  
t.titleId as pubkey ,
t.title, y.year
FROM TitleTable t
LEFT JOIN YearTable y ON t.titleId = y.yearId
ON CONFLICT (pubkey) DO NOTHING;  

DROP TABLE IF EXISTS TitleTable;
DROP TABLE IF EXISTS YearTable;
drop table if exists CombinedTable;
drop sequence if exists publicationId;

--table for article 
delete from article; 
ALTER TABLE article DROP CONSTRAINT IF EXISTS fk_article_publication;
create sequence articleId;  
create table article_journal (
    pubKey TEXT PRIMARY KEY,
    journal TEXT
); 
insert into article_journal(pubKey, journal)
select k, v
from field
where p = 'journal' and k in (select pubkey from publication)
on conflict (pubKey) do nothing;

create table article_month (
    pubKey TEXT PRIMARY KEY,
    month TEXT
); 
insert into article_month(pubKey, month)
select k, v
from field
where p = 'month' and k in (select pubkey from publication)
on conflict (pubKey) do nothing;

create table article_volume (
    pubKey TEXT PRIMARY KEY,
    volume text
);
insert into article_volume(pubKey, volume)
select k, v as INT
from field
where p = 'volume' and k in (select pubkey from publication)
on conflict (pubKey) do nothing;

create table article_number (
    pubKey TEXT PRIMARY KEY,
    number text
);
insert into article_number(pubKey, number)
select k, v 
from field
where p = 'number' and k in (select pubkey from publication)
on conflict (pubKey) do nothing;

insert into article(articleId, journal, month, volume, number)
select nextval('articleId') as articleId, journal, month, volume, number
from pub 
join publication on pub.k = publication.pubkey
LEFT JOIN article_journal on pub.k = article_journal.pubKey 
LEFT JOIN article_month on pub.k = article_month.pubKey
LEFT JOIN article_volume on pub.k = article_volume.pubKey
LEFT JOIN article_number on pub.k = article_number.pubKey
where pub.p='article';


drop sequence if exists articleId;
drop table if exists article_journal;
drop table if exists article_month;
drop table if exists article_volume;
drop table if exists article_number;
--It's displaying an error ! I have to comeback here later
alter table article add constraint fk_article_publication foreign key (pubId) references publication(pubId) on delete cascade;

--table for book 

DELETE FROM book;
ALTER TABLE book DROP CONSTRAINT IF EXISTS fk_book_publication;

CREATE SEQUENCE bookId_seq;

CREATE TABLE book_publisher (
    pubKey TEXT PRIMARY KEY,
    publisher TEXT
);

INSERT INTO book_publisher(pubKey, publisher)
SELECT k, v
FROM field
WHERE k IN (SELECT k FROM pub WHERE p = 'book') AND p = 'publisher'
ON CONFLICT (pubKey) DO NOTHING;

CREATE TABLE book_isbn (
    pubKey TEXT PRIMARY KEY,
    isbn TEXT
);

INSERT INTO book_isbn(pubKey, isbn)
SELECT k, v
FROM field
WHERE k IN (SELECT k FROM pub WHERE p = 'book') AND p = 'isbn'
ON CONFLICT (pubKey) DO NOTHING;

INSERT INTO book(bookId, publisher, isbn)
SELECT nextval('bookId_seq') AS bookId, 
       book_publisher.publisher, 
       book_isbn.isbn
FROM pub p
JOIN publication ON p.k = publication.pubKey
LEFT JOIN book_publisher ON p.k = book_publisher.pubKey
LEFT JOIN book_isbn ON p.k = book_isbn.pubKey
WHERE p.p = 'book';

DROP SEQUENCE IF EXISTS bookId_seq;
DROP TABLE IF EXISTS book_publisher;
DROP TABLE IF EXISTS book_isbn;

ALTER TABLE book ADD CONSTRAINT fk_book_publication  FOREIGN KEY (bookId) REFERENCES publication(pubId) ON DELETE CASCADE;
--for table incollection 

delete from incollection; 
alter table incollection drop constraint  IF EXISTS fk_incollection_publication;
create table incollection_booktitle(
    pubKey TEXT PRIMARY KEY,
    booktitle TEXT
);
insert into incollection_booktitle(pubKey, booktitle)
select k, v
from field
where k in (select k from pub where p='incollection') and p = 'booktitle'
on conflict (pubKey) do nothing;
create table incollection_publisher(
    pubKey TEXT PRIMARY KEY,
    publisher TEXT
);
insert into incollection_publisher(pubKey, publisher)
select k, v 
from field
where k in (select k from pub where p='incollection') and p = 'publisher'
on conflict (pubKey) do nothing;
create table incollection_isbn(
    pubKey TEXT PRIMARY KEY,
    isbn TEXT
);
insert into incollection_isbn(pubKey, isbn)
select k, v
from field
where k in (select k from pub where p='incollection') and p = 'isbn'
on conflict (pubKey) do nothing;

 create sequence incollectionId;
insert into incollection(incollectionId, booktitle, publisher, isbn)
select nextval('incollectionId') AS incollectionId, booktitle, publisher, isbn
from pub p
join publication on p.k = publication.pubKey
left join incollection_booktitle on p.k = incollection_booktitle.pubKey
left join incollection_publisher on p.k = incollection_publisher.pubKey
left join incollection_isbn on p.k = incollection_isbn.pubKey
where p.p = 'incollection'; 
drop sequence if exists incollectionId;
Drop table if exists incollection_booktitle;
Drop table if exists incollection_publisher;
Drop table if exists incollection_isbn;

Alter table incollection add constraint fk_incollection_publication foreign key (incollectionId) references publication(pubId) on delete cascade;



--table for inproceedings
DELETE FROM inproceedings; 
ALTER TABLE inproceedings DROP CONSTRAINT IF EXISTS fk_inproceedings_publication;
DROP SEQUENCE IF EXISTS inproceedingsId;
CREATE SEQUENCE inproceedingsId;  
DROP TABLE IF EXISTS inproceedings_booktitle CASCADE;
CREATE TABLE inproceedings_booktitle (
    pubKey TEXT PRIMARY KEY,
    booktitle TEXT
);
INSERT INTO inproceedings_booktitle(pubKey, booktitle)
SELECT k, v
FROM field
WHERE p = 'booktitle' AND k IN (SELECT pubkey FROM publication)
ON CONFLICT (pubKey) DO NOTHING;

DROP TABLE IF EXISTS inproceedings_editor CASCADE;
CREATE TABLE inproceedings_editor (
    pubKey TEXT PRIMARY KEY,
    editor TEXT
);

INSERT INTO inproceedings_editor(pubKey, editor)
SELECT k, v
FROM field
WHERE p = 'editor' AND k IN (SELECT pubkey FROM publication)
ON CONFLICT (pubKey) DO NOTHING;
CREATE TABLE inproceedings(
    inproceedingsId INT PRIMARY KEY DEFAULT nextval('inproceedingsId'),  -
    booktitle TEXT,
    editor TEXT,
    CONSTRAINT fk_inproceedings_publication FOREIGN KEY (inproceedingsId) REFERENCES publication(pubId) ON DELETE CASCADE);
INSERT INTO inproceedings(inproceedingsId, booktitle, editor)
SELECT nextval('inproceedingsId') AS inproceedingsId, inproceedings_booktitle.booktitle, inproceedings_editor.editor
FROM pub 
JOIN publication ON pub.k = publication.pubKey
LEFT JOIN inproceedings_booktitle ON pub.k = inproceedings_booktitle.pubKey  
LEFT JOIN  inproceedings_editor ON pub.k = inproceedings_editor.pubKey
WHERE  pub.p = 'inproceedings';


DROP SEQUENCE IF EXISTS inproceedingsId; 
DROP TABLE IF EXISTS inproceedings_booktitle;  
DROP TABLE IF EXISTS inproceedings_edito
--for table authored 
delete from authored;
alter table authored drop constraint  IF EXISTS fk_authored_publication;
alter table authored drop constraint  IF EXISTS fk_authored_author;

INSERT INTO authored(pubId, authorId)
SELECT pub.pubId, a.authorId
FROM field f
JOIN publication pub ON f.k = pub.pubKey  
JOIN author a ON f.v = a.authorName
WHERE f.p = 'author'
ON CONFLICT DO NOTHING;

alter table authored add constraint fk_authored_publication foreign key (pubId) references publication(pubId) on delete cascade;
alter table authored add constraint fk_authored_author foreign key (authorId) references author(authorId) on delete cascade;