
-- 
-- This script shows how to export or UNLOAD data from Redshift into CSV files
-- sitting inside of S3.
--
-- We then demonstrate use of Spectrum.  This allows us to query data with SQL
-- while it still sits inside of S3.  No need to load it into REdshift at all.
-- This is sometimes called an operational datastore.  You can stage *ALL* data
-- into S3, then load what you need hot, into the database itself.
--
-- For those who know Oracle these were called EXTERNAL TABLES
-- In MySQL you could create a table with ENGINE = CSV
-- In MySQL you could actually insert data, while Oracle & Redshift only allow 
-- reading of data sitting in S3 CSV files.
--

--
-- Unload Jan 10, 2018 data into a pipe deliminted CSV file
--
unload ('select pagetitle, video, channel, show, url_path, country, region, language from weeklyplays where date_formatted = 2018-01-10') to 's3://acme-assets/weeklyplays/date_formatted=2016-11-26/' CREDENTIALS 'aws_access_key_id=ABCDEFGHIJK;aws_secret_access_key=UUUU222aaa' delimiter '|' addquotes;

--
-- unload jan 12, 2018 data into comma deliminted CSV file
--
unload ('select pagetitle, video, channel, show, url_path, country, region, language from weeklyplays where date_formatted = 2018-01-12') to 's3://acme-assets/weeklyplays/date_formatted=2017-05-20/' CREDENTIALS 'aws_access_key_id=ABCDEFGHIJK;aws_secret_access_key=UUUU222aaa' delimiter ',' addquotes;



-- 
-- unload jan 15 2018 data in pipe delimited csv file
--
unload ('select pagetitle, video, channel, show, url_path, country, region, language from weeklyplays where date_formatted = 2018-01-15') to 's3://acme-assets/weeklyplays/date_formatted=2017-04-28/' CREDENTIALS 'aws_access_key_id=ABCDEFGHIJK;aws_secret_access_key=UUUU222aaa' delimiter '|' addquotes;


--
-- add the partition to our virtual table mapping inside redshift
-- This allows redshift to query CSV file data directly from S3
--
alter table spectrum_schema.weeklyplays
add partition(date_formatted='2018-01-10') 
location 's3://acme-assets/weeklyplays/date_formatted=2018-01-10/';

--
-- add partition to our virtual table mapping. It is a spectrum 
-- table, inside of redshift.  This allows us to query the csv file
-- as the data sits in S3
--
alter table spectrum_schema.weeklyplays
add partition(date_formatted='2018-01-12') 
location 's3://acme-assets/weeklyplays/date_formatted=2018-01-12/';

--
-- add partition
--
alter table spectrum_schema.weeklyplays
add partition(date_formatted='2018-01-15') 
location 's3://acme-assets/weeklyplays/date_formatted=2018-01-15/';


