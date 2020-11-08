CREATE EXTENSION postgis;

CREATE TABLE obiekty (
	id int PRIMARY KEY,
	nazwa varchar(20),
	geom geometry
);


INSERT INTO obiekty VALUES (1,'obiekt1',ST_GeomFromEWKT('COMPOUNDCURVE((0 1,1 1),CIRCULARSTRING(1 1, 2 0, 3 1),CIRCULARSTRING(3 1, 4 2, 5 1),(5 1, 6 1))'));
INSERT INTO obiekty VALUES (2,'obiekt2',ST_GeomFromEWKT('CURVEPOLYGON(COMPOUNDCURVE(CIRCULARSTRING(14 6, 16 4, 14 2, 12 0, 10 2),(10 2, 10 6, 14 6)),CIRCULARSTRING(11 2,13 2, 11 2))'));
INSERT INTO obiekty VALUES (3,'obiekt3',ST_GeomFromText('POLYGON((7 15, 10 17,12 13,7 15))'));
INSERT INTO obiekty VALUES (4,'obiekt4',ST_GeomFromText('Linestring(20 20,25 25,27 24,25 22,26 21,22 19,20.5 19.5)'));
INSERT INTO obiekty VALUES (5,'obiekt5',ST_GeomFromEWKT('MULTIPOINTZ(30 30 59,38 32 234)'));
INSERT INTO obiekty VALUES (6,'obiekt6',ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1,3 2), POINT(4 2))'));

--1
SELECT ST_Area(ST_Buffer((ST_ShortestLine((SELECT geom FROM obiekty WHERE nazwa = 'obiekt3'),(SELECT geom FROM obiekty WHERE nazwa='obiekt4'))),5 ));

--2
--warunek - linestring musi być zamknięty 
UPDATE obiekty
SET geom = ST_AddPoint(geom, ST_StartPoint(geom))
WHERE id = 4 AND ST_IsClosed(geom) = false;
--zamiana na poligon 
SELECT ST_MakePolygon((SELECT geom FROM obiekty WHERE id=4));
--ewentualnie z uaktualnieniem do tabeli
UPDATE obiekty
SET geom = ST_MakePolygon((SELECT geom FROM obiekty WHERE id=4))
WHERE id = 4;

--3
INSERT INTO obiekty VALUES (7, 'obiekt7', ST_Collect((SELECT geom FROM obiekty WHERE nazwa = 'obiekt3'),(SELECT geom FROM obiekty WHERE nazwa='obiekt4')));

--4
--pola buforów
SELECT nazwa, ST_Area((ST_Buffer(geom, 5))) FROM obiekty WHERE ST_HasArc(geom) = false;
--łączne pole buforów
SELECT SUM(ST_Area((ST_Buffer(geom, 5)))) FROM obiekty WHERE ST_HasArc(geom) = false;