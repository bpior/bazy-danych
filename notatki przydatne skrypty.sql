DECLARE @tytul NVARCHAR(50), @cena char(30), @ilosc char(30), @ilosc_kaset char(15), @ilosc_filmow char(15)--, @najwieksza CHAR (30)
SET @ilosc_kaset = (select COUNT(*) from KASETY) 
SET @ilosc_filmow = (SELECT COUNT(*) FROM FILMY)

/*declare @min int, @max int, @max1 NVARCHAR(10)
;with cte1   as 
(
SELECT COUNT(IDKASETY) as filmy, TYTUL
FROM FILMY f JOIN KASETY k ON k.IDFILMU=f.IDFILMU
GROUP BY TYTUL, CENA
)
select @max=max(filmy), @min=min(filmy) from cte1 */

DECLARE testowy1 CURSOR FOR
SELECT tytul, cena,  COUNT(IDKASETY) as ilosc 
FROM FILMY f JOIN KASETY k ON k.IDFILMU=f.IDFILMU
GROUP BY TYTUL, CENA
/*
SELECT NAZWISKO, IMIE, COUNT(IDKASETY) AS LICZBA
FROM KLIENCI K  JOIN WYPO W ON K.IDKLIENTA=W.IDKLIENTA
GROUP BY NAZWISKO, IMIE */

OPEN testowy1
PRINT 'Łącznie w bazie jest ' + RTRIM(@ilosc_kaset) + ' kaset'
PRINT '----------------------------------------'
FETCH NEXT FROM testowy1 INTO @tytul, @cena, @ilosc

WHILE @@FETCH_STATUS = 0
BEGIN
    /*FETCH NEXT FROM testowy INTO @tytul, @cena, @ilosc
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
		END*/
	PRINT  @tytul +@cena + RTRIM(@ilosc) + ' '-- + @MAX1
END
PRINT '----------------------------------------'
PRINT 'lacznie jest ' + RTRIM(@ilosc_filmow) + ' wypozyczen'
PRINT '----------------------------------------'
CLOSE testowy1
DEALLOCATE testowy1






DECLARE @nazwisko NVARCHAR(50), @imie char(50), @LICZBA char(30), @ilosc_klientow char(15), @ilosc_wypozyczen char(15)
SET @ilosc_klientow = (select COUNT(*) from KLIENCI) 
SET @ilosc_wypozyczen = (SELECT COUNT(*) FROM WYPO)
--set @m = (select COUNT(*) from KLIENCI WHERE PLEC= 'M')
--set @k= select( COUNT(*) from KLIENCI WHERE PLEC= 'K')

DECLARE testowy CURSOR FOR



/* SELECT NAZWISKO, IMIE, COUNT(IDKASETY) AS LICZBA 
FROM KLIENCI K  JOIN WYPO W ON K.IDKLIENTA=W.IDKLIENTA
GROUP BY NAZWISKO, IMIE */

OPEN testowy
PRINT 'Łącznie w bazie jest ' + RTRIM(@ilosc_klientow) + ' klientow'
PRINT '----------------------------------------'
FETCH NEXT FROM testowy INTO @nazwisko, @imie, @LICZBA

WHILE @@FETCH_STATUS = 0
BEGIN
    -- add instructions to be executed for every row
    
    FETCH NEXT FROM testowy INTO @nazwisko, @imie, @LICZBA
    PRINT @nazwisko +@imie + RTRIM(@LICZBA)

END
PRINT '----------------------------------------'
PRINT 'lacznie jest ' + RTRIM(@ilosc_wypozyczen) + ' wypozyczen'
PRINT '----------------------------------------'
CLOSE testowy
DEALLOCATE testowy
GO



SELECT * 
coalesce(MAX(CASE WHEN CCP.ENDDATE IS NULL THEN 'Active' END)  
         OVER (PARTITION BY CCP.ID),'Closed') AS CURRENT_STATUS
FROM TABLEA CCP

SELECT CAST(DATAW as date ) as DATA , COUNT(*) as ile_pozyczono
FROM WYPO
GROUP by DATAW  

