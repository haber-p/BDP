CREATE EXTENSION postgis;

CREATE TABLE budynki (
	id int,
	nazwa varchar(30),
	geometria GEOMETRY
);

CREATE TABLE drogi (
	id int,
	nazwa varchar(10),
	geometria GEOMETRY
);

CREATE TABLE punkty_informacyjne (
	id int,
	nazwa varchar(3),
	geometria GEOMETRY
);

INSERT INTO budynki VALUES (1,'BuildingF',ST_GeomFromText('POLYGON((1 1, 2 1, 2 2,1 2, 1 1))',0));
INSERT INTO budynki VALUES (2,'BuildingB',ST_GeomFromText('POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))',0));
INSERT INTO budynki VALUES (3,'BuildingC',ST_GeomFromText('POLYGON((3 8, 3 6, 5 6, 5 8, 3 8))',0));
INSERT INTO budynki VALUES (4,'BuildingD',ST_GeomFromText('POLYGON((9 9, 9 8, 10 8, 10 9, 9 9))',0));
INSERT INTO budynki VALUES (5,'BuildingA',ST_GeomFromText('POLYGON((8 4, 8 1.5, 10.5 1.5, 10.5 4, 8 4))',0));

INSERT INTO drogi VALUES (1, 'RoadX', ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0));
INSERT INTO drogi VALUES (2, 'RoadY', ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0));

INSERT INTO punkty_informacyjne VALUES (1, 'G',ST_GeomFromText('POINT(1 3.5)', 0 ));
INSERT INTO punkty_informacyjne VALUES (2, 'H',ST_GeomFromText('POINT(5.5 1.5)', 0 ));
INSERT INTO punkty_informacyjne VALUES (3, 'I',ST_GeomFromText('POINT(9.5 6)', 0 ));
INSERT INTO punkty_informacyjne VALUES (4, 'J',ST_GeomFromText('POINT(6.5 6)', 0 ));
INSERT INTO punkty_informacyjne VALUES (5, 'K',ST_GeomFromText('POINT(6 9.5)', 0 ));

--a
SELECT SUM(ST_Length(geometria)) FROM drogi;
--b 
SELECT ST_AsText(geometria) AS GeometriaWKT, ST_Area(geometria) AS PolePowierzchni, ST_Perimeter(geometria) AS Obwód 
FROM budynki WHERE nazwa = 'BuildingA' ;
--c 
SELECT nazwa, ST_Area(geometria) AS PolePowierzchni 
FROM budynki
ORDER BY nazwa;
--d
SELECT nazwa, ST_Perimeter(geometria) AS Obwód
FROM budynki
ORDER BY ST_Area(geometria) DESC LIMIT 2;
--e
SELECT ST_Distance (
	(SELECT geometria FROM budynki WHERE nazwa='BuildingC'), 
	(SELECT geometria FROM punkty_informacyjne WHERE nazwa='G'));

--f
SELECT ST_Area (ST_Difference (	(SELECT geometria FROM budynki WHERE nazwa = 'BuildingC'), 
								(SELECT ST_BUFFER(geometria, 0.5) FROM budynki WHERE nazwa='BuildingB')));
--g 
SELECT nazwa
FROM budynki
WHERE ST_Y(ST_Centroid(geometria)) > (SELECT ST_Y(ST_Centroid(geometria)) FROM drogi WHERE nazwa='RoadX')

--h 

SELECT 
(
	ST_Area (ST_Difference( 
	(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')),
	(SELECT geometria FROM budynki WHERE nazwa = 'BuildingC')))
),
(
	SELECT ST_Area(ST_Difference (
	(SELECT geometria FROM budynki WHERE nazwa = 'BuildingC'),
	(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))))
)	
--budynek

SELECT ST_Area (ST_Difference (
	(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')), 
	(ST_Intersection (
		(SELECT geometria FROM budynki WHERE nazwa = 'BuildingC'),
		(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))))));

--poligon		
	
SELECT ST_Area(ST_Difference ((
	SELECT geometria FROM budynki WHERE nazwa = 'BuildingC'), 
	(ST_Intersection (
		(SELECT geometria FROM budynki WHERE nazwa = 'BuildingC'),
		(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))))));




