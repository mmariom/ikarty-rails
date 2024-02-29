import psycopg2
from psycopg2 import Error
import random
import string
from datetime import datetime

num_records = 6000

def generate_random_email():
    """Generate a random email address."""
    domains = ["example.com", "test.com", "demo.com"]
    name = ''.join(random.choice(string.ascii_lowercase) for i in range(10))
    domain = random.choice(domains)
    return f"{name}@{domain}"

def insert_user(cursor, email, encrypted_password, name, created_at, updated_at):
    query = """
    INSERT INTO users 
    (email, encrypted_password, name, created_at, updated_at) 
    VALUES 
    (%s, %s, %s, %s, %s);
    """
    cursor.execute(query, (email, encrypted_password, name, created_at, updated_at))

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
        
        # Generate and insert user records
        for _ in range(num_records):
            email = generate_random_email()
            encrypted_password = "$2a$12$Et09Khk7T3Gvads7/xS/KuaJAP7xSpAuR8qICuMrWhLJZ.dr333U."
            name = ''.join(random.choice(string.ascii_letters) for i in range(10))
            created_at = datetime.now()
            updated_at = datetime.now()
            insert_user(cursor, email, encrypted_password, name, created_at, updated_at)
        
        connection.commit()
        print(f"{num_records} user records have been successfully inserted.")
        
except Error as e:
    print("Error while connecting to PostgreSQL", e)
finally:
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
