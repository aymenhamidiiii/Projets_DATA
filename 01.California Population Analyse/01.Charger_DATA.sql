CREATE SCHEMA ca_population;

USE ca_population;

CREATE TABLE pop_proj(
	county_code VARCHAR(45) NOT NULL,
    county_name VARCHAR(45) NOT NULL,
    date_year INT NOT NULL,
    race_code INT NOT NULL,
    race TEXT NOT NULL,
    gender VARCHAR(6) NOT NULL,
    age INT NOT NULL,
    population INT NOT NULL
);

/* Load Data */
/* ignore first header line, delimiter setting, etc*/
LOAD DATA LOCAL INFILE 'C:\\Users\\User\\CA_DRU_proj_2010-2060.csv'
INTO TABLE pop_proj
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* check the loaded data */
SELECT * FROM pop_proj
LIMIT 10;

