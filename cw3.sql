--CREATE EXTENSION postgis;

--4
CREATE TABLE buildings AS (
SELECT DISTINCT popp.*
FROM popp INNER JOIN majrivers
ON ST_DWithin(popp.geom,majrivers.geom,1000000)
WHERE popp.f_codedesc='Building');

--5
CREATE TABLE airportNew (
gid int PRIMARY KEY,
name varchar(80),
elev numeric,
geom geometry
)
INSERT INTO airportNew (gid,name,elev,geom)
SELECT gid,name,elev,geom FROM airports
--a
--lotnisko najbardziej na wschód 
SELECT name, ST_X(geom) as X FROM airportnew
ORDER BY X DESC LIMIT 1
--lotnisko najbardziej na zachód
SELECT name, ST_X(geom) as X FROM airportnew
ORDER BY X LIMIT 1
--b
INSERT INTO airportnew(gid,name,elev,geom) VALUES (123,'Central',500,(
		ST_Centroid(ST_ShortestLine((SELECT geom FROM airports ORDER BY ST_X(geom) LIMIT 1), 
				(SELECT geom FROM airports ORDER BY ST_X(geom) DESC LIMIT 1)))))


--6
SELECT ST_Area(
	ST_Buffer (
		(ST_ShortestLine(
			(SELECT geom FROM airports WHERE name='AMBLER'),
			(SELECT geom FROM lakes WHERE names = 'Iliamna Lake')))
		,1000))



--7
SELECT  (SUM(tu.area_km2)+SUM(s.areakm2)),tr.vegdesc 
FROM  trees tr, tundra tu , swamp s
WHERE tu.area_km2 IN (SELECT t.area_km2 FROM tundra t, trees tr WHERE ST_CONTAINS(tr.geom,t.geom) = 'true') 
AND s.areakm2 IN (SELECT s.areakm2 FROM swamp s, trees tr WHERE ST_CONTAINS(tr.geom,s.geom) = 'true')
GROUP BY tr.vegdesc
