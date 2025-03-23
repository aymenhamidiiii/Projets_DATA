-- Création du schéma "accidents"
CREATE SCHEMA accidents;

--  Utilisation du schéma "accidents"
USE accidents;

/* -------------------------------- */
--  Création des tables
CREATE TABLE accident(
	accident_index VARCHAR(13),        -- Identifiant unique de l'accident
    accident_severity INT              -- Gravité de l'accident (1 = grave, 2 = moyen, 3 = léger par exemple)
);

CREATE TABLE vehicles(
	accident_index VARCHAR(13),        -- Identifiant de l'accident (clé étrangère)
    vehicle_type VARCHAR(50)           -- Type de véhicule impliqué dans l'accident
);

--  Table de correspondance entre codes véhicules et leur libellé
--  Remplir ce fichier à partir de l’onglet "Vehicle Type" du fichier Excel Road-Accident-Safety-Data-Guide.xls
CREATE TABLE vehicle_types(
	vehicle_code INT,                  -- Code du type de véhicule
    vehicle_type VARCHAR(10)          -- Libellé du type de véhicule (ex: "Car", "Bike", etc.)
);

/* -------------------------------- */
--  Chargement des données

--  Chargement du fichier des accidents
LOAD DATA LOCAL INFILE 'C:\\Users\\Accidents_2015.csv'
INTO TABLE accident
FIELDS TERMINATED BY ','             -- Les colonnes sont séparées par des virgules
ENCLOSED BY '"'                      -- Les champs sont encadrés par des guillemets
LINES TERMINATED BY '\n'            -- Chaque ligne est séparée par un saut de ligne
IGNORE 1 LINES                      -- Ignore la première ligne (en-tête)
(@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, 
 @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, 
 @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, 
 @dummy)
SET accident_index=@col1, accident_severity=@col2;  -- On extrait uniquement l'identifiant et la gravité

--  Chargement du fichier des véhicules
LOAD DATA LOCAL INFILE 'C:\\Users\\Vehicles_2015.csv'
INTO TABLE vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, 
 @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, 
 @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, vehicle_type=@col2;       -- On extrait l'identifiant d'accident et le type de véhicule

--  Chargement du fichier de correspondance des types de véhicules
LOAD DATA LOCAL INFILE 'C:\\Users\\vehicle_types.csv'
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;   -- Ignore la ligne d'en-tête
