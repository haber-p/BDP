--1
CREATE DATABASE s304170
--2
CREATE SCHEMA firma
--3
CREATE ROLE ksiegowosc 
--4
--A
CREATE TABLE firma.pracownicy (
	id_pracownika int not null,
	imie varchar(20), 
	nazwisko varchar(30),
	adres varchar(50),
	telefon varchar(13)
);

CREATE TABLE firma.godziny (
	id_godziny int NOT NULL,
	data date,
	liczba_godzin float,
	id_pracownika int NOT NULL
);

CREATE TABLE firma.pensja_stanowisko (
	id_pensji int NOT NULL,
	stanowisko varchar(20),
	kwota float
);

CREATE TABLE firma.premia (
	id_premii int NOT NULL, 
	rodzaj varchar(20),
	kwota float
);

CREATE TABLE firma.wynagrodzenie (
	id_wynagrodzenia int NOT NULL,
	data date, 
	id_pracownika int, 
	id_godziny int,
	id_pensji int, 
	id_premii int
);

ALTER TABLE firma.pracownicy ADD PRIMARY KEY (id_pracownika);
ALTER TABLE firma.godziny ADD PRIMARY KEY (id_godziny);
ALTER TABLE firma.pensja_stanowisko ADD PRIMARY KEY (id_pensji);
ALTER TABLE firma.premia ADD PRIMARY KEY (id_premii);
ALTER TABLE firma.wynagrodzenie ADD PRIMARY KEY (id_wynagrodzenia);

ALTER TABLE firma.godziny 
ADD FOREIGN KEY (id_pracownika) REFERENCES firma.pracownicy(id_pracownika);
ALTER TABLE firma.wynagrodzenie
ADD FOREIGN KEY (id_pracownika) REFERENCES firma.pracownicy(id_pracownika);
ALTER TABLE firma.wynagrodzenie
ADD FOREIGN KEY (id_godziny) REFERENCES firma.godziny(id_godziny);
ALTER TABLE firma.wynagrodzenie
ADD FOREIGN KEY (id_pensji) REFERENCES firma.pensja_stanowisko(id_pensji);
ALTER TABLE firma.wynagrodzenie
ADD FOREIGN KEY (id_premii) REFERENCES firma.premia(id_premii);

COMMENT ON TABLE firma.pracownicy IS 'Dane teleadresowe pracowników firmy';
COMMENT ON TABLE firma.godziny IS 'Liczba przepracowanych godzin';
COMMENT ON TABLE firma.pensja_stanowisko IS 'Stanowiska w firmie i ich podstawowe wynagrodzenie';
COMMENT ON TABLE firma.premia IS 'Rodzaje i wysokość przyznawanych premii';
COMMENT ON TABLE firma.wynagrodzenie IS 'Wynagrodzenia pracowników z premią';


--5
INSERT INTO firma.pracownicy VALUES (1, 'Miriam', 'Rząsa', 'Słomiana 5, 31-431 Kraków', '603013042');
INSERT INTO firma.pracownicy VALUES (2, 'Miriam', 'Rząsa', 'Słomiana 5, 31-431 Kraków', '603013042');
INSERT INTO firma.pracownicy VALUES (3, 'Antoni', 'Rząsa', 'Słomiana 5, 31-431 Kraków', '648202275');
INSERT INTO firma.pracownicy VALUES (4, 'Piotr', 'Spała', 'Śliczna 4/5,30-489 Kraków', '623313042');
INSERT INTO firma.pracownicy VALUES (5, 'Martyna', 'Mika', 'Słoneczna 135, 31-856 Kraków', '870013042');
INSERT INTO firma.pracownicy VALUES (6, 'Julia', 'Szpar', 'Balicka 117/5, 31-149 Kraków', '730013042');
INSERT INTO firma.pracownicy VALUES (7, 'Andrzej', 'Ciepły', 'Ładna, 31-345 Kraków', '699721942');
INSERT INTO firma.pracownicy VALUES (8, 'Jan', 'Brzechwa', 'Miła 10/4, 31-123 Kraków', '602783219');
INSERT INTO firma.pracownicy VALUES (9, 'Maja', 'Forysiak', 'Brzydka 2A/45, 30-342 Kraków', '675020452');
INSERT INTO firma.pracownicy VALUES (10, 'Miłosz', 'Bojan', 'Słomiana 55, 31-431 Kraków', '603757233');

