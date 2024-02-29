class AddIndexesToVisits < ActiveRecord::Migration[7.1]
  def change

        # Adds an index on just the created_at column
        add_index :visits, :created_at
    
        # Adds a composite index on card_id and created_at
        # This is useful for queries that filter by card_id and then sort or filter by created_at
        add_index :visits, [:card_id, :created_at]
  end
end
