use KASETY_504_09

if exists (SELECT * from dbo.sysobjects where id = object_id(N'KRAJ'))
BEGIN
PRINT 'tabela kraj istnieje w bd kasety'
END
ELSE
BEGIN
PRINT 'Tworze tabele kraj  w BD'
CREATE TABLE KRAJ 
(
    IDKRAJ int PRIMARY key,
    KRAJPROD char(15) not NULL
)
end 
go


if exists (SELECT * from dbo.sysobjects where id = object_id(N'komunikatywyzwalaczy'))
BEGIN
PRINT 'tabela komunikatywyzwalaczy istnieje w bd kasety'
END
ELSE
BEGIN
PRINT 'Tworze tabele komunikatywyzwalaczy  w BD'
CREATE table komunikatywyzwalaczy( 
IDW INT IDENTITY,
TABELA CHAR(30),
KOLUMNA CHAR(30),
OPERACJA CHAR(30),
STARA_WART CHAR(50),
NOWA_WART CHAR (50),
CZAS SMALLDATETIME DEFAULT(GETDATE()),
UZYTKOWNIK CHAR (20) DEFAULT(USER)
)
END
GO




if OBJECT_ID('PO_WSTAW_KRAJ') is not NULL
BEGIN
PRINT 'ususwam triger PO_WSTAW_KRAJ'
DROP TRIGGER PO_WSTAW_KRAJ
END
GO

PRINT'tworze trigger PO_WSTAW_KRAJ'
GO
CREATE TRIGGER PO_WSTAW_KRAJ
ON KRAJ 
AFTER INSERT
AS 
IF UPDATE(KRAJPROD)
DECLARE @kraj_NEW VARCHAR(15)
SELECT @kraj_NEW=krajprod
FROM inserted 
INSERT INTO komunikatywyzwalaczy (TABELA, KOLUMNA, OPERACJA, STARA_WART, NOWA_WART)
VALUES ('KRAJ', 'KRAJPROD', 'INSERT', NULL, @kraj_NEW)
GO

