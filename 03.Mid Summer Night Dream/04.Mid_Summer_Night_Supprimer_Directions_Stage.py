import pymysql
import time

# Connexion à la base de données MySQL
myConnection = pymysql.connect(
    host="localhost", user="root", password="root", db="shakespeare")

cur = myConnection.cursor()

# Mesure du temps de début pour calculer la performance
start_time = time.time()

# Partie 1 : Compter le nombre de lignes avant la suppression des directions de scène
cur.execute('SELECT COUNT(line_number) FROM amnd;')
numPlayLines_Before_Delete = cur.fetchall()[0][0]

# Suppression des directions de scène : utilisation d'une expression régulière pour supprimer les lignes qui commencent par "Enter", "Exit", "Act", "Scene", "Exeunt"
cur.execute(
    "DELETE FROM amnd WHERE play_text RLIKE '^enter|^exit|^act|^scence|^exeunt';")

print("Suppression des lignes...")

# Mesure du temps de fin pour calculer la performance
end_time = time.time()

# Commit des changements dans la base de données
myConnection.commit()

# Partie 2 : Compter le nombre de lignes après la suppression
cur.execute('SELECT COUNT(line_number) FROM amnd;')
numPlayLines_After_Delete = cur.fetchall()[0][0]
numPlayLInes_Deleted = numPlayLines_Before_Delete - numPlayLines_After_Delete
print(numPlayLInes_Deleted, 'lignes supprimées')

# Calcul du temps total d'exécution de la requête de suppression
queryExecTime = end_time - start_time
print("Temps total de la requête : ", queryExecTime)

# Calcul du temps d'exécution par ligne supprimée
queryTimePerLine = queryExecTime / numPlayLInes_Deleted
print("Temps par ligne supprimée : ", queryTimePerLine)

# Enregistrement du temps d'exécution de la requête dans la table de performance
insertPerformanceSQL = "INSERT INTO performance VALUES('DELETE', %s);"
cur.execute(insertPerformanceSQL, queryTimePerLine)

# Commit des informations de performance
myConnection.commit()

# Fermeture de la connexion à la base de données
myConnection.close()
