create database uprawnienia

use uprawnienia
create table uczniowie 
( id_ucznia int identity,
nazwa varchar (50) not null);

create table osoby 
( id_osoby int identity,
imie varchar (50) not null,
nazwisko varchar (50) not null);

create table hobby 
( id_hobby int identity,
nazwa varchar (50) not null);

INSERT INTO dbo.osoby( imie,nazwisko)
values 
    ('MIT', 'ADAM'),
    ('KOT', 'MARIA'),
    ('KOWAL', 'JAN'),
        ('TKACZ', 'PAWEL'),
            ('PAJAK', 'ANNA')

insert into dbo.hobby(nazwa)
values ('pilka nozna'), ('boks')

select *
from hobby

insert into dbo.uczniowie(nazwa)
values ('mali '), ('duzi')

use test
use master
create login Uczen1 with password ='1234' must_change, default_database=[test],
CHECK_EXPIRATION=ON, CHECK_POLICY=ON
use test
sp_addrolemember 'czytaj_tabele', Uczen1
go
create login Uczen2 with password ='1234' must_change, default_database=[test],
CHECK_EXPIRATION=ON, CHECK_POLICY=ON
sp_addrolemember 'modyfikuj_tabele', Uczen2
go

create login Uczen3 with password ='1234' must_change, default_database=[test],
CHECK_EXPIRATION=ON, CHECK_POLICY=ON
sp_addrolemember 'db_owner', Uczen3
go

use uprawnienia
create user Uczen1 
create user Uczen2
create user Uczen3


use uprawnienia
create role modyfikuj_tabele
go
create role czytaj_tabele
go

grant insert, update, delete, select
on dbo.osoby
to modyfikuj_tabele
go
grant insert, update, delete, select
on dbo.hobby
to modyfikuj_tabele
go



grant select(imie, nazwisko)
on dbo.osoby
to czytaj_tabele

grant select(nazwa)
on dbo.hobby
to czytaj_tabele


sp_helprotect
2
odebranie rol uzytkownikom
use uprawnienia
sp_droprolemember 'czytaj_tabele','Uczen1'  
sp_droprolemember 'modyfikuj_tabele','Uczen2'  
sp_droprolemember 'db_owner','Uczen3'  
    
    usuniecie rol
use uprawnienia
drop role czytaj_tabele
go 
drop role modyfikuj_tabele
go

odebranie dostepu do bazy 

drop user Uczen1
drop user Uczen2
drop user Uczen3

usuniecie uzytkownikow sql
drop login Uczen1
drop login Uczen2
drop login Uczen3