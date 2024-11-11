--Drop tables if they already exist  on CASCADE to delete all the dependent objects of the table
DROP table if exists author cascade ;
DROP table if exists publication cascade ; 
DROP table if exists article cascade; 
DROP table if exists book cascade; 
DROP table if exists  incollection cascade; 
DROP table if exists inproceedings cascade ; 
DROP table if exists authored cascade; 

--Create tables 
--Table for author 
CREATE table author(
    authorId INT PRIMARY KEY,
    authorName TEXT,
    homepage TEXT
);
--Table for publication
CREATE table publication(
    pubId INT PRIMARY KEY,
    pubkey TEXT UNIQUE,
    title TEXT,
    year int 
    );
--Table for article
CREATE table article(
    articleId INT PRIMARY KEY,
    journal TEXT,
    month TEXT,
    volume text,
    number text,
    constraint fk_article_publication foreign key (articleId) references publication(pubId) on delete cascade
);
--Table for book
CREATE table book(
    bookId INT PRIMARY KEY,
    publisher TEXT,
    isbn TEXT,
    constraint fk_book_publication foreign key (bookId) references publication(pubId) on delete cascade);
--table for Incollection
CREATE table incollection(
    incollectionId INT PRIMARY KEY,
    booktitle TEXT,
   publisher TEXT, 
   isbn TEXT , 
   constraint fk_incollection_publication foreign key (incollectionId) references publication(pubId) on delete cascade
);
--Table for inproceedings
CREATE table inproceedings(
    inproceedingsId INT PRIMARY KEY,
  
    booktitle TEXT,
    editor TEXT,
    constraint fk_inproceedings_publication foreign key (inproceedingsId) references publication(pubId) on delete cascade
);
--Table for authored 
CREATE table authored(
    pubId INT,
    authorId INT,
    primary Key (pubId, authorId),
    constraint fk_authored_publication foreign key (pubId) references publication(pubId) on delete cascade,
    constraint fk_authored_author foreign key (authorId) references author(authorId) on delete cascade
);