USE KASETY_504_09

if  exists (select * from dbo.sysobjects  where id = object_id(N'WYPO'))
begin
			drop table WYPO
print 'Usuwam tabele fk_wypo WYPO  w db kasety'
end
else 
print 'Brak tabeli WYPO w db KASETY'
GO

if  exists (select * from dbo.sysobjects  where id = object_id(N'KASETY'))
begin
			drop table KASETY
print 'Usuwam tabele fk_wypo KASETY  w db kasety'
end
else 
print 'Brak tabeli KASETY w db KASETY'
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
			drop table FILKRA
print 'Usuwam tabele fk_wypo FILKRA  w db kasety'
end
else 
print 'Brak tabeli FILKRA w db KASETY'
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
			drop table KLIENCI
print 'Usuwam tabele fk_wypo KLIENCI  w db kasety'
end
else 
print 'Brak tabeli KLIENCI w db KASETY'
GO

if  exists (select * from dbo.sysobjects  where id = object_id(N'REZYSER'))
begin
			drop table REZYSER
print 'Usuwam tabele fk_wypo REZYSER  w db kasety'
end
else 
print 'Brak tabeli REZYSER w db KASETY'
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
		drop table KRAJ
print 'Usuwam tabele fk_wypo kraj  w db kasety'
end
else 
print 'Brak tabeli rodzaj w db KASETY'
GO

