

import mysql.connector
from mysql.connector import Error

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "Enter your own password",
    "database": "bacchus_winery",
}

TABLES = [
    "department",
    "employee",
    "employee_quarter_hours",
    "supplier",
    "supply_item",
    "supply_delivery",
    "supply_delivery_item",
    "wine",
    "distributor",
    "distributor_wine",
    "wine_order",
    "wine_order_item",
]


def display_table(cursor, table_name):
    """Display all records from a selected table."""
    print("\n" + "=" * 80)
    print(f"TABLE: {table_name.upper()}")
    print("=" * 80)

    cursor.execute(f"SELECT * FROM {table_name};")
    rows = cursor.fetchall()
    columns = [description[0] for description in cursor.description]

    print(" | ".join(columns))
    print("-" * 80)

    if not rows:
        print("No records found.")
    else:
        for row in rows:
            print(" | ".join(str(value) if value is not None else "NULL" for value in row))


def main():
    try:
        db = mysql.connector.connect(**DB_CONFIG)
        cursor = db.cursor()

        print("Bacchus Winery Database Records")
        for table in TABLES:
            display_table(cursor, table)

    except Error as err:
        print(f"MySQL Error: {err}")
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals() and db.is_connected():
            db.close()
            print("\nDatabase connection closed.")


if __name__ == "__main__":
    main()
