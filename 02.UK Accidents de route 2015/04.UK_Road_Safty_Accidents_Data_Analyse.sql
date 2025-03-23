/* REMARQUE : Comparez les performances des requêtes en utilisant l'icône Explain en premier (avant et après l'indexation) */

/* Créez un index sur accident_index car il est utilisé dans les deux tables vehicles et accident.
L'utilisation d'index rendra les jointures plus rapides. */
CREATE INDEX accident_index
ON accident(accident_index);

CREATE INDEX accident_index
ON vehicles(accident_index);

/* ------------------------------------------ */
/* Analyse de la gravité des accidents et du nombre total d'accidents par type de véhicule */
/* Cette requête permet de savoir combien d'accidents ont eu lieu pour chaque type de véhicule et la gravité des accidents associés */
SELECT vt.vehicle_type AS 'Type de véhicule', a.accident_severity AS 'Gravité', COUNT(vt.vehicle_type) AS 'Nombre d\'accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2, 3;

/* ------------------------------------------ */
/* Moyenne de la gravité des accidents par type de véhicule */
/* Cette requête calcule la gravité moyenne des accidents pour chaque type de véhicule */
SELECT vt.vehicle_type AS 'Type de véhicule', AVG(a.accident_severity) AS 'Gravité moyenne', COUNT(vt.vehicle_type) AS 'Nombre d\'accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2, 3;

/* ------------------------------------------ */
/* Moyenne de la gravité des accidents et nombre d'accidents par motos */
/* Cette requête permet de calculer la gravité moyenne des accidents pour les motos et de connaître le nombre total d'accidents associés aux motos */
SELECT vt.vehicle_type AS 'Type de véhicule', AVG(a.accident_severity) AS 'Gravité moyenne', COUNT(vt.vehicle_type) AS 'Nombre d\'accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
WHERE vt.vehicle_type LIKE '%otorcycle%'
GROUP BY 1
ORDER BY 2, 3;

/* ------------------------------------------ */
/* Analyse de la répartition des accidents par zone géographique et type de véhicule */
/* Si les données géographiques sont disponibles (par exemple, accident_location), cette analyse permettrait de savoir dans quelles zones les accidents sont plus fréquents */
SELECT vt.vehicle_type, a.accident_location, COUNT(*) AS 'Nombre d\'accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY vt.vehicle_type, a.accident_location
ORDER BY 'Nombre d\'accidents' DESC;

/* ------------------------------------------ */
/* Tendances temporelles des accidents par type de véhicule */
/* Cette requête analyse les tendances des accidents au fil des années pour chaque type de véhicule */
SELECT YEAR(a.accident_date) AS 'Année', vt.vehicle_type, COUNT(*) AS 'Nombre d\'accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1, vt.vehicle_type
ORDER BY 1, 2;

/* ------------------------------------------ */
/* Analyse de l'impact des conditions météorologiques sur la gravité des accidents par type de véhicule */
/* Si des données météorologiques sont disponibles, cette analyse permet de comprendre comment le temps influence les accidents */
SELECT vt.vehicle_type, a.weather_condition, AVG(a.accident_severity) AS 'Gravité moyenne'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY vt.vehicle_type, a.weather_condition
ORDER BY 'Gravité moyenne' DESC;

/* ------------------------------------------ */
/* Analyse des accidents par heure de la journée et par type de véhicule */
/* Cette requête permet de savoir à quelle heure les accidents sont les plus fréquents pour chaque type de véhicule */
SELECT HOUR(a.accident_time) AS 'Heure de l\'accident', vt.vehicle_type, COUNT(*) AS 'Nombre d\'accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 'Heure de l\'accident', vt.vehicle_type
ORDER BY 'Nombre d\'accidents' DESC;

/* ------------------------------------------ */
/* Analyse des accidents par âge du conducteur */
/* Si l'âge du conducteur est disponible, cette analyse permettrait de déterminer comment l'âge influence la gravité des accidents par type de véhicule */
SELECT vt.vehicle_type, a.driver_age, AVG(a.accident_severity) AS 'Gravité moyenne'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY vt.vehicle_type, a.driver_age
ORDER BY 'Gravité moyenne' DESC;
