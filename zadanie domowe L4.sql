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
ADRES  CHAR(30) NULL DEFAULT('Brak danych'),
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
CENA DECIMAL(6,2) NOT NULL CHECK (CENA BETWEEN 1 AND 20),
KOLOR  CHAR(1) NOT NULL CHECK (KOLOR IN ('K', 'C')),
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
IDFILMU int NOT NULL UNIQUE,
IDKRAJ INT NOT NULL UNIQUE,
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
IDFILMU int UNIQUE references FILMY(IDFILMU),
IDRODZAJ INT UNIQUE,
CONSTRAINT [FK_FILRODZ_RODZAJ] FOREIGN KEY (IDRODZAJ) REFERENCES RODZAJ(IDRODZAJ))
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
STATUS CHAR(1) NOT NULL CHECK (STATUS IN ('K', 'W')),
constraint [FK_KASETY_WYPO] foreign key (IDFILMU) references FILMY(IDFILMU))

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
IDKLIENTA INT NOT NULL UNIQUE,
IDKASETY INT NOT NULL UNIQUE, 
DATAW SMALLDATETIME  DEFAULT SYSDATETIME() NOT NULL UNIQUE, 
DATAZ SMALLDATETIME NULL,
KWOTA DECIMAL(7,2) NULL,
CONSTRAINT [FK_WYPO_KASETY] FOREIGN KEY (IDKASETY) REFERENCES KASETY(IDKASETY),
CONSTRAINT [FK_WYPO_KLIENCI] FOREIGN KEY (IDKLIENTA) REFERENCES KLIENCI(IDKLIENTA))
END 
GO


-------------------=====================




PRINT 'tworzenie mojej reguly  reguly'
GO
CREATE RULE BP AS @Y IN ('M','K')
GO



DROP RULE BP


PRINT 'dowiawanie reguly do kolumny plec w tabeli KLIENCI  do mojej reguly'
EXEC sp_bindrule BP, 'KLIENCI.PLEC'
GO





drop DEFAULT BRAKINFO

print 'tworzenie zmienneej domysleej do wpisywania doyslenj wartosci Brak informacji'
GO
CREATE DEFAULT BRAKINFO AS 'Brak informacji'
GO



PRINT 'dowiazanie zmiennej domyslej do kolumny opis w tabeli filmy '
GO
EXEC sp_bindefault BRAKINFO,'FILMY.OPIS'
GO

----------------=======

CREATE VIEW W1 
AS 
SELECT NAZWISKO, IMIE, DATAW, DATAZ, TYTUL
FROM KLIENCI K JOIN WYPO W ON K.IDKLIENTA=W.IDKLIENTA JOIN KASETY KA ON W.IDKASETY=KA.IDFILMU JOIN FILMY F ON F.IDFILMU=KA.IDKASETY
GO 

CREATE VIEW W2 
AS 
SELECT K.IDKASETY, TYTUL , COUNT(F.IDFILMU) AS Ilość 
FROM KASETY K JOIN FILMY F ON K.IDFILMU=F.IDFILMU JOIN WYPO W ON W.IDKASETY=K.IDKASETY
GROUP BY K.IDKASETY, f.TYTUL  , F.IDFILMU
GO

SELECT * FROM W4
SELECT * from W1


CREATE VIEW W3
AS 
SELECT COUNT(KWOTA) AS ZAROBEK
FROM WYPO
GO

CREATE VIEW W4
AS
SELECT F.TYTUL, 'Wyporzyczone' AS Wyporzyczone
FROM FILMY F JOIN KASETY K ON F.IDFILMU=K.IDFILMU 
WHERE K.STATUS='W'
UNION
SELECT F.TYTUL, 'Na miejscu' AS WYPOZYCZONE
FROM FILMY F JOIN KASETY K ON F.IDFILMU=K.IDFILMU 
WHERE K.STATUS='K'
GO



SELECT * FROM W3
SELECT * from W4



DROP VIEW W4



SELECT K.IDKASETY, TYTUL , COUNT(F.IDFILMU) AS Ilość 
FROM KASETY K JOIN FILMY F ON K.IDFILMU=F.IDFILMU JOIN WYPO W ON W.IDKASETY=K.IDKASETY
GROUP BY K.IDKASETY, f.TYTUL  , F.IDFILMU
GO

----------======================================-------

INSERT INTO KRAJ (IDKRAJ , KRAJPROD) 
VALUES 
('1', 'polska'),
('2', 'rumunia'),
('3', 'niemcy'),
('4', 'finlandia'),
('5', 'hiszpania')
GO

INSERT INTO RODZAJ (IDRODZAJ , RODZAJFIL) 
VALUES 
('1', 'szeroki'),
('2', 'waski'),
('3', 'mala'),
('4', 'duza')
GO

INSERT INTO REZYSER (IDREZYSER , NAZWISKO, IMIE) 
VALUES 
('1', 'pan', 'jan'),
('2','ktos', 'sebastian'),
('3', 'cos', 'damian'),
('4', 'los ', 'grzes')
GO


INSERT INTO FILMY (IDFILMU , TYTUL, IDREZYSER, CENA, KOLOR, OPIS) 
VALUES 
('1', 'killer', '1', '20', 'C', 'jakis'),
('2', 'czas serferow', '2', '19', 'C', 'jakis'),
('3', 'killer2', '3', '15', 'C', 'jakis'),
('4', 'pitbull', '4', '3', 'K', 'jakis'),
('5', 'porzadki', '3', '17', 'C', 'jakis')
GO


INSERT INTO FILKRA (IDFILMU , IDKRAJ) 
VALUES 
('1', '1'),
('2', '2'),
('3', '3'),
('4', '4')
GO



INSERT INTO FILRODZ (IDFILMU , IDRODZAJ) 
VALUES 
('3', '1'),
('1', '2'),
('4', '4'),
('5', '3')
GO

INSERT INTO KLIENCI (IDKLIENTA, NAZWISKO , IMIE, WIEK, ADRES, TELEFON, PLEC) 
VALUES 
('1', 'killer', 'jan', '20', DEFAULT ,  '57585', 'M'),
( '2','nowak', 'katarzyna', DEFAULT, '19', '65765', 'K'),
('3', 'kowalski', 'sebastian',DEFAULT, '15', '673689', 'M'),
('4', 'galant', 'damian', '28',DEFAULT, '786555', 'M'),
('5','kowalska', 'anna', '17',DEFAULT, '98646', 'K')
GO

INSERT INTO KASETY (IDKASETY, IDFILMU , [STATUS] )
VALUES 
('1', '2', 'K'),
('2', '1', 'W'),
('3', '5', 'K'),
('4', '4', 'K'),
('5', '3', 'K')
GO 





INSERT INTO WYPO (IDKLIENTA, IDKASETY , DATAW, KWOTA)
VALUES 
('3', '5', DEFAULT,1)
go
INSERT INTO WYPO (IDKLIENTA, IDKASETY , DATAW, KWOTA)
VALUES 
('1', '4', DEFAULT, 2)
go
INSERT INTO WYPO (IDKLIENTA, IDKASETY , DATAW, KWOTA)
VALUES 
('2', '1', DEFAULT, 0)
GO
INSERT INTO WYPO (IDKLIENTA, IDKASETY , DATAW, KWOTA)
VALUES 
('5', '2', DEFAULT, 0)
go


SELECT * from WYPO





