import psycopg2
from psycopg2 import Error
import random
import string
from datetime import datetime

num_records = 20000  # Number of cards to generate

def generate_unique_key():
    """Generate a random unique key of 6 uppercase letters and digits."""
    return ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(6))

def insert_card(cursor, unique_key, destination_url, user_id, created_at, updated_at):
    query = """
    INSERT INTO cards 
    (unique_key, destination_url, user_id, created_at, updated_at) 
    VALUES 
    (%s, %s, %s, %s, %s);
    """
    cursor.execute(query, (unique_key, destination_url, user_id, created_at, updated_at))

try:
    # Connect to the database
    connection = psycopg2.connect(
        host='localhost', 
        port='5432',
        database='ikarty',  # Your database
        user='myuser',  # Your database user
        password='mypassword'  # Your database password
    )

    if connection:
        print("Connected to PostgreSQL Server")
        cursor = connection.cursor()
        
        # Generate and insert card records
        for _ in range(num_records):
            unique_key = generate_unique_key()
            destination_url = 'https://google.com'
            user_id = None if random.randint(1, 100) <= 20 else random.randint(441, 6440)  # 20% chance of being None
            created_at = datetime.now()
            updated_at = datetime.now()
            insert_card(cursor, unique_key, destination_url, user_id, created_at, updated_at)
        
        connection.commit()
        print(f"{num_records} card records have been successfully inserted.")
        
except Error as e:
    print("Error while connecting to PostgreSQL", e)
finally:
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