-----------------==================-------------------
if OBJECT_ID('PO_WSTAW_KRAJ', 'TR') is not NULL
BEGIN
PRINT ' trigger PO_WSTAW_KRAJ istnieje w BD'
END
ELSE
BEGIN 
EXEC ('CREATE TRIGGER PO_WSTAW_KRAJ
ON KRAJ 
AFTER INSERT
AS 
IF UPDATE(KRAJPROD)
DECLARE @kraj_NEW VARCHAR(15)
SELECT @kraj_NEW=krajprod
FROM inserted 
INSERT INTO komunikatywyzwalaczy (TABELA, KOLUMNA, OPERACJA, STARA_WART, NOWA_WART)
VALUES (''KRAJ'', ''KRAJPROD'', ''INSERT'', NULL, @kraj_NEW)')
PRINT ' tworze trigger PO_WSTAW_KRAJ w BD '
END

SELECT * from komunikatywyzwalaczy
GO



DROP TRIGGER tr_blokada_modyfikacji
GO

CREATE TRIGGER tr_blokada_modyfikacji
on komunikatywyzwalaczy 
INSTEAD OF UPDATE,DELETE
as 
RAISERROR('edycja i usuwanie wpisow zabroniona ',16,1)
GO


DROP TRIGGER tr_blokada_modyfikacji
GO

CREATE TRIGGER tr_blokada_modyfikacji
on komunikatywyzwalaczy 
INSTEAD OF UPDATE,DELETE
as 
throw 60001, 'edycja i usuwanie wpisow zabroniona !!! ',10
GO

DROP TRIGGER tr_blokada_modyfikacji
GO

CREATE TRIGGER tr_blokada_modyfikacji
on komunikatywyzwalaczy 
INSTEAD OF UPDATE,DELETE
as 
throw 50001, 'nie nalezy tego robic ',3;
go


SELECT * from komunikatywyzwalaczy
GO


---------========Procedury skladowane =======-----------

CREATE PROCEDURE zapisz_nowy_kraj
@idkraj int,
@krajprod char (15)
as
if exists (select * from KRAJ WHERE idkraj=@idkraj)
RETURN 1 
if not exists (select * from KRAJ where KRAJPROD=@krajprod)
RETURN 2 
BEGIN TRANSACTION
INSERT into KRAJ(IDKRAJ,KRAJPROD)
VALUES (@idkraj,@krajprod)
if @@ERROR<>0
GOTO BLAD
COMMIT TRANSACTION
RETURN 0 
BLAD: 
ROLLBACK TRANSACTION
RETURN 2 
GO

DROP PROCEDURE zapisz_nowy_kraj

EXEC zapisz_nowy_kraj 16, 'RRRSS'


DECLARE @return_status INT
EXEC @return_status=zapisz_nowy_kraj 25, 'Malta'
select 'Return Status'=@return_status
GO


DROP PROCEDURE zapisz_nowy_kraj1
GO

CREATE PROCEDURE zapisz_nowy_kraj1
(@idkraj int,
@krajprod CHAR (15),
@komunikat VARCHAR(200) OUTPUT)
as
BEGIN TRY
INSERT into KRAJ(IDKRAJ,KRAJPROD) VALUES (@idkraj, @krajprod)
set @komunikat= 'Tworze nowy kraj -pomysnie zapisany'
END TRY
BEGIN CATCH
set @komunikat= 'blad tworzenia kraju - brak zapisu'
SELECT ErrorNmber = ERROR_NUMBER(),
ErrorSeverity= ERROR_SEVERITY(),
ErrorState= ERROR_STATE(),
ErrorProcedure= ERROR_PROCEDURE(),
ErrorLine = ERROR_LINE(),
ErrorMessage = ERROR_MESSAGE()
END CATCH



DROP PROCEDURE zapisz_nowy_kraj1
go  

DECLARE @return_status VARCHAR(200)
EXEC zapisz_nowy_kraj1 32, 'maroko',@return_status OUTPUT
SELECT 'Return Status' = @return_status
GO


ALTER TABLE KRAJ
ADD UNIQUE (KRAJPROD);



-----------=========Tabele tymczasowe i lokalne======-------

SELECT * INTO #tabelalokalna from KLIENCI
go

SELECT * FROM #tabelalokalna
GO


SELECT * INTO ##tabelaglobalna FROM KLIENCI
go



SELECT * FROM #tabelalokalna
SELECT * FROM ##tabelaglobalna
go

DROP TABLE ##tabelaglobalna
DROP TABLE #tabelalokalna
go


----======stosowanie zmiennych====----

DECLARE @zmienna_lokalna typ_danych
DECLARE @zmienna1 int, @zmienna2 INT

DECLARE @MojaZmienna CHAR(15)
set @MojaZmienna ='witajcie'


DECLARE @MojaZmienna CHAR(15)
SELECT @MojaZmienna='witajcie'

DECLARE @MaxCena CHAR(15)
SELECT @MaxCena = max(cena) from FILMY



DECLARE @mje NVARCHAR(50), @MAXCENA DECIMAL(6,2)

SELECT @moje
SELECT @moje = 'witajcie'
SELECT @moje


set @MojaZmienna = 'witajcie'
SELECT @MojaZmienna

DECLARE @MojaZmienna VARCHAR(30), @Moja2 VARCHAR(30)
SELECT @MojaZmienna as pocz




DECLARE @MaxCena CHAR(15)
SELECT @MaxCena = MAX(cena) FROM FILMY
-- wyświetlenie (pokazanie) wartości

SELECT @MaxCena


--zienne tabularne--


DECLARE @lokalnatab TABLE (tytul char(50), cena DECIMAL(6,2))
INSERT into @lokalnatab SELECT tytul,cena FROM FILMY
SELECT *FROM @lokalnatab

--wyslwietl informacje o serwerze przy pomocy zmiennych globalnych

SELECT @@SERVERNAME, @@VERSION, @@LANGUAGE

---=====instrukcja if ===----

DECLARE @m INT, @k int 
select @m=COUNT(*) from KLIENCI WHERE PLEC= 'M'
select @k=COUNT(*) from KLIENCI WHERE PLEC= 'K'
SELECT 'kobiety', @k
SELECT'mezczyzni', @m
IF @m >@k
BEGIN
PRINT 'mezczyn jest wiecej'
SELECT 'mezczyzn jest wiecej o ', @m-@k
END
ELSE
BEGIN
PRINT ' kobiet jest wiecej'
SELECT 'kobiet jest wiecej o ', @k-@m
END




DECLARE @m INT, @k int 
select @m=COUNT(*) from KLIENCI WHERE PLEC= 'M'
select @k=COUNT(*) from KLIENCI WHERE PLEC= 'K'
SELECT 'kobiety', @k
SELECT'mezczyzni', @m
-------
PRINT IIF (@m>@k,'mezczyzn jest wiecej', 
    IIF(@m<@k, 'meczyzn jest mniej ', 'jest po rowno'))
SELECT  IIF(@m>@k,'mezczyzn jest wiecej',
iif (@m<@k, 'mezczyzn jest mniej', 'jest po rowno') ) as wynik




DECLARE @m INT, @k int 
select @m=COUNT(*) from KLIENCI WHERE PLEC= 'M'
select @k=COUNT(*) from KLIENCI WHERE PLEC= 'K'
SELECT 'kobiety', @k
SELECT'mezczyzni', @m
PRINT IIF ( @m>@k, concat ('mezczyzn jest wiecej o :', RTRIM (@m-@k)),
IIF(@m<@k, CONCAT('mezczyzn jest mniej o :', RTRIM(@k-@m)),
'jest po rowno'))
SELECT IIF(@m>@k, CONCAT('mezczyzn jest wiecej o :', RTRIM(@m-@k)),
IIF(@m<@k, CONCAT('mezczyzn jest mniej o: ',
RTRIM(@k-@m)), 'jest po rowno ')) as wyniki_z_concat


---=== instrukcaja case ===---


SELECT NAZWISKO, IMIE,
CASE PLEC 
WHEN 'K' THEN 'Kobieta'
WHEN 'M' THEN 'Mezczyzna'
ELSE 'Ktos'
END AS Płeć
FROM KLIENCI
ORDER BY NAZWISKO

--petla while--


DECLARE @licznik INT
set @licznik = 1 
WHILE @licznik < 11
BEGIN 
PRINT @licznik
set @licznik = @licznik+1
END



DECLARE @licznik INT
set @licznik = 1
WHILE @licznik < 11
BEGIN 
set @licznik = @licznik+1
if (@licznik%2)=1 CONTINUE
PRINT @licznik
END



---==== kursory ===---
DECLARE prostykursor CURSOR
LOCAL 
for SELECT * FROM KLIENCI
OPEN prostykursor

FETCH prostykursor
FETCH prostykursor

CLOSE prostykursor
DEALLOCATE prostykursor
GO



DECLARE ProstyKursor CURSOR
LOCAL 
FOR SELECT * FROM KLIENCI
OPEN ProstyKursor
FETCH ProstyKursor
WHILE @@FETCH_STATUS = 0 
BEGIN
PRINT 'pobralem'
FETCH ProstyKursor
END
CLOSE ProstyKursor
DEALLOCATE ProstyKursor
GO


SELECT * FROM KLIENCI

SELECT* FROM   sys.dm_exec_cursors(0)
GO

DECLARE prostykursor CURSOR
LOCAL 
keyset
FOR SELECT tytul, cena FROM FILMY
DECLARE @z_tytul CHAR(30), @z_cena INT 
OPEN prostykursor
FETCH FIRST FROM prostykursor INTO @z_tytul, @z_cena
PRINT RTRIM(@z_tytul) + 'jest w zmiennej'
PRINT RTRIM(@z_cena) + 'jest w zmiennej'
SELECT @z_tytul as select1, @z_cena as select2
FETCH absolute 5 FROM prostykursor INTO @z_tytul, @z_cena
PRINT RTRIM(@z_tytul) + 'jest w zmiennej'
PRINT RTRIM(@z_cena) + 'jest w zmiennej'
SELECT @z_tytul as select1, @z_cena as select2
PRINT @z_cena
PRINT @z_cena + 'bez konwersji - zle'
CLOSE prostykursor
DEALLOCATE prostykursor




DECLARE innykursor CURSOR
LOCAL
FOR SELECT table_name, constraint_name from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'

DECLARE @TABELA CHAR(15), @POWIAZANIE VARCHAR(30), @TEKST NVARCHAR(100)
OPEN innykursor
FETCH innykursor into @TABELA, @POWIAZANIE
WHILE @@FETCH_STATUS = 0
BEGIN 
PRINT 'pobralem: tabel ' +@TABELA+'powiazanie: '+@POWIAZANIE
PRINT 'usuwam powiazanie: '+@POWIAZANIE
set @TEKST= 'alter table ' +@TABELA+ ' drop constraint [' +@POWIAZANIE+']'
EXEC sp_executesql @TEKST
fetch innykursor INTO @TABELA, @POWIAZANIE
END
CLOSE innykursor
DEALLOCATE innykursor
go


SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
GO



----======== zadanie 2 ======----
---Napisać, opisać i przetestować funkcjonowanie 2 własnych (z obsługą błędów) funkcji składowanych.

CREATE PROCEDURE zapisz_nowego_rezysera
(@idrezyser int,
@nazwisko CHAR (15),
@imie char(15),
@komunikat VARCHAR(200) OUTPUT)
as
BEGIN TRY
INSERT into REZYSER(IDREZYSER,NAZWISKO, IMIE) VALUES (@idrezyser, @nazwisko, @imie)
set @komunikat= 'Tworze nowego rezysera -pomysnie zapisany'
END TRY
BEGIN CATCH
set @komunikat= 'blad tworzenia rezysera - brak zapisu'
SELECT ErrorNmber = ERROR_NUMBER(),
ErrorSeverity= ERROR_SEVERITY(),
ErrorState= ERROR_STATE(),
ErrorProcedure= ERROR_PROCEDURE(),
ErrorLine = ERROR_LINE(),
ErrorMessage = ERROR_MESSAGE()
END CATCH



DROP PROCEDURE zapisz_nowego_rezysera
go  


DECLARE @return_status VARCHAR(200)
EXEC zapisz_nowego_rezysera 35, 'popis', 'krzysztof',@return_status OUTPUT
SELECT 'Return Status' = @return_status
GO



CREATE PROCEDURE zapisz_nowy_rodzaj
(@idrodzaj int,
@rodzajfil CHAR (15),
@komunikat VARCHAR(200) OUTPUT)
as
BEGIN TRY
INSERT into RODZAJ(IDRODZAJ,RODZAJFIL) VALUES (@idrodzaj, @rodzajfil)
set @komunikat= 'Tworze nowy rodzaj - pomysnie zapisany'
END TRY
BEGIN CATCH
set @komunikat= 'blad tworzenia rodzaju - brak zapisu'
SELECT ErrorNmber = ERROR_NUMBER(),
ErrorSeverity= ERROR_SEVERITY(),
ErrorState= ERROR_STATE(),
ErrorProcedure= ERROR_PROCEDURE(),
ErrorLine = ERROR_LINE(),
ErrorMessage = ERROR_MESSAGE()
END CATCH



DROP PROCEDURE zapisz_nowy_rodzaj
go  


DECLARE @return_status VARCHAR(200)
EXEC zapisz_nowy_rodzaj 34, 'czarna komedia',@return_status OUTPUT
SELECT 'Return Status' = @return_status
GO


---=== zadanie 3 ===---
---Napisać, opisać i przetestować zastosowanie tabel tymczasowych i dowolnych zmiennych


SELECT IDKLIENTA, NAZWISKO+IMIE as Nazwisko_Imie
INTO ##tabelaglobalna1
from KLIENCI
GO

SELECT * FROM ##tabelaglobalna1


DROP TABLE ##tabelaglobalna1
GO




---=== zadanie 4 ===---
---Napisać skrypt (z wykorzystaniem kursorów) który zaprezentuje dane w następującej postaci.


----------------------

DECLARE @nazwisko NVARCHAR(50), @imie char(50), @LICZBA char(30), @ilosc_klientow char(15), @ilosc_wypozyczen char(15), @najwieksza CHAR (30)
SET @ilosc_klientow = (select COUNT(*) from KLIENCI) 
SET @ilosc_wypozyczen = (SELECT COUNT(*) FROM WYPO)

declare @min int, @max int, @max1 NVARCHAR(10)
;with cte1   as 
(
SELECT COUNT(IDKASETY) as klienci
FROM KLIENCI K  JOIN WYPO W ON K.IDKLIENTA=W.IDKLIENTA
GROUP BY NAZWISKO, IMIE
)
select @max=max(klienci), @min=min(klienci) from cte1

DECLARE testowy CURSOR FOR

SELECT NAZWISKO, IMIE, COUNT(IDKASETY) AS LICZBA
FROM KLIENCI K  JOIN WYPO W ON K.IDKLIENTA=W.IDKLIENTA
GROUP BY NAZWISKO, IMIE

OPEN testowy
PRINT 'Łącznie w bazie jest ' + RTRIM(@ilosc_klientow) + ' klientow'
PRINT '----------------------------------------'
FETCH NEXT FROM testowy INTO @nazwisko, @imie, @LICZBA

WHILE @@FETCH_STATUS = 0
BEGIN
    FETCH NEXT FROM testowy INTO @nazwisko, @imie, @LICZBA
	  IF @max=@LICZBA 
		BEGIN 
			SELECT @max1='najwiecej' 
		END 
	ELSE 
		BEGIN 
			IF @MIN=@LICZBA
				BEGIN
					SELECT @max1='najmniej'
				END	
			ELSE
				BEGIN
					SELECT @max1=''
				END	
		END
	PRINT  @nazwisko +@imie + RTRIM(@LICZBA) + ' ' + @MAX1
END
PRINT '----------------------------------------'
PRINT 'lacznie jest ' + RTRIM(@ilosc_wypozyczen) + ' wypozyczen'
PRINT '----------------------------------------'
CLOSE testowy
DEALLOCATE testowy


--------------------



---=== zadanie 5 ===---
/*Napisać i opisać skrypt który (z wykorzystaniem kursorów) zaprezentuje
dane/wyniki analityczne z bazy wypożyczalnia filmów (w podobnej postaci jak
zadanie 4) */
SELECT* from KASETY


SELECT IDKASETY, IDFILMU, [STATUS] as stat
CASE stat 
WHEN 'K' THEN 'Klient'
WHEN 'W' THEN 'Wypozyczalnia'
ELSE 'Ktos'
END AS stat
FROM KASETY
ORDER BY idkasety





SELECT NAZWISKO, IMIE,
CASE PLEC 
WHEN 'K' THEN 'Kobieta'
WHEN 'M' THEN 'Mezczyzna'
ELSE 'Ktos'
END AS Płeć
FROM KLIENCI
ORDER BY NAZWISKO
------------

-- Declare a cursor for a Table or a View 'TableOrViewName' in schema 'dbo'
DECLARE @tytul NVARCHAR(50), @cena char(30), @ilosc char(30), @ilosc_kaset char(15), @ilosc_filmow char(15),@statu CHAR(15)
SET @ilosc_kaset = (select COUNT(*) from KASETY) 
SET @ilosc_filmow = (SELECT COUNT(*) FROM FILMY)

DECLARE testowy1 CURSOR FOR
SELECT tytul, cena,  COUNT(IDKASETY) as ilosc ,  CASE [STATUS]
    WHEN 'W' THEN 'wypozyczalnia'
    WHEN 'K' THEN 'klient'
    END as gdzie
FROM FILMY f JOIN KASETY k ON k.IDFILMU=f.IDFILMU 
GROUP BY TYTUL, CENA, [STATUS]

OPEN testowy1
PRINT 'Łącznie w bazie jest ' + RTRIM(@ilosc_kaset) + ' kaset'
PRINT '----------------------------------------'
FETCH NEXT FROM testowy1 INTO @tytul, @cena, @ilosc, @statu 

WHILE @@FETCH_STATUS = 0
BEGIN
    -- add instructions to be executed for every row
    
    FETCH NEXT FROM testowy1 INTO @tytul, @cena, @ilosc, @statu 
    
		
    PRINT  @tytul +@cena + RTRIM(@ilosc) +'  ' + @statu 

END
PRINT '----------------------------------------'
PRINT 'lacznie jest ' + RTRIM(@ilosc_filmow) + ' filmow'
PRINT '----------------------------------------'
CLOSE testowy1
DEALLOCATE testowy1
GO






----------------------=========----------------------



