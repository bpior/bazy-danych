use KASETY_504_09

if  exists (select * from dbo.sysobjects  where id = object_id(N'KRAJ'))
begin
print 'Tabela KRAJ istenieje w db kasety'
end
else 
begin 
print 'Tworze KRAJ  w db kasety'
create table KRAJ(
IDKRAJ int primary key,
KRAJPROD CHAR (15) NOT NULL)
END 
GO

If  exists (select * from dbo.sysobjects  where id = object_id(N'RODZAJ'))
begin
print 'Tabela RODZAJ istenieje w db kasety'
end
else 
begin 
print 'Tworze RODZAJ  w db kasety'
create table RODZAJ(
IDRODZAJ int primary key,
RODZAJFIL CHAR (15) NOT NULL )
END
GO

if  exists (select * from dbo.sysobjects  where id = object_id(N'REZYSER'))
begin
print 'Tabela REZYSER istenieje w db kasety'
end
else 
begin 
print 'Tworze REZYSER  w db kasety'
create table REZYSER(
IDREZYSER int primary key,
NAZWISKO CHAR (30) NOT NULL,
IMIE CHAR (15) NULL)
END 
GO

if  exists (select * from dbo.sysobjects  where id = object_id(N'KLIENCI'))
begin
print 'Tabela KLIENCI istenieje w db kasety'
end
else 
begin 
print 'Tworze KLIENCI  w db kasety'
create table KLIENCI(
IDKLIENTA int primary key,
NAZWISKO CHAR (30) NOT NULL, 
IMIE CHAR (15) NOT NULL,
WIEK INT NULL,
ADRES  CHAR(30) NULL,
TELEFON CHAR(15) NULL,
PLEC CHAR (1) NOT NULL)
END
GO 

if  exists (select * from dbo.sysobjects  where id = object_id(N'FILMY'))
begin
print 'Tabela FILMY istenieje w db kasety'
end
else 
begin 
print 'Tworze FILMY  w db kasety'
create table FILMY(
IDFILMU int primary key,
TYTUL CHAR (25) NOT NULL, 
IDREZYSER INT NOT NULL,
CENA DECIMAL(6,2) NOT NULL,
KOLOR  CHAR(1) NOT NULL,
OPIS CHAR(40) NULL,
CONSTRAINT [FK_FILMY_REZYSER] FOREIGN KEY (IDREZYSER) REFERENCES REZYSER(IDREZYSER))
END 
GO

if  exists (select * from dbo.sysobjects  where id = object_id(N'FILKRA'))
begin
print 'Tabela FILKRA istenieje w db kasety'
end
else 
begin 
print 'Tworze FILKRA  w db kasety'
create table FILKRA(
IDFILMU int NOT NULL,
IDKRAJ INT NOT NULL,
CONSTRAINT [FK_FILKRA_KRAJ] FOREIGN KEY (IDKRAJ) REFERENCES KRAJ(IDKRAJ),
CONSTRAINT [FK_FILKRA_FILMY] FOREIGN KEY (IDFILMU) REFERENCES FILMY(IDFILMU))
END
GO


if  exists (select * from dbo.sysobjects  where id = object_id(N'FILRODZ'))
begin
print 'Tabela FILRODZ istenieje w db kasety'
end
else 
begin 
print 'Tworze FILRODZ  w db kasety'
create table FILRODZ(
IDFILMU int references FILMY(IDFILMU),
IDKRAJ INT)
END
GO


if  exists (select * from dbo.sysobjects  where id = object_id(N'KASETY'))
begin
print 'Tabela KASETY istenieje w db kasety'
end
else 
begin 
print 'Tworze KASETY  w db kasety'
create table KASETY(
IDKASETY int PRIMARY KEY,
IDFILMU INT NOT NULL, 
STATUS CHAR(1) NOT NULL,
constraint [FK_KASETY_WYPO] foreign key (IDKASETY) references KASETY(IDKASETY))
END
GO 


if  exists (select * from dbo.sysobjects  where id = object_id(N'WYPO'))
begin
print 'Tabela WYPO istenieje w db kasety'
end
else 
begin 
print 'Tworze WYPO  w db kasety'
create table WYPO(
IDKLIENTA INT NOT NULL,
IDKASETY INT NOT NULL, 
DATAW SMALLDATETIME NOT NULL,
DATAZ SMALLDATETIME NULL,
KWOTA DECIMAL(7,2) NULL,
CONSTRAINT [FK_WYPO_KASETY] FOREIGN KEY (IDKASETY) REFERENCES KASETY(IDKASETY),
CONSTRAINT [FK_WYPO_KLIENCI] FOREIGN KEY (IDKLIENTA) REFERENCES KLIENCI(IDKLIENTA))
END
GO