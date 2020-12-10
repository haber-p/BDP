--raster2pgsql -s 3763 -N -32767 -t 100x100 -I -C -M -d D:\Studia\V_semestr\BDP\rasters\srtm_1arc_v3.tif rasters.dem > D:\Studia\V_semestr\BDP\dem.sql
--raster2pgsql -s 3763 -N -32767 -t 100x100 -I -C -M -d D:\Studia\V_semestr\BDP\rasters\srtm_1arc_v3.tif rasters.dem | psql -d rasters -h localhost -U postgres -p 5432
--raster2pgsql -s 3763 -N -32767 -t 128x128 -I -C -M -d D:\Studia\V_semestr\BDP\rasters\Landsat8_L1TP_RGBN.TIF rasters.landsat8 | psql -d rasters -h localhost -U postgres -p 5432

-- 4
CREATE TABLE tutorial.intersects AS
SELECT a.rast, b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';

alter table tutorial.intersects
add column rid SERIAL PRIMARY KEY;

CREATE INDEX idx_intersects_rast_gist ON tutorial.intersects
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('tutorial'::name,
'intersects'::name,'rast'::name);

CREATE TABLE tutorial.clip AS
SELECT ST_Clip(a.rast, b.geom, true), b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality like 'PORTO';

CREATE TABLE stutorial.union AS
SELECT ST_Union(ST_Clip(a.rast, b.geom, true))
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast);
CREATE TABLE tutorial.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

-- 5
DROP TABLE tutorial.porto_parishes; --> drop table porto_parishes first
CREATE TABLE tutorial.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

-- 6
DROP TABLE tutorial.porto_parishes; 
CREATE TABLE tutorial.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1 
)
SELECT st_tile(st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)),128,128,true,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

--7
CREATE TABLE tutorial.intersection as
SELECT a.rid,(ST_Intersection(b.geom,a.rast)).geom,(ST_Intersection(b.geom,a.rast)).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

CREATE TABLE tutorial.dumppolygons AS
SELECT a.rid,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);


-- 8

CREATE TABLE tutorial.landsat_nir AS
SELECT rid, ST_Band(rast,4) AS rast
FROM rasters.landsat8;

CREATE TABLE tutorial.paranhos_dem AS
SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

CREATE TABLE tutorial.paranhos_slope AS
SELECT a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast
FROM tutorial.paranhos_dem AS a;

CREATE TABLE tutorial.paranhos_slope_reclass AS
SELECT a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3', '32BF',0)
FROM tutorial.paranhos_slope AS a;

SELECT ST_SummaryStats(a.rast) AS stats
FROM tutorial.paranhos_dem AS a;

SELECT ST_SummaryStats(ST_Union(a.rast))
FROM tutorial.paranhos_dem AS a;

WITH t AS (
SELECT ST_SummaryStats(ST_Union(a.rast)) AS stats
FROM tutorial.paranhos_dem AS a
)
SELECT (stats).min,(stats).max,(stats).mean FROM t;

WITH t AS (
SELECT b.parish AS parish, st_summarystats(ST_Union(ST_Clip(a.rast, b.geom,true))) AS stats
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
group by b.parish
)
SELECT parish,(stats).min,(stats).max,(stats).mean FROM t;

SELECT b.name,st_value(a.rast,(ST_Dump(b.geom)).geom) AS wartosc_piksela
FROM
rasters.dem a, vectors.places AS b
WHERE ST_Intersects(a.rast,b.geom)
ORDER BY b.name;

-- 9
CREATE TABLE tutorial.tpi30 as
SELECT ST_TPI(a.rast,1) as rast
FROM rasters.dem a;

CREATE INDEX idx_tpi30_rast_gist ON tutorial.tpi30
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('tutorial'::name, 'tpi30'::name,'rast'::name);


CREATE TABLE tutorial.tpi30_porto as
SELECT ST_TPI(a.rast,1) as rast
FROM rasters.dem a, vectors.porto_parishes AS b WHERE  ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto'

CREATE INDEX idx_tpi30_porto_rast_gist ON tutorial.tpi30_porto
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('tutorial'::name, 'tpi30_porto'::name,'rast'::name);

-- 10
CREATE TABLE tutorial.porto_ndvi AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, 1,
r.rast, 4,
'([rast2.val] - [rast1.val]) / ([rast2.val] + [rast1.val])::float','32BF'
) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi_rast_gist ON tutorial.porto_ndvi
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('tutorial'::name, 'porto_ndvi'::name,'rast'::name);

CREATE OR REPLACE FUNCTION tutorial.ndvi(
VALUE double precision [] [] [],
pos integer [][],
VARIADIC userargs text []
)
RETURNS double precision AS
$$
BEGIN
RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value [1][1][1]); --> NDVI calculation!
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;

CREATE TABLE tutorial.porto_ndvi2 AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, ARRAY[1,4],
'tutorial.ndvi(double precision[], integer[],text[])'::regprocedure, --> This is the function!
'32BF'::text

CREATE INDEX idx_porto_ndvi2_rast_gist ON tutorial.porto_ndvi2
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('tutorial'::name, 'porto_ndvi2'::name,'rast'::name);


-- 11) 
SELECT ST_AsTiff(ST_Union(rast))
FROM tutorial.porto_ndvi;
SELECT ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
FROM tutorial.porto_ndvi;

-- 12) 
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM tutorial.porto_ndvi;
-- eksport
SELECT lo_export(loid, 'D:\Studia\V_semestr\BDP\myraster.tiff') 
FROM tmp_out;
-- 
SELECT lo_unlink(loid)
FROM tmp_out; --> Delete the large object.


gdal_translate -co COMPRESS=DEFLATE -co PREDICTOR=2 -co ZLEVEL=9 PG:"host=localhost port=5432 dbname=rasters user=postgres password= schema=tutorial table=porto_ndvi mode=2" porto_ndvi.tiff

