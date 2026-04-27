# import statements
import mysql.connector
from mysql.connector import errorcode

import dotenv
from dotenv import dotenv_values

# load .env file
secrets = dotenv_values(".env")

# database config
config = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "database": secrets["DATABASE"],
    "raise_on_warnings": True
}

try:
    # connect to database
    db = mysql.connector.connect(**config)

    print("\nDatabase connection successful!")
    print("User:", config["user"])
    print("Host:", config["host"])
    print("Database:", config["database"])

    input("\nPress Enter to continue...")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Invalid username or password")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
    else:
        print(err)

finally:
    db.close()