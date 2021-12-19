USE KASETY_504_09
-- DROP 



/*

if  exists (select * from dbo.sysobjects  where id = object_id(N'KASETY'))
begin
print 'Tabela KASETY istenieje w db kasety'
end
else 
begin 
print 'Tworze KASETY  w db kasety'
create table KAETY(
IDKASETY int primary key,
--IDFILMU INT, 
STATTUS CHAR(1),
IDFILMU int PRIMARY KEY references WYPO(IDFILMU) )
END
GO 
 */
/*

if  exists (select * from dbo.sysobjects  where id = object_id(N'KLIENCI'))
begin
print 'Tabela KLIENCI istenieje w db kasety'
end
else 
begin 
print 'Tworze KLIENCI  w db kasety'
create table KLIENCI(
-- IDKLIENTA int primary key,
NAZWISKO (CHAR 30), 
IMIE CHAR (15),
WIEK INT NOT NULL,
ADRES  CHAR(30) NOT NULL,
TELEFON CHAR(15) NOT NULL,
PLEC CHAR (1)
IDKLIENTA int PRIMARY KEY references WYPO(IDKLIENTA) )
END
GO 


*/







-----==========================================------

If  exists (select * from dbo.sysobjects  where id = object_id(N'RODZAJ'))
begin
print 'Usuwam powiazanie fk_wypo w db kasety'
alter table RODZAJ drop constraint [FK_RODZAJ_FILRODZ]
end
else 
print 'Brak powiazania rodzaj w db KASETY'
GO


If  exists (select * from dbo.sysobjects  where id = object_id(N'RODZAJ'))
begin
	drop table RODZAJ
print 'Usuwam tabele fk_wypo w db kasety'
end
else 
print 'Brak tabeli rodzaj w db KASETY'
GO




if  exists (select * from dbo.sysobjects  where id = object_id(N'KRAJ'))
begin
print 'Usuwam powiazanie fk_wypo kraj  w db kasety'
alter table RODZAJ drop constraint [FK_KRAJ_FILRODZ]
end
else 
print 'Brak powiazania rodzaj w db KASETY'
GO

if  exists (select * from dbo.sysobjects  where id = object_id(N'KRAJ'))
begin
		drop table KRAJ
print 'Usuwam tabele fk_wypo kraj  w db kasety'
end
else 
print 'Brak tabeli rodzaj w db KASETY'
GO



if  exists (select * from dbo.sysobjects  where id = object_id(N'REZYSER'))
begin
print 'Usuwam powiazanie fk_wypo REZYSER  w db kasety'
alter table RODZAJ drop constraint [FK_REZYSER_FILMY]
end
else 
print 'Brak powiazania REZYSER w db KASETY'
GO

if  exists (select * from dbo.sysobjects  where id = object_id(N'REZYSER'))
begin
			drop table REZYSER
print 'Usuwam tabele fk_wypo REZYSER  w db kasety'
end
else 
print 'Brak tabeli REZYSER w db KASETY'
GO






if  exists (select * from dbo.sysobjects  where id = object_id(N'FILRODZ'))
begin
print 'Usuwam powiazanie fk_wypo REZYSER  w db kasety'
alter table FILRODZ drop constraint [FK_FILRODZ_FILMY]
end
else 
print 'Brak powiazania FILRODZ w db KASETY'
GO

if  exists (select * from dbo.sysobjects  where id = object_id(N'FILRODZ'))
begin
			drop table FILRODZ
print 'Usuwam tabele fk_wypo FILRODZ  w db kasety'
end
else 
print 'Brak tabeli FILRODZ w db KASETY'
GO






if  exists (select * from dbo.sysobjects  where id = object_id(N'FILKRA'))
begin
print 'Usuwam powiazanie fk_wypo FILKRA  w db kasety'
alter table FILRODZ drop constraint [FK_FILKRA_FILMY]end
end
else 
print 'Brak powiazania FILKRA w db KASETY'
GO


if  exists (select * from dbo.sysobjects  where id = object_id(N'FILKRA'))
begin
			drop table FILKRA
print 'Usuwam tabele fk_wypo FILKRA  w db kasety'
end
else 
print 'Brak tabeli FILKRA w db KASETY'
GO





if  exists (select * from dbo.sysobjects  where id = object_id(N'FILMY'))
begin
print 'Usuwam powiazanie fk_wypo FILMY  w db kasety'
alter table FILMY drop constraint [FK_FILMY_KASETY]
end
else 
print 'Brak powiazania FILMY w db KASETY'
GO 


if  exists (select * from dbo.sysobjects  where id = object_id(N'FILMY'))
begin
			drop table FILMY
print 'Usuwam tabele fk_wypo FILMY  w db kasety'
end
else 
print 'Brak tabeli FILMY w db KASETY'
GO







if  exists (select * from dbo.sysobjects  where id = object_id(N'KLIENCI'))
begin
print 'Usuwam powiazanie fk_wypo FILMY  w db kasety'
alter table KLIENCI drop constraint [FK_KLIENCI_KASETY]
end
else 
print 'Brak powiazania KLIENCI w db KASETY'
GO 


if  exists (select * from dbo.sysobjects  where id = object_id(N'KLIENCI'))
begin
			drop table KLIENCI
print 'Usuwam tabele fk_wypo KLIENCI  w db kasety'
end
else 
print 'Brak tabeli KLIENCI w db KASETY'
GO



if  exists (select * from dbo.sysobjects  where id = object_id(N'WYPO'))
begin
			drop table WYPO
print 'Usuwam tabele fk_wypo WYPO  w db kasety'
end
else 
print 'Brak tabeli WYPO w db KASETY'
GO


/*

if  exists (select * from dbo.sysobjects  where id = object_id(N'WYPO'))
begin
print 'Usuwam powiazanie fk_wypo FILMY  w db kasety'
alter table KLIENCI drop constraint [FK_KLIENCI_KASETY]
end
else 
print 'Brak powiazania KLIENCI w db KASETY'
GO 

*/