SELECT NAZWISKO, IMIE, W.DATAW, IDKASETY, TYTUL
FROM KLIENCI K JOIN WYPO  W ON K.IDKLIENTA=W.IDKLIENTA JOIN KASETY ON KASETY.IDKASETY=W.IDKASETY JOIN FILMY F ON KASETY.IDFILMU=F.IDFILMU -- W.IDKASETY=A.IDKASETY JOIN FILMY F ON A.IDFILMU=F.IDFILMU
ORDER BY K.NAZWISKO, W.DATAW

SELECT NAZWISKO, IMIE, COUNT(IDKASETY) AS LICZBA 
FROM KLIENCI K  JOIN WYPO W ON K.IDKLIENTA=W.IDKLIENTA
GROUP BY NAZWISKO, IMIE








SELECT NAZWISKO, IMIE, COUNT(IDKASETY) AS LICZBA 
FROM KLIENCI K  JOIN WYPO W ON K.IDKLIENTA=W.IDKLIENTA




DECLARE db_cursor CURSOR FOR SELECT name, age, color FROM table; 
DECLARE @myName VARCHAR(256);
DECLARE @myAge INT;
DECLARE @myFavoriteColor VARCHAR(40);
OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @myName, @myAge, @myFavoriteColor;
WHILE @@FETCH_STATUS = 0  
BEGIN  

       --Do stuff with scalar values

       FETCH NEXT FROM db_cursor INTO @myName, @myAge, @myFavoriteColor;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;




DECLARE @ilosc_klientow		VARCHAR(100)
SET @ilosc_klientow = 'NAZWISKO'
EXECUTE ('SELECT COUNT(*) ' + @ilosc_klientow + ' FROM KLIENCI')





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
GO






SELECT* FROM   sys.dm_exec_cursors(0)
GO


----ok

CREATE PROCEDURE dbo.p_cleanUpCursor @cursorName varchar(255) AS
BEGIN

    DECLARE @cursorStatus int
    SET @cursorStatus =  (SELECT cursor_status('global',@cursorName))

    DECLARE @sql varchar(255)
    SET @sql = ''

    IF @cursorStatus > 0
        SET @sql = 'CLOSE '+@cursorName

    IF @cursorStatus > -3
        SET @sql = @sql+' DEALLOCATE '+@cursorName

    IF @sql <> ''
        exec(@sql)

END

EXEC dbo.p_cleanUpCursor C1 --nazwa kursora


DECLARE @adate DATETIME
DECLARE @FROMDATE DATETIME
DECLARE @TODATE DATETIME

SELECT @FROMDATE = getdate()

SELECT @TODATE = getdate() + 7

DECLARE @weekdates CURSOR;

SET @weekdates = CURSOR FOR
WITH DATEINFO(DATES)
     AS (SELECT @FROMDATE
         UNION ALL
         SELECT DATES + 1
         FROM   DATEINFO
         WHERE  DATES < @TODATE)
SELECT *
FROM   DATEINFO
OPTION (MAXRECURSION 0) 

OPEN @weekdates

FETCH next FROM @weekdates INTO @adate

WHILE @@fetch_status = 0
  BEGIN
      PRINT 'success'

      FETCH next FROM @weekdates INTO @adate
  END

DECLARE @min int, @max int
WITH cte1 as (
    SELECT COUNT(idkasety) as klienci
    from KLIENCI k JOIN wypo w on k.IDKLIENTA=w.IDKLIENTA
    GROUP by NAZWISKO, IMIE 
)
SELECT @max=max(KLIENCI), @min= MIN(KLIENCI) from cte1




DECLARE @ilosc_klientow	VARCHAR(100)
SET @ilosc_klientow = (SELECT COUNT(IDKASETY)
FROM KLIENCI K  JOIN WYPO W ON K.IDKLIENTA=W.IDKLIENTA
GROUP BY NAZWISKO, IMIE)
EXECUTE ('SELECT COUNT(*) ' + @ilosc_klientow + ' FROM KLIENCI')


EXEC zapisz_nowego_rezysera 35, 'popis', 'krzysztof',@return_status OUTPUT


SELECT * 
coalesce(MAX(CASE WHEN KLIENCI. IS NULL THEN 'Active' END)  
         OVER (PARTITION BY KLIENCI),'Closed') AS CURRENT_STATUS
FROM KLIENCI CCP
