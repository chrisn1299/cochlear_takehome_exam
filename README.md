# Cochlear Technical Challenge

## Scenario

You are an Analyst specialising in Manufacturing Insights at Cochlear. Your manager has asked you to analyse manufacturing data in order to provide meaningful and actionable information for our manufacturing managers. Each manufacturing manager is responsible for one manufacturing team.

You will need to produce a live dashboard (one page) that is aligned with meeting Cochlear’s strategic priorities, which aim to:

- Meet our revenue and cost targets
- Improve quality, efficiency and agility

Your manager has also requested you to prepare a 5 minute presentation explaining your findings to an audience consisting of the manufacturing services team and manufacturing managers.

## Results

## Methods

1. download data into local folder
2. upload data to Mage for light processing and ingestion to Google Cloud Storage
3. build datasets and clean for given data in BigQuery. 
4. connect BigQuery to Tableau Desktop to build dashboards
5. upload dashboard on Tableau Public along with GitHub repo.

## data pre-processing and ingestion
- assign data types
- standardize naming formats to snake case
- ingest into Google Cloud Storage bucket

## data exploration and cleaning 
- ingest data from GCS bucket into BigQuery 

takeaways: 
- a lot of duplicated data
Volume: 
- there are negative values for return quantity. further exploration suggests that these might be accummulated units that fail quality control over a long period of time, hence treated as positive return quantity. 

Hours: 
- several Team values have different naming conventions. 
- there are negative hours charged values

Cleaning: 
Volume:
- negative return_qty values are converted to positive.
- convert fiscal_period from MM-yy to start date of the month
- aggregate data so that the level of detail is (part_number, fiscal_date)

Hours:
- negative hours_charged values are converted to 0. 
- team ids are standardized to be AA_AAAA
- aggregate so that the final level of detail is (fiscal_date, part_number, team_id)

## final data sources
since the stakeholders would be manufacturing team managers, each of whom manage one team. 
we left join the aggregated hours with aggregated volume table to retain all team_id. 

join based on fiscal_date and part_number
