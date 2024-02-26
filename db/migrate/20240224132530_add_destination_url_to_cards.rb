class AddDestinationUrlToCards < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :destination_url, :string
  end
end
