-- Pour améliorer les performances, on crée un index sur le nom du comté
CREATE INDEX county_name
ON pop_proj(county_name);

-- Liste initiale des populations masculines et féminines par comté pour l'année 2014
SELECT county_name, gender, SUM(population) AS total_population
FROM pop_proj
WHERE date_year = 2014
GROUP BY county_name, gender
ORDER BY county_name;

-- Tableau formaté : répartition des populations masculines et féminines par comté pour 2014
SELECT p.county_name, 
       SUM(p.population) AS Male, 
       female_pop.Female
FROM (
        SELECT county_name, SUM(population) AS Female
        FROM pop_proj
        WHERE date_year = 2014 AND gender = 'Female'
        GROUP BY county_name
     ) AS female_pop
JOIN pop_proj p
  ON p.county_name = female_pop.county_name
WHERE p.date_year = 2014 AND p.gender = 'Male'
GROUP BY p.county_name, female_pop.Female
ORDER BY p.county_name;

--  Calcul du ratio Hommes / Femmes par comté pour l'année 2014
SELECT 
    male_pop.county_name,
    male_pop.Male,
    female_pop.Female,
    ROUND(CAST(male_pop.Male AS FLOAT) / female_pop.Female, 2) AS male_female_ratio,
    (male_pop.Male + female_pop.Female) AS total_population,
    ABS(male_pop.Male - female_pop.Female) AS gender_gap
FROM
    (SELECT county_name, SUM(population) AS Male
     FROM pop_proj
     WHERE date_year = 2014 AND gender = 'Male'
     GROUP BY county_name) AS male_pop

JOIN
    (SELECT county_name, SUM(population) AS Female
     FROM pop_proj
     WHERE date_year = 2014 AND gender = 'Female'
     GROUP BY county_name) AS female_pop
ON male_pop.county_name = female_pop.county_name
ORDER BY male_female_ratio DESC;


--  Comtés avec les plus grands écarts entre hommes et femmes
SELECT county_name,
       SUM(CASE WHEN gender = 'Male' THEN population ELSE 0 END) AS Male,
       SUM(CASE WHEN gender = 'Female' THEN population ELSE 0 END) AS Female,
       ABS(SUM(CASE WHEN gender = 'Male' THEN population ELSE 0 END) - 
           SUM(CASE WHEN gender = 'Female' THEN population ELSE 0 END)) AS gender_gap
FROM pop_proj
WHERE date_year = 2014
GROUP BY county_name
ORDER BY gender_gap DESC;

--  Population totale par comté (tous genres confondus)
SELECT county_name,
       SUM(population) AS total_population
FROM pop_proj
WHERE date_year = 2014
GROUP BY county_name
ORDER BY total_population DESC;

--  Top 10 des comtés les plus peuplés
SELECT county_name,
       SUM(population) AS total_population
FROM pop_proj
WHERE date_year = 2014
GROUP BY county_name
ORDER BY total_population DESC
LIMIT 10;

--  Pourcentage d'hommes et de femmes par comté
SELECT county_name,
       ROUND(SUM(CASE WHEN gender = 'Male' THEN population ELSE 0 END) * 100.0 / SUM(population), 2) AS male_percentage,
       ROUND(SUM(CASE WHEN gender = 'Female' THEN population ELSE 0 END) * 100.0 / SUM(population), 2) AS female_percentage
FROM pop_proj
WHERE date_year = 2014
GROUP BY county_name
ORDER BY county_name;

--  Comtés où la population féminine est majoritaire
SELECT county_name,
       SUM(CASE WHEN gender = 'Female' THEN population ELSE 0 END) AS Female,
       SUM(CASE WHEN gender = 'Male' THEN population ELSE 0 END) AS Male
FROM pop_proj
WHERE date_year = 2014
GROUP BY county_name
HAVING SUM(CASE WHEN gender = 'Female' THEN population ELSE 0 END) > 
       SUM(CASE WHEN gender = 'Male' THEN population ELSE 0 END)
ORDER BY Female DESC;

--  Moyenne, min et max de population totale par comté
SELECT 
    ROUND(AVG(total), 0) AS average_population,
    MIN(total) AS min_population,
    MAX(total) AS max_population
FROM (
    SELECT county_name, SUM(population) AS total
    FROM pop_proj
    WHERE date_year = 2014
    GROUP BY county_name
) AS totals;

--  Population totale de l'État pour 2014
SELECT SUM(population) AS california_total_population_2014
FROM pop_proj
WHERE date_year = 2014;
