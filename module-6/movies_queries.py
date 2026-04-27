import mysql.connector
from dotenv import dotenv_values

secrets = dotenv_values(".env")

db = mysql.connector.connect(
    host=secrets["HOST"],
    user=secrets["USER"],
    password=secrets["PASSWORD"],
    database=secrets["DATABASE"]
)

cursor = db.cursor()

# Query 1: Display all fields from studio table
print("\n-- DISPLAYING Studio RECORDS --")
cursor.execute("SELECT * FROM studio")
studios = cursor.fetchall()

for studio in studios:
    print("Studio ID: {}\nStudio Name: {}\n".format(studio[0], studio[1]))


# Query 2: Display all fields from genre table
print("\n-- DISPLAYING Genre RECORDS --")
cursor.execute("SELECT * FROM genre")
genres = cursor.fetchall()

for genre in genres:
    print("Genre ID: {}\nGenre Name: {}\n".format(genre[0], genre[1]))


# Query 3: Display movie names with runtime less than 120 minutes
print("\n-- DISPLAYING Short Film RECORDS --")
cursor.execute("SELECT film_name, film_runtime FROM film WHERE film_runtime < 120")
films = cursor.fetchall()

for film in films:
    print("Film Name: {}\nRuntime: {}\n".format(film[0], film[1]))


# Query 4: Display film names and directors grouped by director
print("\n-- DISPLAYING Director RECORDS in Order --")
cursor.execute("SELECT film_name, film_director FROM film ORDER BY film_director")
directors = cursor.fetchall()

for director in directors:
    print("Film Name: {}\nDirector: {}\n".format(director[0], director[1]))

cursor.close()
db.close()