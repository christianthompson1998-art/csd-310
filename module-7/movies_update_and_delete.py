import mysql.connector
from dotenv import dotenv_values

secrets = dotenv_values(".env")

db = mysql.connector.connect(
    host=secrets["MYSQL_HOST"],
    user=secrets["MYSQL_USER"],
    password=secrets["MYSQL_PASSWORD"],
    database=secrets["MYSQL_DATABASE"]
)

cursor = db.cursor()


def show_films(cursor, title):
    cursor.execute("""
        SELECT 
            film_name AS Name,
            film_director AS Director,
            genre_name AS Genre,
            studio_name AS Studio
        FROM film
        INNER JOIN genre ON film.genre_id = genre.genre_id
        INNER JOIN studio ON film.studio_id = studio.studio_id
    """)

    films = cursor.fetchall()

    print("\n-- {} --".format(title))

    for film in films:
        print("Film Name: {}\nDirector: {}\nGenre Name: {}\nStudio Name: {}\n".format(
            film[0], film[1], film[2], film[3]
        ))


# Display original films
show_films(cursor, "DISPLAYING FILMS")

# Insert a new film
cursor.execute("""
    INSERT INTO film (film_name, film_releaseDate, film_runtime, film_director, studio_id, genre_id)
    VALUES ('The Dark Knight', '2008', 152, 'Christopher Nolan', 1, 1)
""")
db.commit()

show_films(cursor, "DISPLAYING FILMS AFTER INSERT")

# Update Alien to Horror
cursor.execute("""
    UPDATE film
    SET genre_id = 3
    WHERE film_name = 'Alien'
""")
db.commit()

show_films(cursor, "DISPLAYING FILMS AFTER UPDATE- Changed Alien to Horror")

# Delete Gladiator
cursor.execute("""
    DELETE FROM film
    WHERE film_name = 'Gladiator'
""")
db.commit()

show_films(cursor, "DISPLAYING FILMS AFTER DELETE")

cursor.close()
db.close()
    
