import pymysql
import time

# Connexion à la base de données MySQL
myConnection = pymysql.connect(
    host="localhost", user="root", password="root", db="shakespeare")

cur = myConnection.cursor()

# Lecture du fichier contenant les personnages et stockage des personnages dans une liste
with open("datasets/characters.txt", "r") as char:
    characterList = char.read().splitlines()

# Initialisation du personnage courant à "Unknown" (le premier personnage est inconnu)
currentCharacter = "Unknown"

# Mesure du temps de début pour calculer la performance
start_time = time.time()

# Requête SQL pour insérer les données dans la table 'amnd' (nom du personnage et texte du jeu)
createSQL = "INSERT INTO amnd(char_name, play_text) VALUES(%s, %s);"

# Partie 1 : Traitement du fichier texte du jeu
# Créer un enregistrement pour chaque ligne du jeu :
# Le personnage qui parle, le numéro de la ligne et la phrase elle-même
with open("datasets/A_Midsummer_Nights_Dream.txt", "r") as playlines:
    for line in playlines:
        # Si la ligne contient un personnage, on met à jour le personnage courant
        if line.upper().strip() in characterList:
            currentCharacter = line.upper().strip()
            print("Changement de personnage : ", currentCharacter)
        else:
            # Si ce n'est pas un personnage, c'est une réplique, on l'ajoute à la base
            sql_values = currentCharacter, line.strip()
            print("Écriture de la ligne : ", sql_values)
            cur.execute(createSQL, sql_values)

# Commit des changements dans la base de données
myConnection.commit()

# Mesure du temps de fin pour calculer la performance
end_time = time.time()

# Partie 2 : Calcul des performances de la requête
# Exécution d'une requête pour compter le nombre de lignes dans la table 'amnd'
cur.execute('SELECT COUNT(line_number) FROM amnd;')
numPlayLines = cur.fetchall()[0][0]
print(numPlayLines, 'lignes enregistrées')

# Calcul du temps total d'exécution de la requête d'insertion
queryExecTime = end_time - start_time
print("Temps total de la requête : ", queryExecTime)

# Calcul du temps d'exécution par ligne insérée
queryTimePerLine = queryExecTime / numPlayLines
print("Temps par ligne insérée : ", queryTimePerLine)

# Enregistrement du temps d'exécution de la requête dans la table de performance
insertPerformanceSQL = "INSERT INTO performance VALUES('CREATE', %s);"
cur.execute(insertPerformanceSQL, queryTimePerLine)

# Commit des informations de performance
myConnection.commit()

# Fermeture de la connexion à la base de données
myConnection.close()
