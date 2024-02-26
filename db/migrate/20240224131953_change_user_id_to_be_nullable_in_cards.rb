class ChangeUserIdToBeNullableInCards < ActiveRecord::Migration[7.1]
  def change
    change_column_null :cards, :user_id, true
  end
end