INSERT INTO firma.godziny VALUES (1,'2020-03-25', 8, 1);
INSERT INTO firma.godziny VALUES (2,'2020-03-25', 8, 2);
INSERT INTO firma.godziny VALUES (3,'2020-03-25', 4, 3);
INSERT INTO firma.godziny VALUES (4,'2020-03-25', 11, 4);
INSERT INTO firma.godziny VALUES (5,'2020-03-25', 8, 5);
INSERT INTO firma.godziny VALUES (6,'2020-03-26', 8, 6);
INSERT INTO firma.godziny VALUES (7,'2020-03-26', 8, 7);
INSERT INTO firma.godziny VALUES (8,'2020-03-26', 4, 8);
INSERT INTO firma.godziny VALUES (9,'2020-03-26', 8, 9);
INSERT INTO firma.godziny VALUES (10,'2020-03-26', 7, 10);

INSERT INTO firma.pensja_stanowisko VALUES (1, 'księgowa', 3500);
INSERT INTO firma.pensja_stanowisko VALUES (2, 'asystent', 2800);
INSERT INTO firma.pensja_stanowisko VALUES (3, 'prezes zarządu',9000);
INSERT INTO firma.pensja_stanowisko VALUES (4, 'sekretarka', 3000 );
INSERT INTO firma.pensja_stanowisko VALUES (5, 'członek zarządu', 6500 );
INSERT INTO firma.pensja_stanowisko VALUES (6, 'ochroniarz', 2500 );
INSERT INTO firma.pensja_stanowisko VALUES (7, 'magazynier', 2800);
INSERT INTO firma.pensja_stanowisko VALUES (8, 'konserwator pow. pł.', 2500);
INSERT INTO firma.pensja_stanowisko VALUES (9, 'główny księgowy', 4500);
INSERT INTO firma.pensja_stanowisko VALUES (10, 'administrator sieci', 5000);

INSERT INTO firma.premia VALUES (1,'kwartalna',800);
INSERT INTO firma.premia VALUES (2,'retencyjna',1000);
INSERT INTO firma.premia VALUES (3,'rekrutacyjna', 1500);
INSERT INTO firma.premia VALUES (4,'motywacyjna', 700);
INSERT INTO firma.premia VALUES (5,'motywacyjna',500);
INSERT INTO firma.premia VALUES (6,'miesięczna',200);
INSERT INTO firma.premia VALUES (7,'roczna',1000);
INSERT INTO firma.premia VALUES (8,'motywacyjna', 500);
INSERT INTO firma.premia VALUES (9,'uznaniowa',500);
INSERT INTO firma.premia VALUES (10,'inna', 500);

INSERT INTO firma.wynagrodzenie VALUES (1,'2020-04-10',1,1,1,1);
INSERT INTO firma.wynagrodzenie VALUES (2,'2020-04-10',2,2,2,2);
INSERT INTO firma.wynagrodzenie VALUES (3,'2020-04-10',3,3,3,3);
INSERT INTO firma.wynagrodzenie VALUES (4,'2020-04-10',4,4,4,4);
INSERT INTO firma.wynagrodzenie VALUES (5,'2020-04-10',5,5,5,5);
INSERT INTO firma.wynagrodzenie VALUES (6,'2020-04-10',6,6,6,6);
INSERT INTO firma.wynagrodzenie VALUES (7,'2020-04-10',7,7,7,7);
INSERT INTO firma.wynagrodzenie VALUES (8,'2020-04-10',8,8,8,8);
INSERT INTO firma.wynagrodzenie VALUES (9,'2020-04-10',9,9,9,9);
INSERT INTO firma.wynagrodzenie VALUES (10,'2020-04-10',10,10,10,10);

ALTER TABLE firma.wynagrodzenie
ALTER COLUMN data TYPE varchar(13);


--6
--a
SELECT id_pracownika, nazwisko FROM firma.pracownicy
--b
SELECT id_pracownika
FROM firma.wynagrodzenie wyn
JOIN firma.pensja_stanowisko ps
ON wyn.id_pensji = ps.id_pensji
WHERE ps.kwota > 1000
--c
SELECT id_pracownika
FROM firma.wynagrodzenie wyn
JOIN firma.pensja_stanowisko ps
ON wyn.id_pensji = ps.id_pensji
JOIN firma.premia pr
ON wyn.id_premii = pr.id_premii
WHERE pr.rodzaj = 'brak' AND ps.kwota > 2000 ;
--d
SELECT * FROM firma.pracownicy 
WHERE imie LIKE 'J%';
--e
SELECT * FROM firma.pracownicy
WHERE nazwisko LIKE '%n%' AND imie LIKE '%a'
--f
SELECT imie, nazwisko, (godz.liczba_godzin-160) AS nadgodziny
FROM firma.wynagrodzenie wyn 
JOIN firma.pracownicy prac 
ON wyn.id_pracownika = prac.id_pracownika
JOIN firma.godziny godz
ON wyn.id_godziny=godz.id_godziny
WHERE godz.liczba_godzin>160;
--g
SELECT imie, nazwisko
FROM firma.wynagrodzenie wyn 
JOIN firma.pensja_stanowisko pen 
ON wyn.id_pensji = pen.id_pensji
JOIN firma.pracownicy prac 
ON wyn.id_pracownika = prac.id_pracownika
WHERE kwota BETWEEN 1500 AND 3000;
--h
SELECT imie, nazwisko
FROM firma.wynagrodzenie wyn 
JOIN firma.premia prem
ON wyn.id_premii = prem.id_premii
JOIN firma.pracownicy prac 
ON wyn.id_pracownika = prac.id_pracownika
JOIN firma.godziny godz
ON wyn.id_godziny=godz.id_godziny
WHERE godz.liczba_godzin>160 AND prem.kwota=0;

