-- create external tables using parquet files from GCS bucket
CREATE OR REPLACE EXTERNAL TABLE `cochlear-technical-challenge.manufacturing.external_volume`
OPTIONS (
  format = 'parquet',
  uris = ['gs://cochlear-technical-challenge-bucket/volume.parquet']
);
CREATE OR REPLACE EXTERNAL TABLE `cochlear-technical-challenge.manufacturing.external_hours`
OPTIONS (
  format = 'parquet',
  uris = ['gs://cochlear-technical-challenge-bucket/hours.parquet']
);
-- create tables using external tables above
CREATE OR REPLACE TABLE `cochlear-technical-challenge.manufacturing.stg_volume` AS
SELECT * FROM `cochlear-technical-challenge.manufacturing.external_volume`
;
select count(*) from `cochlear-technical-challenge.manufacturing.volume` 
limit 100;

CREATE OR REPLACE TABLE `cochlear-technical-challenge.manufacturing.stg_hours` AS
SELECT * FROM `cochlear-technical-challenge.manufacturing.external_hours`
;
select count(*) from `cochlear-technical-challenge.manufacturing.hours` limit 100;