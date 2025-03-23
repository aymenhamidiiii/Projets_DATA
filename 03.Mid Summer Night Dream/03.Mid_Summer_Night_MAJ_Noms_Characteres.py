import pymysql
import time

# Connexion à la base de données MySQL
myConnection = pymysql.connect(
    host="localhost", user="root", password="root", db="shakespeare")

cur = myConnection.cursor()

# Mesure du temps de début pour calculer la performance
start_time = time.time()

# Partie 1 : Mettre à jour le nom du personnage en majuscules pour chaque ligne du jeu
# La requête met à jour les lignes dans la table 'amnd' en remplaçant les occurrences du nom du personnage par sa version en majuscule.
updateSQL = "UPDATE amnd SET play_text = REPLACE(play_text, %s, %s);"

# Lecture du fichier contenant les personnages et mise à jour de chaque ligne du jeu
with open("datasets/characters.txt", "r") as char:
    for character in char.read().splitlines():
        print("Mise en majuscule des occurrences de ", character)
        updateStrings = character.capitalize(), character.upper()  # Remplace la version capitalisée par la version en majuscule
        cur.execute(updateSQL, updateStrings)

# Commit des changements dans la base de données
myConnection.commit()

# Mesure du temps de fin pour calculer la performance
end_time = time.time()

# Partie 2 : Calcul des performances de la requête
# Exécution d'une requête pour compter le nombre de lignes dans la table 'amnd'
cur.execute('SELECT COUNT(line_number) FROM amnd;')
numPlayLines = cur.fetchall()[0][0]
print(numPlayLines, 'lignes mises à jour')

# Calcul du temps total d'exécution de la requête de mise à jour
queryExecTime = end_time - start_time
print("Temps total de la requête : ", queryExecTime)

# Calcul du temps d'exécution par ligne mise à jour
queryTimePerLine = queryExecTime / numPlayLines
print("Temps par ligne mise à jour : ", queryTimePerLine)

# Enregistrement du temps d'exécution de la requête dans la table de performance
insertPerformanceSQL = "INSERT INTO performance VALUES('UPDATE', %s);"
cur.execute(insertPerformanceSQL, queryTimePerLine)

# Commit des informations de performance
myConnection.commit()

# Fermeture de la connexion à la base de données
myConnection.close()