--7
--a
SELECT prac.* FROM firma.wynagrodzenie wyn
JOIN firma.pracownicy prac
ON wyn.id_pracownika = prac.id_pracownika
JOIN firma.pensja_stanowisko pen
ON wyn.id_pensji = pen.id_pensji
ORDER BY pen.kwota
--b
SELECT prac.* FROM firma.wynagrodzenie wyn
JOIN firma.pracownicy prac
ON wyn.id_pracownika = prac.id_pracownika
JOIN firma.pensja_stanowisko pen
ON wyn.id_pensji = pen.id_pensji
JOIN firma.premia prem 
ON wyn.id_premii = prem.id_premii
ORDER BY pen.kwota DESC, prem.kwota DESC
--c
SELECT pen.stanowisko, COUNT(pen.stanowisko) AS zliczenie 
FROM firma.wynagrodzenie wyn
JOIN firma.pensja_stanowisko pen
ON wyn.id_pensji = pen.id_pensji
GROUP BY pen.stanowisko
--d
SELECT AVG(kwota), MAX(kwota),MIN(kwota)
FROM firma.wynagrodzenie wyn 
JOIN firma.pensja_stanowisko pen
ON wyn.id_pensji = pen.id_pensji
WHERE stanowisko='kierownik'
--e
SELECT SUM(kwota) AS suma
FROM firma.pensja_stanowisko pen
--f
SELECT stanowisko, SUM(kwota) AS suma
FROM firma.pensja_stanowisko pen
GROUP BY stanowisko
--g
SELECT stanowisko, SUM(prem.kwota) AS suma
FROM firma.pensja_stanowisko pen
JOIN firma.wynagrodzenie wyn
ON pen.id_pensji = wyn.id_pensji
JOIN firma.premia prem
ON wyn.id_premii = prem.id_premii
GROUP BY stanowisko
--h
DELETE FROM firma.wynagrodzenie  wyn
USING firma.pensja_stanowisko pen
WHERE pen.kwota <1200 AND wyn.id_pensji = pen.id_pensji;

--8
--a
UPDATE firma.pracownicy
SET telefon = '(+48)'||telefon
--b
UPDATE firma.pracownicy
SET telefon = SUBSTRING(telefon,0,9) || '-' || SUBSTRING (telefon,9,3) || '-' || SUBSTRING (telefon,12,3)
--c
SELECT UPPER(nazwisko)
FROM firma.pracownicy
WHERE CHARACTER_LENGTH(nazwisko) = (SELECT MAX(CHARACTER_LENGTH(nazwisko)) FROM firma.pracownicy)
--d
SELECT prac.*, MD5(CAST(pen.kwota as char)) as wynagrodzenie_MD5 
FROM firma.pracownicy prac
JOIN firma.wynagrodzenie wy 
ON wy.id_pracownika = prac.id_pracownika 
JOIN firma.pensja_stanowisko pen 
ON wy.id_pensji = pen.id_pensji 

--7
SELECT CONCAT('Pracownik ', prac.imie , ' ', prac.nazwisko,', w dniu ',
godz.data,' otrzymał pensję całkowitą na kwotę ', pe.kwota+pr.kwota,
' zł, gdzie wynagrodzenie zasadnicze wynosiło: ',pe.kwota, ' zł, premia:', pr.kwota,
', nadgodziny: ', (godz.liczba_godzin-160)*15 ,'zł') AS Raport
FROM firma.wynagrodzenie wy
JOIN firma.pensja_stanowisko pe ON wy.id_pensji = pe.id_pensji
JOIN firma.premia pr ON wy.id_premii = pr.id_premii 
JOIN firma.pracownicy prac ON wy.id_pracownika = prac.id_pracownika
JOIN firma.godziny godz ON prac.id_pracownika = godz.id_pracownika
