import pymysql
import time

# Connexion à la base de données MySQL
myConnection = pymysql.connect(
    host="localhost", user="root", password="root", db="shakespeare")

cur = myConnection.cursor()

# Mesure du temps de début pour calculer la performance
start_time = time.time()

# Partie 1 : Récupérer les textes de la pièce depuis la base de données
cur.execute("SELECT play_text FROM amnd;")

# Affichage du texte de chaque ligne de la pièce
for line in cur.fetchall():
    print(line[0])

# Mesure du temps de fin pour calculer la performance
end_time = time.time()

# Partie 2 : Calcul de la performance de la requête
cur.execute('SELECT COUNT(line_number) FROM amnd;')
numPlayLines = cur.fetchall()[0][0]
print(numPlayLines, 'lignes récupérées')

# Calcul du temps total d'exécution de la requête de lecture
queryExecTime = end_time - start_time
print("Temps total de la requête : ", queryExecTime)

# Calcul du temps d'exécution par ligne récupérée
queryTimePerLine = queryExecTime / numPlayLines
print("Temps par ligne récupérée : ", queryTimePerLine)

# Enregistrement du temps d'exécution de la requête dans la table de performance
insertPerformanceSQL = "INSERT INTO performance VALUES('READ', %s);"
cur.execute(insertPerformanceSQL, queryTimePerLine)

# Commit des informations de performance
myConnection.commit()

# Fermeture de la connexion à la base de données
myConnection.close()
