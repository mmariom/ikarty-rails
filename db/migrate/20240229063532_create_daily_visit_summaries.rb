class CreateDailyVisitSummaries < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_visit_summaries do |t|
      t.references :card, null: false, foreign_key: true
      t.date :date
      t.integer :visit_count

      t.timestamps
    end
  end
end
