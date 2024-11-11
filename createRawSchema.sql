-- uncomment these lines if you are rerunning this file multiple times 
--drop table pub;
--drop table field;

create table Pub (k text, p text);
create table Field (k text, i text, p text, v text);

--windows commands (change the address to the absolute address of your files)
--\copy Pub from 'C:\\Users\\...\\pubFile.txt';
--\copy Field(k,i,p,v) from program 'cmd /c "type C:\\Users\\...\\fieldFile.txt"' with (format text, encoding 'UTF8');

--mac/linux commands (change the address to the absolute address of your files)
--\copy Pub from '/Users/.../pubFile.txt';
--\copy Field from '/Users/.../fieldFile.txt';
\copy Pub FROM '/home/aljene/DBSys_Lab1_Aljene/startercodeDBSys/pubFile.txt' WITH (FORMAT text, DELIMITER E'\t', ENCODING 'UTF8');
\copy Field FROM '/home/aljene/DBSys_Lab1_Aljene/startercodeDBSys/fieldFile.txt' WITH (FORMAT text, DELIMITER E'\t', ENCODING 'UTF8');