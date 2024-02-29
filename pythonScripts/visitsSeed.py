import psycopg2
from psycopg2 import Error
import random
from datetime import datetime, timedelta

# Define the range of card IDs
start_card_id = 230
end_card_id = 20200
visits_per_card = 20

def insert_visit(cursor, card_id, created_at, updated_at):
    query = """
    INSERT INTO visits 
    (card_id, created_at, updated_at) 
    VALUES 
    (%s, %s, %s);
    """
    cursor.execute(query, (card_id, created_at, updated_at))

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
        
        # Generate and insert visit records
        for card_id in range(start_card_id, end_card_id + 1):
            for _ in range(visits_per_card):
                # 80% chance to use yesterday's date, 20% chance for today's date
                if random.randint(1, 100) <= 80:
                    visit_date = datetime.now() - timedelta(days=1)
                else:
                    visit_date = datetime.now()
                
                insert_visit(cursor, card_id, visit_date, visit_date)
        
        connection.commit()
        print(f"Visit records have been successfully inserted for card IDs {start_card_id} to {end_card_id}.")
        
except Error as e:
    print("Error while connecting to PostgreSQL", e)
finally:
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
