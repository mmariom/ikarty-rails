class AddRedirectCounterToCards < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :redirect_counter, :integer
  end
end
